import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'others/app_text.dart';

class ImageWithRightArrow extends StatefulWidget {
  final String? image;
  final String? groupValue;
  final String? title;
  final Function()? onTap;


  const ImageWithRightArrow({super.key, this.image, this.onTap, this.groupValue, this.title});

  @override
  State<ImageWithRightArrow> createState() => _ImageWithRightArrowState();
}

class _ImageWithRightArrowState extends State<ImageWithRightArrow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 19.w),
          child: Row(
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
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset('assets/images/${widget.image}.png'),
                      )),
                  SizedBox(width: 20.w,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(widget.title!, fontWeight: FontWeight.w600, fontSize: 15.5.sp, textColor: const Color(0xff1E293B)),
                      SizedBox(height: 4.h,),
                      Row(
                        children: [
                          Container(
                            width: 100.w,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/images/cards.png",
                                )
                              )
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                  width: 18.0, // Customize as needed
                  height: 24.0,
                  child: Center(child: Icon(Icons.chevron_right, size: 26,))),
            ],
          ),
        ),
      ),
    );
  }
}