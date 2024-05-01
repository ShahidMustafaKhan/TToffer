import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/View/Notification/notification_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight = 70.0;
  final context;
  // Callback function

  const CustomAppBar({super.key, this.context});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 40, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/logo1.png",
            height: 40,
            width: 120,
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      push(context, const NotificationScreen());
                    },
                    child: Image.asset(
                      "assets/images/notification.png",
                      height: 20,
                    )),
                Image.asset(
                  "assets/images/location.png",
                  height: 20,
                ),
                AppText.appText("Belarus",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.textColor)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
