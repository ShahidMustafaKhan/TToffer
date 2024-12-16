import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final onTap;
  final keyboard;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;
  final bool readOnly;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  const LableTextField(
      {super.key,
      this.labelTxt,
      this.controller,
      this.errorText,
      this.width,
      this.pass,
      this.hintTxt,
      this.lableColor,
      this.height,
      this.onTap,
      this.keyboard,
      this.maxLines, this.onChanged, this.readOnly=false, this.focusNode, this.inputFormatters, this.validator});

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
          widget.labelTxt == null
              ? const SizedBox.shrink()
              : AppText.appText("${widget.labelTxt}",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: widget.lableColor ?? AppTheme.text09),
          widget.labelTxt == ''
              ? const SizedBox.shrink()
              : const SizedBox(
                  height: 10,
                ),
          widget.pass == true
              ? CustomAppPasswordfield(
                  texthint: "Password",
                  controller: widget.controller,
                )
              : CustomAppFormField(
                  maxline: widget.maxLines,
                  focusNode: widget.focusNode,
                  height: widget.height,
                  onChanged:  widget.onChanged,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly,
                  validator: widget.validator,
                  type: widget.keyboard,
                  width: widget.width ?? MediaQuery.of(context).size.width,
                  texthint: "${widget.hintTxt}",
                  controller: widget.controller,
                  borderColor: AppTheme.borderColor,
                  hintTextColor: AppTheme.hintTextColor,
                ),
          if(widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 5.w, top: 2.h),
            child: AppText.appText(widget.errorText ?? '', textColor: Colors.red, fontSize: 11.sp),
          )
        ],
      ),
    );
    ;
  }
}
