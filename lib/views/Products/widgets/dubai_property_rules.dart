import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/resources/res/app_theme.dart';

class DubaiPropertyRules extends StatelessWidget {
  const DubaiPropertyRules({super.key});

  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                      color: AppTheme.borderColor
                  )
              ),
              child: Image.asset("assets/images/qr.png")
          ),

          SizedBox(height: 15.h,),

          Container(
              padding: EdgeInsets.symmetric(horizontal:17.5.w, vertical: 11.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: const Color(0xffd8dbe0).withOpacity(0.25),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/icon.png', height: 40.w, width: 40.w,),
                  SizedBox(width: 15.w,),
                  RichText(
                    text: TextSpan(
                      text: "To know more about the rules \nand regulations visit the ",
                      style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(
                          text: "Dubai Land \nDepartment Website",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            color: Colors.black, // Optional: change the color to indicate it's clickable
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url = 'https://dubailand.gov.ae/en/#/';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                        ),
                        const TextSpan(text: "."),
                      ],
                    ),
                  ),
                ],
              )
          ),

          SizedBox(height: 28.h,),

        ],
      ),
    );
  }
}
