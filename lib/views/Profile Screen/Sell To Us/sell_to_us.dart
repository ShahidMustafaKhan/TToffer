import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';


class SellToUs extends StatelessWidget {
  const SellToUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Sell To Us",
      ),
      body: sellToUsColumn(),
    );
  }
  Widget sellToUsColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction List
          Column(
            children: [
              instructionRow("1", "Post your product on our platform."),
              SizedBox(height: 10.h), // Space between rows
              instructionRow("2", "Copy the link to your ad."),
              SizedBox(height: 10.h),
              instructionRow("3", "Send the ad link to our email: ",
                  boldText: "selltous@ttoffer.com"),
              SizedBox(height: 10.h),
              instructionRow(
                  "4", "Our representative will contact you via email within an hour."),
            ],
          ),

          SizedBox(height: 25.h), // Space between text and image

          // Centered Image
          Center(
            child: SvgPicture.asset(
              "assets/images/sell_to_us.svg",
              height: 285.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget instructionRow(String count, String text, {String? boldText}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number Circle
        Text(
          "$count.",
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w), // Space between number and text

        // Instruction Text
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(text: text),
                if (boldText != null)
                  TextSpan(
                    text: boldText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }}
