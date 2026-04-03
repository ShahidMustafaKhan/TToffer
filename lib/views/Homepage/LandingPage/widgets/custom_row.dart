
import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import '../../../../Utils/resources/res/app_theme.dart';



class CustomRow extends StatelessWidget {
  String txt1;
  String txt2;
  String txt3;
  Function() onTap;
  CustomRow({super.key, required this.txt1, required this.txt2, required this.txt3, required this.onTap});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText(txt1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.textColor),
              GestureDetector(
                onTap: onTap,
                child: AppText.appText(txt2,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.textColor),
              )
            ],
          ),
          AppText.appText(txt3,
              fontSize: 10,
              fontWeight: FontWeight.w300,
              textColor: AppTheme.textColor),
        ],
      ),
    );
  }
}


