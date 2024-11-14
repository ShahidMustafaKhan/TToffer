import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';

import '../../../views/Profile Screen/profile_screen.dart';

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;
  final context;
  final title;
  final action;
  final actionOntap;
  final img;
  final bool dialog;
  Function()? backButtonTap;
  bool? selFaster;
  List<Widget>? widget = [];

  final bool? leading;

  final dynamic popValue;

  // Callback function

  CustomAppBar1(
      {super.key,
      this.context,
      this.title,
      this.action,
      this.selFaster = false,
      this.dialog = false,
      this.actionOntap,
      this.widget,
      this.backButtonTap,
      this.img,
      this.preferredHeight = 50.0,
      this.leading, this.popValue});

  @override
  Widget build(BuildContext context) {
    late AppDio dio;
    AppLogger logger = AppLogger();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AppBar(
          backgroundColor: Colors.white,
          forceMaterialTransparency: true,
          elevation: 0,
          leading: leading == false
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: selFaster == true
                      ? () {
                          pushReplacement(context,  BottomNavView(showDialog: dialog ? true : false ,));
                        }
                      : () async {
                          // dio = AppDio(context);
                          // logger.init();
                          // final profileApi =
                          // Provider.of<ProfileApiProvider>(context, listen: false);
                          // await profileApi.getProfile(
                          //   dio: dio,
                          //   context: context,
                          // );
                          if(backButtonTap!=null){
                            backButtonTap!();
                          }
                          else{
                            Navigator.pop(context, popValue);
                          }

                        },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/arrow-left.png",
                      height: 24,
                      width: 24,
                    ),
                  )),
          title: AppText.appText("$title",
              fontSize: 18,
              fontWeight: FontWeight.w400,
              textColor: const Color(0xff1B2028)),
          centerTitle: true,
          actions: widget),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight = 70.0;
  final context;
  final title;
  final action;
  final actionOntap;
  final imageOnTap;
  final String? img;
  final String? userRating;
  final String? productImg;
  final String? productPrice;

  // Callback function

  const ChatAppBar(
      {super.key,
      this.context,
      this.title,
      this.action,
      this.userRating,
      this.actionOntap,
      this.img, this.productImg, this.productPrice, this.imageOnTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, right: 12.w),
      child: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
          titleSpacing: 10,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15, bottom: 15),
                child: Image.asset(
                  "assets/images/arrow-left.png",
                  height: 24,
                  width: 24,
                ),
              )),

          title: Row(
            children: [
              InkWell(
                onTap: actionOntap,
                child: Row(
                  children: [
                    if(img == null)
                      SvgPicture.asset('assets/images/Avatar.svg',
                          width: 36.w,
                          height: 36.w
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: img == null ? Border.all(
                                color: Color(0xffa2a2a2),
                                width: 2
                            ) : null
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: img == null
                              ? const AssetImage("assets/images/user.png")
                              : NetworkImage(img!) as ImageProvider,
                          radius: 28,
                        ),
                      ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.appText("$title",
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            textColor: AppTheme.blackColor),
                        SizedBox(height: 2.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SizedBox(width: userRating == "0" ? 40.w : 12.w,),
                            StarRating(
                              percentage: userRating == null ? 0 : percentageOfFive(userRating.toString()),
                              color: Colors.yellow,
                              size: 18,
                            ),
                            SizedBox(width: 3.w,),
                            if(userRating != null)
                              AppText.appText(
                                  userRating == "0" ? 'not rated yet' : userRating.toString(),
                                  fontSize: userRating == "0" ? 11.sp : 12.sp,
                                  fontWeight: FontWeight.normal,
                                  textColor: AppTheme.txt1B20),
                          ],
                        ),
                        // AppText.appText("kevin.eth is typing...",
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.w400,
                        //     textColor: const Color(0xff626C7B)),
                      ],
                    ),
                  ],
                ),
              ),

              Spacer(),
              if(productImg != null)
              InkWell(
                onTap: imageOnTap,
                child: Row(
                  children: [
                    Stack(
                      children: [


                        Container(
                             width: 50.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23.r),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(productImg!)
                              )
                            ),),

                        Positioned(
                            bottom: 0,
                            child: Container(
                                height: 35.h,
                                width: 50.w,
                                padding: EdgeInsets.only(top: 3.h),
                                decoration: const BoxDecoration(
                                  color: Colors.black38,
                                ),
                                child: AppText.appText(productPrice == 'Auction' ? productPrice! : "AED ${removeLastTwoZeros(formatNumber(productPrice ?? ''))}" ?? '', fontSize: 10.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textColor: Colors.white.withOpacity(0.85)))),

                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5.w,)
            ],
          ),
          centerTitle: true,
          actions: action),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
