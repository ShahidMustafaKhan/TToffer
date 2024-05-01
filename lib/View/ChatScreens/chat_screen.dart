import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserDetail();
    super.initState();
  }

  getUserDetail() async {
    final apiProvider = Provider.of<ChatApiProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var id = pref.getString(PrefKey.userId);
      userId = id;
      apiProvider.getAllChats(dio: dio, context: context, userId: id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatApi = Provider.of<ChatApiProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: AppText.appText("Chat",
            fontSize: 20,
            fontWeight: FontWeight.w400,
            textColor: AppTheme.blackColor),
      ),
      body: chatApi.allChatsData == null? LoadingDialog(): ListView.builder(
        itemCount: chatApi.allChatsData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              chatApi.getConversation(
                  dio: dio,
                  context: context,
                  conversationId: chatApi.allChatsData[index]
                      ["conversation_id"],
                  title: chatApi.allChatsData[index]["receiver"]["id"] ==
                          int.parse(userId)
                      ? "${chatApi.allChatsData[index]["sender"]["name"]}"
                      : "${chatApi.allChatsData[index]["receiver"]["name"]}",
                  recieverId: chatApi.allChatsData[index]["receiver_id"] ==
                          int.parse(userId)
                      ? chatApi.allChatsData[index]["sender_id"]
                      : chatApi.allChatsData[index]["receiver_id"]);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage("assets/images/sp4.png"),
                          radius: 26,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppText.appText(
                                  chatApi.allChatsData[index]["receiver"]
                                              ["id"] ==
                                          int.parse(userId)
                                      ? "${chatApi.allChatsData[index]["sender"]["name"]}"
                                      : "${chatApi.allChatsData[index]["receiver"]["name"]}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  textColor: AppTheme.blackColor),
                              AppText.appText(
                                  "${chatApi.allChatsData[index]["message"]}",
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
                                  textColor: const Color(0xff626C7B)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppText.appText(
                            formatTimestamp(
                                "${chatApi.allChatsData[index]["created_at"]}"),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: const Color(0xffA7ACB4)),
                        // Container(
                        //   height: 20,
                        //   width: 20,
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: AppTheme.appColor,
                        //   ),
                        //   child: Center(
                        //     child: AppText.appText("1",
                        //         textColor: AppTheme.whiteColor,
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w400),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(timestamp);

    Duration difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour ago";
    } else if (difference.inDays == 1) {
      return "yesterday";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }
}
