import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/All%20Aucton%20Products/auction_container.dart';
import 'package:tt_offer/View/All%20Featured%20Products/feature_container.dart';
import 'package:tt_offer/View/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/View/Auction%20Info/auction_info.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class CatagoryProductScreen extends StatefulWidget {
  final catId;
  final String? catNAme;
  const CatagoryProductScreen({super.key, this.catId, this.catNAme});

  @override
  State<CatagoryProductScreen> createState() => _CatagoryProductScreenState();
}

class _CatagoryProductScreenState extends State<CatagoryProductScreen> {
  String selectedOption = 'Auction';
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool isLoading = false;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    apiProvider.getAuctionProducts(
        dio: dio, context: context, cateId: widget.catId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ProductsApiProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar1(
        title: "${widget.catNAme}",
        leading: true,
      ),
      body: Column(
        children: [
          selectOption(),
          if (selectedOption == "Auction")
            apiProvider.isLoading == true
                ? LoadingDialog()
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 20,
                        crossAxisCount: 2,
                        childAspectRatio: screenWidth / (3.8 * 200),
                      ),
                      shrinkWrap: true,
                      itemCount: apiProvider.allauctionProductsData.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                            onTap: () {
                              getAuctionProductDetail(apiProvider
                                  .allauctionProductsData[index]["id"]);
                            },
                            child: AuctionProductContainer(
                              data: apiProvider.allauctionProductsData[index],
                            ));
                      },
                    ),
                  ),
          if (selectedOption == "Featured")
            apiProvider.isLoading == true
                ? LoadingDialog()
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 20,
                        crossAxisCount: 2,
                        childAspectRatio: screenWidth / (2.6 * 220),
                      ),
                      shrinkWrap: true,
                      itemCount: apiProvider.allfeatureProductsData.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                            onTap: () {
                              getFeatureProductDetail(apiProvider
                                  .allfeatureProductsData[index]["id"]);
                            },
                            child: FeatureProductContainer(
                              data: apiProvider.allfeatureProductsData[index],
                            ));
                      },
                    ),
                  ),
        ],
      ),
    );
  }

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.45) {
            setState(() {
              if (selectedOption != 'Auction') {
                final apiProvider =
                    Provider.of<ProductsApiProvider>(context, listen: false);
                apiProvider.getAuctionProducts(
                    dio: dio, context: context, cateId: widget.catId);
              }
              selectedOption = 'Auction';
            });
          } else if (tapPosition < screenWidth * 0.9) {
            setState(() {
              if (selectedOption == 'Auction') {
                final apiProvider =
                    Provider.of<ProductsApiProvider>(context, listen: false);
                apiProvider.getFeatureProducts(
                    dio: dio, context: context, cateId: widget.catId);
              }
              selectedOption = 'Featured';
            });
          }
        },
        child: Container(
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xffEDEDED))),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(100)),
                    color: selectedOption == 'Auction'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Auction',
                    style: TextStyle(
                      color: selectedOption == 'Auction'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == 'Featured'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      color: selectedOption == 'Featured'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getAuctionProductDetail(productId) async {
    setState(() {
      isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
    };
    try {
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            isLoading = false;
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          push(
              context,
              AuctionInfoScreen(
                detailResponse: detailResponse[0],
              ));
          isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void getFeatureProductDetail(productId) async {
    setState(() {
      isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            isLoading = false;
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          push(
              context,
              FeatureInfoScreen(
                detailResponse: detailResponse[0],
              ));
          isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }
}
