
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/search_service.dart';
import 'package:tt_offer/data/response/api_response.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/suggestion/suggestion_view_model.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/auction_products_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/banner_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/category_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/feature_products_section.dart';
import 'package:tt_offer/views/Homepage/home_app_bar.dart';
import 'package:tt_offer/views/Homepage/search_screen.dart';
import 'package:tt_offer/views/SearchPage/search_page.dart';
import '../../../Utils/widgets/others/app_field.dart';
import '../../../providers/notification_provider.dart';
import '../../../view_model/notification/notification_api.dart';
import '../../../view_model/product/product/product_viewmodel.dart';
import '../../../view_model/profile/user_profile/user_view_model.dart';
import '../../Notification/notification_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  late ProductViewModel productViewModel;
  late UserViewModel userViewModel;
  String? authenticationToken;
  int? userId;

  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {

    handler();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);

    userViewModel.getUserProfile();
    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
    userViewModel.getWishList();


    getNotificationHandler();

    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    authenticationToken = pref.getString(PrefKey.authorization);
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    if(authenticationToken!=null && userId!=null) {
      cartViewModel.getCartList(userId);
    }


    super.initState();
  }

  Future<void> getData() async {

    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
    userViewModel.getWishList();
  }

  List<SearchData> provider = [];

  handler() async {
    await BlockedUserServices().getBlockedUser(context: context);
  }

  getNotificationHandler() async {
    await NotificationService().notificationService(context: context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar(context: context, authenticationCode: authenticationToken, setState: setState,),
      body:
      Consumer<ProductViewModel>(
          builder: (context, productViewModel, child) {
            return Stack(
            children: [
              if(( _searchController.text.isNotEmpty && productViewModel.searchProductList.status != Status.notStarted))
                const ViewSearchedProducts()
              else
              Padding(
                padding: EdgeInsets.only(top: 55.h),
                child: const SingleChildScrollView(
                  child: Column(
                    children: [
                      BannerSection(),

                      CategorySection(),

                      AuctionProductSection(),

                      SizedBox(
                        height: 20,
                      ),

                      FeatureProductSection(),

                      SizedBox(
                        height: 40,
                      ),


                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Stack(
                  children: [
                    if(_searchController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40, right: 46, left: 4),
                        child: Column(
                          children: [
                            Consumer<SuggestionViewModel>(
                                builder: (context, suggestionViewModel, child) {
                                  if(suggestionViewModel.suggestionList.isNotEmpty) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0, 2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(top: 5.h),
                                        shrinkWrap: true,
                                        itemCount: suggestionViewModel.suggestionList.length > 7  ? 7 : suggestionViewModel.suggestionList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: const Icon(Icons.history),
                                            title: Text(
                                              suggestionViewModel.suggestionList[index]['title'] ?? '',
                                              style: const TextStyle(color: Colors.black, fontSize: 14.0),
                                            ),
                                            onTap: () {
                                              setState((){});
                                              _searchController.text = suggestionViewModel.suggestionList[index]['title'] ?? '';
                                              productViewModel.searchAllProducts(search: suggestionViewModel.suggestionList[index]['title']);
                                              suggestionViewModel.emptySuggestionList(notify: true);

                                            },
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomAppFormField(
                            onChanged: (value){
                              if(value.isNotEmpty && value.length >= 3){
                                Provider.of<SuggestionViewModel>(context, listen: false).searchSuggestion(value,context);
                              }
                              if(value.isEmpty || value.length < 3){
                                Provider.of<SuggestionViewModel>(context, listen: false).emptySuggestionList(notify: true);
                              }
                              if(value.isEmpty){
                                Provider.of<ProductViewModel>(context, listen: false).setSearchProduct(ApiResponse.notStarted());
                              }

                              setState((){});
                            },
                            onFieldSubmitted: (value){
                              if(value.isNotEmpty){
                                productViewModel.searchAllProducts(search: value);
                                Provider.of<SuggestionViewModel>(context, listen: false).emptySuggestionList(notify: true);
                              }
                            },
                            radius: 15.0,
                            hintStyle: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400),
                            prefixIcon: Image.asset(
                              "assets/images/search.png",
                              height: 22.h,
                              color: AppTheme.textColor,
                            ),
                            texthint: "What are you looking for?",
                            // controller: searchController,
                            cPadding: 9.h, controller: _searchController,
                            // contentPadding : EdgeInsets.only(left: 10, right : 10 , top: 6.h , bottom: 0.h)
                          ),
                        ),
                        SizedBox(width: 20.w,),
                        Consumer<NotificationProvider>(
                            builder: (context, apiProvider, child) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        push(context, const NotificationScreen());
                                      },
                                      child: Image.asset(
                                        "assets/images/notification.png",
                                        height: 26,
                                      )),
                                  if(apiProvider.unreadNotificationIndicator==true)
                                    Positioned(
                                      top: -3,
                                      right: -3,
                                      child: Container(
                                        height: 19, // Adjust the size as needed
                                        width: 19,  // Adjust the size as needed
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(child: AppText.appText('${apiProvider.unreadNotificationCount}', textColor: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                ],
                              );
                            }
                        )

                      ],
                    ),



                  ],
                ),
              ),
            ],
          );
        }
      )

    );
  }




}
