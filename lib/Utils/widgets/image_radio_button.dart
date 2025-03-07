import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/res/app_theme.dart';
import 'others/app_text.dart';

class ImageWithRadio extends StatefulWidget {
  final String? image;
  final String? val;
  final String? groupValue;
  final String? title;
  final Function()? onTap;

  final Function(String?)? onChanged;

  const ImageWithRadio({super.key, this.val, this.onTap, this.image, this.onChanged, this.groupValue, this.title});

  @override
  State<ImageWithRadio> createState() => _ImageWithRadioState();
}

class _ImageWithRadioState extends State<ImageWithRadio> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 15.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          height: 57.h,
                          width: 71.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8.r)),
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Image.asset('assets/images/${widget.image}.png'),
                          )),
                      SizedBox(width: 20.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.appText(widget.title!, fontWeight: FontWeight.w600, fontSize: 15.5.sp, textColor: const Color(0xff1E293B)),
                          SizedBox(height: 3.h,),
                          AppText.appText('default', fontWeight: FontWeight.normal, fontSize: 11.5.sp, textColor: const Color(0xffA4A4A4) )

                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 18.0, // Customize as needed
                    height: 24.0,
                    child: Radio<String>(
                      activeColor: AppTheme.appColor,
                      value: widget.val!,
                      groupValue: widget.groupValue,
                      onChanged: widget.onChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}