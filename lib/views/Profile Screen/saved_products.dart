
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/models/saved_model.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../data/response/status.dart';
import '../../main.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({Key? key}) : super(key: key);

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  bool isLoading = false;

  int? userId;

  @override
  void initState() {
    getUserId();

    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getSavedItemList();
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
        title: "Saved items",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SavedItemListView(
          userId: userId,
        ),
      ),
    );
  }

}

class SavedItemListView extends StatefulWidget {
  final int? userId;

  const SavedItemListView({
    super.key,
    required this.userId,
  });

  @override
  State<SavedItemListView> createState() => _SavedItemListViewState();
}

class _SavedItemListViewState extends State<SavedItemListView> {




  @override
  Widget build(BuildContext context) {

    return Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          List<SaveList> savedItemList = userViewModel.saveList.data ?? [];

          if (userViewModel.saveList.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.appColor,
              ),
            );
          }
          if (savedItemList.isEmpty) {
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
              itemCount: savedItemList.length,
              reverse: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<ProductViewModel>(context, listen: false).navigateToProductPage(
                              savedItemList[index].product?.id,
                              context
                          );
                        },
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (savedItemList[index].product?.photo?.isNotEmpty ?? false)
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
                                          savedItemList[index].product!.photo![0].url!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 200.w, // Adjust width to make space for the button
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText.appText(
                                          savedItemList[index].product?.title ?? '',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          textColor: AppTheme.txt1B20,
                                        ),
                                        AppText.appText(
                                          "AED ${savedItemList[index].product?.productType == 'auction' ? savedItemList[index].product?.auctionInitialPrice?.toString() ?? '' : savedItemList[index].product?.fixPrice?.toString()}",
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
                                              formatTimestamp("${savedItemList[index].product?.createdAt}"),
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
                              // Add the remove button here
                              Consumer<CartViewModel>(
                                  builder: (context, cartViewModel, child) {
                                    return userViewModel.toggleSaveLoadingList.isNotEmpty && userViewModel.toggleSaveLoadingList[index] == true ? loadingIndicator(rightPadding: 10) : IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      userViewModel.toggleSavedItem(widget.userId, savedItemList[index].product?.id, context, saveItemIndex: index);
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
