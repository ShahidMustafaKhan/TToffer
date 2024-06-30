import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight = 50.0;
  final context;
  final title;
  final action;
  final actionOntap;
  final img;
  bool? selFaster;
  List<Widget>? widget = [];

  final bool? leading;

  // Callback function

  CustomAppBar1(
      {super.key,
      this.context,
      this.title,
      this.action,
      this.selFaster = false,
      this.actionOntap,
      this.widget,
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
                  onTap: selFaster == true
                      ? () {
                          pushReplacement(context, const BottomNavView());
                        }
                      : () async {
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
          actions: widget),
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
