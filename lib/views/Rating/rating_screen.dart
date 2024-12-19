import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';
import '../../Controller/APIs Manager/send_notification_service.dart';
import '../../Utils/widgets/others/app_text.dart';
import '../../config/keys/pref_keys.dart';

import '../../models/user_model.dart';


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

  late UserViewModel userViewModel;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
      UserModel? sellerModel;

      sellerModel = await userViewModel.getSellerProfile(int.tryParse(widget.sellerId ?? ''));


      widget.name = sellerModel?.name;
      widget.img = sellerModel?.img;
      widget.location = sellerModel?.location;
      widget.joinDate = sellerModel?.createdAt;

      if(mounted) {
        setState(() {});
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
                        Icons.star,
                        color: Color(0xff006DEF),
                      ),
                      empty: const Icon(
                        Icons.star,
                        color: Color(0xffD9D9D9),
                      )),
                  onRatingUpdate: (double value) {
                    starValue = value;
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
                      Expanded(child: Consumer<UserViewModel>(
                          builder: (context, userViewModel, child) {
                            return InkWell(
                            onTap: () async {
                              ratingService(context);
                            },
                            child: userViewModel.reviewLoading
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
                          );
                        }
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

      Map<String, dynamic> data = {
        "seller_id": int.tryParse(widget.sellerId ?? ''),
        "reviewer_id": int.tryParse(pref.getString(PrefKey.userId) ?? ''),
        "rating": starValue?.ceil(),
        "comment" : textEditingController.text,
        "product_id" : int.tryParse(widget.productId ?? '')
      };

      userViewModel.addReview(data).then((value){
        showSnackBar(context, 'Review Added Successfully', title: 'Congratulations!');
        Navigator.of(context).pop();
        SendNotification.sendNotification(
            context: context,
            userId: int.parse(widget.sellerId!),
            sellerId: int.tryParse(widget.sellerId ?? ''),
            text: reviewText(starValue ?? 0.0),
            type: "Customer Review",
            productId: int.tryParse(widget.productId ?? ''),
            typeId: starValue.toString(),
            buyerId: int.tryParse(pref.getString(PrefKey.userId)!));
      }).onError((error, stackTrace){
        showSnackBar(context, error.toString());
      });


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
