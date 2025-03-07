import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';

class CustomAppFormField extends StatefulWidget {
  final double? height;
  final double? width;
  final double? fontsize;
  final fontweight;
  final bool containerBorderCondition;
  final String texthint;
  final errorText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? hintTextColor;
  final int? maxline;
  final texAlign;
  bool? enable;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final double? radius;
  final TextStyle? errorStyle;
  final errorBorder;
  final focusedErrorBorder;
  final cPadding;
  final contentPadding;
  final type;
  final readOnly;
  final FocusNode? focusNode;
  List<TextInputFormatter>? inputFormatters;

   CustomAppFormField({
    Key? key,
    this.containerBorderCondition = false,
    this.readOnly = false,
    required this.texthint,
    required this.controller,
    this.validator,
    this.height,
    this.width,
    this.obscureText = false,
    this.enable = true,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.cursorHeight,
    this.textAlign = TextAlign.start,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.fontweight,
    this.fontsize,
    this.hintStyle,
    this.borderColor,
    this.errorText,
    this.radius,
    this.style,
    this.errorStyle,
    this.maxline,
    this.errorBorder,
    this.hintTextColor,
    this.focusedErrorBorder,
    this.cursorColor,
    this.texAlign,
    this.cPadding,
    this.contentPadding,
    this.type, this.focusNode,
    this.inputFormatters
  }) : super(key: key);

  @override
  State<CustomAppFormField> createState() => _CustomAppFormFieldState();
}

class _CustomAppFormFieldState extends State<CustomAppFormField> {
  @override
  Widget build(BuildContext context) {
    return TextField(


      // style:
      //     TextStyle(fontFamily : 'Poppins', fontSize: 13.5.sp, fontWeight: FontWeight.w400, color: AppTheme.textColor,  ),

      controller: widget.controller,
      textAlignVertical: TextAlignVertical.center,
      // cursorHeight: widget.cursorHeight ?? 20,
      cursorWidth: 2,
      keyboardType: widget.type ?? TextInputType.name,
      decoration: InputDecoration(
        isDense: false,
        errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints: BoxConstraints(
            minHeight: 48,
            maxHeight: 48,
            minWidth: 50

          ),


          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r), // Rounded corners
            borderSide: const BorderSide(
              color: Color(0xff1E293B), // Border color
              width: 1, // Border width
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
          hintText: widget.texthint,
          hintStyle: TextStyle(fontFamily : 'Poppins', fontSize: 13.5.sp, fontWeight: FontWeight.w400, color: AppTheme.textColor),
          ),
    );
  }
}

class CustomAppPasswordfield extends StatefulWidget {
  final double? height;
  final double? width;
  final bool containerBorderCondition;
  final String texthint;
  final errorText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final style;
  final errorStyle;
  final errorBorder;
  final focusedErrorBorder;

  const CustomAppPasswordfield(
      {Key? key,
      this.containerBorderCondition = false,
      required this.texthint,
      required this.controller,
      this.validator,
      this.height,
      this.width,
      this.onChanged,
      this.onTap,
      this.onTapOutside,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.cursorHeight,
      this.textAlign = TextAlign.start,
      this.prefix,
      this.suffix,
      this.prefixIcon,
      this.suffixIcon,
      this.prefixIconColor,
      this.suffixIconColor,
      this.errorText,
      this.hintStyle,
      this.cursorColor,
      this.style,
      this.errorStyle,
      this.errorBorder,
      this.focusedErrorBorder})
      : super(key: key);

  @override
  State<CustomAppPasswordfield> createState() => _CustomAppPasswordfieldState();
}

class _CustomAppPasswordfieldState extends State<CustomAppPasswordfield> {
  bool _obscureText = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 48,
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE5E9EB)),
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        textAlign: widget.textAlign,
        controller: widget.controller,
        cursorColor: AppTheme.blackColor,
        cursorWidth: 2,
        keyboardType: TextInputType.visiblePassword,
        textAlignVertical: TextAlignVertical.center,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        onTapOutside: widget.onTapOutside,
        onFieldSubmitted: widget.onFieldSubmitted,
        key: widget.key,
        obscureText: _obscureText,
        validator: widget.validator,
        style: widget.style,
        decoration: InputDecoration(
            suffixIconConstraints:
                const BoxConstraints(maxHeight: 20, minWidth: 40),
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 50,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(8),
            hintText: widget.texthint,
            hintStyle: widget.hintStyle ?? const TextStyle(
                color: Color(0xff939699),
                fontSize: 14,
                fontWeight: FontWeight.w400),
            isDense: true,
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.appColor,
                ),
              ),
            )),
      ),
    );
  }
}
