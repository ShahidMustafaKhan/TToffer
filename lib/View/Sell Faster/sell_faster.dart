import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/listview_container.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/Post%20screens/post_card_payment.dart';

class SellFaster extends StatefulWidget {
  const SellFaster({super.key});

  @override
  State<SellFaster> createState() => _SellFasterState();
}

class _SellFasterState extends State<SellFaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar1(
        title: "Sell Faster",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const ListViewContainer(),
            const CustomDivider(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 206,
                width: 250,
                decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.appColor),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppText.appText("Standard",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.appColor),
                    AppText.appText("Boost 3 Days",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppTheme.blackColor),
                    AppText.appText("\$4.99",
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        textColor: AppTheme.blackColor),
                    AppButton.appButton("Subscribe",
                        height: 42,
                        onTap: () {},
                        width: 161,
                        textColor: AppTheme.whiteColor,
                        backgroundColor: AppTheme.appColor,
                        radius: 32.0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: customRow(txt: "Switch promotion to any item."),
            ),
            const SizedBox(
              height: 40,
            ),
            AppText.appText("How does promoting work?",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: AppTheme.appColor),
          ],
        ),
      ),
    );
  }

  Widget customRow({txt}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/shield-tick.png",
            height: 24,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.79,
            child: AppText.appText("$txt",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.txt1B20),
          ),
        ],
      ),
    );
  }
}
