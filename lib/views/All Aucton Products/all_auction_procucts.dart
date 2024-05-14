import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/All%20Aucton%20Products/auction_container.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';

class ViewAllAuctionProducts extends StatefulWidget {
  const ViewAllAuctionProducts({super.key});

  @override
  State<ViewAllAuctionProducts> createState() => _ViewAllAuctionProductsState();
}

class _ViewAllAuctionProductsState extends State<ViewAllAuctionProducts> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  late AppDio dio;
  AppLogger logger = AppLogger();
  int? selectedIndex;
  List<bool>? isExpanded;
  bool isLoading = false;
  var catId;
  var subCatId;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    apiProvider.getAuctionProducts(
      dio: dio,
      context: context,
    );

    apiProvider.getCatagories(
      dio: dio,
      context: context,
    );
    apiProvider.getSubCatagories(dio: dio, context: context);
    getCatagories(search: "");
    getSubCatagories(search: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final apiProvider = Provider.of<ProductsApiProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Auction Products",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            //   child: CustomAppFormField(
            //     height: 40,
            //     radius: 15.0,
            //     prefixIcon: Image.asset(
            //       "assets/images/search.png",
            //       height: 17,
            //       color: AppTheme.textColor,
            //     ),
            //     texthint: "Search",
            //     controller: _searchController,
            //   ),
            // ),
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
                      onTap: () {
                        _showFilterBottomSheet(context);
                      },
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
          apiProvider.getAuctionProducts(
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

  void _showFilterBottomSheet(BuildContext context) {
    final apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(30)),

              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: AppText.appText(
                            "Filter",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        AppText.appText(
                          'Sort by',
                          fontWeight: FontWeight.w800,
                        ),
                        const SizedBox(height: 8),
                        customDropdown(Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                              hint: AppText.appText(
                                sorting,
                                fontWeight: FontWeight.w500,
                              ),
                              underline: const SizedBox(),
                              icon: const SizedBox(),
                              isExpanded: true,
                              items: filter.map((e) {
                                return DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        sorting = e;
                                      });
                                    },
                                    value: e,
                                    child: Text(e));
                              }).toList(),
                              onChanged: (_) {}),
                        )),

                        const SizedBox(height: 20),

                        AppText.appText(
                          'Filter ads by',
                          fontWeight: FontWeight.w800,
                        ),
                        const SizedBox(height: 8),
                        customDropdown(Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                              hint: AppText.appText(
                                isUrgent,
                                fontWeight: FontWeight.w500,
                              ),
                              underline: const SizedBox(),
                              icon: const SizedBox(),
                              isExpanded: true,
                              items: urgent.map((e) {
                                return DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        isUrgent = e;
                                      });
                                    },
                                    value: e,
                                    child: Text(e));
                              }).toList(),
                              onChanged: (_) {}),
                        )),
                        const SizedBox(height: 20),

                        AppText.appText(
                          'Sort by min to max price',
                          fontWeight: FontWeight.w800,
                        ),

                        Row(
                          children: [
                            Expanded(
                                child: lableFields(
                                    controller: minPrice,
                                    hintText: 'Min Price')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: lableFields(
                                    controller: maxPrice,
                                    hintText: 'High Price'))
                          ],
                        ),

                        AppText.appText(
                          'Filter by distance',
                          fontWeight: FontWeight.w800,
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Slider(
                                  activeColor: AppTheme.appColor,
                                  value: sliderValue,
                                  min: 0,
                                  max: 100,
                                  onChanged: (val) {
                                    setState(() {
                                      sliderValue = val;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                key: tooltipKey,
                                left: (sliderValue / 100) * 300 - 20,
                                // Adjust position based on slider value and width
                                bottom: 40,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: AppTheme.appColor,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    sliderValue.toStringAsFixed(0),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      apiProvider.getAuctionFiltterProducts(
          dio: dio,
          context: context,
          maxPrice: maxPrice.text.trim(),
          minPrice: minPrice.text.trim(),
          sortBy: sorting,
          isUrgent: isUrgent);
    });
  }

  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();

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
        apiProvider.getAuctionProducts(
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

  Widget lableFields({lableTtxt, controller, hintText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        children: [
          LableTextField(
            // labelTxt: lableTtxt == null ? '' : "$lableTtxt",
            lableColor: AppTheme.hintTextColor,
            hintTxt: hintText,
            controller: controller,
          ),
          // const CustomDivider(),
        ],
      ),
    );
  }

  var catagoryData;
  var subCatagoryData;

  Widget _buildConditionList(StateSetter setState) {
    List<String> conditions = [
      "New",
      "Good",
      "Open Box",
      "Refurnished",
      "For Part or Not Working"
    ];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: conditions.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              checkColor: AppTheme.whiteColor,
              activeColor: AppTheme.appColor,
              value: _selectedCondition == conditions[index],
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    _selectedCondition = conditions[index];
                  } else {
                    _selectedCondition = "";
                  }
                });
              },
            ),
            AppText.appText(conditions[index],
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppTheme.textColor),
          ],
        );
      },
    );
  }

  void getCatagories({search}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "search": "$search",
      "limit": null,
    };
    try {
      response = await dio.post(path: AppUrls.categories, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          catagoryData = responseData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong $e");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getSubCatagories({search}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "category_id": "",
      "search": null,
      "limit": null,
      "id": "",
    };
    try {
      response = await dio.post(path: AppUrls.subCategories, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          subCatagoryData = responseData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong $e");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

// void addProductDetail() async {
//   setState(() {
//     _isLoading = true;
//   });
//   var response;
//   int responseCode200 = 200; // For successful request.
//   int responseCode400 = 400; // For Bad Request.
//   int responseCode401 = 401; // For Unauthorized access.
//   int responseCode404 = 404; // For For data not found
//   int responseCode422 = 422; // For For data not found
//   int responseCode500 = 500; // Internal server error.
//   Map<String, dynamic> params = {
//     "category_id": "${widget.selling == null ? catagoryId : catagoryId}",
//     "product_id": "${widget.productId}",
//     "condition": _selectedCondition,
//     "sub_category_id": "$subCatagoryId",
//     "make_and_model": _modelYearController.text,
//     "mileage": _millageController.text,
//     "color": _colorController.text,
//     "brand": _brandController.text,
//     "model": _modelController.text,
//     "edition": _editionController.text,
//     "authenticity": _authenticityController.text,
//   };
//   try {
//     response = await dio.post(
//         path: widget.selling != null
//             ? AppUrls.updateProductDetail
//             : AppUrls.addProductDetail,
//         data: params);
//     var responseData = response.data;
//     if (response.statusCode == responseCode400) {
//       showSnackBar(context, "${responseData["msg"]}");
//       setState(() {
//         _isLoading = false;
//       });
//     } else if (response.statusCode == responseCode401) {
//       showSnackBar(context, "${responseData["msg"]}");
//       setState(() {
//         _isLoading = false;
//       });
//     } else if (response.statusCode == responseCode404) {
//       showSnackBar(context, "${responseData["msg"]}");
//       setState(() {
//         _isLoading = false;
//       });
//     } else if (response.statusCode == responseCode500) {
//       showSnackBar(context, "${responseData["msg"]}");
//       setState(() {
//         _isLoading = false;
//       });
//     } else if (response.statusCode == responseCode422) {
//       setState(() {
//         _isLoading = false;
//       });
//     } else if (response.statusCode == responseCode200) {
//       setState(() {
//         pushReplacement(
//             context,
//             SetPostPriceScreen(
//               selling: widget.selling,
//               productId: widget.productId,
//               title: widget.title,
//             ));
//         _isLoading = false;
//       });
//     }
//   } catch (e) {
//     print("Something went Wrong $e");
//     showSnackBar(context, "Something went Wrong.");
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }
}

String _selectedCategory = "";
String _selectedSubCategory = "";
String _selectedCondition = "";
String sorting = "Select Sort By";
String isUrgent = "Select Ads By";
var catagoryId;
var subCatagoryId;
double sliderValue = 0;
OverlayEntry? overlayEntry;
GlobalKey tooltipKey = GlobalKey();

bool _isLoading = false;

List<String> filter = [
  'newest on top',
  'newest on bottom',
  'lowest price on top',
  'lowest price on bottom'
];

List<String> urgent = [
  'urgent',
  'normal',
];

customDropdown(Widget? widget) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        decoration: BoxDecoration(
            color: AppTheme.white,
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(18)),
        width: double.infinity,
        height: 50,
        child: widget,
      ),
      Positioned(
        right: 18,
        bottom: 15,
        child: Container(
          height: 20,
          width: 20,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/arrowDown.png'))),
        ),
      )
    ],
  );
}
