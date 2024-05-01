import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';

class ListViewContainer extends StatefulWidget {
  const ListViewContainer({super.key});

  @override
  State<ListViewContainer> createState() => _ListViewContainerState();
}

class _ListViewContainerState extends State<ListViewContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/images/auction1.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.appText("Modern light clothes",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: AppTheme.txt1B20),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText("Sold",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.appColor),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 10,
                              width: 1,
                              color: const Color(0xffEAEAEA),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AppText.appText("",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.appColor),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const CustomDivider()
      ],
    );
  }
}
