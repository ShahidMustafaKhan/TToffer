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
import 'package:tt_offer/View/All%20Featured%20Products/feature_container.dart';
import 'package:tt_offer/View/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class ViewFeaturedProducts extends StatefulWidget {
  const ViewFeaturedProducts({super.key});

  @override
  State<ViewFeaturedProducts> createState() => _ViewFeaturedProductsState();
}

class _ViewFeaturedProductsState extends State<ViewFeaturedProducts> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  late AppDio dio;
  AppLogger logger = AppLogger();
  List<bool>? isExpanded;
  var catId;
  var subCatId;
  bool isLoading = false;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    apiProvider.getFeatureProducts(
      dio: dio,
      context: context,
    );

    apiProvider.getCatagories(
      dio: dio,
      context: context,
    );
    apiProvider.getSubCatagories(dio: dio, context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final apiProvider = Provider.of<ProductsApiProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Featured Products",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: CustomAppFormField(
                height: 40,
                radius: 15.0,
                prefixIcon: Image.asset(
                  "assets/images/search.png",
                  height: 17,
                  color: AppTheme.textColor,
                ),
                texthint: "Search",
                controller: _searchController,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: SizedBox(
                height: 20,
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customRow(
                      img: "assets/images/location.png",
                      txt: "Belarus",
                      onTap: () {
                        _showLocationBottomSheet(context);
                      },
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: AppTheme.blackColor,
                    ),
                    customRow(
                      img: "assets/images/category.png",
                      txt: "All Category",
                      onTap: () {
                        _showCategoryBottomSheet(context);
                      },
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: AppTheme.blackColor,
                    ),
                    customRow(
                      img: "assets/images/filter.png",
                      txt: "Filter",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
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
      ),
    );
  }

  Widget customRow({img, txt, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            "$img",
            height: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          AppText.appText("$txt",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textColor: AppTheme.textColor)
        ],
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AppText.appText(
                      "Categories",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomAppFormField(
                    radius: 15.0,
                    prefixIcon: Image.asset(
                      "assets/images/search.png",
                      height: 17,
                      color: AppTheme.textColor,
                    ),
                    texthint: "Search",
                    controller: _searchController,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: buildCategoryList(setState),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        subCatId = subCatId;
        if (subCatId != null && catId != null) {
          apiProvider.getFeatureProducts(
              context: context, dio: dio, subCatId: subCatId, cateId: subCatId);
        }
      });
    });
    ;
  }

  Widget buildCategoryList(StateSetter setState) {
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    isExpanded ??= List.filled(apiProvider.catagoryData.length, false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: apiProvider.catagoryData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    catId = apiProvider.catagoryData[index]["id"];
                    _toggleExpand(index);
                  });
                },
                child: Container(
                  color: AppTheme.whiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.appText(apiProvider.catagoryData[index]["name"],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: const Color(0xff1B2028)),
                      Image.asset(
                        "assets/images/arrowFor.png",
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
              if (isExpanded![index])
                for (int i = 0; i < apiProvider.subCatagoryData.length; i++)
                  if (apiProvider.catagoryData[index]["id"] ==
                      apiProvider.subCatagoryData[i]["category_id"])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: SizedBox(
                        height: 30,
                        child: RadioListTile<int>(
                          tileColor: AppTheme.appColor,
                          activeColor: AppTheme.appColor,
                          title: AppText.appText(
                              apiProvider.subCatagoryData[i]["name"],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              textColor: const Color(0xff1B2028)),
                          value: apiProvider.subCatagoryData[i]["id"],
                          groupValue: subCatId,
                          onChanged: (int? value) {
                            setState(() {
                              subCatId = value;
                            });
                          },
                        ),
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  void _toggleExpand(int tappedIndex) {
    setState(() {
      for (int i = 0; i < isExpanded!.length; i++) {
        if (i == tappedIndex) {
          isExpanded![i] = !isExpanded![i]; // Toggle the tapped index
        } else {
          isExpanded![i] = false; // Collapse all other indices
        }
      }
    });
  }

  void _showLocationBottomSheet(BuildContext context) {
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AppText.appText(
                      "Location",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppText.appText("Address",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.textColor),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomAppFormField(
                    texthint: "Set a loction",
                    controller: _locationController,
                    borderColor: const Color(0xffE5E9EB),
                    hintTextColor: AppTheme.hintTextColor,
                    suffixIcon: Image.asset(
                      "assets/images/location.png",
                      height: 20,
                      width: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     customLocationRow(txt1: "City", txt2: "New York"),
                  //     customLocationRow(txt1: "State", txt2: "California"),
                  //     customLocationRow(txt1: "Zip", txt2: "3254"),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      if (_locationController.text.isNotEmpty) {
        apiProvider.getFeatureProducts(
            context: context, dio: dio, location: _locationController.text);
      }
    });
  }

  // Widget customLocationRow({txt1, txt2}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AppText.appText("$txt1",
  //           fontSize: 12,
  //           fontWeight: FontWeight.w600,
  //           textColor: AppTheme.textColor),
  //       const SizedBox(
  //         height: 10,
  //       ),
  //       CustomAppFormField(
  //         texthint: "$txt2",
  //         controller: _locationController,
  //         borderColor: const Color(0xffE5E9EB),
  //         hintTextColor: AppTheme.hintTextColor,
  //         width: MediaQuery.of(context).size.width * 0.25,
  //       ),
  //     ],
  //   );
  // }

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
