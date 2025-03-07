import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
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
import 'package:tt_offer/view_model/category/category_view_model.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Products/Auction%20Product/all_auction_procucts.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_container.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

import '../../../Utils/widgets/custom_radio_button.dart';
import '../../../Utils/widgets/grid_delegate.dart';
import '../../../models/product_model.dart';

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
  var catName;
  var categoryName = "All Category";
  var subCatId;

  bool? isUrgentAds;
  String? subCategory;
  String? category;

  List<CategoryModel> catModel = [];
  List<SubCategoriesModel> subCat = [];
  late ProductViewModel productViewModel;
  List<Product?>? featureProductList = [];
  var condition = [];
  String selectedCondition = "Select By Condition";



  getCategories() async {
    catModel = Provider.of<CategoryViewModel>(context, listen: false).categoryList.data ?? [];
    setState(() {});
  }

  getSubCat() async {

    subCat = Provider.of<CategoryViewModel>(context, listen: false).subCategoryList.data ?? [];
    setState(() {});
  }

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();

    getCategories();
    getSubCat();
    sortNewestOnTop();

    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    productViewModel.getFeatureProducts();

    featureProductList = productViewModel.featureProductList.data?.data?.productList ?? [];



    super.initState();
  }

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
        title: "Featured Products",
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
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              mainAxisSpacing: 15.h,
                              crossAxisSpacing: 12,
                              crossAxisCount: 2,
                              height: MediaQuery.of(context).size.height * 0.312
                          ),
                          shrinkWrap: true,
                          itemCount: featureProductList?.length ?? 0,
                          itemBuilder: (context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  push(
                                      context,
                                      FeatureInfoScreen(
                                        product: featureProductList?[index],
                                      ));

                                  // getFeatureProductDetail(
                                  //     featureProductList[index]["id"]);
                                },
                                child: FeatureProductContainer(
                                  fromHomePage: true,
                                  product: featureProductList?[index],
                                ));
                          },
                        ),
                      ),
                if(featureProductList?.isEmpty ?? true)
                  NoDataFound.noDataFound()

              ],
            ),
          );
        }
      ),
    );
  }

  Map<int, int> selectedIndexes =
      {}; // Map to store selected indexes for each category
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
                      categoryName = "All Category";
                      selectedCondition = 'Select By Condition';
                      isExpanded = null;
                      filterProductsByPrice();
                      Navigator.of(context).pop();
                    }
                    else{
                      subCategory=null;
                      catId = catModel[index-1].id;
                      category=catModel[index-1].id.toString();
                      catName = catModel[index-1].title;
                      categoryName = catModel[index-1].title ?? '';
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

  void _showLocationBottomSheet(BuildContext context) {
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

  void sortNewestOnTop() {
    featureProductList?.sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
    setState(() {

    });  }

  void sortNewestOnBottom() {
    featureProductList?.sort((a, b) => a!.createdAt!.compareTo(b!.createdAt!));
    setState(() {});
  }

  void sortLowestPriceOnTop() {
    featureProductList?.sort((a, b) => double.parse(a!.fixPrice.toString()).compareTo(double.parse(b!.fixPrice.toString())));
    setState(() {});
  }

  void sortLowestPriceOnBottom() {
    featureProductList?.sort((a, b) => double.parse(b!.fixPrice.toString()).compareTo(double.parse(a!.fixPrice.toString())));
    setState(() {});
  }
// Notify listeners about the updated state


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
    featureProductList = productViewModel.featureProductList.data?.data?.productList?.where((product) {
      bool matches = true;

      if (selectedCondition != 'Select By Condition' && categoryName!= 'All Category') {
        matches = matches && (product.condition == selectedCondition);
      }

      if (_locationController.text.isNotEmpty) {
        List<dynamic> locationParts = product.location!.toLowerCase().split(',').map((s) => s.trim()).toList();
        String searchText = _locationController.text.toLowerCase();

        matches = matches && locationParts.any((part) => part.contains(searchText));
      }

      if (category != null) {
        matches = matches && (product.category?.id.toString() == category);
      }

      if (subCategory != null) {
        matches = matches && (product.subCategory?.id.toString() == subCategory);
      }

      if (minPrice != null || maxPrice != null) {
        int price = int.parse(product.fixPrice.toString().split('.')[0]);

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

  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
}


