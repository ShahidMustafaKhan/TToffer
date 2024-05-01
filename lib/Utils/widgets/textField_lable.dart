import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class LableTextField extends StatefulWidget {
  final labelTxt;
  final controller;
  final width;
  final pass;
  final hintTxt;
  final lableColor;
  final height;
  final maxLines;
  const LableTextField(
      {super.key,
      this.labelTxt,
      this.controller,
      this.width,
      this.pass,
      this.hintTxt,
      this.lableColor,
      this.height,
      this.maxLines});

  @override
  State<LableTextField> createState() => _LableTextFieldState();
}

class _LableTextFieldState extends State<LableTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText("${widget.labelTxt}",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: widget.lableColor ?? AppTheme.text09),
          const SizedBox(
            height: 10,
          ),
          widget.pass == true
              ? CustomAppPasswordfield(
                  texthint: "Password",
                  controller: widget.controller,
                )
              : CustomAppFormField(
                  maxline: widget.maxLines,
                  height: widget.height,
                  width: widget.width ?? MediaQuery.of(context).size.width,
                  texthint: "${widget.hintTxt}",
                  controller: widget.controller,
                  borderColor: AppTheme.borderColor,
                  hintTextColor: AppTheme.hintTextColor,
                )
        ],
      ),
    );
    ;
  }
}
