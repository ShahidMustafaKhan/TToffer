import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/search_service.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/auction_products_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/banner_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/category_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/custom_row.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/feature_products_section.dart';
import 'package:tt_offer/views/All%20Categories/all_caetgories.dart';
import 'package:tt_offer/views/All%20Categories/catagory_container.dart';
import 'package:tt_offer/views/All%20Categories/sub_categories_screen.dart';
import 'package:tt_offer/views/Homepage/home_app_bar.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/Homepage/search_screen.dart';
import 'package:tt_offer/views/SearchPage/search_page.dart';
import '../../../Controller/APIs Manager/cart_api.dart';
import '../../../Controller/APIs Manager/notification_api.dart';
import '../../../view_model/product/product/product_viewmodel.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  final TextEditingController _searchController = TextEditingController();
  late ProductViewModel productViewModel;
  String? authenticationToken;
  late CartApiProvider cartProvider;

  @override
  void initState() {

    handler();
    final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);
    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    profileApi.getProfile(
      dio: dio,
      context: context,
    );


    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();

    getNotificationHandler();

    cartProvider = Provider.of<CartApiProvider>(context, listen: false);
    authenticationToken = pref.getString(PrefKey.authorization);

    if(authenticationToken!=null) {
      cartProvider.getCartItems(dio: dio, context: context);
    }


    super.initState();
  }

  Future<void> getData() async {

    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
  }

  List<SearchData> provider = [];

  handler() async {
    await BlockedUserServices().getBlockedUser(context: context);
  }

  void searchHandler(BuildContext context) async {
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.appColor,
                  ),
                ],
              ),
            ));

    bool res = await SearchService().searchService(
      context: context,
      query: _searchController.text.trim(),
    );
    Navigator.pop(context);

    if (res) {
      push(context, const SearchPage(), then: (){
        getData();
      });
    }

    provider = Provider.of<SearchProvider>(context, listen: false).selling;
    print('provider---->${provider}');
    setState(() {});
  }

  getNotificationHandler() async {
    await NotificationService().notificationService(context: context);
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar(context: context, authenticationCode: authenticationToken, searchHandler: (){ searchHandler(context);}, searchController: _searchController, setState: setState,),
      body: _searchController.text.isNotEmpty ?
              const ViewSearchedProducts() :
              Padding(
                padding: EdgeInsets.only(
                  top: 20.h,
                ),
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
              )


    );
  }




}
