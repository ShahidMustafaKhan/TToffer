import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class AppButton {
  static Widget appButton(String text,
      {double? height,
      double? width,
      Color? backgroundColor,
      EdgeInsetsGeometry? padding,
      TextAlign? textAlign,
      Color? textColor,
      double? fontSize,
      GestureTapCallback? onTap,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      TextBaseline? textBaseline,
      TextOverflow? overflow,
      var radius,
      double? letterSpacing,
      bool underLine = false,
      bool fontFamily = false,
      bool? border,
      bool? blurContainer}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
            boxShadow: [
              blurContainer == true
                  ? const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0.0, 4))
                  : const BoxShadow()
            ],
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius ?? 10),
            border: border == false
                ? null
                : Border.all(
                    color: border == true
                        ? AppTheme.blackColor
                        : AppTheme.appColor,
                    width: 1)),
        child: AppText.appText(text,
            fontFamily: fontFamily,
            fontSize: fontSize,
            textAlign: textAlign,
            fontWeight: fontWeight,
            textColor: textColor,
            overflow: overflow,
            letterSpacing: letterSpacing,
            textBaseline: textBaseline,
            fontStyle: fontStyle,
            underLine: underLine),
      ),
    );
  }

//this AppButton is for the GoogleSignup/AppleSignup Button will only be used once in the app
  static Widget appButtonWithLeadingIcon(String text,
      {double? height,
      double? width,
      Color? backgroundColor,
      EdgeInsetsGeometry? padding,
      TextAlign? textAlign,
      Color? textColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      TextBaseline? textBaseline,
      TextOverflow? overflow,
      double? letterSpacing,
      Function()? onTap,
      IconData? icons,
      bool underLine = false,
      bool fontFamily = false,
      bool? border}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(50),
            border: border == false
                ? null
                : Border.all(
                    color: AppTheme.appColor,
                    width: 2,
                  )),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Icon(icons, size: 35),
            const SizedBox(
              width: 20,
            ),
            AppText.appText(text,
                fontFamily: fontFamily,
                fontSize: fontSize,
                textAlign: textAlign,
                fontWeight: fontWeight,
                textColor: textColor,
                overflow: overflow,
                letterSpacing: letterSpacing,
                textBaseline: textBaseline,
                fontStyle: fontStyle,
                underLine: underLine),
          ],
        ),
      ),
    );
  }

  static Widget appButtonWithLeadingImage(String text,
      {double? height,
      double? width,
      space,
      borderColor,
      double? imgHeight,
      Color? backgroundColor,
      EdgeInsetsGeometry? padding,
      TextAlign? textAlign,
      Color? textColor,
      radius,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      TextBaseline? textBaseline,
      TextOverflow? overflow,
      Color? color,
      double? letterSpacing,
      IconData? icons,
      Function()? onTap,
      String? imagePath,
      bool underLine = false,
      bool fontFamily = false,
      bool? border}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius?? 16),
            border: border == false
                ? null
                : Border.all(
                    color: borderColor?? const Color(0xff292D32),
                    width: 1,
                  )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "$imagePath",
              height: imgHeight,
              color: borderColor?? null,
            ),
            SizedBox(
              width: space ?? 10,
            ),
            AppText.appText(text,
                fontFamily: fontFamily,
                fontSize: fontSize,
                textAlign: textAlign,
                fontWeight: fontWeight,
                textColor: textColor,
                overflow: overflow,
                letterSpacing: letterSpacing,
                textBaseline: textBaseline,
                fontStyle: fontStyle,
                underLine: underLine),
          ],
        ),
      ),
    );
  }
}
