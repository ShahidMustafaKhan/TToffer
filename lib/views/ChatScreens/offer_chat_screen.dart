import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:tt_offer/view_model/offer/offer_view_model.dart';

import '../../Utils/suggestion_list.dart';
import '../../models/chat_list_model.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../view_model/chat/chat_list_view_model/chat_view_model.dart';
import '../../view_model/profile/user_profile/user_view_model.dart';

class OfferChatScreen extends StatefulWidget {
  Product? product;
  UserModel? participantModel;
  bool? isOffer;
  dynamic offerPrice;
  int? receiverId;
  int? buyerId;
  int? sellerId;
  int? productId;
  String? conversationId;
  bool isFromFeatureProduct;

  OfferChatScreen({
    super.key,
    this.participantModel,
    this.product,
    this.isOffer,
    this.offerPrice,
    this.receiverId,
    this.buyerId,
    this.sellerId,
    this.productId,
    this.conversationId,
    this.isFromFeatureProduct = false,
  });

  @override
  State<OfferChatScreen> createState() => _OfferChatScreenState();
}

class _OfferChatScreenState extends State<OfferChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _priceController = TextEditingController();
  XFile? pickedImage;

  int? userId;
  late ChatViewModel chatViewModel;
  late OfferViewModel offerViewModel;
  bool isLoading = false;
  String? currentUserImage;

  File? imageFile;

  List<String> predefinedMessages = [];

  String selectedMessage = '';
  String emptyMessage =
      'Start a chat and it will appear\n   here. If you\'re looking for   \n  something, try to find it on \n                 TTOffer.\nOr post a random ad and act\n     fast! Don\'t miss a deal!';

  Future<void> onMessageTap(String message) async {
    await sendMessage(
        context: context,
        senderId: userId,
        receiverId: widget.receiverId,
        buyerId: widget.buyerId,
        productId: widget.productId,
        sellerId: widget.sellerId,
        message: message,
        isTapMessageLoading: true);
  }

  @override
  void initState() {
    chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    offerViewModel = Provider.of<OfferViewModel>(context, listen: false);
    chatViewModel.setConversationLoading(true, update: false);

    print(widget.product?.category?.name);
    print(widget.product?.productType);

    predefinedMessages = getMessages(widget.product?.category?.name == 'Jobs'
        ? widget.product?.productType ?? ''
        : widget.product?.category?.name ?? '');

    getConversationData();

    product = widget.product;
    participantModel = widget.participantModel;
    userId = int.parse(pref.getString(PrefKey.userId)!);
    getCurrentUserImage();
    _priceController.text = "AED 60";

    super.initState();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  getUserDetails() async {
    if (widget.participantModel == null) {
      UserViewModel userViewModel =
          Provider.of<UserViewModel>(context, listen: false);

      UserModel? participant = await userViewModel
          .getSellerProfile(int.parse(widget.receiverId.toString()));
      participantModel = participant;
      setState(() {});
    }
  }

  getCurrentUserImage() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (userViewModel.userModel.data?.img != null) {
      currentUserImage = userViewModel.userModel.data?.img;
    } else {
      await userViewModel.getUserProfile();
      currentUserImage = userViewModel.userModel.data?.img;
      setState(() {});
    }
  }

  getConversationData() async {
    if (widget.isFromFeatureProduct == false) {
      getConversation(loading: true);
    } else {
      await getConversationId();
      getConversation(loading: true);
    }
    startTimer();
  }

  getConversationId() async {
    await chatViewModel
        .getConversationId(
            buyerId: widget.buyerId,
            sellerId: widget.sellerId,
            productId: widget.productId)
        .then((value) {
      if (value["data"] != null) {
        widget.conversationId = value["data"];
        setState(() {});
      }
    }).onError((error, stackTrace) {});
  }

  List<Conversation> conversation = [];

//! offer variables

  String? productId;
  String? offerId;
  String? sellerId;
  String? buyerId;
  Product? product;
  UserModel? participantModel;
  var open;
  Timer? _timer;

  bool offerLoading = false;

  Future<void> getConversation({bool loading = false}) async {
    final chatApi = Provider.of<ChatViewModel>(context, listen: false);

    conversation = await chatApi
        .getConversationList(widget.conversationId, loading: loading)
        .then((value) => conversation = value)
        .onError((error, stackTrace) => conversation = []);

    for (var element in conversation) {
      if (element.offer != null &&
          element.offer?.status == 1 &&
          element.senderId != userId) {
        log("widget.isOffer is set to true");

        widget.isOffer = true;
        widget.offerPrice = element.offer!.offerPrice ?? "0";
        _priceController.text = widget.offerPrice.toString();

        productId = element.productId.toString();
        offerId = element.offer?.id.toString();
        break;
      }
    }

    if (conversation.isNotEmpty) {
      product = conversation[0].product;
      widget.sellerId ??= conversation[0].sellerId;
      widget.buyerId ??= conversation[0].buyerId;
      widget.productId ??= conversation[0].productId;
      widget.receiverId ??= conversation.last.receiverId == userId
          ? conversation.last.senderId
          : conversation.last.receiverId;
    }

    getUserDetails();

    if (conversation.isNotEmpty) {
      if (conversation.last.receiverId == userId &&
          widget.conversationId != null) {
        chatApi.markReadChat(widget.conversationId);
      }
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (widget.conversationId != null) {
        getConversation();
      }
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    open = Provider.of<NotifyProvider>(context);

    return Scaffold(
      appBar: ChatAppBar(
        productId: widget.productId,
        recipientId: widget.buyerId.toString() == userId.toString()
            ? widget.sellerId
            : widget.buyerId,
        product: product,
        participantModel: participantModel,
      ),
      body: Consumer<ChatViewModel>(builder: (context, chatViewModel, child) {
        List<Conversation> list = conversation.reversed.toList();
        return chatViewModel.conversationLoading == true
            ? Center(
                child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      color: AppTheme.yellowColor,
                    )))
            : Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: (conversation.isEmpty) &&
                                predefinedMessages.isNotEmpty &&
                                chatViewModel.conversationLoading == false &&
                                (widget.isOffer == true &&
                                        userId.toString() ==
                                            widget.sellerId.toString()) ==
                                    false
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.w, vertical: 12.h),
                                child: chatViewModel.sendingTapMessage == true
                                    ? Center(
                                        child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator(
                                              color: AppTheme.yellowColor,
                                            )))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            AppText.appText(
                                                'Tap a message to send or write your own',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            ListView.builder(
                                              itemCount:
                                                  predefinedMessages.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () => onMessageTap(
                                                      predefinedMessages[
                                                          index]),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      6.0),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      12),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xff6ba99c),
                                                                  width: 2)),
                                                          child: AppText.appText(
                                                              predefinedMessages[
                                                                  index],
                                                              fontSize: 13.0,
                                                              textColor:
                                                                  const Color(
                                                                      0xff6ba99c),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ]),
                              )
                            : ListView.separated(
                                controller: _scrollController,
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return _buildMessageBubble(
                                      time: "${list[index].createdAt}",
                                      user: userId == list[index].senderId
                                          ? true
                                          : false,
                                      message: list[index].message,
                                      img: "${list[index].file}",
                                      offerPrice: list[index].offer?.offerPrice,
                                      status: list[index].status == null
                                          ? false
                                          : list[index].status == 'read'
                                              ? true
                                              : false);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                      height: index != 0
                                          ? list[index - 1].senderId! ==
                                                  list[index].senderId!
                                              ? 5.h
                                              : 0
                                          : 0);
                                },
                              ),
                      ),
                      _buildUserInput(),
                    ],
                  ),
                  offerDialog()
                ],
              );
      }),
    );
  }

  Widget offerDialog() {
    return widget.isOffer == true &&
            userId.toString() == widget.sellerId.toString()
        ? Align(
            child: Padding(
              padding: EdgeInsets.only(bottom: 136.h),
              child: SizedBox(
                height: open.isCustom == false ? 200 : 360,
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 11.0, right: 11, top: 30),
                      child: Container(
                        height: open.isCustom == false ? 170 : 330,
                        decoration: BoxDecoration(
                            color: const Color(0xffF3F4F5),
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppText.appText(
                                  "${capitalizeWords(participantModel?.name ?? '')} sent you a offer",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textColor: const Color(0xff2A2A2F)),
                              AppText.appText("AED ${widget.offerPrice}",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  textColor: const Color(0xff2A2A2F)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    offerButtons(
                                        onTap: () {
                                          rejectOfferHandler();
                                        },
                                        txt: "Reject Offer"),
                                    offerButtons(
                                        onTap: () {
                                          acceptOfferHandler();
                                        },
                                        txt: "Accept Offer"),
                                    offerButtons(
                                        onTap: () {
                                          open.openclose();
                                        },
                                        txt: "Custom Offer"),
                                  ],
                                ),
                              ),
                              open.isCustom == false
                                  ? const SizedBox.shrink()
                                  : Column(
                                      children: [
                                        AppText.appText("Enter Your Offer",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            textColor: AppTheme.textColor),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        CustomAppFormField(
                                          texthint: "",
                                          controller: _priceController,
                                          width: 161,
                                          textAlign: TextAlign.center,
                                          fontsize: 24,
                                          fontweight: FontWeight.w600,
                                          cPadding: 2.0,
                                          type: TextInputType.number,
                                        ),
                                      ],
                                    ),
                              open.isCustom == false
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: offerLoading
                                          ? Center(
                                              child: CircularProgressIndicator(
                                              color: AppTheme.appColor,
                                            ))
                                          : AppButton.appButton("Send Offer",
                                              onTap: () {
                                              sendOffer();
                                              // push(
                                              //     context, OfferChatScreen());
                                            },
                                              height: 50,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              radius: 32.0,
                                              backgroundColor:
                                                  AppTheme.appColor,
                                              textColor: AppTheme.whiteColor),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (product?.photo?.isNotEmpty ?? false)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(product!.photo![0].url!),
                                // : const AssetImage(
                                //         "assets/images/user.png")
                                //     as ImageProvider,
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget offerButtons({Function()? onTap, txt}) {
    return AppButton.appButton("$txt",
        onTap: onTap,
        height: 29,
        width: MediaQuery.of(context).size.width * 0.25,
        fontWeight: FontWeight.w500,
        fontSize: 8,
        radius: 16.0,
        backgroundColor: AppTheme.appColor,
        textColor: AppTheme.whiteColor);
  }

  Widget _buildMessageBubble(
      {required user,
      String? message,
      String? img,
      int? offerPrice,
      required var time,
      required bool status}) {
    return Column(
      crossAxisAlignment:
          user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              user ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            SizedBox(
              width: user ? 8 : 24,
            ),
            // Spacer(),
            AppText.appText(formatTimestamp(time),
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.lighttextColor),

            SizedBox(
              width: user ? 24 : 0,
            ),
          ],
        ),
        if (img != null && (img.isEmpty || img.trim().isEmpty))
          Container(
              alignment: user ? Alignment.centerRight : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 250, minWidth: 80),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: user ? AppTheme.appColor : const Color(0xffEAEAEA),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.appText(message ?? "no text",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: user ? AppTheme.whiteColor : Colors.black)
                  ],
                ),
              ))
        else if (img != null &&
            (img.endsWith(".png") ||
                img.endsWith(".jpeg") ||
                img.endsWith(".jpg")))
          // Display image message
          Column(
            children: [
              BubbleNormalImage(
                isSender: user,
                id: 'id001',
                image: Image.network(img),
                // color: Colors.purpleAccent,
                tail: true,
                delivered: true,
              ),
            ],
          ),
        if (message != null)
          Container(
              alignment: user ? Alignment.centerRight : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              child: Row(
                mainAxisAlignment:
                    user ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (user)
                    Image.asset(
                      "assets/images/check.png",
                      height: 16.h,
                      color: status
                          ? AppTheme.yellowColor
                          : const Color(0xff7486A1),
                    ),
                  if (user)
                    SizedBox(
                      width: 10.w,
                    ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: systemMessage(message ?? '')
                                ? (user
                                    ? MediaQuery.of(context).size.width * 0.82
                                    : MediaQuery.of(context).size.width * 0.89)
                                : 250,
                            minWidth: 80),
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.r, vertical: 9.h),
                        decoration: BoxDecoration(
                          color: systemMessage(message ?? '')
                              ? AppTheme.yellowColor
                              : user
                                  ? AppTheme.appColor
                                  : const Color(0xffEAEAEA),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText(
                                msg(message, user, offerPrice) ?? "no text",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: systemMessage(message ?? '')
                                    ? Colors.black
                                    : user
                                        ? AppTheme.whiteColor
                                        : Colors.black)
                          ],
                        ),
                      ),
                      if (user
                          ? currentUserImage != null
                          : participantModel?.img != null)
                        Positioned(
                          right: user ? -8.w : null,
                          left: user ? null : -8.w,
                          top: user ? -6.h : -6.h,
                          child: CircleAvatar(
                            radius: 10.r,
                            backgroundImage: NetworkImage(user
                                ? currentUserImage!
                                : participantModel!.img!),
                          ),
                        )
                    ],
                  ),
                ],
              )),
      ],
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        children: [
          if (imageFile != null) ...[
            Divider(color: AppTheme.borderColor),
            const SizedBox(height: 5),
            Stack(clipBehavior: Clip.none, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.file(imageFile!,
                      height: 120.w, width: 120.w, fit: BoxFit.cover)),
              Positioned(
                right: -10,
                top: -10,
                child: InkWell(
                  onTap: () {
                    imageFile = null;
                    setState(() {});
                  },
                  child: const Card(
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 8),
          ],
          Container(
            width: MediaQuery.of(context).size.width,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              color: const Color(0xffECECEC),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    autofocus: false,
                    enabled: chatViewModel.disableTextField == false,
                    controller: _textEditingController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type here ...',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    getImagesFromGallery();
                  },
                  child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        "assets/images/gallery.png",
                        fit: BoxFit.fill,
                        color: const Color(0xff8E97A4),
                      )),
                ),
                if (chatViewModel.sendingMessage)
                  Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.appColor,
                    ),
                  )
                else
                  InkWell(
                    onTap: () async {
                      final userMessage = _textEditingController.text;

                      if (imageFile != null) {
                        sendImage(imageFile!.path,
                            userMessage.isNotEmpty ? userMessage : null);
                      } else {
                        if (userMessage.isNotEmpty) {
                          //! this is chat api
                          await sendMessage(
                              context: context,
                              senderId: userId,
                              receiverId: widget.receiverId,
                              buyerId: widget.buyerId,
                              productId: widget.productId,
                              sellerId: widget.sellerId,
                              message: userMessage);
                        }
                      }
                    },
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: Image.asset(
                          "assets/images/send.png",
                          color: const Color(0xff039b73),
                          fit: BoxFit.cover,
                        )),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool systemMessage(String message) {
    if (message.contains('accepted your offer') ||
        message.contains('rejected your offer') ||
        message.contains('made an offer') ||
        message.contains('Unfortunately, the seller has canceled the offer.')) {
      return true;
    } else {
      return false;
    }
  }

  String msg(String? message, bool isCurrentUserSender, int? offerPrice) {
    if (message != null) {
      if (message.contains('accepted the offer') ||
          message.contains('accepted your offer')) {
        if (isCurrentUserSender == true) {
          return 'The price has been agreed. Please proceed with selling the product to avoid any account restriction issues.';
        } else {
          return 'Congratulations! The seller accepted your offer. To avoid any account restriction issues, please proceed with purchasing the product from the seller.';
        }
      } else if (message.contains('rejected the offer') ||
          message.contains('rejected your offer')) {
        if (isCurrentUserSender == true) {
          return 'You have rejected this offer.';
        } else {
          return '${capitalizeWords(participantModel?.name ?? '')} has rejected the offer.';
        }
      } else if (message.contains('made an offer')) {
        if (isCurrentUserSender == true) {
          if (offerPrice == null) {
            return 'You have made an offer.';
          } else {
            return 'You have made an offer for AED $offerPrice.';
          }
        } else {
          return capitalizeWholeTitle(message, participantModel?.name ?? '');
        }
      } else if (message
          .contains('Unfortunately, the seller has canceled the offer.')) {
        if (isCurrentUserSender == true) {
          return 'You have declined the buyer’s offer and made a special offer.';
        } else {
          return message;
        }
      } else {
        return message;
      }
    } else {
      return '';
    }
  }

  Future<bool> sendMessage(
      {required context,
      required int? senderId,
      required int? receiverId,
      required int? buyerId,
      required int? sellerId,
      required int? productId,
      required String? message,
      bool isTapMessageLoading = false}) async {
    chatViewModel
        .sendMessage(
            senderId: senderId,
            receiverId: receiverId,
            buyerId: buyerId,
            sellerId: sellerId,
            productId: productId,
            message: message,
            isTapMessageLoading: isTapMessageLoading)
        .then((conversationList) {
      _textEditingController.clear();

      var cons = Conversation(
          message: message,
          senderId: senderId,
          createdAt: DateTime.now(),
          receiverId: receiverId);

      int? id;

      if (conversationList.isNotEmpty &&
          conversationList[0].conversationId != null) {
        widget.conversationId = conversationList[0].conversationId;
        id = conversationList[0].id;
      }

      if (conversation.isNotEmpty && conversation.last.id == id) {
      } else {
        conversation.add(cons);
      }

      return true;
    }).onError((error, stackTrace) {
      showSnackBar(context, error.toString());
      return false;
    });

    return false;
  }

  Future<bool> sendFileMsg({
    required context,
    String? message,
    required int? senderId,
    required int? receiverId,
    required int? buyerId,
    required int? sellerId,
    required int? productId,
    required XFile image,
  }) async {
    chatViewModel
        .sendMessageWithImage(
            senderId: senderId,
            receiverId: receiverId,
            buyerId: buyerId,
            sellerId: sellerId,
            productId: productId,
            filePaths: image.path,
            message: message)
        .then((value) {
      imageFile = null;

      _textEditingController.clear();

      var cons = Conversation(
          senderId: senderId,
          createdAt: DateTime.now(),
          file: value[0].file,
          receiverId: receiverId);

      int? id;

      if (value.isNotEmpty && value[0].conversationId != null) {
        widget.conversationId = value[0].conversationId;
        id = value[0].id;
      }

      if (conversation.isNotEmpty && conversation.last.id == id) {
      } else {
        conversation.add(cons);
      }

      return true;
    }).onError((error, stackTrace) {
      imageFile = null;
      _textEditingController.clear();
      getConversation();
      // showSnackBar(context, error.toString());
      return false;
    });

    return false;
  }

  Future<bool> rejectOfferHandler() async {
    showAlertLoader(context: context);

    offerViewModel
        .rejectOffer(int.tryParse(productId ?? ''), widget.sellerId,
            widget.buyerId, int.tryParse(offerId ?? ''))
        .then((value) {
      Navigator.of(context).pop();
      setState(() {
        widget.isOffer = false;
      });

      return true;
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      showSnackBar(context, error.toString());
      return false;
    });

    return false;
  }

  Future<void> acceptOfferHandler() async {
    showAlertLoader(context: context);

    offerViewModel
        .acceptOffer(int.tryParse(productId ?? ''), widget.sellerId,
            widget.buyerId, int.tryParse(offerId ?? ''))
        .then((value) {
      Navigator.of(context).pop();
      setState(() {
        widget.isOffer = false;
      });
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      showSnackBar(context, error.toString());
    });
  }

  Future<void> sendOffer() async {
    showAlertLoader(context: context);

    offerViewModel
        .customOffer(
            int.tryParse(productId ?? ''),
            widget.sellerId,
            widget.buyerId,
            int.tryParse(offerId ?? ''),
            int.tryParse(_priceController.text.trim()))
        .then((value) {
      open.openclose();
      Navigator.of(context).pop();
      setState(() {
        widget.isOffer = false;
      });
    }).onError((error, stackTrace) {
      open.openclose();
      Navigator.of(context).pop();
      showSnackBar(context, error.toString());
    });
  }

////////////////////////////////////////// Image Compression ///////////////////////////////////////
  Future<void> getImagesFromGallery() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFiles != null) {
      imageFile = File(pickedFiles.path);
      setState(() {});
    }

    // newImagePath = pickedFiles.single.path;
    // notifyListeners();
  }

  Future<void> sendImage(String imagePath, String? userMessage) async {
    // img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());
    //
    // img.Image compressedImage = img.copyResize(image!, width: 800);
    // List<int> compressedImageData = img.encodeJpg(compressedImage, quality: 85);
    //
    // String compressedImagePath = await saveCompressedImage(compressedImageData);

    sendFileMsg(
      image: XFile(imagePath),
      context: context,
      message: userMessage,
      senderId: userId,
      receiverId: widget.receiverId,
      buyerId: widget.buyerId,
      productId: widget.productId,
      sellerId: widget.sellerId,
    );
  }

  Future<String> saveCompressedImage(List<int> imageData) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File(
            '${tempDir.path}/compressed_image_${DateTime.now().millisecondsSinceEpoch}.jpg')
        .create();

    await tempFile.writeAsBytes(imageData);

    return tempFile.path;
  }
}
