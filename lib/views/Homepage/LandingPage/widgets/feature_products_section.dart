
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import '../../../../Utils/resources/res/app_theme.dart';
import '../../../../Utils/widgets/grid_delegate.dart';
import '../../../../data/response/status.dart';
import '../../../../view_model/product/product/product_viewmodel.dart';
import '../../../Products/Feature Product/all_feature_products.dart';
import 'custom_product_row.dart';


class FeatureProductSection extends StatelessWidget {
  const FeatureProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return Column(
            children: [
              const ProductTypeDetails(
                  txt1: "Feature Products",
                  txt3: "Act fast! These featured products won't last long."),

              if(productViewModel.featureProductList.status != Status.completed || (productViewModel.featureProductList.data?.data?.productList?.length ?? 0) == 0)
              const SizedBox(
                height: 20,
              ),

              productViewModel.featureProductList.status == Status.loading
                  ? Center(
                child: AppText.appText("Loading...."),
              ):
              productViewModel.featureProductList.status == Status.error
                  ? Center(
                child: AppText.appText("Error fetching products...."
                    "${productViewModel.featureProductList.message}"
                ),
              )

                  : (productViewModel.featureProductList.data?.data?.productList?.length ?? 0) == 0
                  ? Center(
                child:
                AppText.appText("No Feature Product Added Yet"),
              )
                  :
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20, bottom: 12),
                child: SizedBox(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      mainAxisSpacing: 15.h,
                      crossAxisSpacing: 12,
                      crossAxisCount: 2,
                        height: MediaQuery.of(context).size.height * 0.312),
                    shrinkWrap: true,
                    itemCount: (productViewModel.featureProductList.data?.data?.productList?.length ?? 0) >
                        4
                        ? 4
                        : (productViewModel.featureProductList.data?.data?.productList?.length ?? 0),
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                          onTap: () {
                            push(
                                context,
                                FeatureInfoScreen(
                                    product: productViewModel.featureProductList.data?.data?.productList?[index]
                                ), then: () {
                              // getData();
                            });
                            // getFeatureProductDetail(
                            //     productId: apiProvider
                            //         .allfeatureProductsData[index]["id"]);
                          },
                          child: FeatureProductContainer(
                              fromHomePage : true,
                              product:
                              productViewModel.featureProductList.data?.data?.productList?[index]));
                    },
                  ),
                ),
              ),
              if(productViewModel.featureProductList.data?.data?.productList?.isNotEmpty ?? false)
                Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        push(context, const ViewFeaturedProducts(),
                            then: () {
                              getData(productViewModel);
                            });
                      },
                      child: AppText.appText("View All",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          textColor: AppTheme.textColor),
                    )
                  ],
                ),
              )

            ],
          );
        }
    );
  }

  Future<void> getData(ProductViewModel productViewModel) async {

    productViewModel.getAuctionProducts();
    productViewModel.getFeatureProducts();
  }
}


