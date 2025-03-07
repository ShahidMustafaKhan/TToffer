
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/no_data_found.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';
import '../../Utils/widgets/grid_delegate.dart';
import '../../models/product_model.dart';

class ViewSearchedProducts extends StatelessWidget {
  const ViewSearchedProducts({super.key});

  @override
  Widget build(BuildContext context) {


    return  Consumer<ProductViewModel>(
          builder: (context, productViewModel, child) {
            List<Product>? searchProduct = productViewModel.searchProductList.data?.data?.productList;
            if(productViewModel.searchProductList.status == Status.loading) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator())
                ],
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                          mainAxisSpacing: 15.h,
                          crossAxisSpacing: 12,
                          crossAxisCount: 2,
                          height: MediaQuery.of(context).size.height * 0.28),
                      shrinkWrap: true,
                      itemCount: searchProduct?.length ?? 0,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                            onTap: () {

                              if(searchProduct?[index].productType == 'auction') {
                                push(
                                    context,
                                    AuctionInfoScreen(
                                      product: searchProduct?[index],
                                    ));
                              }
                              else {
                                push(
                                    context,
                                    FeatureInfoScreen(
                                      product: searchProduct?[index],
                                    ));
                              }

                            },
                            child: FeatureProductContainer(
                              product: searchProduct?[index],
                            ));
                      },
                    ),
                  ),
                  if(productViewModel.searchProductList.status == Status.error || searchProduct != null && searchProduct.isEmpty)
                    NoDataFound.noDataFound()

                ],
              ),
            );
          }
      );
  }
}


