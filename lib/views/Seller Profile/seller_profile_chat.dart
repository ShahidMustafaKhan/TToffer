import 'dart:developer';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dialogs/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/listview_container.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/bolck_user_service.dart';
import 'package:tt_offer/custom_requests/user_info_service.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/models/user_info_model.dart';
import 'package:tt_offer/providers/profile_info_provider.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';
import 'package:tt_offer/views/Profile%20Screen/profile_screen.dart';

import '../../Controller/APIs Manager/profile_apis.dart';
import '../../Utils/utils.dart';
import '../../config/dio/app_dio.dart';
import '../../utils/widgets/custom_loader.dart';

class SellerProfileChatScreen extends StatefulWidget {
  final int userId;
  final bool review;

  const SellerProfileChatScreen({super.key, required this.userId, this.review=false});

  @override
  State<SellerProfileChatScreen> createState() => _SellerProfileChatScreenState();
}

class _SellerProfileChatScreenState extends State<SellerProfileChatScreen> {
  List<ProductsDataInfo> data = [];
  List<ReviewsDataInfo> reviews = [];

  List<ProductsDataInfo> auction = [];
  List<ProductsDataInfo> feature = [];
  late final dio;

  bool loader = false;
  late bool isCurrentUser;

  String timeDifference = ''; // Store the calculated time difference

  getUserProduct() async {
    Provider.of<ProfileInfoProvider>(context, listen: false).rating = null;

    setState(() {
      loader = true;
    });
    await UserInfoService().userInfoService(
        context: context, id: widget.userId);

    setState(() {
      loader = false;
    });
    data = Provider.of<ProfileInfoProvider>(context, listen: false).data;
    reviews = Provider.of<ProfileInfoProvider>(context, listen: false).review;

    print('data --> $data');
    print('review --> $reviews');

    // Clear the lists before adding data to them
    feature.clear();
    auction.clear();

    // Calculate time difference and add to appropriate list
    List<ProductsDataInfo> temp=[];
    data.forEach((element) {
      if(element.isSold!='1') {
        temp.add(element);
        if (element.firmOnPrice == null) {
          auction.add(element);
        } else if (element.auctionPrice == null) {
          feature.add(element);
        }
      }
    });
    data = temp;

    setState(() {}); // Update the UI after adding data to lists
  }

  @override
  void initState() {
    super.initState();
    if(widget.userId == Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"] ){
      isCurrentUser=true;
    }
    else{
      isCurrentUser=false;
    }

    if(widget.review == true){
      selectIndex = 1 ;
    }

    dio = AppDio(context);
    getUserProduct();
  }



  String calculateTimeDifference(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(dateTime);
    int days = difference.inDays;
    int hours =
    difference.inHours.remainder(24); // Get hours within the current day
    int minutes = difference.inMinutes
        .remainder(60); // Get minutes within the current hour

    if (days > 0) {
      return '$days ${days == 1 ? 'day' : 'days'} $hours ${hours == 1 ? 'hour' : 'hours'} $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'} $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }
  }

  List<String> dataRequest = [
    'Inappropriate profile picture',
    'The user is threatening me',
    'The user is insulting me',
    'Spam',
    'Fraud',
    'Other'
  ];

  String? selectData;

  int selectIndex = 0;

  blockUserHandler(bool report, setstaet) async {
    setstaet(() {
      loader = true;
    });

    await BlockdeUserService().blockUserService(
        context: context, id: widget.userId, report: report);

    setstaet(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: CustomAppBar1(
          widget: [
            if(isCurrentUser==false)
              PopupMenuButton(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        padding:
                        const EdgeInsets.only(right: 60, left: 10, bottom: 0),
                        value: 1,
                        child: const Text('Block User'),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setsts) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        surfaceTintColor: AppTheme.white,
                                        title: const Text(
                                          'Do you want to block this user?',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: AppTheme.appColor),
                                              )),
                                          loader
                                              ? CupertinoActivityIndicator(
                                            color: AppTheme.appColor,
                                            animating: true,
                                            radius: 12,
                                          )
                                              : TextButton(
                                              onPressed: () {
                                                blockUserHandler(false, setsts);
                                              },
                                              child: Text('Yes',
                                                  style: TextStyle(
                                                      color: AppTheme.appColor))),
                                        ],
                                      );
                                    });
                              });
                        },
                      ),
                      PopupMenuItem(
                        padding:
                        const EdgeInsets.only(right: 60, left: 10, bottom: 0),
                        value: 2,
                        child: const Text('Report User'),
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) =>
                                  StatefulBuilder(builder: (context, setstates) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                const Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 25.0),
                                                  child: Text('Report User',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 27)),
                                                ),
                                                const SizedBox(height: 15),
                                                for (int i = 0;
                                                i < dataRequest.length;
                                                i++)
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20)),
                                                        value: selectData ==
                                                            dataRequest[i],
                                                        onChanged: (val) {
                                                          selectData =
                                                          dataRequest[i];

                                                          setstates(() {});
                                                        },
                                                        activeColor:
                                                        AppTheme.appColor,
                                                        side: const BorderSide(
                                                            width: .5),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      AppText.appText(
                                                          dataRequest[i],
                                                          fontSize: 16)
                                                    ],
                                                  ),
                                                const SizedBox(height: 8),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18.0),
                                                  child: Container(
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                            Colors.black54),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                    child: const TextField(
                                                      decoration: InputDecoration(
                                                          hintText: 'Comment',
                                                          border:
                                                          InputBorder.none,
                                                          contentPadding:
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              10,
                                                              vertical:
                                                              7)),
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                            AppTheme.appColor,
                                                            decoration:
                                                            TextDecoration
                                                                .underline),
                                                      ),
                                                    ),
                                                    loader
                                                        ? CupertinoActivityIndicator(
                                                      color:
                                                      AppTheme.appColor,
                                                      animating: true,
                                                      radius: 12,
                                                    )
                                                        : TextButton(
                                                        onPressed: () {
                                                          blockUserHandler(
                                                              true,
                                                              setstates);
                                                        },
                                                        child: Text(
                                                          'Send',
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .appColor,
                                                              decoration:
                                                              TextDecoration
                                                                  .underline),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                        },
                      ),
                    ];
                  })
          ],
          action: true,
          title: capitalizeWords(isCurrentUser ? 'My Profile' : "Seller's Profile"),
        ),
        body: SingleChildScrollView(
          child: Consumer<ProfileInfoProvider>(
              builder: (context, apiProvider, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      upperContainer(apiProvider),
                      SizedBox(height: 3.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatItem('31', 'Bought'),
                          buildStatItem('624', 'Sold'),
                          buildStatItem('51', 'Followers'),
                          buildStatItem('53', 'Following'),
                        ],
                      ),

                      SizedBox(height: 3.h,),


                      if(apiProvider.userInfoModel?.data?.emailVerifiedAt ==
                          null || apiProvider.userInfoModel?.data?.phoneVerifiedAt ==
                          null || apiProvider.userInfoModel?.data?.imageVerifiedAt ==
                          null
                      )
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verifiedContainer(
                                txt: apiProvider.userInfoModel?.data?.emailVerifiedAt ==
                                    null
                                    ? "Email\nis not\nVerified"
                                    : "Email\nVerified",
                                color: apiProvider.userInfoModel?.data?.emailVerifiedAt !=
                                    null
                                    ? null
                                    : Colors.red,
                                img: "assets/images/sms.png"),
                            SizedBox(width: 57.w,),
                            verifiedContainer(
                                txt: apiProvider.userInfoModel?.data?.imageVerifiedAt ==
                                    null
                                    ? "Image\nis not\nVerified"
                                    : "Image\nVerified",
                                img: "assets/images/gallery.png",
                                color: apiProvider.userInfoModel?.data?.imageVerifiedAt !=
                                    null
                                    ? null
                                    : Colors.red

                            ),
                            SizedBox(width: 57.w,),
                            verifiedContainer(
                                txt: apiProvider.userInfoModel?.data?.phoneVerifiedAt ==
                                    null
                                    ? "Phone\nis not\nVerified"
                                    : "Phone\nVerified",
                                img: "assets/images/call.png",
                                color: apiProvider.userInfoModel?.data?.phoneVerifiedAt !=
                                    null
                                    ? null
                                    : Colors.red),
                          ],
                        ),
                      // selectOption(),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          SizedBox(width: 30.w,),
                          SellerSelectOption(
                            select: selectIndex == 0 ? true : false,
                            onTap: () {
                              selectIndex = 0;
                              setState(() {});
                            },
                            txt: 'Products',
                          ),
                          const Spacer(),
                          SellerSelectOption(
                            select: selectIndex == 1 ? true : false,
                            onTap: () {
                              selectIndex = 1;
                              setState(() {});
                            },
                            txt: 'Reviews',
                          ),
                          SizedBox(width: 30.w,),

                        ],
                      ),

                      const SizedBox(height: 10),
                      if (selectIndex == 0 && data.isNotEmpty)
                        for (int i = 0; i < data.length; i++)
                          InkWell(
                            onTap: () {
                              if (data[i].auctionPrice == null) {
                                getFeatureProductDetail(productId: data[i].id);
                                // print('featureId--->${l.id}');
                              } else {
                                getAuctionProductDetail(productId: data[i].id);
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 30.w,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: (data[i].photo != null &&
                                              data[i].photo!.isNotEmpty &&
                                              data[i].photo![0].src != null)
                                              ? NetworkImage(data[i]
                                              .photo![0]
                                              .src
                                              .toString()) as ImageProvider
                                              : const AssetImage(
                                              'assets/images/gallery1.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[i].title.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      SizedBox(height: 10.h,),
                                      Text(
                                        data[i].isSold == '1' ? 'Sold' : 'Listing',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xff1E293B),
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 30.w,),

                              ],
                            ),
                          ),

                      if((selectIndex == 0 && data.isEmpty) || (selectIndex == 1 && reviews.isEmpty))
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 60.h,),
                            Center(child: Image.asset("assets/images/no_data_folder.png", height: 120.h,)),
                            SizedBox(height: 12.h,),
                            AppText.appText(selectIndex == 0 ? "No products" : "No reviews",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textColor: Colors.black),
                            SizedBox(height: 12.h,)
                          ],
                        ),

                      if (selectIndex == 1 && reviews.isNotEmpty)
                        for (int i = 0; i < reviews.length; i++)
                          InkWell(
                            onTap: () {
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 30.w,),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                          (
                                              reviews[i].product!=null && reviews[i].product!.imagePath!=null && reviews[i].product!.imagePath!.src!=null &&
                                                  reviews[i].product!.imagePath!.src!.isNotEmpty
                                          )
                                              ? NetworkImage(reviews[i].product!.imagePath!.src!) as ImageProvider
                                              : const AssetImage(
                                              'assets/images/default_image.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(left: 12.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reviews[i].fromUesr!.name!=null ? reviews[i].fromUesr!.name! ?? '' : "",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          SizedBox(height: 6.h,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              StarRating(
                                                percentage: reviews[i].rating == null ? 0 : percentageOfFive(reviews[i].rating ?? '0'),
                                                color: Colors.yellow,
                                                size: 14,
                                              ),
                                              SizedBox(width: 7.w,),
                                              AppText.appText("${getRating(reviews[i].rating)}.0" ?? '',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.normal,
                                                  textColor: const Color(0xff1E293B)),
                                            ],
                                          ),
                                          SizedBox(height: 6.h,),
                                          if(reviews[i].comments!=null)
                                            LayoutBuilder(
                                              builder: (context, constraints) {
                                                final text = reviews[i].comments ?? '';

                                                // Create a TextPainter to determine the number of lines
                                                final textPainter = TextPainter(
                                                  text: TextSpan(
                                                    text: text,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xff000000),
                                                      fontSize: 12, // Default font size
                                                    ),
                                                  ),
                                                  maxLines: 5,
                                                  textDirection: TextDirection.ltr,
                                                );

                                                // Perform layout to calculate size
                                                textPainter.layout(maxWidth: constraints.maxWidth);

                                                // Determine the number of lines
                                                final lineCount = textPainter.computeLineMetrics().length;

                                                // Set font size based on line count
                                                final fontSize = lineCount > 3 ? 9.0 : lineCount > 1 ? 10.5 : 12.0;

                                                return AutoSizeText(
                                                  text,
                                                  maxLines: 5,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.normal,
                                                    color: Color(0xff000000),
                                                    fontSize: fontSize,
                                                  ),
                                                  minFontSize: 8, // Ensure it doesn't go below 8 if multiline
                                                  overflow: TextOverflow.ellipsis,
                                                );
                                              },
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 30.w,),

                                ],
                              ),
                            ),
                          )


                    ],
                  ),
                );
              }
          ),
        ));
  }



  Widget verifiedContainer({img, txt, color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color ?? AppTheme.appColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "$img",
                  height: 20,
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            WordsOnNewLine(text: txt),

          ],
        ),
      ),
    );
  }

  Widget upperContainer(ProfileInfoProvider apiProvider ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: apiProvider.userInfoModel?.data?.img ==
                            null
                            ? const AssetImage(
                            'assets/images/default_image.png')
                            : NetworkImage(apiProvider.userInfoModel!.data!.img!) as ImageProvider<Object>,
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(16)),
              ),
              SizedBox(height: 15.h,),
              Column(
                children: [
                  AppText.appText(capitalizeWords(apiProvider.userInfoModel?.data?.name ?? ''),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.txt1B20),
                  SizedBox(height: 4.h,),
                  AppText.appText("Joined ${formatMonthYear(apiProvider.userInfoModel?.data?.createdAt ?? '')}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.txt1B20),
                  if(apiProvider.userInfoModel?.data?.location !=null)...[
                    SizedBox(height: 4.h,),
                    AppText.appText(capitalizeWords(apiProvider.userInfoModel?.data?.location ?? ''),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.txt1B20),
                  ],
                  SizedBox(height: 6.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: apiProvider.rating == 0 ? 40.w : 12.w,),
                      StarRating(
                        percentage: apiProvider.rating == null ? 0 : percentageOfFive(apiProvider.rating.toString()),
                        color: Colors.yellow,
                        size: 25,
                      ),
                      SizedBox(width: 3.w,),
                      if(apiProvider.rating != null)
                        AppText.appText(
                            apiProvider.rating == 0 ? 'not rated yet' : apiProvider.rating.toString(),
                            fontSize: apiProvider.rating == 0 ? 11.sp : 12.sp,
                            fontWeight: FontWeight.normal,
                            textColor: AppTheme.txt1B20),
                    ],
                  ),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       SizedBox(width: 12.w,),
                  //       StarRating(
                  //       percentage: percentageOfFive(apiProvider.rating!=null ? apiProvider.rating.toString() : '0'),
                  //       color: Colors.yellow,
                  //       size: 25,
                  //     ),
                  //     SizedBox(width: 3.w,),
                  //     AppText.appText("(${apiProvider.rating ?? 0}/5)",
                  //         textAlign: TextAlign.center,
                  //         fontSize: 12.sp,
                  //         fontWeight: FontWeight.w400,
                  //         textColor: AppTheme.txt1B20),
                  //   ],
                  // ),
                  SizedBox(height: 8.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.access_time, size: 15.w, color: Colors.green,),
                      SizedBox(width: 5.w,),
                      AppText.appText("Responds within a few hours",
                          textAlign: TextAlign.end,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          textColor: AppTheme.txt1B20),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getRating(String? rating){
    if(rating == null){
      return "0";
    }
    else{
      if(int.parse(rating) > 5){
        return "5";
      }
      else if(int.parse(rating) < 0){
        return '0';
      }
      return rating;
    }
  }

  void getAuctionProductDetail({productId, limit}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    setState(() {
      pr.show();
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
      "limit": limit,
    };
    try {
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          push(context, AuctionInfoScreen(detailResponse: detailResponse[0]));
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }

  bool isLoading = false;

  bool isAuctionProduct = false;

  void getFeatureProductDetail({productId, limit}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    setState(() {
      pr.show();
      isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
      "limit": limit,
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          push(
              context,
              FeatureInfoScreen(
                detailResponse: detailResponse[0],
              ));
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }

  String selectedOption = 'Auction';

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.45) {
            setState(() {
              if (selectedOption != 'Auction') {
                // final apiProvider =
                // Provider.of<ProductsApiProvider>(context, listen: false);
                // apiProvider.getAuctionProducts(
                //     dio: dio, context: context, cateId: widget.catId);
              }
              selectedOption = 'Auction';
            });
          } else if (tapPosition < screenWidth * 0.9) {
            setState(() {
              if (selectedOption == 'Auction') {
                // final apiProvider =
                // Provider.of<ProductsApiProvider>(context, listen: false);
                // apiProvider.getFeatureProducts(
                //     dio: dio, context: context, cateId: widget.catId);
              }
              selectedOption = 'Featured';
            });
          }
        },
        child: Container(
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xffEDEDED))),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(100)),
                    color: selectedOption == 'Auction'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Auction',
                    style: TextStyle(
                      color: selectedOption == 'Auction'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == 'Featured'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      color: selectedOption == 'Featured'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerSelectOption extends StatefulWidget {
  String? txt;
  bool select;
  Function()? onTap;

  SellerSelectOption({this.txt, this.onTap, required this.select});

  @override
  State<SellerSelectOption> createState() => _SellerSelectOptionState();
}

class _SellerSelectOptionState extends State<SellerSelectOption> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Text(
            widget.txt!,
            style: GoogleFonts.poppins(
              fontSize: 17,
              color: AppTheme.appColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h,),
          if (widget.select == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 73.w,
                  height: 2.h,  // Height of the underline
                  color: AppTheme.appColor,
                ),
              ],
            ),
        ],
      ),
    );

  }
}
