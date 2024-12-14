import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/detail_model/attribute_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/views/Products/Feature%20Product/widgets/feature_product_interactive_buttons.dart';
import 'package:tt_offer/views/Products/widgets/product_image.dart';
import 'package:tt_offer/views/Products/widgets/seller_detail_widget.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../../models/product_model.dart';
import '../../../view_model/product/product/product_viewmodel.dart';
import '../../BottomNavigation/navigation_bar.dart';
import '../widgets/action_buttons.dart';
import '../widgets/description_widget.dart';
import '../widgets/divider.dart';
import '../widgets/dubai_property_rules.dart';
import '../widgets/product_atrributes_widget.dart';
import '../widgets/product_details_widget.dart';

class FeatureInfoScreen extends StatefulWidget {
  Product? product;
  String? productId;
  bool fromDynamicLink;
  bool popToBottomNav;

  FeatureInfoScreen({super.key, this.product, this.fromDynamicLink=false, this.popToBottomNav=false, this.productId});

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

  late AppDio dio;
  var userId;
  String? authorizationToken;
  AppLogger logger = AppLogger();


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
  late ElectronicApplianceAttributes electronicApplicanceAttributes;



  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString(PrefKey.userId) != null) {
      userId = int.tryParse(pref.getString(PrefKey.userId)!);
    }
    authorizationToken = pref.getString(PrefKey.authorization);
    setState(() {

    });
  }


  late List<String> attributeKeyList;
  List<String> attributeValueList = [];

  void initializeAttributeKeyList(String categoryName, String subCategoryName, JobAttributes jobAttributes) {
    switch (categoryName) {
      case 'Animals':
        attributeKeyList = [
          'Age',
          'Breed',
        ];
        break;

      case 'Jobs':
        if (jobAttributes.hireStatus == 'Hiring') {
          attributeKeyList = [
            'Company Name',
            'Position Type',
            'Salary Period',
            'Education',
            'Description',
          ];
        } else {
          attributeKeyList = [
            'Linkedin Profile',
            'Preferred Employment Type',
            'Experience Level',
            'Education',
            'Description',
          ];
        }
        break;

      case 'Fashion & beauty':
      case 'Services':
      case 'Kids':
        attributeKeyList = [
          'Description',
        ];
        break;

      case 'Electronics & Appliance':
        attributeKeyList = [
          'Brand',
          'Color',
        ];
        break;

      case 'Furniture & home decor':
        attributeKeyList = [
          'Type',
          'Color',
        ];
        break;

      case 'Mobiles':
        attributeKeyList = [
          'Brand',
          subCategoryName == 'Accessories'
              ? 'Color'
              : 'Storage Capacity',
          if(subCategoryName != 'Accessories')
            'Color'

        ];
        break;

      case 'Vehicles':
        attributeKeyList = [
          'Fuel Type',
          'Color',
          'Kilometers',
          'Make',
          'Year',
        ];
        break;

      case 'Bikes':
        if (subCategoryName == 'Bikes Accessories') {
          attributeKeyList = [
            'Accessories Description',
          ];
        } else {
          attributeKeyList = [
            'Model',
            'Engine Capacity',
          ];
        }
        break;

      case 'Property for Sale':
        attributeKeyList = [
          'Furnished',
          'Area',
          'Bathrooms',
          'Completion',
          subCategoryName == 'Commercial Space' ? 'Zone For' : 'Bedrooms',
          'Year Built',
        ];
        break;

      case 'Property for Rent':
        attributeKeyList = [
          'Furnished',
          'Area',
          'Bathrooms',
          subCategoryName == 'Commercial Space' ? 'Zone For' : 'Bedrooms',
          'Year Built',
        ];
        break;

      default:
        attributeKeyList = [];
    }
  }
  
  @override
  void initState() {

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
        // markProductView();

    }
    else{
      isPageLoading = true;
      await getProductDetail(dynamicLink: true );
      getAttributes();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        getUserId();
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
    electronicApplicanceAttributes = ElectronicApplianceAttributes.fromJson(attributesJson);

    initializeAttributeKeyList(categoryName ?? '' , subCategoryName! ?? '' , jobAttributes);


    if(widget.fromDynamicLink == true){
        isPageLoading = false;
        setState(() {
        });
    }
  }


  int? loopLimit;

  @override
  Widget build(BuildContext context) {

    if(isPageLoading == false) {
      loopLimit = (subCategoryName == 'Commercial Space' &&
          (categoryName == 'Property for Sale')) ? 7 :
      categoryName == 'Property for Sale' ? 6 :
      categoryName == 'Property for Rent' ? 4
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

      Map<String, List<String>> sortedAttributes = {
        'Animals': [
          animalsAttributes.age,
          animalsAttributes.breed,
          '', // Placeholder for any additional attribute
        ],
        'Jobs': [
          jobAttributes.hireStatus == 'Hiring'
              ? jobAttributes.companyName
              : jobAttributes.linkedinProfile,
          jobAttributes.positionType,
          jobAttributes.hireStatus == 'Hiring'
              ? jobAttributes.salaryPeriod
              : jobAttributes.experience,
          jobAttributes.education,
          jobAttributes.description,
        ],
        'Fashion & beauty': [
          furnitureAttributes.description ?? '-',
        ],
        'Services': [
          servicesAttributes.description ?? '-',
        ],
        'Furniture & home decor': [
          furnitureAttributes.type,
          furnitureAttributes.color,
        ],
        'Mobiles': [
          mobileAttributes.brand,
          subCategoryName == 'Accessories'
              ? mobileAttributes.color
              : mobileAttributes.storage,
          mobileAttributes.color,
        ],
        'Vehicles': [
          vehicleAttributes.fuelType,
          vehicleAttributes.color,
          vehicleAttributes.mileAge,
          vehicleAttributes.makeModel,
          vehicleAttributes.year,
        ],
        'Property for Sale': [
          propertyAttributes.furnished,
          propertyAttributes.area.isNotEmpty
              ? '${propertyAttributes.area} sqft'
              : '',
          propertyAttributes.bathroom.isNotEmpty
              ? propertyAttributes.bathroom == 'no bathroom'
              ? propertyAttributes.bathroom
              : '${propertyAttributes.bathroom} BA'
              : '',
          propertyAttributes.completion.isNotEmpty ? propertyAttributes.completion : '',
          if(subCategoryName == 'Commercial Space')
            propertyAttributes.zoneFor.isNotEmpty
                ? propertyAttributes.zoneFor
                : ''
          else
            propertyAttributes.bedroom.isNotEmpty
                ? '${propertyAttributes.bedroom} ${propertyAttributes.bedroom != "Studio" ? "BDRM" : ''}'
                : '',
          propertyAttributes.yearBuilt,

          // propertyAttributes.features,
        ],
        'Property for Rent': [
          propertyAttributes.furnished,
          propertyAttributes.area.isNotEmpty
              ? '${propertyAttributes.area} sqft'
              : '',
          propertyAttributes.bathroom.isNotEmpty
              ? propertyAttributes.bathroom == 'no bathroom'
              ? propertyAttributes.bathroom
              : '${propertyAttributes.bathroom} BA'
              : '',
          if(subCategoryName == 'Commercial Space')
            propertyAttributes.zoneFor.isNotEmpty
                ? propertyAttributes.zoneFor
                : ''
          else
            propertyAttributes.bedroom.isNotEmpty
                ? '${propertyAttributes.bedroom} ${propertyAttributes.bedroom != "Studio" ? "BDRM" : ''}'
                : '',
          propertyAttributes.yearBuilt,
        ],
        'Bikes': [
          if (subCategoryName == 'Bikes Accessories')
            bikeAttributes.description ?? '-'
          else
          bikeAttributes.model,
          bikeAttributes.engineCapacity,
        ],
        'Kids': [
          kidsAttributes.description ?? '-',
        ],
        'Electronics & Appliance': [
          electronicApplicanceAttributes.brand,
          electronicApplicanceAttributes.color,
        ],
      };

      attributeValueList = sortedAttributes[categoryName] ?? [];


      isProperty = categoryName == 'Property for Sale'
          || categoryName == 'Property for Rent';

      if (categoryName == 'Property for Sale' ||
          categoryName == 'Property for Rent' ||
          categoryName == 'Services' ||
          categoryName == 'Fashion') {
        attributeValueList.remove('Condition');
        attributeKeyList.remove('Condition');
      }

      if (categoryName == 'Bikes' &&
          (subCategoryName == 'Bicycles' ||
              subCategoryName == 'Bikes Accessories' ||
              subCategoryName == 'Parts')) {
        if (attributeKeyList.contains("Engine Capacity")) {
          attributeValueList.remove('-');
          attributeKeyList.remove("Engine Capacity");
        }
      }

      if (categoryName == 'Mobiles' &&
          (subCategoryName == 'Accessories' ||
              subCategoryName == 'Smart Watches')) {
        if (attributeKeyList.contains("Storage Capacity")) {
          attributeValueList.remove('-');
          attributeKeyList.remove("Storage Capacity");
        }
      }

      if (categoryName == 'Vehicles' &&
          (subCategoryName == 'Car Accessories' ||
              subCategoryName == 'Parts')) {
        if (attributeKeyList.contains("Fuel Type")) {
          attributeValueList.remove('-');
          attributeKeyList.remove("Fuel Type");
        }
        if (attributeKeyList.contains("Kilometers")) {
          attributeValueList.remove('-');
          attributeKeyList.remove("Kilometers");
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

                                    ProductAttributesWidget(attributeValueList: attributeValueList, attributeKeyList: attributeKeyList, subCategoryName: subCategoryName,
                                      userRating: userRating, isProperty: isProperty, loopLimit: attributeKeyList.length-1, propertyOwner: propertyAttributes.owner, hireStatus: jobAttributes.hireStatus,),

                                    const AddDivider(),

                                    SellerDetailWidget(authorizationToken: authorizationToken, product: product,),


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

    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);

    setState(() {
      isPageLoading = true;
    });

    product = await productViewModel.getProductDetails(product != null ? product?.id : int.parse(widget.productId ?? ''));
    categoryName = product?.category?.name;
    subCategoryName = product?.subCategory?.name;

    setState(() {
      isPageLoading = false;
    });

  }

  void markProductView() {
    Map body = {"product_id": product?.id?.toString() ?? ''};
    customPostRequest.httpPostRequest(
        url: AppUrls.increaseProductCount, body: body);
  }


}
