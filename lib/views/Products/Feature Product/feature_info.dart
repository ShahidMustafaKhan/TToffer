import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/cart_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/custom_requests/dynmaic_link_service.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/views/Products/widgets/full_image_page.dart';
import 'package:tt_offer/views/Products/Feature%20Product/widgets/make_offer_screen.dart';
import 'package:tt_offer/views/ChatScreens/offer_chat_screen.dart';
import 'package:tt_offer/views/Products/widgets/feature_product_interactive_buttons.dart';
import 'package:tt_offer/views/Products/widgets/product_image.dart';
import 'package:tt_offer/views/Products/widgets/seller_detail_widget.dart';
import 'package:tt_offer/views/Seller%20Profile/seller_profile.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/views/ShoppingFlow/cart/cart_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/APIs Manager/chat_api.dart';
import '../../../models/product_model.dart';
import '../../Authentication screens/login_screen.dart';
import '../../BottomNavigation/navigation_bar.dart';
import '../../Profile Screen/profile_screen.dart';
import '../widgets/action_buttons.dart';
import '../widgets/description_widget.dart';
import '../widgets/divider.dart';
import '../widgets/dubai_property_rules.dart';
import '../widgets/product_atrributes_widget.dart';
import '../widgets/product_details_widget.dart';
import 'feature_container.dart';

class FeatureInfoScreen extends StatefulWidget {
  var detailResponse;
  Product? product;
  String? productId;
  bool fromDynamicLink;
  bool popToBottomNav;

  FeatureInfoScreen({super.key, this.detailResponse, this.product, this.fromDynamicLink=false, this.popToBottomNav=false, this.productId});

  @override
  State<FeatureInfoScreen> createState() => _FeatureInfoScreenState();
}

class _FeatureInfoScreenState extends State<FeatureInfoScreen> {
  bool isLoading = false;
  bool isPageLoading = false;
  bool isFav = false;
  bool isProperty=false;
  String? categoryName;
  String? subCategoryName;

  // static List<String> wrapList1 = [];
  late AppDio dio;
  var userId;
  String? authorizationToken;
  AppLogger logger = AppLogger();

  static List wrapList1 = [];

  double? userRating;
  
  Product? product;

  Map<String, dynamic>? attributes;

  late FashionAttributes fashionAttributes;
  late MobileAttributes mobileAttributes;
  late VehicleAttributes vehicleAttributes;
  late PropertyAttributes propertyAttributes;
  late JobAttributes jobAttributes;
  late BikeAttributes bikeAttributes;
  late ServicesAttributes servicesAttributes;
  late KidsAttributes kidsAttributes;
  late AnimalsAttributes animalsAttributes;
  late FurnitureAttributes furnitureAttributes;
  late ElectronicApplicanceAttributes electronicApplicanceAttributes;


  setUserRating() async {
    userRating = await getUserRating(product.toString());
    setState(() {

    });
  }

  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString(PrefKey.userId) != null) {
      userId = int.tryParse(pref.getString(PrefKey.userId)!);
    }
    authorizationToken = pref.getString(PrefKey.authorization);
    setState(() {

    });
  }

   late CartApiProvider cartProvider;

  late List<String> wrapList;

  void initializeWrapList(String categoryName, String subCategoryName, JobAttributes jobAttributes) {
    switch (categoryName) {
      case 'Animals':
        wrapList = [
          'Age',
          'Breed',
          '',
          '',
          '',
          '',
          '',
          '',
        ];
        break;

      case 'Jobs':
        if (jobAttributes.hireStatus == 'Hiring') {
          wrapList = [
            'Company Name',
            'Position Type',
            'Salary Period',
            'Education',
            'Description',
            '',
            '',
          ];
        } else {
          wrapList = [
            'Linkedin Profile',
            'Preferred Employment Type',
            'Experience Level',
            '',
            'Education',
            'Description',
            '',
          ];
        }
        break;

      case 'Fashion & beauty':
      case 'Services':
      case 'Kids':
        wrapList = [
          'Description',
          '',
          '',
          '',
          '',
          '',
          '',
        ];
        break;

      case 'Electronics & Appliance':
        wrapList = [
          'Brand',
          'Color',
          'Storage Capacity',
          '',
          '',
          '',
          '',
        ];
        break;

      case 'Furniture & home decor':
        wrapList = [
          'Type',
          'Color',
          '',
          '',
          '',
          '',
          '',
        ];
        break;

      case 'Mobiles':
        wrapList = [
          'Condition',
          'Brand',
          'Storage Capacity',
          'Color',
          '',
          '',
          '',
          '',
        ];
        break;

      case 'Vehicles':
        wrapList = [
          'Fuel Type',
          'Color',
          'Kilometers',
          'Make',
          'Year',
          '',
          '',
        ];
        break;

      case 'Bikes':
        if (subCategoryName == 'Bikes Accessories') {
          wrapList = [
            'Accessories Description',
            '',
            '',
            '',
            '',
            '',
            '',
          ];
        } else {
          wrapList = [
            'Model',
            'Engine Capacity',
            '',
            '',
            '',
            '',
            '',
          ];
        }
        break;

      case 'Property for Sale':
        wrapList = [
          'Furnished',
          'Area',
          'Bathrooms',
          'Completion',
          subCategoryName == 'Commercial Space' ? 'Zone For' : 'Bedrooms',
          'YearBuilt',
          'Features',
          '',
        ];
        break;

      case 'Property for Rent':
        wrapList = [
          'Furnished',
          'Area',
          'Bathrooms',
          'YearBuilt',
          subCategoryName == 'Commercial Space' ? 'Zone For' : 'Bedrooms',
          'Features',
          '',
          '',
        ];
        break;

      default:
        wrapList = ['', '', '', '', '', '', '', ''];
    }}


  @override
  void initState() {
    cartProvider = Provider.of<CartApiProvider>(context, listen: false);

    dio = AppDio(context);
    logger.init();
    
    product = widget.product;
    categoryName = product?.category?.name;
    subCategoryName = product?.subCategory?.name;


    getProductData();
    super.initState();
  }




  Future<void> getProductData() async {
    if(product!= null){
      getAttributes();
        getUserId();
        setUserRating();
        // markProductView();

    }
    else{
      isPageLoading = true;
      await getProductDetail(dynamicLink: true );
      getAttributes();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        getUserId();
        setUserRating();
        // markProductView();
      });

    }
  }

  void getAttributes(){
    final attributesJson = product?.attributes;
    fashionAttributes = FashionAttributes.fromJson(attributesJson);
    mobileAttributes = MobileAttributes.fromJson(attributesJson);
    vehicleAttributes = VehicleAttributes.fromJson(attributesJson);
    propertyAttributes = PropertyAttributes.fromJson(attributesJson);
    jobAttributes = JobAttributes.fromJson(attributesJson);
    bikeAttributes = BikeAttributes.fromJson(attributesJson);
    servicesAttributes = ServicesAttributes.fromJson(attributesJson);
    kidsAttributes = KidsAttributes.fromJson(attributesJson);
    animalsAttributes = AnimalsAttributes.fromJson(attributesJson);
    furnitureAttributes = FurnitureAttributes.fromJson(attributesJson);
    electronicApplicanceAttributes = ElectronicApplicanceAttributes.fromJson(attributesJson);

    initializeWrapList(categoryName! , subCategoryName! , jobAttributes);

    wrapList1 = [
      '${categoryName == 'Animals'  ? animalsAttributes.age : categoryName == 'Jobs' ?
      jobAttributes.hireStatus == 'Hiring' ?  jobAttributes.companyName : jobAttributes.linkedinProfile  : categoryName == 'Fashion & beauty' ? furnitureAttributes.description : categoryName == 'Services' ? servicesAttributes.description : "Condition" ?? 'NA' }',
      (categoryName == 'Furniture & home decor'
          ? furnitureAttributes.type
          :  categoryName == 'Mobiles'
          ? mobileAttributes.brand
          : categoryName == 'Vehicles'
          ? vehicleAttributes.FuelType
          : categoryName == 'Property for Sale' ||
          categoryName == 'Property for Rent'
          ? propertyAttributes.furnished
          : categoryName == 'Jobs'
          ? jobAttributes.possitionType
          : categoryName == 'Bikes'
          ? bikeAttributes.model
          : categoryName == 'Kids'
          ? kidsAttributes.description
          : categoryName ==
          'Electronics & Appliance'
          ? electronicApplicanceAttributes.brand
          : categoryName == 'Animals'
          ? animalsAttributes.breed
          :''),

      (categoryName == 'Electronics & Appliance'
          ? electronicApplicanceAttributes.color
          : categoryName == 'Furniture & home decor'
          ? furnitureAttributes.color
          :   categoryName == 'Mobiles'
          ? subCategoryName == 'Accessories' ? mobileAttributes.color : mobileAttributes.storage
          : categoryName == 'Vehicles'
          ? vehicleAttributes.color
          : categoryName ==
          'Property for Sale' ||
          categoryName ==
              'Property for Rent'
          ? propertyAttributes.area.isNotEmpty ? '${propertyAttributes.area} sqft' : ''
          : categoryName == 'Jobs'
          ? jobAttributes.type
          : categoryName == 'Bikes'
          ? (categoryName == 'Bikes Accessories' ? bikeAttributes.description : bikeAttributes.engineCapacity)
          : ''),
      (categoryName == 'Mobiles'
          ? mobileAttributes.color
          : categoryName == 'Property for Sale' ||
          categoryName == 'Property for Rent'
          ? propertyAttributes.bathroom.isNotEmpty ? propertyAttributes.bathroom == 'no bathroom' ? propertyAttributes.bathroom : '${propertyAttributes.bathroom} BA' : ''
          : categoryName == 'Jobs'
          ? jobAttributes.hireStatus == 'Hiring' ? jobAttributes.salaryPeriod : jobAttributes.experience:
      categoryName == 'Vehicles'
          ? vehicleAttributes.mileAge
          : ''),
      (categoryName == 'Property for Sale' &&
          categoryName != 'Property for Rent'
          ? propertyAttributes.completion
          : categoryName != 'Property for Sale' &&
          categoryName == 'Property for Rent'
          ? propertyAttributes.yearBuilt
          : categoryName == 'Jobs'
          ? jobAttributes.education
          : categoryName == 'Vehicles'
          ? vehicleAttributes.makeModel
          : ''),
      propertyAttributes.catName == 'Property for Sale' ||
          propertyAttributes.catName == 'Property for Rent'
          ?  subCategoryName == 'Commercial Space' ?
      propertyAttributes.zoneFor :
      propertyAttributes.bedroom.isNotEmpty ? '${propertyAttributes.bedroom} ${propertyAttributes.bedroom!= "Studio" ? "BDRM" : ''}' : ''
          : categoryName == 'Vehicles'
          ? vehicleAttributes.year
          : categoryName == 'Jobs'
          ? jobAttributes.description : '',
      categoryName == 'Property for Sale'
          ? propertyAttributes.yearBuilt :
      propertyAttributes.catName == 'Property for Rent' ? propertyAttributes.features
          : '',

      categoryName == 'Property for Sale' ?
      propertyAttributes.features
          :
      categoryName == 'Vehicles'
          ? vehicleAttributes.makeModel
          :  '',

      categoryName == 'Vehicles' ? vehicleAttributes.year : '',
      categoryName == 'Vehicles'
          ? vehicleAttributes.makeModel
          : '',
      categoryName == 'Vehicles' ? vehicleAttributes.mileAge : '',


    ];


    if(widget.fromDynamicLink == true){
        isPageLoading = false;
        setState(() {
        });
    }
  }

  bool isChatBtnLoading = false;
  List<String> wrapListAd = [];


  int? loopLimit;

  @override
  Widget build(BuildContext context) {


    if(isPageLoading == false) {
      loopLimit = (subCategoryName == 'Commercial Space' &&
          (categoryName == 'Property for Sale')) ? 7 :
      categoryName == 'Property for Sale' ? 6 :
      categoryName == 'Property for Rent' ? 5
          : categoryName == 'Vehicles'
          ? 5
          : categoryName == 'Jobs'
          ? 5 :
      categoryName == 'Electronics & Appliance'
          ? 1
          : categoryName == 'Mobiles'
          ? subCategoryName == 'Accessories' ? 2 : 3
          : categoryName == 'Animals' ||
          categoryName == 'Kids'
          ? 1
          : categoryName == 'Fashion & beauty' ||
          categoryName == 'Services' ? 0 :
      categoryName == 'Bikes' ? (subCategoryName ==
          'Bicycles' || subCategoryName == 'Bikes Accessories' ||
          subCategoryName == 'Parts' ? 1 : 2)
          : 2;




      isProperty = categoryName == 'Property for Sale'
          || categoryName == 'Property for Rent';
      wrapListAd = wrapList;


      if (categoryName == 'Property for Sale' ||
          categoryName == 'Property for Rent' ||
          categoryName == 'Services' ||
          categoryName == 'Fashion') {
        wrapList.remove('Condition');
        wrapList1.remove('Condition');
      }


      if (categoryName == 'Bikes' &&
          (subCategoryName == 'Bicycles' ||
              subCategoryName == 'Bikes Accessories' ||
              subCategoryName == 'Parts')) {
        if (wrapList.contains("Engine Capacity")) {
          wrapList1.remove('-');
          wrapList.remove("Engine Capacity");
        }
      }

      if (categoryName == 'Mobiles' &&
          (subCategoryName == 'Accessories' ||
              subCategoryName == 'Smart Watches')) {
        if (wrapList.contains("Storage Capacity")) {
          wrapList1.remove('-');
          wrapList.remove("Storage Capacity");
        }
      }

      if (categoryName == 'Vehicles' &&
          (subCategoryName == 'Car Accessories' ||
              subCategoryName == 'Parts')) {
        if (wrapList.contains("Fuel Type")) {
          wrapList1.remove('-');
          wrapList.remove("Fuel Type");
        }
        if (wrapList.contains("Kilometers")) {
          wrapList1.remove('-');
          wrapList.remove("Kilometers");
        }
      }
    }




    return PopScope(
        canPop: widget.popToBottomNav == true ? false : true,
        onPopInvoked: (didPop) {
          final apiProvider =
              Provider.of<ProductsApiProvider>(context, listen: false);
          apiProvider.getFeatureProducts(
            dio: dio,
            context: context,
          );
          if(widget.popToBottomNav == true) {
            pushUntil(context, const BottomNavView());
          }
        },
        child:
            Scaffold(backgroundColor: AppTheme.whiteColor, body: bodyColumn()));
  }


  Widget bodyColumn() {
    return SizedBox(
      child:
        isPageLoading==true ?
          const Center(child: CircularProgressIndicator()) :
        SizedBox(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImage(
                        product: product,
                        popToBottomNav: widget.popToBottomNav,
                        userId: userId,
                        categoryName: categoryName,
                        subCategoryName: subCategoryName,
                        authorizationToken: authorizationToken,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children : [

                                    ProductDetailsWidget(product: product),

                                    const AddDivider(),

                                    ProductAttributesWidget(wrapListAd: wrapListAd, wrapList1: wrapList1, subCategoryName: subCategoryName,
                                      userRating: userRating, isProperty: isProperty, loopLimit: loopLimit, propertyOwner: propertyAttributes.owner, hireStatus: jobAttributes.hireStatus,),

                                    const AddDivider(),

                                    SellerDetailWidget(authorizationToken: authorizationToken, product: product, userRating: userRating,),


                                    const AddDivider(),

                                    DescriptionWidget(product : product),

                                    const AddDivider(),

                                    ActionButtons(authorizationToken: authorizationToken, product: product, isFav : isFav, userId: userId),

                                    if(userId.toString() != product?.userId.toString())
                                      const AddDivider(),

                                    Visibility(
                                        visible : userId.toString() != product?.userId.toString(),
                                        child: FeatureProductInteractiveButtons(authorizationToken: authorizationToken, product: product, categoryName: categoryName, isFav : isFav, userId: userId,)
                                    ),

                                    if(categoryName == 'Property for Rent' || categoryName == 'Property for Sale')
                                      const AddDivider(),


                                  ]),
                            ),
                          ),

                          const SizedBox(height: 12,),

                          if(categoryName == 'Property for Rent' || categoryName == 'Property for Sale' )
                            const DubaiPropertyRules()

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }


  Future<void> getProductDetail({bool dynamicLink = false}) async {
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
      "id": dynamicLink==true ? widget.productId! : product?.id,
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            isLoading = false;
            if(dynamicLink==true){
              isPageLoading = false;
            }
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          isLoading = false;
          if(dynamicLink==true){
            isPageLoading = false;
          }
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          isLoading = false;
          if(dynamicLink==true){
            isPageLoading = false;
          }
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          isLoading = false;
          if(dynamicLink==true){
            isPageLoading = false;
          }
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          isLoading = false;
          if(dynamicLink==true){
            isPageLoading = false;
          }
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          isLoading = false;

          // widget.detailResponse = responseData["data"][0];
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
        isPageLoading = false;
      });
    }
  }


  void markProductView() {
    Map body = {"product_id": product?.id?.toString() ?? ''};
    customPostRequest.httpPostRequest(
        url: AppUrls.increaseProductCount, body: body);
  }


}
