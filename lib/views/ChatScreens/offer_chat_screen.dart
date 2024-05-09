import 'dart:convert';
import 'dart:developer';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/constants.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class OfferChatScreen extends StatefulWidget {
  final String? userImgUrl;
  final bool? isOffer;
  final dynamic offerPrice;
  final dynamic recieverId;
  final String? title;
  const OfferChatScreen(
      {super.key,
      this.isOffer,
      this.offerPrice,
      this.userImgUrl,
      this.recieverId,
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
  ChatModel? chatModel;

  var nextUserId;
  var nextUserName;

  @override
  void initState() {
    // dio = AppDio(context);
    logger.init();
    getUserDetail();
    _priceController.text = "\$ 60";

    chatModel = Provider.of<ChatProvider>(context, listen: false).data!;

    if (chatModel != null) {
      if (userId != chatModel!.data.participant1.id) {
        nextUserId = chatModel!.data.participant1.id;
        nextUserName = chatModel!.data.participant1.name;
      } else {
        nextUserId = chatModel!.data.participant2.id;
        nextUserName = chatModel!.data.participant2.name;
      }
    }
    conversation = Provider.of<ChatProvider>(context, listen: false)
        .data!
        .data
        .conversation;

    super.initState();
  }

  getUserDetail() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var id = pref.getString(PrefKey.userId);
      userId = int.parse(id!);
    });
  }

  List<Conversation> conversation = [];

  bool isSending = false;
  @override
  Widget build(BuildContext context) {
    final open = Provider.of<NotifyProvider>(context);
    // final chatApi = Provider.of<ChatApiProvider>(context);

    // log("chatApi data = ${chatApi.conversationData}");
    return Scaffold(
      // key: navigatorKey,
      appBar: ChatAppBar(
        img: widget.userImgUrl,
        title: widget.title,
        action: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: CallButtonWidget(
                    id: nextUserId,
                    name: nextUserName,
                  ),
                )),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(right: 20),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Image.asset(
          //       "assets/images/callCalling.png",
          //       height: 24,
          //       width: 24,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                widget.isOffer == true
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
                                      AppText.appText("Sent you a offer",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          textColor: const Color(0xff2A2A2F)),
                                      AppText.appText("\$${widget.offerPrice}",
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
                                                onTap: () {},
                                                txt: "Reject Offer"),
                                            offerButtons(
                                                onTap: () {},
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
                                              child: AppButton.appButton(
                                                  "Send Offer", onTap: () {
                                                push(context,
                                                    const OfferChatScreen());
                                              },
                                                  height: 50,
                                                  fontWeight: FontWeight.w500,
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/auction1.png"),
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
                      ? const SizedBox.shrink()
                      : StreamBuilder<Object>(
                          stream: secRef.onValue,
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: conversation.length,
                              itemBuilder: (context, index) {
                                return _buildMessageBubble(
                                  time: "${conversation[index].createdAt}",
                                  user: userId == conversation[index].senderId
                                      ? true
                                      : false,
                                  message: "${conversation[index].message}",
                                  img: "${conversation[index].file}",
                                );
                              },
                            );
                          }),
                ),
                _buildUserInput(),
              ],
            ),
          ],
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
      {required user, String? message, String? img, required var time}) {
    log("img msg = $img");
    log("message msg = $message");
    return Column(
      crossAxisAlignment:
          user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
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
              )),
        Padding(
          padding: user
              ? const EdgeInsets.only(right: 20.0)
              : const EdgeInsets.only(left: 20.0),
          child: AppText.appText(formatTimestamp(time),
              fontSize: 10,
              fontWeight: FontWeight.w400,
              textColor: AppTheme.lighttextColor),
        ),
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
                controller: _textEditingController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type here ...',
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                pickedImage = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                await sendFileMsg(
                  image: pickedImage!,
                  senderId: userId,
                  recieverId: widget.recieverId,
                );

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
                  final userMessage = _textEditingController.text;
                  if (userMessage.isNotEmpty) {
                    //! this is chat api
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
                        message: userMessage);

                    setState(() {
                      isSending = false;
                    });
                    if (isSent) {
                      _textEditingController.clear();

                      showSnackBar(context, "Message Sent");
                    }
                  }
                },
                child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      "assets/images/send.png",
                      fit: BoxFit.cover,
                    )),
              ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime time = DateTime.parse(timestamp);
    String formattedTime = DateFormat('HH:mm').format(time);

    return formattedTime;
  }

  Future<void> sendFileMsg(
      {required senderId, required recieverId, required XFile image}) async {
    String token = pref.getString(PrefKey.authorization)!;

    log("token in sendFileMsg= $token");

    log("filePath in SendFileMsgRepo=${pickedImage!.path}");

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
    request.headers.addAll(headers);
    http.MultipartFile multipartfile;

    multipartfile = await http.MultipartFile.fromPath('images[]', image.path);
    request.files.add(multipartfile);
    // }

    var response = await request.send();

    log("response.statusCode : ${response.statusCode}");
    if (response.statusCode != 200) {
      log("exception in sending file message");
      throw Exception("exception in sending file message");
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    json = jsonDecode(responseString);
    setState(() {
      isSending = false;
    });
    if (json["message"] == "Message Send Successfully.") {
      showSnackBar(context, "Message Sent");
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
    } catch (e) {
      log("exception in file = ${e.toString()}");
    }

    log("conversation length after = ${conversation.length}");
  }

  Future<bool> sendMessage(
      {required dio,
      required context,
      required senderId,
      required recieverId,
      required message,
      title,
      XFile? image,
      document}) async {
    // final imageProvider =
    //     Provider.of<ImageNotifyProvider>(context, listen: false);

    // List<MultipartFile> imageFiles = [];

    // for (var i = 0; i < imageProvider.imagePaths.length; i++) {
    //   File file = File(imageProvider.imagePaths[i]);
    //   imageFiles.add(await MultipartFile.fromFile(file.path));
    // }
    // var formData = FormData.fromMap({
    //    "sender_id": productId,
    //   "receiver_id": sellerId,
    //   "message": buyerId,
    //   "images[]": imageFiles,
    //   "documents[]": document,
    // });
    var formData;
    Map<String, dynamic>? params;

    if (image != null) {
      log("sending image in chat i.e = ${image.path}");
      formData = FormData.fromMap({
        "sender_id": senderId,
        "receiver_id": recieverId,
        // "message": message,
        "images[]":
            await MultipartFile.fromFile(image.path, filename: image.name),
      });
    } else {
      params = {
        "sender_id": senderId,
        "receiver_id": recieverId,
        "message": message,
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

      conversation.add(cons);

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
}

class CallButtonWidget extends StatelessWidget {
  int id;
  String name;
  CallButtonWidget({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    log("receiver id = $id");
    log("receiver name = $name");
    return ZegoSendCallInvitationButton(
      // key: navigatorKey,

      // borderRadius: 30,
      iconSize: const Size.fromRadius(15),
      // buttonSize: Size.fromWidth(20),
      isVideoCall: false,
      verticalLayout: true,
      resourceID: "ttoffer_resource_id",
      invitees: [
        ZegoUIKitUser(
          id: id.toString(),
          name: name,
        ),

        // ZegoUIKitUser(
        //   id: "222",
        //   name: "ikram",
        // )
      ],
    );
  }
}
