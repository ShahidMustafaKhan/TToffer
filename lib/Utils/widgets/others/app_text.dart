import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';

class AppText {
  static Widget  appText(String text,
      {TextAlign? textAlign,
      Color? textColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      TextBaseline? textBaseline,
      TextOverflow? overflow,
      int? maxlines,
      double? letterSpacing,
      bool underLine = false,
      bool fontFamily = false}) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxlines,
      style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontFamily:  'Poppins',
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          overflow: overflow,
          fontStyle: fontStyle,
          textBaseline: textBaseline,
          decorationColor: AppTheme.appColor,
          decoration: underLine == false
              ? TextDecoration.none
              : TextDecoration.underline),
    );
  }
}
