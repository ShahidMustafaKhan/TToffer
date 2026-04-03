
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/models/wishlist_model.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../Utils/utils.dart';
import '../../data/response/status.dart';
import '../../main.dart';
import '../../view_model/cart/cart_viewmodel.dart';


class WishListItemsScreen extends StatefulWidget {
  const WishListItemsScreen({Key? key}) : super(key: key);

  @override
  State<WishListItemsScreen> createState() => _WishListItemsScreenState();
}

class _WishListItemsScreenState extends State<WishListItemsScreen> {
  bool isLoading = false;
  int? userId;

  @override
  void initState() {
    getUserId();

    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getWishList();
    super.initState();
  }

  getUserId() {
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Wishlist items",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: WishListView(
          userId: userId,
        ),
      ),
    );
  }

}

class WishListView extends StatefulWidget {
  final int? userId;

  const WishListView({
    super.key,
    required this.userId,
  });

  @override
  State<WishListView> createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView> {




  @override
  Widget build(BuildContext context) {

    return Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          List<WishList> wishList = userViewModel.wishList.data ?? [];

          if (userViewModel.wishList.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.appColor,
              ),
            );
          }
          if (wishList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset("assets/images/no_data_folder.png", height: 150.h,)),
                SizedBox(height: 16.h,),
                Center(
                    child: AppText.appText(
                        "No Saved Item found",
                        textColor: AppTheme.appColor, fontSize: 14.sp
                    )),
                SizedBox(height: 25.h,)
              ],
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: wishList.length,
              reverse: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<ProductViewModel>(context, listen: false)
                              .navigateToProductPage(wishList[index].product?.id, context);
                        },
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (wishList[index].product?.photo?.isNotEmpty ?? false)
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          wishList[index].product!.photo![0].url!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 200.w, // Adjusted width to fit the delete button
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText.appText(
                                          wishList[index].product?.title ?? '',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          textColor: AppTheme.txt1B20,
                                        ),
                                        AppText.appText(
                                          "AED ${wishList[index].product?.productType == 'auction' ? wishList[index].product?.auctionInitialPrice?.toString() ?? '' : wishList[index].product?.fixPrice?.toString()}",
                                          fontSize: 12.5,
                                          maxlines: 1,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                          textColor: AppTheme.appColor,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.appText(
                                              formatTimestamp(
                                                  "${wishList[index].product?.createdAt}"),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppTheme.appColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Delete Button
                              Consumer<CartViewModel>(
                                  builder: (context, cartViewModel, child) {
                                    return userViewModel.wishlistLoadingList.isNotEmpty && userViewModel.wishlistLoadingList[index] == true ? loadingIndicator(rightPadding: 10) : IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        userViewModel.toggleWishList(widget.userId, wishList[index].product?.id, context, itemIndex: index);
                                      },
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const CustomDivider(),
                  ],
                );

              },
            );
          }
        });




  }

  String formatTimestamp(String timestamp) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(timestamp);

    Duration difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour ago";
    } else if (difference.inDays == 1) {
      return "yesterday";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }


}
