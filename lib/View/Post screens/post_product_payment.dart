import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/Post%20screens/post_card_payment.dart';

class PostProductPayment extends StatefulWidget {
  const PostProductPayment({super.key});

  @override
  State<PostProductPayment> createState() => _PostProductPaymentState();
}

class _PostProductPaymentState extends State<PostProductPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar1(
        title: "Post Product Payment",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              "assets/images/rough.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
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
                            AppText.appText("500",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.txt1B20),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const CustomDivider(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 180,
                width: 250,
                decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.appColor),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppText.appText("Post your product in",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppTheme.blackColor),
                    AppText.appText("\$10",
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        textColor: AppTheme.blackColor),
                    AppButton.appButton("Pay Now", height: 42, onTap: () {
                      push(context, PostingPaymentScreen());
                    },
                        width: 161,
                        textColor: AppTheme.whiteColor,
                        backgroundColor: AppTheme.appColor,
                        radius: 32.0)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
