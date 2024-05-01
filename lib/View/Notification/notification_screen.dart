import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Notifications",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/auction2.png"),
                                          fit: BoxFit.cover)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AppText.appText("Modern light clothes",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppTheme.textColor),
                                    AppText.appText(
                                        "Here are the notification text",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        textColor: AppTheme.textColor),
                                  ],
                                ),
                              ],
                            ),
                            AppText.appText("34m Ago",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.textColor),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
