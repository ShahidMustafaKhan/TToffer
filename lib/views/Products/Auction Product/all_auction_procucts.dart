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
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/sub_categories_model.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/all_feature_products.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';
import '../../../models/product_model.dart';

import '../../../Utils/widgets/custom_radio_button.dart';
import '../../../Utils/widgets/others/no_data_found.dart';


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
  late ProductViewModel productViewModel;
  List<Product>? auctionProductList = [];
  bool? isUrgentAds;
  String? subCategory;
  String? category;
  var categoryName = "All Category";

  List<CategoryModel> catModel = [];
  List<SubCategoriesModel> subCat = [];

  getCategories() async {
    await BlockedUserServices().getBlockedUser(context: context);

    catModel = Provider.of<CategoryProvider>(context, listen: false).category;

    setState(() {});
  }

  getSubCat() async {
    await SubCategoriesService().subCategoriesService(context: context);

    subCat = Provider.of<SubCategoriesProvider>(context, listen: false)
        .subCategories;

    setState(() {});
  }

  @override
  void initState() {
    getCategories();
    getSubCat();
    sortNewestOnTop();


    dio = AppDio(context);
    logger.init();
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    productViewModel.getAuctionProducts(

    );

    auctionProductList = productViewModel.auctionProductList?.data?.data?.productList;

    super.initState();
  }

  var catName;


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if(categoryName=='Mobiles'){
      if(catName=='Accessories'){
        condition = ["New", "Used", "Open Box", "Others"];
      }
      else {
        condition = ["New", "Used", "Open Box", "Refurbished", "Others"];
      }
    }
    else if(categoryName=='All Category'){
      condition=[];
    }
    else if(categoryName=="Electronics & Appliance"){
      condition = ["New", "Used", "Refurbished", "Others"];
    }
    else if(categoryName=="Kids"){
      condition = ["New", "Used", "Open Box", "Others"];
    }
    else if(categoryName=="Vehicles"){
      condition = ["New", "Used", "Others"];
    }
    else{
      condition = ["New", "Used", "Refurbished", "Others"];
    }
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Auction Products",
      ),
      body: Consumer<ProductViewModel>(
          builder: (context, productViewModel, child) {
            return SingleChildScrollView(
            child: Column(
              children: [
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
                          txt: _locationController.text.isEmpty ? "Global" : _locationController.text,
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
                          txt: catName ?? "All Category",
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
                 Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: screenWidth / (3.8 * 175),
                    ),
                    shrinkWrap: true,
                    itemCount: productViewModel.auctionProductList.data?.data?.productList?.length ?? 0,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                          onTap: () {
                            push(
                                context,
                                AuctionInfoScreen(
                                 detailResponse: productViewModel.auctionProductList.data?.data?.productList?[index],
                                ));
                            // getAuctionProductDetail(apiProvider
                            //     .allauctionProductsData[index]["id"]);
                          },
                          child: AuctionProductContainer(
                            product:productViewModel.auctionProductList.data?.data?.productList?[index],
                          ));
                    },
                  ),
                ),
                if(productViewModel.auctionProductList.status == Status.error || (productViewModel.auctionProductList.data?.data?.productList?.isEmpty ?? true))
                  NoDataFound.noDataFound()
              ],
            ),
          );
        }
      ),
    );
  }

  Map<int, int> selectedIndexes = {};

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
      });
    });
    ;
  }

  Widget buildCategoryList(StateSetter setState) {
    final apiProvider =
    Provider.of<ProductsApiProvider>(context, listen: false);
    isExpanded ??= List.filled(catModel.length, false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: catModel.length+1,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if(index==0){
                      subCategory=null;
                      category=null;
                      catName= "All Category";
                      categoryName= "All Category";
                      isExpanded = null;
                      selectedCondition = 'Select By Condition';
                      filterProductsByPrice();
                      Navigator.of(context).pop();

                    }
                    else{
                      catId = catModel[index-1].id;
                      category=catModel[index-1].id.toString();
                      catName = catModel[index-1].title;
                      categoryName = catModel[index-1].title!;
                      _toggleExpand(index-1);
                      filterProductsByPrice();

                    }

                  });
                },
                child: Container(
                  color: AppTheme.whiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.appText(index==0 ? "All Category" :catModel[index-1].title.toString(),
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
              if (index!=0 && isExpanded![index-1])
                for (int i = 0; i < subCat.length; i++)
                  if (catId == subCat[i].categoryId)
                    CustomRadioButton(selectedIndexes[catModel[index-1].id] == i,
                        subCat[i].title, () {
                          // subCatId = subCat[i].id;
                          subCatId = subCat[i].title;
                          print('newSub---->${subCatId}');

                          selectedIndexes[catModel[index-1].id!] = i;
                          subCategory = subCat[i].id.toString();
                          catName = subCat[i].title;
                          // filterBySubCategory("${subCat[i].id}");
                          filterProductsByPrice();
                          setState(() {});
                          Navigator.of(context).pop();
                        })
            ]));
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
                              onChanged: (value) {
                                if(filter[0] == value){
                                  sortNewestOnTop();
                                  Navigator.of(context).pop();
                                }
                                else if(filter[1] == value){
                                  sortNewestOnBottom();
                                  Navigator.of(context).pop();
                                }
                                else if(filter[2] == value){
                                  sortLowestPriceOnTop();
                                  Navigator.of(context).pop();
                                }
                                else if(filter[3] == value){
                                  sortLowestPriceOnBottom();
                                  Navigator.of(context).pop();
                                }
                              }),
                        )),
                        if(categoryName!='All Category')...[
                          const SizedBox(height: 20),

                          AppText.appText(
                            'Condition',
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 8),
                          customDropdown(Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton(
                                hint: AppText.appText(
                                  selectedCondition,
                                  fontWeight: FontWeight.w500,
                                ),
                                underline: const SizedBox(),
                                icon: const SizedBox(),
                                isExpanded: true,
                                items: condition.map((e) {
                                  return DropdownMenuItem(
                                      onTap: () {
                                        setState(() {
                                          selectedCondition = e;
                                        });
                                      },
                                      value: e,
                                      child: Text(e));
                                }).toList(),
                                onChanged: (value) {
                                  isUrgentAds = true;
                                  filterProductsByPrice();
                                  Navigator.of(context).pop();
                                }),
                          )),

                        ],
                        const SizedBox(height: 20),
                        AppText.appText(
                          'Sort by min to max price',
                          fontWeight: FontWeight.w800,
                        ),

                        Row(
                          children: [
                            Expanded(
                                child: labelField(
                                    controller: minPrice,

                                    onChanged: (value){filterProductsByPrice(min: value.isEmpty ? null : value);},
                                    hintText: 'Min Price')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: labelField(
                                    controller: maxPrice,
                                    onChanged: (value){filterProductsByPrice(max: value.isEmpty ? null : value);},
                                    hintText: 'High Price'))
                          ],
                        ),

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
    );
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
                    texthint: "Set a location",
                    controller: _locationController,
                    onChanged: (value){
                      // filterByLocation(value);
                      location = value;
                      filterProductsByPrice();
                    },
                    onFieldSubmitted: (value){
                      Navigator.of(context).pop();
                    },
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

  void sortNewestOnTop() {
    // productViewModel.auctionProductList.data?.data?.productList?.sort((a, b) => b..compareTo(a['created_at']));
    setState(() {

    });  }

  void sortNewestOnBottom() {
    // auctionProductList.sort((a, b) => a['created_at'].compareTo(b['created_at']));
    setState(() {});
  }

  void sortLowestPriceOnTop() {
    // auctionProductList.sort((a, b) => double.parse(a['auction_price']).compareTo(double.parse(b['auction_price'])));
    setState(() {});
  }

  void sortLowestPriceOnBottom() {
    // auctionProductList.sort((a, b) => double.parse(b['auction_price']).compareTo(double.parse(a['auction_price'])));
    setState(() {});
  }


  void filterProductsByPrice({
    String? min,
    String? max,
  }){
    filterProducts(maxPrice: max ?? (maxPrice.text.isNotEmpty ? maxPrice.text : null) , minPrice:  min ?? (minPrice.text.isNotEmpty ? minPrice.text : null));
  }

  void filterProducts({
    String? minPrice,
    String? maxPrice,
  }) {
    auctionProductList = productViewModel.auctionProductList.data?.data?.productList?.where((product) {
      bool matches = true;

      if (selectedCondition != 'Select By Condition' && categoryName!= 'All Category') {
        matches = matches && (product.condition == selectedCondition);
      }

      if (_locationController.text.isNotEmpty) {
        List<dynamic> locationParts = product.location != null
            ? product.location!
            .toLowerCase()
            .split(',')
            .map((s) => s.trim())
            .toList()
            : [];

        String searchText = _locationController.text.toLowerCase();

        matches = matches && locationParts.any((part) => part.contains(searchText));
      }

      if (category != null) {
        matches = matches && (product.categoryId.toString() == category);
      }

      if (subCategory != null) {
        matches = matches && (product.subCategory?.id.toString() == subCategory);
      }

      if (minPrice != null || maxPrice != null) {
        int price = int.parse(product.auctionInitialPrice.toString().split('.')[0]);

        if (minPrice != null && maxPrice != null) {
          matches = matches && (price >= int.parse(minPrice) && price <= int.parse(maxPrice));
        } else if (minPrice != null) {
          matches = matches && (price >= int.parse(minPrice));
        } else if (maxPrice != null) {
          matches = matches && (price <= int.parse(maxPrice));
        }
      }

      return matches;
    }).toList();

    setState(() {});  // Notify listeners about the updated state
  }

  Widget labelField({labelText, controller, hintText, onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        children: [
          LableTextField(
            lableColor: AppTheme.hintTextColor,
            hintTxt: hintText,
            keyboard: const TextInputType.numberWithOptions(),
            controller: controller,
            onChanged: onChanged,
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

}

String _selectedCategory = "";
String _selectedSubCategory = "";
String _selectedCondition = "";
String sorting = "Select Sort By";
var condition = [];
String selectedCondition = "Select By Condition";

var catagoryId;
var subCatagoryId;
double sliderValue = 0;
OverlayEntry? overlayEntry;
GlobalKey tooltipKey = GlobalKey();

bool _isLoading = false;

List<String> filter = [
  'Newest on top',
  'Newest on bottom',
  'Lowest price on top',
  'Lowest price on bottom'
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
