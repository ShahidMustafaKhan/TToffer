import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/views/Profile%20Screen/profile_screen.dart';

import '../../Controller/APIs Manager/send_notification_service.dart';
import '../../Utils/widgets/others/app_text.dart';
import '../../config/app_urls.dart';
import '../../config/keys/pref_keys.dart';
import '../../custom_requests/user_info_service.dart';
import '../../models/user_info_model.dart';
import '../../providers/profile_info_provider.dart';
import '../BottomNavigation/navigation_bar.dart';

class RatingScreen extends StatefulWidget {
  final String? sellerId;
  String? img;
  String? name;
  String? location;
  String? joinDate;
  String? productId;


  RatingScreen({super.key, this.sellerId, this.img, this.name, this.location, this.joinDate, this.productId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double? starValue;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    if(widget.name == null){
      UserInfoModel? data;

      await UserInfoService().userInfoService(
          context: context, id: int.parse(widget.sellerId!));

      data = Provider.of<ProfileInfoProvider>(context, listen: false).userInfoModel;

      widget.name = data!.data!.name;
      widget.img = data.data!.img;
      widget.location =data.data!.location;
      widget.joinDate =data.data!.createdAt;
      setState(() {

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Rate Seller',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 25),
                ),
                const SizedBox(height: 50),
                Container(
                  height: 98.w,
                  width: 98.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19.71.r),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                          image: widget.img == null
                              ? const AssetImage('assets/images/profile.png')
                              : NetworkImage(
                                      widget.img!)
                                  as ImageProvider)),
                ),
                const SizedBox(height: 15),
                Text(
                  capitalizeWords(widget.name ?? ''),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                AppText.appText("Joined ${formatMonthYear(widget.joinDate)}",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),

                if(widget.location!=null)...[
                  const SizedBox(height: 3,),
                  AppText.appText(widget.location ?? '',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.txt1B20)],
                SizedBox(height: 35.h),
                RatingBar(
                  glow: true,
                  itemSize: 50,
                  unratedColor: Colors.black45,
                  updateOnDrag: true,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 8),
                  glowColor: Colors.blue,
                  ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star,
                        color: Color(0xff006DEF),
                      ),
                      half: const Icon(
                        Icons.star_half,
                        color: Color(0xff006DEF),
                      ),
                      empty: const Icon(
                        Icons.star,
                        color: Color(0xffD9D9D9),
                      )),
                  onRatingUpdate: (double value) {
                    starValue = value;
                    print('starValuew--->$starValue');

                    setState(() {});
                  },
                ),
                SizedBox(height: 47.h),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20)),
                      height: 170,
                      width: double.infinity,
                      child: TextField(
                        maxLines: 10,
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            hintText:
                                'How was your experience about this seller?',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20)),
                      )),
                ),
                SizedBox(height: 63.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppTheme.appColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 9.h),
                                child: Text(
                                  'Skip',
                                  style: TextStyle(color: AppTheme.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 37.w,),
                      Expanded(child: InkWell(
                        onTap: () async {
                          ratingService(context);
                        },
                        child: loading
                            ? SizedBox(
                             width: 32.w,
                              child: Center(
                                child: CircularProgressIndicator(
                                color: AppTheme.appColor),
                              ),
                            )
                            : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppTheme.appColor),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 9.h),
                              child: Text(
                                'Post Seller',
                                style: TextStyle(color: AppTheme.white),
                              ),
                            ),
                          ),
                        ),
                      ))

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;

  Future ratingService(BuildContext context) async {
    try {
      Map<String, dynamic> body = {
        "to_user": widget.sellerId.toString(),
        "from_user": widget.sellerId.toString(),
        "rating": starValue.toString(),
        "comments" : textEditingController.text.toString(),
        "product_id" : widget.productId
      };

      setState(() {
        loading = true;
      });

      var res = await customPostRequest.httpPostRequest(
          url: AppUrls.review, body: body);

      if (res != null) {
        Navigator.of(context).pop();
        showSnackBar(context, 'Review Added Successfully', title: 'Congratulations!');
          SendNotification.sendNotification(
              context: context,
              userId: int.parse(widget.sellerId!),
              sellerId: widget.sellerId.toString(),
              text: reviewText(starValue ?? 0.0),
              type: "Customer Review",
              productId: widget.productId.toString(),
              typeId: starValue.toString().replaceAll(".0", ""),
              status: "unread", buyerId: pref.getString(PrefKey.userId)!);
      } else {
        return false;
      }

      setState(() {
        loading = false;
      });
    } catch (err) {
      print(err);
      return false;
    }
  }

  String reviewText(double rating){
    if(rating <= 2.0){
      return "Buyer has given a negative review on an order.";
    }
    else if(rating >2.0 && rating <=3.0 ){
      return "Buyer has given a neutral review on an order.";
    }
    else{
      return "Congratulations! Buyer has given a positive review on an order.";
    }
  }


}
