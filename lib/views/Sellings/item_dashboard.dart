import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import 'package:tt_offer/views/ChatScreens/chat_screen.dart';
import 'package:tt_offer/views/Post%20screens/post_screen.dart';
import 'package:tt_offer/views/Sell%20Faster/sell_faster.dart';
import 'package:tt_offer/views/Sellings/item_performance.dart';
import 'package:tt_offer/views/Sellings/new_sold_screen.dart';
import '../../models/product_model.dart';
import '../Products/Auction Product/widgets/reschdule_acution_time.dart';

class ItemDashBoard extends StatefulWidget {
  const ItemDashBoard({super.key, required this.product});

  final Product? product;

  @override
  State<ItemDashBoard> createState() => _ItemDashBoardState();
}

class _ItemDashBoardState extends State<ItemDashBoard> {
  bool loading = false;
  bool restrictEdit = false;
  bool restrictMarkSold = false;

  Product? product;

  @override
  void initState() {
    product = widget.product;

    if(product?.auctionInitialPrice!=null && endTimeReached(product?.auctionEndingDate ?? '', product?.auctionEndingTime ?? '')==false){
      restrictEdit = true;
      restrictMarkSold = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        bottomNavigationBar: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 5.h),
                child: Column(
                  children: [
                    const CustomDivider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/cross.png",
                          height: 14,
                        )),
                    InkWell(
                      onTap: () {
                        push(context, SellFaster(product: product));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.appText("Sell faster with promotions",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      textColor: const Color(0xff1E293B)),
                                  SizedBox(height: 6.h,),
                                  AppText.appText(
                                      "Get an average of 20x more\n views each day",
                                      fontSize: 11.sp,
                                      textAlign: TextAlign.justify,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppTheme.txt1B20),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 107.w,
                            child: SizedBox(
                              child: AppButton.appButtonWithLeadingImage(
                                "Sell Faster",
                                imagePath: "assets/images/sellFaster.png",
                                imgHeight: 14,
                                fontSize: 10,
                                height: 30.h,
                                width: 30.h,
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                fontWeight: FontWeight.w400,
                                backgroundColor: AppTheme.appColor,
                                textColor: AppTheme.whiteColor,
                                containerWidth: 4
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w,)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: CustomAppBar1(
          title: "Item DashBoard",
          action: true,
          img: "assets/images/more.png",
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setStatess) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: SizedBox(
                                height: 200,
                                width: getWidth(context) * .8,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {},
                                        child: AppText.appText("Share",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();

                                          push(
                                              context,
                                              PostScreen(
                                                  product: widget.product,
                                                  ));
                                        },
                                        child: AppText.appText("Sell Another",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {

                                        },
                                        child: AppText.appText("Archive",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: AppText.appText("Cancel",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.appColor),
                                      ),
                                    ),
                                    if (loading)
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: AppTheme.appColor,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: customListview(
                      img: (product?.photo?.isNotEmpty ?? false) ? product!.photo![0].url! : '',
                      title: product?.title ?? '',
                      subtitle: product?.productType == 'featured' ? product?.fixPrice :  product?.auctionInitialPrice),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        push(
                            context,
                            FeatureInfoScreen(
                              product: product,
                            ));
                      },
                      child: customContainer(
                          img: "assets/images/eye.png", txt: "View Post"),
                    ),
                    InkWell(
                      onTap: () {
                        if(restrictEdit == false) {
                          if(product?.auctionInitialPrice!=null){
                            push(context, RescheduleTimeProduct(
                              productId: product?.id.toString(),

                            ));
                          }
                          else{
                            push(context, PostScreen(product: product,));}
                        }
                        else{
                          showSnackBar(context, 'You cannot edit this product until the auction has ended.');
                        }
                      },
                      child: customContainer(
                          img: "assets/images/edit.png", txt: "Edit Post"),
                    ),
                    InkWell(
                      onTap: () {
                        if(restrictMarkSold == false) {
                          push(
                            context,
                            NewSoldScreen(
                              title: product?.title,
                              productId: product?.id.toString(),
                              fixPrice: product?.fixPrice.toString(),
                              auctionPrice: product?.auctionInitialPrice.toString(),
                              image: product?.photo?.isNotEmpty ?? false ? product!.photo![0].url! : null,
                              auction: product?.productType == 'auction' ? true : false,
                            ));
                        }
                        else{
                          showSnackBar(context, 'You cannot mark this as sold until the auction has ended.');
                        }

                      },
                      child: customContainer(
                          img: "assets/images/markSold.png",
                          txt: "Mark Sold"),
                    ),
                    InkWell(
                      onTap: () {
                        push(
                            context,
                            SellFaster(
                              product: product,
                            ));
                      },
                      child: customContainer(
                          img: "assets/images/sellFaster.png",
                          txt: "Sell Faster"),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: CustomDivider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: customRow(
                    onTap: () {
                      push(
                          context,
                          ItemPerformanceScreen(
                            product: product,
                          ));
                    },
                    txt: "Item Performance",
                    img: "assets/images/performance.png"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: CustomDivider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 18.w),
                child: AppText.appText('Messages', fontWeight: FontWeight.w600, fontSize: 16.sp),
              ),

              SizedBox(
                  // width: getWidth(context),
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: ChatScreen(isProductChat: true, productId: product?.id.toString(),),
                  )),

              // ListView.builder(
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: 3,
              //   itemBuilder: (context, index) {
              //     return customListview(
              //         img: "assets/images/sp2.png",
              //         title: "Anthony (Web3.io)",
              //         subtitle: "How are you today?",
              //         trailing: "9:54 AM",
              //         subTitleColor: const Color(0xff626C7B));
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }


  bool endTimeReached(String endDate, String endTimeString) {
    DateTime? endTime = convertEndTimeToUserTimeZone(_parseEndingDateTime(endDate, endTimeString));

    if (kDebugMode) {
      print('endTime $endTime');
    }

    // If the current time is after or at the endTime, return true (end time reached)
    return !endTime.isAfter(DateTime.now());
  }

  DateTime _parseEndingDateTime(String endDate, String endTime) {
    String? endingTimeString = endTime;
    String? endingDateString = endDate;
    DateTime endingDate =
    DateFormat("yyyy-MM-dd").parse(endDate);
    DateTime endingTime;

    if (endingTimeString.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse(endTime);
      if (kDebugMode) {
        print(" vkrvlrvm$endingTime");
      }
    } else {
      endingTime = DateFormat("HH:mm").parse(endTime);
      if (kDebugMode) {
        print(" jf3o3jfpfp3fpk$endingTime");
      }
    }
    return DateTime(
      endingDate.year,
      endingDate.month,
      endingDate.day,
      endingTime.hour,
      endingTime.minute,
    );
  }


  DateTime convertEndTimeToUserTimeZone(DateTime endTime) {
    // Get the user's local time zone offset (e.g., UTC+5)
    Duration userTimeZoneOffset = DateTime.now().timeZoneOffset;

    // Define the time zone offset for UTC+4 (Dubai time)
    const dubaiTimeZoneOffset = Duration();

    // Calculate the difference between user time zone and Dubai time zone
    Duration timeDifference = userTimeZoneOffset - dubaiTimeZoneOffset;

    // Add or subtract the time difference to the endTime
    return endTime.add(timeDifference);
  }


  Widget customRow({img, txt, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "$img",
                  height: 20,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.appText("$txt",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.txt1B20),
              ],
            ),
            Image.asset(
              "assets/images/arrowFor.png",
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget customContainer({img, txt}) {
    return Container(
      height: 75,
      width: 71,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19), color: AppTheme.appColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "$img",
              height: 18,
            ),
            AppText.appText(
              "$txt",
              textAlign: TextAlign.center,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.whiteColor,
            )
          ],
        ),
      ),
    );
  }

  Widget customListview({img, title, subtitle, trailing, subTitleColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: img.isEmpty
                        ? Image.asset('assets/images/gallery.png')
                        : Image.network(
                            img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.appText("$title",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: AppTheme.txt1B20),
                    const SizedBox(
                      height: 5,
                    ),
                    AppText.appText("AED ${formatNumber((removeLastTwoZeros(subtitle.toString())))}",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: subTitleColor ?? AppTheme.txt1B20),
                  ],
                ),
              ],
            ),
            trailing == null
                ? const SizedBox.shrink()
                : AppText.appText("$trailing",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.lighttextColor),
          ],
        ),
      ),
    );
  }

}
