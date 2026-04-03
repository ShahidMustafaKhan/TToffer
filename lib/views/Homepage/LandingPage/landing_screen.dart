import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/view_model/category/category_view_model.dart';
import 'package:tt_offer/views/Homepage/LandingPage/search_bar_with_suggestion/search_bar_with_suggestion.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/auction_products_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/banner_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/category_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/feature_products_section.dart';
import 'package:tt_offer/views/Homepage/LandingPage/widgets/home_app_bar.dart';
import 'package:tt_offer/views/SearchPage/search_screen.dart';
import '../../../view_model/product/product/product_viewmodel.dart';
import '../../../view_model/profile/user_profile/user_view_model.dart';
import '../../../view_model/suggestion/suggestion_view_model.dart';

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

  @override
  void initState() {

    handler();
    authenticationToken = pref.getString(PrefKey.authorization);
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);

    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
    userViewModel.getWishList();


    if(authenticationToken!=null && userId!=null) {
      userViewModel.overViewApi(userId, context);
    }

    super.initState();
  }

  List<SearchData> provider = [];

  handler() async {
    Provider.of<CategoryViewModel>(context, listen: false).getCategoryData();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.whiteColor,
        appBar: HomeAppBar(context: context, authenticationCode: authenticationToken, setState: setState,),
        body:
        RefreshIndicator(
          onRefresh: _refresh,
          child:Consumer<ProductViewModel>(
              builder: (context, productViewModel, child) {
                return Consumer<SuggestionViewModel>(
                    builder: (context, suggestionViewModel, child) {
                      return Stack(
                    children: [
                      if((suggestionViewModel.searchText.isNotEmpty && productViewModel.searchProductList.status != Status.notStarted))
                        Padding(
                          padding: EdgeInsets.only(top: 48.h + 15.h),
                          child: const ViewSearchedProducts(),
                        )
                      else
                      Padding(
                        padding: EdgeInsets.only(top: 48.h + 15.h),
                        child: const SingleChildScrollView(
                          child: Column(
                            children: [
                              BannerSection(),

                              CategorySection(),

                              AuctionProductSection(),

                              SizedBox(height: 20,),

                              FeatureProductSection(),

                              SizedBox(
                                height: 40,
                              ),


                            ],
                          ),
                        ),
                      ),

                      const SearchBarWithSuggestions()
                    ],
                                );
                  }
                );
            }
          ),
        )
      
      ),
    );
  }




}
