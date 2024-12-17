
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/no_data_found.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';
import '../../models/product_model.dart';

class ViewSearchedProducts extends StatefulWidget {
  const ViewSearchedProducts({super.key});

  @override
  State<ViewSearchedProducts> createState() => _ViewSearchedProductsState();
}

class _ViewSearchedProductsState extends State<ViewSearchedProducts> {


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;


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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: screenWidth / (3.8 * 150),
                      ),
                      shrinkWrap: true,
                      itemCount: searchProduct?.length ?? 0,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                            onTap: () {
                              if(searchProduct?[index].productType == 'featured') {
                                push(
                                  context,
                                  FeatureInfoScreen(
                                    product: searchProduct?[index],
                                  ));
                              }
                              else if(searchProduct?[index].productType == 'auction') {
                                push(
                                    context,
                                    AuctionInfoScreen(
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


