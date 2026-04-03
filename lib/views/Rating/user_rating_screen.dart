import 'package:flutter/material.dart';
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

class UserRatingScreen extends StatefulWidget {
 final String? id;
 final UserModel? userModel;
 final String? productId;
 final bool reviewBuyer;

  const UserRatingScreen({super.key, this.id, this.userModel, this.productId, this.reviewBuyer = false});

  @override
  State<UserRatingScreen> createState() => _UserRatingScreenState();
}

class _UserRatingScreenState extends State<UserRatingScreen> {
  double? starValue;
  TextEditingController textEditingController = TextEditingController();
  UserModel? userModel;
  late UserViewModel userViewModel;
  int? userId;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userModel = widget.userModel;
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
      userModel = await userViewModel.getSellerProfile(int.tryParse(widget.id ?? ''));
      if(mounted) {
        setState(() {});
      }}

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
                Text(
                  'Rate ${widget.reviewBuyer ? 'Buyer' : 'Seller'}',
                  style: const TextStyle(
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
                          image: userModel?.img == null
                              ? const AssetImage('assets/images/profile.png')
                              : NetworkImage(
                              userModel!.img!)
                                  as ImageProvider)),
                ),
                const SizedBox(height: 15),
                Text(
                  capitalizeWords(userModel?.name ?? ''),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                AppText.appText("Joined ${formatMonthYear(userModel?.createdAt)}",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),

                if(userModel?.location!=null)...[
                  const SizedBox(height: 3,),
                  AppText.appText(userModel?.location ?? '',
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
                        decoration: InputDecoration(
                            hintText:
                                'How was your experience with the ${widget.reviewBuyer ? 'buyer' : 'seller'}?',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20)),
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
                              if(widget.reviewBuyer == true){
                                buyerRatingApi(context);
                              }
                              else{
                                sellerRatingApi(context);
                              }
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
                                    'Post Review',
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

  Future sellerRatingApi(BuildContext context) async {

      Map<String, dynamic> data = {
        "seller_id": int.tryParse(widget.id ?? ''),
        "reviewer_id": int.tryParse(pref.getString(PrefKey.userId) ?? ''),
        "rating": starValue?.ceil(),
        "comment" : textEditingController.text,
        "product_id" : int.tryParse(widget.productId ?? '')
      };

      userViewModel.addSellerReview(data, int.tryParse(widget.id ?? '')).then((value){
        showSnackBar(context, 'Review Added Successfully', title: 'Congratulations!');
        Navigator.of(context).pop();
        SendNotification.sendNotification(
            context: context,
            userId: int.parse(widget.id!),
            sellerId: int.tryParse(widget.id ?? ''),
            text: reviewText(starValue ?? 0.0),
            type: "Buyer Review",
            productId: int.tryParse(widget.productId ?? ''),
            typeId: starValue.toString(),
            buyerId: int.tryParse(pref.getString(PrefKey.userId)!));
      }).onError((error, stackTrace){
        showSnackBar(context, error.toString());
      });
  }

  String reviewText(double rating){
    if(rating <= 2.0){
      return "Buyer has left a negative review for you.";
    }
    else if(rating >2.0 && rating <=3.0 ){
      return "Buyer has left a neutral review for you.";
    }
    else{
      return "Congratulations! Buyer has left a positive review for you.";
    }
  }


  Future buyerRatingApi(BuildContext context) async {

    Map<String, dynamic> data = {
      "seller_id": int.tryParse(widget.id ?? ''),
      "reviewer_id": int.tryParse(pref.getString(PrefKey.userId) ?? ''),
      "rating": starValue?.ceil(),
      "comment" : textEditingController.text,
      "product_id" : int.tryParse(widget.productId ?? '')
    };

    userViewModel.addBuyerReview(data, int.tryParse(widget.id ?? '')).then((value){
      showSnackBar(context, 'Review Added Successfully', title: 'Congratulations!');
      Navigator.of(context).pop();
      SendNotification.sendNotification(
        context: context,
        userId: int.tryParse(widget.id ?? ''),
        buyerId: int.tryParse(widget.id ?? ''),
        sellerId: userId,
        text: "You got the review form the seller! Do you want to proceed with your feedback?",
        type: "Seller Review",
        typeId: "${widget.id}0000${widget.productId}",
        productId: int.tryParse( widget.productId ?? ''));
    }).onError((error, stackTrace){
      showSnackBar(context, error.toString());});
  }







  // SendNotification.sendNotification(
  //   context: context,
  //   userId: product?.productType != 'auction' ? int.parse(getUserId(chatList[selectedIndex!])) : bids[selectedIndex!].userId!,
  //   buyerId: product?.productType != 'auction' ? int.parse(getUserId(chatList[selectedIndex!])) : bids[selectedIndex!].userId!,
  //   sellerId: sellerId,
  //   text: "Rate Your Recent Purchase: ${(capitalizeWords(product?.title))} ",
  //   type: "Product Review",
  //   typeId: "${sellerId}0000${product?.id}",
  //   productId:product?.id,);




}
