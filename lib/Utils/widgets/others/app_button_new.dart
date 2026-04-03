import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class AppButton {
  static Widget appButtonForTextField(String text,
      {double? height,
      double? width,
       IconData? icon,
      Color? backgroundColor,
      Color? borderColor,
      EdgeInsetsGeometry? padding,
      TextAlign? textAlign,
      Color? textColor,
      Color? imageColor,
      double? fontSize,
      bool loading = false,
      Color? loadingColor,
      GestureTapCallback? onTap,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      TextBaseline? textBaseline,
      TextOverflow? overflow,
      double borderWidth=1,
      var radius,
      double? letterSpacing,
      bool underLine = false,
      bool fontFamily = false,
      String? imagePath,
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
                  : const BoxShadow(color: Colors.transparent)
            ],
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius ?? 10),
            border: border == false
                ? null
                : Border.all(
                    color: borderColor ?? (border == true
                        ? AppTheme.blackColor
                        : AppTheme.appColor),
                    width: borderWidth)),
        child: loading == true ? CircularProgressIndicator(color: loadingColor ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imagePath!=null)
              if(imagePath.endsWith(".svg"))
                SvgPicture.asset(imagePath, color: imageColor)
              else
                Image.asset(imagePath),
            if(icon!=null)
              Icon(icon, size: 15, color: const Color(0xff434343),),
            if(imagePath!=null || icon!=null)
              SizedBox(width: 10.w,),
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
        ]
        ),
      ),
    );
  }

//this AppButton is for the GoogleSignup/AppleSignup Button will only be used once in the app
  static Widget appBarWithLeadingIcon(String text,
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
      required double containerWidth,
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
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: containerWidth.w,),
              Expanded(
                child: SizedBox(
                  child: Row(
                    children: [
                      if(imagePath!.endsWith(".svg"))
                      SvgPicture.asset(
                        imagePath,
                        height: imgHeight,
                        color: borderColor,
                      ),
                      if(imagePath.endsWith(".png"))
                        Image.asset(
                          imagePath,
                          height: imgHeight,
                          color: borderColor,
                        ),
                      SizedBox(
                        width: space ?? 12,
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
              )

            ],
          ),
        ),
      ),
    );
  }
}
