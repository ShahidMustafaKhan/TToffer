import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class OfferChatScreen extends StatefulWidget {
  final String? userImgUrl;
  final bool? isOffer;
  final String? offerPrice;
  final int? recieverId;
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

  late AppDio dio;
  AppLogger logger = AppLogger();
  int? userId;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserDetail();
    _priceController.text = "\$ 60";
    super.initState();
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var id = pref.getString(PrefKey.userId);
      userId = int.parse(id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final open = Provider.of<NotifyProvider>(context);
    final chatApi = Provider.of<ChatApiProvider>(context);
    return Scaffold(
      appBar: ChatAppBar(
        title: widget.title,
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
                  child: chatApi.conversationData== null
                      ? const SizedBox.shrink()
                      : StreamBuilder<Object>(
                          stream: secRef.onValue,
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: chatApi
                                  .conversationData["conversation"].length,
                              itemBuilder: (context, index) {
                                return _buildMessageBubble(
                                  time:
                                      "${chatApi.conversationData["conversation"][index]["created_at"]}",
                                  user: userId ==
                                          chatApi.conversationData[
                                                  "conversation"][index]
                                              ["sender_id"]
                                      ? true
                                      : false,
                                  message:
                                      "${chatApi.conversationData["conversation"][index]["message"]}",
                                  img: "",
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

  Widget _buildMessageBubble({user, message, img, time}) {
    return Column(
      crossAxisAlignment:
          user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
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
                  AppText.appText("$message",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: user ? AppTheme.whiteColor : Colors.black),
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
              onTap: () {},
              child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    "assets/images/gallery.png",
                    fit: BoxFit.fill,
                    color: const Color(0xff8E97A4),
                  )),
            ),
            InkWell(
              onTap: () {
                final userMessage = _textEditingController.text;
                if (userMessage.isNotEmpty) {
                  chatApi.sendMessage(
                      dio: dio,
                      context: context,
                      senderId: userId,
                      recieverId: widget.recieverId,
                      title: widget.title,
                      message: userMessage);
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
}
