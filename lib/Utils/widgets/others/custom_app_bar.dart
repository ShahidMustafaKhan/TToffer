import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight = 50.0;
  final context;
  final title;
  final action;
  final actionOntap;
  final img;
  final bool? leading;

  // Callback function

  const CustomAppBar1(
      {super.key,
      this.context,
      this.title,
      this.action,
      this.actionOntap,
      this.img,
      this.leading});

  @override
  Widget build(BuildContext context) {
    late AppDio dio;
    AppLogger logger = AppLogger();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: leading == false
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: () async {
                  // dio = AppDio(context);
                  // logger.init();
                  // final profileApi =
                  // Provider.of<ProfileApiProvider>(context, listen: false);
                  // await profileApi.getProfile(
                  //   dio: dio,
                  //   context: context,
                  // );
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    "assets/images/arrow-left.png",
                    height: 24,
                    width: 24,
                  ),
                )),
        title: AppText.appText("$title",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xff1B2028)),
        centerTitle: true,
        actions: [
          action == true
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: actionOntap,
                    child: Image.asset(
                      "${img}",
                      height: 24,
                      width: 24,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight = 70.0;
  final context;
  final title;
  final action;
  final actionOntap;
  final img;

  // Callback function

  const ChatAppBar(
      {super.key,
      this.context,
      this.title,
      this.action,
      this.actionOntap,
      this.img});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AppBar(
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15, bottom: 15),
                child: Image.asset(
                  "assets/images/arrow-left.png",
                  height: 24,
                  width: 24,
                ),
              )),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: img == null
                    ? const AssetImage("assets/images/user.png")
                    : NetworkImage(img) as ImageProvider,
                radius: 26,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.appText("$title",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textColor: AppTheme.blackColor),
                  // AppText.appText("kevin.eth is typing...",
                  //     fontSize: 10,
                  //     fontWeight: FontWeight.w400,
                  //     textColor: const Color(0xff626C7B)),
                ],
              ),
            ],
          ),
          centerTitle: true,
          actions: action),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
