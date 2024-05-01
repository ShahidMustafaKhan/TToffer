import 'package:flutter/material.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/View/Post%20screens/indicator.dart';
import 'package:tt_offer/View/Post%20screens/set_price_screen.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class PostDetailScreen extends StatefulWidget {
  final productId;
  const PostDetailScreen({super.key, this.productId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String _selectedCategory = "";
  String _selectedSubCategory = "";
  String _selectedCondition = "";
  var catagoryId;
  var subCatagoryId;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _millageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _modelYearController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _authenticityController = TextEditingController();
  final TextEditingController _editionController = TextEditingController();

  bool _isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var catagoryData;
  var subCatagoryData;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getCatagories(search: "");
    getSubCatagories(search: "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("object${_selectedCategory}");
    return Scaffold(
      appBar: CustomAppBar1(
        title: "Detail",
        action: true,
        img: "assets/images/cross.png",
        actionOntap: () {
          pushUntil(context, const BottomNavView());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StepsIndicator(
                conColor1: AppTheme.appColor,
                circleColor1: AppTheme.appColor,
                circleColor2: AppTheme.appColor,
                conColor2: AppTheme.appColor,
              ),
              const SizedBox(
                height: 20,
              ),
              customRow(
                  onTap: () {
                    _showCategoryBottomSheet(context);
                  },
                  title: "Category(required)",
                  selectText: _selectedCategory),
              customRow(
                onTap: () {
                  _showSubCategoryBottomSheet(context);
                },
                title: "Sub-category(optional)",
                selectText: _selectedSubCategory,
              ),
              customRow(
                onTap: () {
                  _showConditionBottomSheet(context);
                },
                title: "Condition (required)",
                selectText: _selectedCondition,
              ),
              lableFields(
                  lableTtxt: "Year, Make & Model(Optional)",
                  controller: _modelYearController),
              lableFields(
                  lableTtxt: "Mileage (Optional)",
                  controller: _millageController),
              lableFields(
                  lableTtxt: "Color (optional)", controller: _colorController),
              lableFields(
                  lableTtxt: "Brand (optional)", controller: _brandController),
              lableFields(
                  lableTtxt: "Model (optional)", controller: _modelController),
              lableFields(
                  lableTtxt: "Edition (optional)",
                  controller: _editionController),
              lableFields(
                  lableTtxt: "Authenticity (optional)",
                  controller: _authenticityController),
              _isLoading == true
                  ? LoadingDialog()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: AppButton.appButton("Next", onTap: () {
                        print("object $catagoryId  $subCatagoryId");
                        addProductDetail();
                      },
                          height: 53,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          radius: 32.0,
                          backgroundColor: AppTheme.appColor,
                          textColor: AppTheme.whiteColor),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget lableFields({lableTtxt, controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          LableTextField(
              labelTxt: "$lableTtxt",
              lableColor: AppTheme.hintTextColor,
              hintTxt: "",
              controller: controller),
          const CustomDivider(),
        ],
      ),
    );
  }

  Widget customRow({Function()? onTap, title, selectText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("$title",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.hintTextColor),
                  Image.asset(
                    "assets/images/arrowDown.png",
                    height: 14,
                    width: 14,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AppText.appText("$selectText",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.textColor),
              const SizedBox(
                height: 20,
              ),
              const CustomDivider()
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////   category bottom sheet ///////////////////////
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
                  Expanded(child: _buildCategoryList(setState)),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        _selectedCategory = _selectedCategory;
      });
    });
  }

  Widget _buildCategoryList(StateSetter setState) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: catagoryData.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              checkColor: AppTheme.whiteColor,
              activeColor: AppTheme.appColor,
              value: _selectedCategory == catagoryData[index]["name"],
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    _selectedCategory = catagoryData[index]["name"];
                    catagoryId = catagoryData[index]["id"];
                  } else {
                    _selectedCategory = "";
                  }
                });
              },
            ),
            AppText.appText(catagoryData[index]["name"],
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppTheme.textColor),
          ],
        );
      },
    );
  }

  /////////////////////////////   Subcategory bottom sheet ///////////////////////
  void _showSubCategoryBottomSheet(BuildContext context) {
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
                      "Sub Categories",
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
                    child: _buildSubCategoryList(setState),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        _selectedSubCategory = _selectedSubCategory;
      });
    });
  }

  Widget _buildSubCategoryList(StateSetter setState) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: subCatagoryData.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              checkColor: AppTheme.whiteColor,
              activeColor: AppTheme.appColor,
              value: _selectedSubCategory == subCatagoryData[index]["name"],
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    _selectedSubCategory = subCatagoryData[index]["name"];
                    subCatagoryId = subCatagoryData[index]["id"];
                  } else {
                    _selectedSubCategory = "";
                  }
                });
              },
            ),
            AppText.appText(subCatagoryData[index]["name"],
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppTheme.textColor),
          ],
        );
      },
    );
  }

  /////////////////////////////  Condition bottom sheet ///////////////////////
  void _showConditionBottomSheet(BuildContext context) {
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
                      "Condition",
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
                    child: _buildConditionList(setState),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        _selectedCondition = _selectedCondition;
      });
    });
  }

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
      print("Something went Wrong ${e}");
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
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void addProductDetail() async {
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
      "category_id": "$catagoryId",
      "product_id": "${widget.productId}",
      "condition": _selectedCondition,
      "sub_category_id": "$subCatagoryId",
      "make_and_model": _modelYearController.text,
      "mileage": _millageController.text,
      "color": _colorController.text,
      "brand": _brandController.text,
      "model": _modelController.text,
      "edition": _editionController.text,
      "authenticity": _authenticityController.text,
    };
    try {
      response = await dio.post(path: AppUrls.addProductDetail, data: params);
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
          pushReplacement(
              context,
              SetPostPriceScreen(
                productId: widget.productId,
              ));
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
