
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/no_data_found.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/sub_categories_model.dart';
import 'package:tt_offer/views/Products/Auction%20Product/all_auction_procucts.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';

import '../../Utils/widgets/custom_radio_button.dart';

class ViewSearchedProducts extends StatefulWidget {
  const ViewSearchedProducts({super.key});

  @override
  State<ViewSearchedProducts> createState() => _ViewSearchedProductsState();
}

class _ViewSearchedProductsState extends State<ViewSearchedProducts> {

  late AppDio dio;
  AppLogger logger = AppLogger();



  @override
  void initState() {
    dio = AppDio(context);
    logger.init();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;


    return  Consumer<ProductsApiProvider>(
          builder: (context, apiProvider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if(apiProvider.allProductsData != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: screenWidth / (3.8 * 150),
                      ),
                      shrinkWrap: true,
                      itemCount: apiProvider.allProductsData.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                            onTap: () {
                              if(apiProvider.allProductsData[index]['fix_price'] != null) {
                                push(
                                  context,
                                  FeatureInfoScreen(
                                    detailResponse: apiProvider.allProductsData[index],
                                  ));
                              }
                              else if(apiProvider.allProductsData[index]["auction_price"] != null) {
                                push(
                                    context,
                                    AuctionInfoScreen(
                                      detailResponse: apiProvider.allProductsData[index],
                                    ));
                              }

                            },
                            child: FeatureProductContainer(
                              data: apiProvider.allProductsData[index],
                            ));
                      },
                    ),
                  ),
                  if(apiProvider.allProductsData!=null && apiProvider.allProductsData.isEmpty && apiProvider.allProductsData.isLoading==false)
                    NoDataFound.noDataFound()

                ],
              ),
            );
          }
      );
  }





}


