import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/bolck_user_service.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/product_model.dart';

import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';

import 'package:tt_offer/views/Profile%20Screen/profile_screen.dart';
import '../../Utils/utils.dart';
import '../../config/dio/app_dio.dart';
import '../../models/user_model.dart';
import '../../view_model/profile/user_profile/user_view_model.dart';

class SellerProfileScreen extends StatefulWidget {
  final detailResponse;
  final UserModel? sellerProfile;
  final bool review;

  const SellerProfileScreen({super.key, this.detailResponse, this.sellerProfile , this.review=false});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  List<Product?> products = [];
  List<Reviews?> reviews = [];


  late UserViewModel userViewModel;
  UserModel? sellerProfile;
  
  bool loader = false;
  late bool isCurrentUser;

  String selectedOption = 'Auction';

  String? authorizationToken;

  @override
  void initState() {
    super.initState();
    
    sellerProfile = widget.sellerProfile;

    userViewModel = Provider.of<UserViewModel>(context, listen: false);


    authorizationToken = pref.getString(PrefKey.authorization);
    int? userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    getSellerProfile();

    if(sellerProfile?.id == userId ){
      isCurrentUser=true;
    }
    else{
      isCurrentUser=false;
    }

    if(widget.review == true){
      selectIndex = 1 ;
    }

    dio = AppDio(context);
  }
  
  
  void getSellerProfile() async {
    try{
      sellerProfile = await userViewModel.getSellerProfile(sellerProfile?.id);

      reviews = sellerProfile?.reviews ?? [];
      products = sellerProfile?.products ?? [];

      setState(() {
        
      });
    }
    catch(e){
      log("get seller ${e.toString()}");
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
        context: context, id: sellerProfile?.id, report: report);

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      _upperContainer(),

                      SizedBox(height: 17.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildStatItem('${sellerProfile?.bought ?? 0}', 'Bought'),
                          buildStatItem('${sellerProfile?.sold ?? 0}', 'Sold'),
                          buildStatItem('${sellerProfile?.followersCount ?? 0}', 'Followers'),
                          buildStatItem('${sellerProfile?.followingCount ?? 0}', 'Following'),
                        ],
                      ),


                      if(isCurrentUser == false && authorizationToken != null)...[
                        SizedBox(height: 20.h,),
                        // Follow Button
                        _followButton(),
                      ],

                      SizedBox(height: 20.h,),

                      _verifiedIcons(),
                    ],
                  ),
                ),


                SizedBox(height: 20.h),

                _productAndReview()



              ],
            ),
          )
        ));
  }


  Widget _productAndReview(){
    return Column(
      children: [
        Row(
          children: [
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

          ],
        ),

        const SizedBox(height: 10),
        if (selectIndex == 0 && products.isNotEmpty)
          for (int i = 0; i < products.length; i++)
            InkWell(
              onTap: () {
                final productViewModel =  Provider.of<ProductViewModel>(context, listen: false);
                productViewModel.navigateToProductPage(products[i]?.id, context);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (products[i]?.photo?.isNotEmpty ?? false)
                                      ? NetworkImage(products[i]!
                                      .photo![0]
                                      .url!
                                      .toString()) as ImageProvider
                                      : const AssetImage(
                                      'assets/images/gallery1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    height: 25.h,
                                    width: productPriceForImage(products[i]) == '' ? 0 : 80,
                                    decoration: const BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),

                                    ),
                                    child: Center(child: AppText.appText(productPriceForImage(products[i]),
                                        fontSize: 10.sp, fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center, textColor: Colors.white.withOpacity(0.85))))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[i]?.title?.toString() ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 17),
                          ),
                          SizedBox(height: 10.h,),
                          Text(
                            products[i]?.isSold == 1 ? 'Sold' : 'Listing',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xff1E293B),
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

        if((selectIndex == 0 && products.isEmpty) || (selectIndex == 1 && reviews.isEmpty))
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            (
                                (reviews[i]?.product?.photo?.isNotEmpty ?? false)
                            )
                                ? NetworkImage(reviews[i]!.product!.photo![0].url!) as ImageProvider
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
                              reviews[i]?.user?.name ?? '' ,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 6.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                StarRating(
                                  percentage: percentageOfFive(reviews[i]?.rating),
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                SizedBox(width: 7.w,),
                                AppText.appText("${getRating(reviews[i]?.rating.toString())}.0" ?? '',
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    textColor: const Color(0xff1E293B)),
                              ],
                            ),
                            SizedBox(height: 6.h,),
                            if(reviews[i]?.comment!=null)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 197.w,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final text = reviews[i]?.comment ?? '';

                                        // Create a TextPainter to determine the number of lines
                                        final textPainter = TextPainter(
                                          text: TextSpan(
                                            text: text,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal,
                                              color: const Color(0xff000000),
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
                                            color: const Color(0xff000000),
                                            fontSize: fontSize,
                                          ),
                                          minFontSize: 8, // Ensure it doesn't go below 8 if multiline
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            )
      ],
    );
  }

  Widget _followButton(){
    return Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          return InkWell(
            onTap: (){
              userViewModel.toggleFollowApi(sellerProfile?.id)
                  .then((model) {
                    sellerProfile = model;
                    reviews = model?.reviews ?? [];
                    products = model?.products ?? [];
                    setState(() {

                    });
              }).onError((error, stackTrace){
                    showSnackBar(context, error.toString());
              });
            },
            child: Container(
            height: 40.h,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(6.r))
            ),
            child: Center(
              child: userViewModel.toggleFollowLoading ?
              const Center(child: CircularProgressIndicator(color: Colors.white,)) :
              AppText.appText(
                  sellerProfile?.isUserFollowed == true ? 'Unfollow' : 'Follow',
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp
              ),
            ),
                    ),
          );
      }
    );
  }

  Widget _verifiedIcons(){
      if(sellerProfile?.emailVerifiedAt == null ||
        sellerProfile?.imageVerifiedAt == null ||
        sellerProfile?.phoneVerifiedAt == null
    ) {
        return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _verifiedContainer(
              txt: sellerProfile?.emailVerifiedAt == null
                  ? "Email\nis not\nVerified"
                  : "Email\nVerified",
              color: sellerProfile?.emailVerifiedAt !=
                  null
                  ? null
                  : Colors.red,
              img: "assets/images/sms.png"),
          SizedBox(width: 57.w,),
          _verifiedContainer(
              txt: sellerProfile?.imageVerifiedAt ==
                  null
                  ? "Image\nis not\nVerified"
                  : "Image\nVerified",
              img: "assets/images/gallery.png",
              color: sellerProfile?.imageVerifiedAt !=
                  null
                  ? null
                  : Colors.red

          ),
          SizedBox(width: 57.w,),
          _verifiedContainer(
              txt: sellerProfile?.phoneVerifiedAt ==
                  null
                  ? "Phone\nis not\nVerified"
                  : "Phone\nVerified",
              img: "assets/images/call.png",
              color: sellerProfile?.phoneVerifiedAt !=
                  null
                  ? null
                  : Colors.red),
        ],
      );
      } else {
        return const SizedBox();
      }
  }

  Widget _verifiedContainer({img, txt, color}) {
    return SizedBox(
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
    );
  }

  Widget _upperContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
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
                        image: sellerProfile?.img ==
                                null
                            ? const AssetImage(
                                'assets/images/default_image.png')
                            : NetworkImage(sellerProfile!.img!) as ImageProvider<Object>,
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(16)),
              ),
              SizedBox(height: 15.h,),
              Column(
                children: [
                  AppText.appText(capitalizeWords(sellerProfile?.name ?? ''),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.txt1B20),
                  SizedBox(height: 4.h,),
                  if(sellerProfile?.createdAt!=null)
                  AppText.appText("Joined ${formatMonthYear(sellerProfile?.createdAt ?? '')}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.txt1B20),
                  if(sellerProfile?.location!=null)...[
                    SizedBox(height: 4.h,),
                    AppText.appText(capitalizeWords(sellerProfile?.location ?? ''),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.txt1B20),
                  ],
                  SizedBox(height: 6.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: sellerProfile?.reviewPercentage == null || sellerProfile?.reviewPercentage == 0 ? 40.w : 12.w,),
                      StarRating(
                        percentage: percentageOfFive(sellerProfile?.reviewPercentage?.round() ?? 0),
                        color: Colors.yellow,
                        size: 25,
                      ),
                      SizedBox(width: 3.w,),
                      if(sellerProfile?.reviewPercentage != null)
                      AppText.appText(
                          starCount(sellerProfile?.reviewPercentage),
                          fontSize: sellerProfile?.reviewPercentage == null || sellerProfile?.reviewPercentage == 0.0 ? 11.sp : 12.sp,
                          fontWeight: FontWeight.normal,
                          textColor: AppTheme.txt1B20),
                    ],
                  ),
                  //   Row(

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


}

class SellerSelectOption extends StatefulWidget {
  final String? txt;
  final bool select;
  final Function()? onTap;

  const SellerSelectOption({super.key, this.txt, this.onTap, required this.select});

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
