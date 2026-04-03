import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';

import '../../utils/resources/res/app_theme.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Contact",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9),
          child: Column(
            children: [
              customRow(
                  onTap: () {},
                  img: "assets/images/sms.png",
                  txt: "Support@ttoffer.com"),
              customRow(
                  onTap: () {},
                  img: "assets/images/call.png",
                  txt: "+971 50265 1684"),
              customRow(
                  onTap: () {},
                  icon: true,
                  img: "assets/images/call",
                  txt: "24/7 customer service"),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRow({img, txt, required Function() onTap, bool icon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if(icon == false)
                Image.asset(
                  "$img",
                  height: 20,
                )
                else
                  const Icon(Icons.access_time),
                const SizedBox(
                  width: 20,
                ),
                AppText.appText("$txt",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),
              ],
            ),
            // Image.asset(
            //   "assets/images/arrowFor.png",
            //   height: 16,
            // ),
          ],
        ),
      ),
    );
  }
}
