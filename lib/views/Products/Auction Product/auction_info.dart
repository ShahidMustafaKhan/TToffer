import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_logout_pop_up.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/detail_model/attribute_model.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/view_model/bids/bids_view_model.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Products/Auction%20Product/widgets/panel_widget.dart';

import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/views/Products/widgets/product_reviews.dart';

import '../../../models/product_model.dart';
import '../../Authentication screens/login_screen.dart';
import '../../BottomNavigation/navigation_bar.dart';

import '../widgets/action_buttons.dart';
import '../widgets/description_widget.dart';
import '../widgets/divider.dart';
import '../widgets/dubai_property_rules.dart';
import '../widgets/features.dart';
import '../widgets/product_atrributes_widget.dart';
import '../widgets/product_details_widget.dart';
import '../widgets/product_image.dart';
import '../widgets/seller_detail_widget.dart';

class AuctionInfoScreen extends StatefulWidget {
  Product? product;
  String? productId;
  bool fromDynamicLink;
  bool popToBottomNav;

  AuctionInfoScreen({super.key, this.product, this.fromDynamicLink=false,this.popToBottomNav=false, this.productId});

  @override
  State<AuctionInfoScreen> createState() => _AuctionInfoScreenState();
}

class _AuctionInfoScreenState extends State<AuctionInfoScreen> {
  final GlobalKey<_AuctionInfoScreenState> _panelKey =
      GlobalKey<_AuctionInfoScreenState>();
  bool isLoading = false;
  bool isPageLoading = false;
  bool isFav = false;
  final panelController = PanelController();
  bool isProperty=false;
  double? userRating;
  String? authorizationToken;
  Product? product;
  String? categoryName;
  String? subCategoryName;

  late Timer _timer;

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  static List<String> bidList = [
    "20",
    "40",
    "60",
    "80",
    "use custom bid",
  ];

  late AppDio dio;
  AppLogger logger = AppLogger();
  int? userId;
  var productId;
  int highestPrice = 0;
  @override
  void didUpdateWidget(covariant AuctionInfoScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    getBidsHandler();
  }

  List<String> generateBidList(int highestBid) {
    const int increment = 200; // This is the step increment between bids

    if (highestBid == 0) {
      // If the highest bid is 0, return the default values
      return ["20", "40", "60", "80", "100", "use custom bid"];
    } else {
      // Generate the bid list based on the highest bid
      List<String> bidList = [];
      for (int i = 1; i <= 5; i++) {
        bidList.add((highestBid + increment * i).toString());
      }
      bidList.add("use custom bid");
      return bidList;
    }
  }

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
    // final String AttributesJson = widget.detailResponse;
    product = widget.product;

    dio = AppDio(context);
    logger.init();

    categoryName = product?.category?.name;
    subCategoryName = product?.subCategory?.name;

    getProductData();





    super.initState();
  }


  Future<void> getProductData() async {
    if(widget.product!= null){
      getAttributes();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        getUserId();
        getBidsHandler();
        startTimer();
        // markProductView();
      });

    }
    else{
      isPageLoading = true;
      await getProductDetail(dynamicLink: true );
      getAttributes();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        getUserId();
        getBidsHandler();
        startTimer();
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
    electronicApplicanceAttributes =
        ElectronicApplianceAttributes.fromJson(attributesJson);


    initializeAttributeKeyList(categoryName! , subCategoryName! , jobAttributes);

     // if(authorizationToken!=null && widget.detailResponse["wishlist"]!=null){
     // isFav = widget.detailResponse["wishlist"].isNotEmpty
     //    ? true
     //    : false;}

    if(widget.fromDynamicLink==true){
      isPageLoading = false;
      setState(() {

      });
    }

  }

  @override
  void dispose() {
    _pageController.dispose();
    _priceController.dispose();
    _timer.cancel();

    super.dispose();
  }


  void startTimer() {

    Duration interval = Duration(seconds: 10);

   _timer =  Timer.periodic(interval, (Timer timer) {
      // Code to execute at each interval
      getBidsHandler();
    });


  }


  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = int.tryParse(pref.getString(PrefKey.userId)!);
    authorizationToken = pref.getString(PrefKey.authorization);
    setState(() {

    });
  }

  final TextEditingController _priceController = TextEditingController();

  List<BidsData> bids = [];

  bool loading = false;

  getBidsHandler() async {
    if(product?.id != null) {
      final bidViewModel = Provider.of<BidsViewModel>(context, listen: false);
      await bidViewModel.getBids(product!.id!);

      if(bidViewModel.bidsList.status == Status.completed){

        bids = bidViewModel.bidsList.data?.data ?? [];
        setState(() {
        });
      }
    }
  }

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
        attributeKeyList.remove('Condition');
        attributeValueList.remove('Condition');
      }


      // if (categoryName == 'Property for Rent') {
      //   for (int i = 0; i < attributeKeyList.length; i++) {
      //     if (attributeKeyList[i].isEmpty) {
      //       attributeValueList.removeAt(i);
      //       attributeKeyList.removeAt(i);
      //     }
      //   }
      // }

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


      for (var bid in bids) {
        int price = bid.price!;
        if (price > highestPrice) {
          highestPrice = price;
        }
      }

      for (int i = 0; i < attributeValueList.length; i++) {
        if (attributeValueList[i] == null || attributeValueList[i].isEmpty) {
          attributeValueList[i] = '-';
        }
      }
    }



    return PopScope(
      canPop: widget.popToBottomNav==true ? false : true,
      onPopInvoked: (didPop) {
        if(widget.popToBottomNav == true) {
          pushUntil(context, const BottomNavView());
        }
      },
      child: Scaffold(
          backgroundColor: AppTheme.whiteColor,
          body: isPageLoading==true ?
              const Center(child: CircularProgressIndicator()) :
              SlidingUpPanel(
              key: _panelKey,
              controller: panelController,
              isDraggable: false,
              footer: auctionBottomCard(),
              maxHeight: MediaQuery.of(context).size.height - 300,
              minHeight: 250,
              borderRadius: BorderRadius.circular(32),
              body: bodyColumn(),
              panelBuilder: (controller) => PanelWidget(
                    product: widget.product,
                    controller: controller,
                    panelController: panelController,
                    bidsData: bids,
                  ))),
    );
  }

////////////////////////////////////////////////// auction ///////////////////////////////////

  Widget auctionBottomCard() {
    final open = Provider.of<NotifyProvider>(context);

    // return SizedBox();

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      elevation: 10,
      shadowColor: Colors.grey,
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: bidList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      String bid;
                      List newBidList;
                      if(index<4 && highestPrice != 0){
                        newBidList = calculatePercentIncrements(highestPrice);
                        bid = (newBidList[index]).toString();
                      }
                      else{
                        newBidList = calculatePercentIncrements(product?.auctionInitialPrice);
                        bid = (newBidList[index]).toString();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            log("clicked");
                            open.index(index: index);
                            if (index < bidList.length - 1) {
                              open.bidPrices(price: bid);
                              _priceController.text = bid;
                            } else {
                              _priceController.clear();
                              open.makeField();
                            }
                          },
                          child: Container(
                            height: 26,
                            decoration: BoxDecoration(
                                color: open.indexbid == index
                                    ? const Color(0xff14181B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1, color: const Color(0xffBDBDBD))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: AppText.appText(index==bidList.length-1 ? 'use custom bid' : 'AED ${formatNumber(bid)}',
                                  textColor: open.indexbid == index
                                      ? AppTheme.whiteColor
                                      : const Color(0xff001B2E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    open.field == true
                        ? CustomAppFormField(
                            texthint: "Custom Bid",
                            hintStyle: TextStyle(
                              fontSize: 16.7.sp,
                              fontWeight: FontWeight.w500
                            ),
                            onChanged: (value){_priceController.text=formatNumber(value, textFiled: true);},
                            controller: _priceController,
                            width: 161,
                            textAlign: TextAlign.center,
                            fontsize: 24,
                            fontweight: FontWeight.w600,
                            cPadding: 2.0,
                            type: TextInputType.number,
                          )
                        : AppButton.appButton(
                            "Place Bid for AED ${formatNumber(open.bidPrice)}",
                            onTap: () async {

                              if(authorizationToken!=null){
                              if(userId != widget.product?.userId) {
                                if((double.parse(widget.product?.auctionInitialPrice?.toString() ?? '')) < double.parse(open.bidPrice.replaceAll(',', '')) ) {
                                  if (isPriceLessThanOrEqualToExistingBids(
                                      double.parse(
                                          open.bidPrice.replaceAll(',', ''))) ==
                                      false) {
                                    await placeBidDialog(
                                        context,
                                        _priceController.text,
                                        product?.id,
                                        userId,
                                        product?.id,);
                                    // sendNotifications();
                                    // getProductDetail();
                                    getBidsHandler();
                                    _priceController.text = '';
                                    open.bidPrice = '';
                                    open.field = true;
                                    open.indexbid = 4;
                                  }
                                  else {
                                    showSnackBar(context,
                                        'This bid amount is already taken; please submit a higher bid.');
                                  }
                                }
                                else{
                                  showSnackBar(context,
                                      'The bid amount must be higher than “Current bid Price”.');
                                }
                              }
                              else {
                                showSnackBar(context, 'You can\'t place a bid on your own product.');
                              }

                              }
                              else {
                                push(context, const SigInScreen());

                              }
                          },
                            height: 53,
                            width: 200,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            radius: 32.0,
                            backgroundColor: AppTheme.appColor,
                            textColor: AppTheme.whiteColor),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // log("open.field = ${open.field}");
                            if (open.field == false) {
                              open.sheetTrue();
                              panelController.open();
                            } else {
                              if(_priceController.text.isNotEmpty) {
                                  open.bidPrices(price: _priceController.text);
                              }
                              else{
                                showSnackBar(context, 'Please enter amount', title: 'Input Required');
                              }
                            }
                            //  else {
                            //   open.field = false;
                            // }
                          },
                          child: Container(
                            height: 53,
                            width: 53,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1, color: const Color(0xffBDBDBD))),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(open.field == true
                                  ? "assets/images/correct.png"
                                  : "assets/images/arrowUp.png"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _priceController.clear();
                            if (open.field == false) {
                              open.sheetFalse();
                              panelController.close();
                            }
                          },
                          child: Container(
                            height: 53,
                            width: 53,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1, color: const Color(0xffBDBDBD))),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(open.field == true
                                  ? "assets/images/cancel.png"
                                  : "assets/images/arrowDown.png"),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isPriceLessThanOrEqualToExistingBids(double givenPrice) {
    for (var bid in bids) {
      if (givenPrice <= double.parse(bid.price.toString() ?? '0')) {
        return true;
      }
    }
    return false;
  }

  bool isTwentyPercentAboveHighestBid(int? value, int? highestBid) {

    value ??= 0;
    highestBid ??= 0;

    // Calculate 20% of the highest bid
    int threshold = (highestBid * 20 ~/ 100) + highestBid;

    // Check if the value is greater than or equal to the threshold
    return value >= threshold;
  }


  List<int> calculatePercentIncrements(int? value) {

    if(value == null){
      return [];
    }

    // Define the percentage increments as a list
    final percentages = [20, 40, 60, 80, 100];

    // Map each percentage to its incremented value and return the result as a list
    return percentages.map((percentage) => value + (value * percentage ~/ 100)).toList();
  }


  Widget bodyColumn() {
    return SizedBox(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            children: [
              // Product Image Section
              ProductImage(
                product: product,
                popToBottomNav: widget.popToBottomNav,
                userId: userId,
                categoryName: categoryName,
                subCategoryName: subCategoryName,
                authorizationToken: authorizationToken,
              ),

              // Product Details and Related Widgets
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductDetailsWidget(product: product),
                        const AddDivider(),
                        ProductAttributesWidget(
                          attributeKeyList: attributeKeyList,
                          attributeValueList: attributeValueList,
                          subCategoryName: subCategoryName,
                          userRating: userRating,
                          isProperty: isProperty,
                          loopLimit: attributeKeyList.length-1,
                          propertyOwner: propertyAttributes.owner,
                          hireStatus: jobAttributes.hireStatus,
                        ),
                        FeatureWidget(product: product, propertyAttributes: propertyAttributes, ),
                        const AddDivider(),
                        SellerDetailWidget(
                          authorizationToken: authorizationToken,
                          product: product,
                        ),
                        const AddDivider(),
                        DescriptionWidget(product: product),
                        const AddDivider(),
                        ActionButtons(
                          authorizationToken: authorizationToken,
                          product: product,
                          isFav: isFav,
                          userId: userId,
                        ),

                      ],
                    ),
                  ),



                  // Dubai Property Rules Section
                  if (categoryName == 'Property for Rent' || categoryName == 'Property for Sale')...[
                    const AddDivider(),
                    const SizedBox(height: 12),
                    const DubaiPropertyRules(),

                  ],

                  ProductReviewsSection(product: product,),

                  // Add Bottom Spacing
                  SizedBox(height: 270.h),
                ],
              ),
            ],
          ),
        ),
      ),
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










}
