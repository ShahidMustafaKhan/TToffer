import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';
import '../../Controller/APIs Manager/send_notification_service.dart';
import '../../Utils/widgets/others/app_text.dart';
import '../../config/keys/pref_keys.dart';

import '../../custom_requests/notification_delete_request.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';

class ProductRatingScreen extends StatefulWidget {
 final String? sellerId;
 final Product? product;
 final String? productId;
 final int? notificationId;

  const ProductRatingScreen({super.key, this.sellerId, this.product, this.productId, this.notificationId});

  @override
  State<ProductRatingScreen> createState() => _ProductRatingScreenState();
}

class _ProductRatingScreenState extends State<ProductRatingScreen> {
  double? starValue;
  TextEditingController textEditingController = TextEditingController();
  Product? product;
  late ProductViewModel productViewModel;
  late UserViewModel userViewModel;
  int? userId;

  @override
  void initState() {
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    product = widget.product;
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
      product = await productViewModel.getProductDetails(int.tryParse(widget.productId ?? ""));
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
                const Text(
                  'Rate Product',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 25),
                ),
                const SizedBox(height: 50),
                Container(
                  height: 98.w,
                  width: 98.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19.71.r),
                    color: product?.photo?.isNotEmpty ?? false ? Colors.transparent : Colors.amber,
                    image:  product?.photo?.isNotEmpty ?? false ? DecorationImage(
                      image: NetworkImage(product!.photo![0].url!),
                      fit: BoxFit.fill,
                    ) : const DecorationImage(
                      image: AssetImage('assets/images/gallery.png',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Consumer<ProductViewModel>(
                    builder: (context, productViewModel, child) {
                      return productViewModel.productDetailLoading ? Center(child: CircularProgressIndicator(color: AppTheme.yellowColor,)) : Column(
                      children: [
                        Text(
                          capitalizeWords(product?.title ?? ''),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        if(product?.createdAt != null)...[
                          const SizedBox(height: 5),
                          AppText.appText("Created at ${formatMonthYear(product?.createdAt)}",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.txt1B20)],
                        if(product?.location!=null)...[
                          const SizedBox(height: 5,),
                          AppText.appText(product?.location ?? '',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.txt1B20)],
                      ],
                    );
                  }
                ),

                SizedBox(height: 20.h),
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
                SizedBox(height: 25.h),
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
                                'How was your experience with this product?',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20)),
                      )),
                ),
                SizedBox(height: 30.h),
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

  Future ratingService(BuildContext context) async {

      Map<String, dynamic> data = {
        "seller_id": int.tryParse(widget.sellerId ?? ''),
        "reviewer_id": int.tryParse(pref.getString(PrefKey.userId) ?? ''),
        "rating": starValue?.ceil(),
        "comment" : textEditingController.text,
        "product_id" : int.tryParse(widget.productId ?? '')
      };

      userViewModel.addProductReview(data, int.tryParse(widget.productId ?? '')).then((value){
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
      return "Buyer has left a negative review for your product: ${product?.title}.";
    }
    else if(rating >2.0 && rating <=3.0 ){
      return "Buyer has left a neutral review for your product: ${product?.title}.";
    }
    else{
      return "Congratulations! Buyer has left a positive review for your product: ${product?.title}.";
    }
  }


}
