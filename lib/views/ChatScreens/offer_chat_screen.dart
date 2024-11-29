import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/send_notification_service.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:tt_offer/utils/widgets/loading_popup.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/APIs Manager/profile_apis.dart';
import '../../config/dio/app_dio.dart';
import '../../custom_requests/user_info_service.dart';
import '../../models/user_info_model.dart';
import '../../providers/profile_info_provider.dart';
import '../Products/Feature Product/feature_info.dart';
import '../Seller Profile/seller_profile.dart';
import '../Seller Profile/seller_profile_chat.dart';

class OfferChatScreen extends StatefulWidget {
  String? userImgUrl;
  String? userRating;
  final String? contactNumber;
  bool? isOffer;
  dynamic offerPrice;
  dynamic recieverId;
  dynamic buyerId;
  dynamic sellerId;
  dynamic productId;
  String? title;
  String? conversationId;
  bool isFromFeatureProduct;

  OfferChatScreen(
      {super.key,
      this.isOffer,
      this.contactNumber,
      this.offerPrice,
      this.userImgUrl,
      this.userRating,
      this.recieverId,
      this.buyerId,
      this.sellerId,
      this.productId,
      this.conversationId,
      this.isFromFeatureProduct = false,
      this.title});

  @override
  State<OfferChatScreen> createState() => _OfferChatScreenState();
}

class _OfferChatScreenState extends State<OfferChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _priceController = TextEditingController();
  late final DatabaseReference firstResf;
  final DatabaseReference secRef =
      FirebaseDatabase.instance.ref().child('Chats');
  XFile? pickedImage;

  // late AppDio dio;
  AppLogger logger = AppLogger();
  int? userId;
  late final dio;
  ChatModel? chatModel;
  bool isLoading = false;
  String? currentUserImage;
  late ProgressDialog pr;
  var nextUserId;
  var nextUserName;
  bool disableTextField = false;

  final List<String> predefinedMessages = [
    "Hi, is this still available?",
    "Hi, I'd like to buy this",
    "Hi, can you meet today?",
    "Are you willing to ship through TToffer?",
  ];

  String selectedMessage = '';



  String emptyMessage = 'Start a chat and it will appear\n   here. If you\'re looking for   \n  something, try to find it on \n                 TTOffer.\nOr post a random ad and act\n     fast! Don\'t miss a deal!';


  Future<void> onMessageTap(String message) async {
    setState(() {
      isSending = true;
      disableTextField = true;
    });
    bool isSent = await sendMessage(
        dio: dio,
        context: context,
        image: pickedImage,
        senderId: userId,
        recieverId: widget.recieverId,
        title: widget.title,
        buyerId: widget.buyerId,
        productId: widget.productId,
        sellerId: widget.sellerId,
        message: message);

    setState(() {
      isSending = false;
      disableTextField = true;
    });
  }
  @override
  void initState() {
    // dio = AppDio(context);
    logger.init();
    dio = AppDio(context);

    pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    userId = int.parse(pref.getString(PrefKey.userId)!);

    getCurrentUserImage();

    _priceController.text = "AED 60";


    // getUserDetails();

    getData();


    super.initState();
  }

  @override
  void dispose(){
    stopTimer();
    super.dispose();
  }


  getUserDetails() async {
    if(widget.title == null){
      UserInfoModel? data;

      await UserInfoService().userInfoService(
          context: context, id: int.parse(widget.recieverId.toString()));

      data = Provider.of<ProfileInfoProvider>(context, listen: false).userInfoModel;

      widget.title = data!.data!.name;
      widget.userImgUrl =data.data!.img;
      setState(() {

      });


    }
  }

  getCurrentUserImage() async {
    final providerApi = Provider.of<ProfileApiProvider>(context, listen: false);

    if(providerApi.profileData!=null && providerApi.profileData['img'] != null){
      currentUserImage = providerApi.profileData['img'];
    }
    else{
        final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);
        await profileApi.getProfile(dio: dio, context: context);
        currentUserImage = providerApi.profileData['img'];
    }

  }



  getData() async {
    if(widget.isFromFeatureProduct == false){
      getConversation(loading: true);
    }
    else{
      Provider.of<ChatApiProvider>(context, listen: false).isConversationLoading = true;
      await createConversationId();
      getConversation(loading: true);
    }
    startTimer();
  }

  createConversationId() async {
    Map body = {
      "sender_id": pref.getString(PrefKey.userId),
      "receiver_id": widget.recieverId,
      "product_id": widget.productId

    };

    var responce = await customPostRequest.httpPostRequest(
        body: body, url: AppUrls.existingConversationUrl);

    if(responce["success"] == true) {
      widget.conversationId = responce["data"];
    }
    setState(() {

    });
  }


  List<Conversation> conversation = [];

  bool isSending = false;

//! offer variables

  String? productId;
  String? offerId;
  String? sellerId;
  String? buyerId;
  String productImg = '';
  String offerResponcePersonName = '';
  var chatApiProvider;
  var open;
  Timer? _timer;

  bool offerLoading = false;



  Future<void> getConversation({bool loading=false}) async {
   final chatApi =  Provider.of<ChatApiProvider>(context, listen: false);

    await chatApi.getConversation(updateOnly: true, dio: dio, loading: loading, context: context, conversationId: widget.conversationId, recieverId: widget.recieverId, sellingId: widget.sellerId, buyerId: widget.buyerId, title: widget.title);

    chatModel = Provider.of<ChatProvider>(context, listen: false).data!;



    if (chatModel != null &&
        chatModel!.data!.participant1 != null &&
        chatModel!.data!.conversation != []) {
      if (userId != chatModel!.data!.participant1!.id) {
        nextUserId = chatModel!.data!.participant1!.id;
        nextUserName = chatModel!.data!.participant1!.name;
      } else {
        nextUserId = chatModel!.data!.participant2!.id;
        nextUserName = chatModel!.data!.participant2!.name;
      }
    }

    conversation = Provider.of<ChatProvider>(context, listen: false)
        .data!
        .data!
        .conversation ??
        [];

    conversation.forEach((element) {
      if (element.offer != null &&
          element.offer?.status == null &&
          element.senderId != userId) {
        // if (element.offer!.sellerId != userId) {
        log("widget.isOffer is set to true");


        widget.isOffer = true;
        widget.offerPrice = element.offer!.offerPrice ?? "0";
        _priceController.text = widget.offerPrice.toString();

        productId = element.productId.toString();

        offerId = element.offerId.toString();
        sellerId = element.offer!.sellerId.toString();
        buyerId = element.offer!.buyerId.toString();


        if(element.product!=null && element.product!.photo!.isNotEmpty){
          productImg = element.product?.imagePath?.url ?? '';
        }
        else{
          productImg = "";
        }

        // offerResponcePersonName=element.

        return;
        // }

        //  offerImage = element.offer!.;
      }
    });

   if(conversation.last.receiverId == userId){
     chatApi.changeUnReadMessagesStatus(
       dio: dio,
       context: context,
       conversationId: conversation.last.conversationId,
     );
   }

   widget.sellerId ??= chatModel!.data!.conversation![0].sellerId;
   widget.buyerId ??= chatModel!.data!.conversation![0].buyerId;
   widget.productId ??= chatModel!.data!.conversation![0].productId;
   widget.recieverId ??= chatModel!.data!.conversation!.last.receiverId == userId ? chatModel!.data!.conversation!.last.senderId : chatModel!.data!.conversation!.last.receiverId  ;

   getUserDetails();
  }


  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if(chatModel!=null && chatModel!.data!=null && chatModel!.data!.conversation!=null && chatModel!.data!.conversation!.isNotEmpty) {
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
    chatApiProvider = Provider.of<ChatApiProvider>(context);
    open = Provider.of<NotifyProvider>(context);

    // final chatApi = Provider.of<ChatApiProvider>(context);

    // log("chatApi data = ${chatApi.conversationData}");
    return PopScope(
      onPopInvoked: (value){
        // Provider.of<ChatProvider>(context).loading = true;
      },
      child: Scaffold(
        // key: navigatorKey,
        appBar: ChatAppBar(
          img: widget.userImgUrl,
          userRating:  widget.userRating,
          productImg: chatModel?.data?.conversation?[0].product?.imagePath?.url,
          productPrice: chatModel?.data?.conversation?[0].product?.fixPrice?.toString() ?? 'Auction',
          title: capitalizeWords(widget.title ?? ''),
          actionOntap: () {
            if(widget.productId!=null){
              push(context,SellerProfileChatScreen(userId: widget.buyerId.toString() == userId.toString() ? widget.sellerId : widget.buyerId,));
            }
          },
          imageOnTap: () {
            if(widget.productId!=null){
              getFeatureProductDetail(productId:widget.productId!, navigateToProduct:true);
            }
          },
          action: [
            if(widget.contactNumber != null)
            InkWell(
              onTap: () async {
                var url = Uri.parse("tel:${widget.contactNumber.toString()}");

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Image.asset(
                "assets/images/callCalling.png",
                height: 24,
                width: 24,
              ),
            )
          ],
        ),
        body:
        Consumer<ChatApiProvider>(
            builder: (context, apiProvider, child) {
                return apiProvider.isConversationLoading ? const Center(child: CircularProgressIndicator()) : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.isOffer == true && userId.toString() == widget.sellerId.toString()
                      ? SizedBox(
                          height: open.isCustom == false ? 200 : 360,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20, top: 30),
                                child: Container(
                                  height: open.isCustom == false ? 170 : 330,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffF3F4F5),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AppText.appText(
                                            "${capitalizeWords(widget.title ?? '')} sent you a offer",
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
                                                  AppText.appText(
                                                      "Enter Your Offer",
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      textColor:
                                                          AppTheme.textColor),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: offerLoading
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                        color: AppTheme.appColor,
                                                      ))
                                                    : AppButton.appButton(
                                                        "Send Offer", onTap: () {
                                                        sendOffer();
                                                        // push(
                                                        //     context, OfferChatScreen());
                                                      },
                                                        height: 50,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        radius: 32.0,
                                                        backgroundColor:
                                                            AppTheme.appColor,
                                                        textColor:
                                                            AppTheme.whiteColor),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 64,
                                  width: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(productImg),
                                        // : const AssetImage(
                                        //         "assets/images/user.png")
                                        //     as ImageProvider,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                    child: conversation.isEmpty
                        ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.appText('Tap a message to send or write your own',
                              fontWeight: FontWeight.w600,
                                fontSize: 13.sp
                              ),
                              SizedBox(height: 10.h,),
                              ListView.builder(
                                itemCount: predefinedMessages.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => onMessageTap(predefinedMessages[index]),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4.0),
                                            border: Border.all(
                                              color: Color(0xff6ba99c),
                                              width: 2
                                            )
                                          ),
                                          child: AppText.appText(
                                            predefinedMessages[index],
                                            fontSize: 13.0,
                                            textColor: Color(0xff6ba99c),
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ]
                          ),
                        )
                        : StreamBuilder<Object>(
                            stream: secRef.onValue,
                            builder: (context, AsyncSnapshot snapshot) {
                              List<Conversation> list = conversation.reversed.toList();
                              return ListView.separated(
                                controller: _scrollController,
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: conversation.length,
                                itemBuilder: (context, index) {
                                  return _buildMessageBubble(
                                    time: "${list[index].createdAt}",
                                    user: userId == list[index].senderId!
                                        ? true
                                        : false,
                                    message: "${list[index].message}",
                                    img: "${list[index].file}",
                                    offerPrice: list[index].offer?.offerPrice,
                                    status: list[index].status == null ? false : list[index].status == 'read' ? true : false
                                  );
                                }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: index!=0 ? list[index-1].senderId! ==  list[index].senderId! ? 5.h : 0 : 0); },
                              );
                            }),
                  ),
                  _buildUserInput(),
                ],
              ),
            );
          }
        ),
      ),
    );
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
      {required user, String? message, String? img, int? offerPrice, required var time, required bool status, String? profilePhoto}) {
    log("img msg = $img");
    log("message msg = $message");


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
            AppText.appText(formatTimestamp(time, full: true),
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
          BubbleNormalImage(
            isSender: user,
            id: 'id001',
            image: Image.network(img),
            // color: Colors.purpleAccent,
            tail: true,
            delivered: true,
          )
        else
          Container(
              alignment: user ? Alignment.centerRight : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              child: Row(
                mainAxisAlignment: user ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [

                  if(user)
                  Image.asset(
                    "assets/images/check.png",
                    height: 16.h,
                    color: status ? AppTheme.yellowColor : const Color(0xff7486A1),
                  ),
                  if(user)
                    SizedBox(width: 10.w,),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 250, minWidth: 80),
                        padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 9.h),
                        decoration: BoxDecoration(
                          color: systemMessage(message ?? '') ? AppTheme.yellowColor : user ? AppTheme.appColor : const Color(0xffEAEAEA),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText(msg(message,user, offerPrice ) ?? "no text",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: systemMessage(message ?? '') ? Colors.black : user ? AppTheme.whiteColor : Colors.black)
                          ],
                        ),
                      ),
                        if(user ? currentUserImage!=null : widget.userImgUrl!=null)
                        Positioned(
                          right: user ? -8.w : null,
                          left: user ? null : -8.w,
                          top:  user ? -6.h : -6.h,
                          child: CircleAvatar(
                            radius: 10.r,
                            backgroundImage: NetworkImage(user ? currentUserImage! : widget.userImgUrl!),
                          ),
                        )
                    ],
                  ),
                ],
              )),


        // Padding(
        //   padding: user
        //       ? const EdgeInsets.only(right: 20.0)
        //       : const EdgeInsets.only(left: 20.0),
        //   child: AppText.appText(formatTimestamp(time),
        //       fontSize: 10,
        //       fontWeight: FontWeight.w400,
        //       textColor: AppTheme.lighttextColor),
        // ),
      ],
    );
  }

  Widget _buildUserInput() {
    final chatApi = Provider.of<ChatApiProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Container(
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
                enabled: !disableTextField,
                controller: _textEditingController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type here ...',
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                getImagesFromGallery();

                // await chatApi.sendMessage(
                //     dio: dio,
                //     context: context,
                //     image: pickedImage,
                //     senderId: userId,
                //     recieverId: widget.recieverId,
                //     title: widget.title,
                //     message: "");
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
            if (isSending)
              Center(
                child: CircularProgressIndicator(
                  color: AppTheme.appColor,
                ),
              )
            else
              InkWell(
                onTap: () async {

                  // if(widget.isFromFeatureProduct == true){
                  //   await createConversationId();
                  // }


                  final userMessage = _textEditingController.text;
                  if (userMessage.isNotEmpty) {
                    //! this is chat api
                    setState(() {
                      isSending = true;
                      disableTextField = true;
                    });
                    bool isSent = await sendMessage(
                        dio: dio,
                        context: context,
                        image: pickedImage,
                        senderId: userId,
                        recieverId: widget.recieverId,
                        title: widget.title,
                        buyerId: widget.buyerId,
                        productId: widget.productId,
                        sellerId: widget.sellerId,
                        message: userMessage);

                    setState(() {
                      isSending = false;
                      disableTextField = true;
                    });
                    if (isSent) {
                      _textEditingController.clear();

                      // showSnackBar(context, "Message Sent");
                    }

                    // SendNotification.sendNotification(
                    //     context: context,
                    //     userId: int.parse(widget.recieverId.toString()),
                    //     text: "You have a new message",
                    //     type: "conversation",
                    //     typeId: int.parse(
                    //         conversation[0].conversationId!.toString()),
                    //     status: "unread");


                  }
                },
                child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      "assets/images/send.png",
                      color: Color(0xff039b73),
                      fit: BoxFit.cover,
                    )),
              ),
          ],
        ),
      ),
    );
  }

  bool systemMessage(String message){
    if(message.contains('accepted your offer') || message.contains('rejected your offer') || message.contains('made an offer') || message.contains('Unfortunately, the seller has canceled the offer.')){
      return true;
    }
    else {
      return false;
    }
  }

  String msg(String? message, bool isCurrentUserSender, int? offerPrice ){
    if(message!=null){
      if(message.contains('accepted the offer') || message.contains('accepted your offer')){
        if(isCurrentUserSender==true) {
          return 'The price has been agreed. Please proceed with selling the product to avoid any account restriction issues.';
        }
        else{
            return 'Congratulations! The seller accepted your offer. To avoid any account restriction issues, please proceed with purchasing the product from the seller.';
        }
      }
      else if(message.contains('rejected the offer') || message.contains('rejected your offer')){
        if(isCurrentUserSender==true) {
          return 'You have rejected this offer.';
        }
        else{
          return '${capitalizeWords(widget.title ?? '')} has rejected the offer.';
        }
      }
      else if(message.contains('made an offer')){
        if(isCurrentUserSender==true) {
          if(offerPrice == null) {
            return 'You have made an offer.';
          } else {
            return 'You have made an offer for AED $offerPrice.';
          }
        }
        else{
          return capitalizeWholeTitle(message, widget.title ?? '');
        }
      }
      else if(message.contains('Unfortunately, the seller has canceled the offer.')){
        if(isCurrentUserSender==true) {
          return 'You have declined the buyer\’s offer and made a special offer.';
        }
        else{
          return message;
        }
      }
      else{
        return message;
      }
    }
    else{
      return '';
    }
  }


  Future<void> sendFileMsg(
      {required senderId, required recieverId, required XFile image, required productId,
      }) async {
    String token = pref.getString(PrefKey.authorization)!;

    log("token in sendFileMsg= $token");


    setState(() {
      isSending = true;
    });
    final headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map<String, dynamic> json = {};
    var request = http.MultipartRequest(
        "POST", Uri.parse(AppUrls.baseUrl + AppUrls.sendMessage));
    request.fields['sender_id'] = senderId.toString();
    request.fields['receiver_id'] = recieverId.toString();
    request.fields['seller_id'] = widget.sellerId.toString();
    request.fields['buyer_id'] = widget.buyerId.toString();
    request.fields['product_id'] = widget.productId.toString();
    request.headers.addAll(headers);
    http.MultipartFile multipartfile;

    multipartfile = await http.MultipartFile.fromPath('images[]', image.path);
    request.files.add(multipartfile);
    // }

    var response = await request.send();

    log("response.statusCode : ${response.statusCode}");
    log("response.statusCode : ${response}");
    if (response.statusCode != 200) {
      log("exception in sending file message");
      throw Exception("exception in sending file message");
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    json = jsonDecode(responseString.replaceFirst('saving files', ''));
    setState(() {
      isSending = false;
    });
    if (json["message"] == "Message Send Successfully.") {
      // showSnackBar(context, "Message Sent");
    }
    log("json in SendFileMsgRepo = ${json.toString()}");

    try {
      log("image file = ${json["data"]["Images"][0]["file"]} ");
      var cons = Conversation(
          // message: message,
          senderId: senderId,
          createdAt: DateTime.now(),
          conversationId: json['conversationId'],
          file: json["data"]["Images"][0]["file"],
          receiverId: recieverId);

      log("conversation length before = ${conversation.length}");
      conversation.add(cons);

      setState(() {});
      // await SendNotification.sendNotification(
      //     context: context,
      //     userId: int.parse(recieverId.toString()),
      //     text: "You have a new message",
      //     type: "conversation",
      //     typeId: int.parse(conversation[0].conversationId!.toString()),
      //     status: "unread");
    } catch (e) {
      log("exception in file = ${e.toString()}");
      setState(() {
        isSending = false;
      });
    }

    log("conversation length after = ${conversation.length}");
  }

  Future<bool> sendMessage(
      {required dio,
      required context,
      required senderId,
      required recieverId,
      required buyerId,
      required sellerId,
      required productId,
      required message,
      title,
      XFile? image,
      document}) async {


    var cons = Conversation(
        message: message,
        senderId: senderId,
        createdAt: DateTime.now(),
        conversationId: widget.conversationId,
        // file: responseData["Images"][0],
        receiverId: recieverId);


    var formData;
    Map<String, dynamic>? params;

    bool found = false;

    if (image != null) {
      log("sending image in chat i.e = ${image.path}");
      formData = FormData.fromMap({
        "sender_id": senderId,
        "receiver_id": recieverId,
        "buyer_id": buyerId,
        "seller_id": sellerId,
        "product_id": productId,
        // "message": message,
        "images[]":
            await MultipartFile.fromFile(image.path, filename: image.name),
      });
    } else {
      params = {
        "sender_id": senderId,
        "receiver_id": recieverId,
        "message": message,
        "buyer_id": buyerId,
        "seller_id": sellerId,
        "product_id": productId,
        // "images[]": image,
        // "documents[]": document,
      };
    }

    // try {
    var response =
        await dio.post(path: AppUrls.sendMessage, data: formData ?? params);
    var responseData = response.data;
    if (response.statusCode == 200) {
      log("send message response = $responseData");


      var cons = Conversation(
          message: message,
          senderId: senderId,
          createdAt: DateTime.now(),
          conversationId: responseData['conversationId'],
          // file: responseData["Images"][0],
          receiverId: recieverId);

      int id =responseData['data']["Message"][0]['id'];


        if (conversation.isNotEmpty && conversation.last.id == id) {
          found = true;
        }
        else {
          conversation.add(cons);

        }



      setState(() {});

      // var data = responseData["data"]["Message"][0];
      //  getConversation(dio: dio, context: context, conversationId: data["conversation_id"], recieverId: recieverId, title: title);
      return true;
    } else {
      return false;
    }
    // } catch (e) {
    //   print("Something went Wrong $e");
    //   showSnackBar(context, "Something went Wrong.");
    //   return false;
    // }
  }

  Future<bool> rejectOfferHandler() async {
    Map body = {
      "product_id": productId,
      "seller_id": widget.sellerId,
      "buyer_id": widget.buyerId,
      "offer_id": offerId,
    };
    showAlertLoader(context: context);

    var responce = await customPostRequest.httpPostRequest(
        url: AppUrls.rejectOfferrUrl, body: body);

    Navigator.of(context).pop();

    log("responce in rejectOfferHandler = $responce");

    showSnackBar(context, responce["message"], error: false);

    if (responce["success"] == true) {
      log("offer should be closed in rejectOfferHandler");

      setState(() {
        widget.isOffer = false;
      });
      return true;
    } else {
      return false;
    }
  }

  Future<void> acceptOfferHandler() async {
    showAlertLoader(context: context);

    Map body = {
      "product_id": productId,
      "seller_id": widget.sellerId,
      "buyer_id": widget.buyerId,
      "offer_id": offerId,
    };
    var responce = await customPostRequest.httpPostRequest(
        url: AppUrls.acceptOfferrUrl, body: body);

    Navigator.of(context).pop();

    log("responce in acceptOfferHandler = $responce");
    showSnackBar(context, responce["message"], error: false);

    if (responce["success"] == true) {
      log("offer should be closed in acceptOfferHandler");
      setState(() {
        widget.isOffer = false;
      });
    }
  }

  void makeCustomOfferHandler() {
    setState(() {
      offerLoading = true;
    });
  }

  Future<void> sendOffer() async {
    bool isRejected = await rejectOfferHandler();
    open.openclose();
    widget.isOffer = false;

    if (isRejected) {
      setState(() {
        isSending = true;
      });
      bool isSent = await sendMessage(
          dio: dio,
          context: context,
          image: pickedImage,
          senderId: userId,
          recieverId: widget.recieverId,
          title: widget.title,
          buyerId: widget.buyerId,
          productId: widget.productId,
          sellerId: widget.sellerId,
          message:
              "Unfortunately, the seller has canceled the offer. They've proposed a new price ${_priceController.text.trim()}. If you are still interested then make a new offer of ${_priceController.text.trim()}");

      setState(() {
        isSending = false;
      });
      if (isSent) {
        _priceController.clear();
      }
      // var responce = await chatApiProvider.makeOffer(
      //     dio: dio,
      //     context: context,
      //     productId: productId,
      //     sellerId: sellerId,
      //     buyerId: int.parse(buyerId!),
      //     offerPrice: int.parse(_priceController.text.trim()));

      // if (responce['success'] == true) {
      //   widget.isOffer = false;
      //   setState(() {});
      // pushReplacement(
      //     context,
      //     OfferChatScreen(
      //       isOffer: false,
      //       userImgUrl: widget.userImgUrl,
      //       title: widget.title,
      //     ));
      // }

      // Map<String, dynamic> params = {
      //   "product_id": productId,
      //   "seller_id": sellerId,
      //   "buyer_id": buyerId,
      //   "offer_price": _priceController.text.trim(),
      // };

      // var response = await dio.post(path: AppUrls.makeOffer, data: params);
      // var responseData = response.data;

      // if (responseData['success'] == true) {
      //   showSnackBar(context, "Offer placed Successfully");

      //   pushReplacement(
      //       context,
      //       OfferChatScreen(
      //         isOffer: false,
      //         userImgUrl: widget.userImgUrl,
      //         title: widget.title,
      //       ));
      // } else {
      //   showSnackBar(context, "Offer could not be placed");
      // }
    }
  }


////////////////////////////////////////// Image Compression ///////////////////////////////////////
  Future<void> getImagesFromGallery() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickImage(source: ImageSource.gallery);

      if(pickedFiles != null) {
        compressAndAddImage(pickedFiles.path);
      }

      // newImagePath = pickedFiles.single.path;
      // notifyListeners();

  }

  Future<void> compressAndAddImage(String imagePath) async {

    setState(() {
      isSending = true;
    });

    img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());

    img.Image compressedImage = img.copyResize(image!, width: 800);
    List<int> compressedImageData = img.encodeJpg(compressedImage, quality: 85);

    String compressedImagePath = await saveCompressedImage(compressedImageData);


    await sendFileMsg(
      image: XFile(compressedImagePath),
      senderId: userId.toString(),
      recieverId: widget.recieverId.toString(),
      productId: productId,
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

  void getAuctionProductDetail({productId}) async {
    pr.show();
    isLoading = true;

    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
    };
    try {
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
      var responseData = response.data;

      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          if(detailResponse.isEmpty){
          }
          else {
            push(
                context,
                SellerProfileScreen(
                    detailResponse:
                  detailResponse[0]));
          }


        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }

  void getFeatureProductDetail({productId, limit, bool navigateToProduct = false}) async {
    pr.show();
    isLoading = true;
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          if(detailResponse.isEmpty){
          }
          else {
            if(navigateToProduct == false){
            push(
                context,
                SellerProfileScreen(
                    detailResponse:
                    detailResponse[0]));  }
          else{
              push(
                  context,
                  FeatureInfoScreen(
                      detailResponse:
                      detailResponse[0]));
            }}
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }



}
