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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/send_notification_service.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_logout_pop_up.dart';
import 'package:tt_offer/custom_requests/bids_service.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/providers/bids_provider.dart';
import 'package:tt_offer/views/Products/widgets/full_image_page.dart';
import 'package:tt_offer/views/Products/Auction%20Product/widgets/panel_widget.dart';
import 'package:tt_offer/views/Seller%20Profile/seller_profile.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Controller/APIs Manager/profile_apis.dart';
import '../../../custom_requests/dynmaic_link_service.dart';
import '../../../main.dart';
import '../../../models/product_model.dart';
import '../Feature Product/feature_container.dart';
import '../../Authentication screens/login_screen.dart';
import '../../BottomNavigation/navigation_bar.dart';
import '../../ChatScreens/offer_chat_screen.dart';
import '../../Profile Screen/profile_screen.dart';
import '../widgets/action_buttons.dart';
import '../widgets/description_widget.dart';
import '../widgets/divider.dart';
import '../widgets/dubai_property_rules.dart';
import '../widgets/product_atrributes_widget.dart';
import '../widgets/product_details_widget.dart';
import '../widgets/product_image.dart';
import '../widgets/seller_detail_widget.dart';

class AuctionInfoScreen extends StatefulWidget {
  var detailResponse;
  Product? product;
  String? productId;
  bool fromDynamicLink;
  bool popToBottomNav;

  AuctionInfoScreen({super.key, this.detailResponse, this.product, this.fromDynamicLink=false,this.popToBottomNav=false, this.productId});

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

  static List wrapList1 = [];
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
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
  late ElectronicApplicanceAttributes electronicApplicanceAttributes;

  @override
  void initState() {
    // final String AttributesJson = widget.detailResponse;

    dio = AppDio(context);
    logger.init();

    getProductData();

    product = widget.product;
    categoryName = product?.category?.name;
    subCategoryName = product?.subCategory?.name;



    super.initState();
  }

  setUserRating() async {
    userRating = await getUserRating(widget.product!.userId!.toString());
    setState(() {

    });
  }

  Future<void> getProductData() async {
    if(widget.product!= null){
      getAttributes();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        getUserId();
        getBidsHandler();
        startTimer();
        setUserRating();
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
    electronicApplicanceAttributes =
        ElectronicApplicanceAttributes.fromJson(attributesJson);


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
    userId = pref.getString(PrefKey.userId);
    authorizationToken = pref.getString(PrefKey.authorization);
    setState(() {

    });
  }

  final TextEditingController _priceController = TextEditingController();

  List<BidsData> bids = [];

  bool loading = false;

  getBidsHandler() async {
    setState(() {
      loading = true;
    });
    await BidsService().getBidsService(
        context: context, productId: int.parse(widget.productId.toString()));

    bids = Provider.of<BidsProvider>(context, listen: false).bids;

    setState(() {});

    setState(() {
      loading = false;
    });

    setState(() {});
  }


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

      List<String> wrapList = [
        categoryName == 'Animals'
            ? 'Age'
            : categoryName == 'Jobs'
            ? jobAttributes.hireStatus == 'Hiring'
            ? 'Company Name'
            : 'Linkedin Profile'
            : categoryName == 'Fashion & beauty' ||
            categoryName == 'Services'
            ? 'description'
            : 'Condition',
        categoryName == 'Electronics & Appliance'
            ? 'Brand'
            : categoryName == 'Furniture & home decor'
            ? "Type"
            : categoryName == 'Animals'
            ? 'Breed'
            : categoryName == 'Mobiles'
            ? 'Brand'
            : categoryName == 'Vehicles'
            ? 'Fuel Type'
            : categoryName ==
            'Property for Sale' ||
            categoryName ==
                'Property for Rent'
            ? 'Furnished'
            : categoryName == 'Jobs'
            ? jobAttributes.hireStatus == 'Hiring'
            ? 'Position Type'
            : 'Preferred Employment Type'
            : categoryName == 'Bikes'
            ? 'Model'
            : categoryName== 'Kids'
            ? 'description'
            : '',
        categoryName == 'Electronics & Appliance'
            ? 'Color'
            : categoryName == 'Furniture & home decor'
            ? "Color"
            : categoryName == 'Mobiles'
            ? 'Storage Capacity'
            : categoryName == 'Vehicles'
            ? 'Color'
            : categoryName == 'Property for Sale' ||
            categoryName ==
                'Property for Rent'
            ? 'Area'
            : categoryName == 'Jobs'
            ? 'Job Type'
            : categoryName == 'Bikes'
            ? subCategoryName == 'Bikes Accessories'
            ? 'Accessories description'
            : 'Engine Capacity'
            : '',
        categoryName == 'Mobiles'
            ? "Color" :
        categoryName == 'Vehicles' ? 'Kilometers'
            : categoryName == 'Property for Sale' ||
            categoryName == 'Property for Rent'
            ? 'Bathrooms'
            : categoryName == 'Jobs'
            ? jobAttributes.hireStatus == 'Hiring'
            ? 'Salary Period'
            : 'Experience Level'
            : '',
        categoryName == 'Property for Sale' &&
            categoryName != 'Property for Rent'
            ? 'Completion' :
        categoryName != 'Property for Sale' &&
            categoryName == 'Property for Rent'
            ? 'YearBuilt' :
        categoryName == 'Vehicles' ? 'Make'
            : categoryName == 'Jobs'
            ? 'Education'
            : '',
        categoryName == 'Property for Sale' ||
            categoryName == 'Property for Rent'
            ? subCategoryName == 'Commercial Space'
            ? 'Zone For'
            : 'Bedrooms'
            : categoryName == 'Vehicles' ? 'Year'
            : categoryName == 'Jobs'
            ? 'Description' : '',
        categoryName == 'Property for Sale'
            ? 'YearBuilt' :
        categoryName == 'Property for Rent' ? 'Features'
            : '',
        categoryName == 'Property for Sale'
            ? 'Features' :
        ''

      ];
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


      // if (categoryName == 'Property for Rent') {
      //   for (int i = 0; i < wrapList.length; i++) {
      //     if (wrapList[i].isEmpty) {
      //       wrapList1.removeAt(i);
      //       wrapList.removeAt(i);
      //     }
      //   }
      // }

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


      for (var bid in bids) {
        int price = bid.price!;
        if (price > highestPrice) {
          highestPrice = price;
        }
      }

      for (int i = 0; i < wrapList1.length; i++) {
        if (wrapList1[i] == null || wrapList1[i].isEmpty) {
          wrapList1[i] = '-';
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
                    data: widget.product,
                    controller: controller,
                    panelController: panelController,
                    bidsData: bids,
                  ))),
    );
  }

////////////////////////////////////////////////// auction ///////////////////////////////////

  Widget auctionBottomCard() {
    final open = Provider.of<NotifyProvider>(context);

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
                padding: const EdgeInsets.only(left: 10.0),
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
                        newBidList = calculateBidList(highestPrice, [20,40,60,80,100]);
                        bid = (newBidList[index]).toString();
                      }
                      else{
                        newBidList = calculateBidList(widget.product!.auctionInitialPrice!, [20,40,60,80,100]);
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              if(userId.toString() != widget.product?.userId.toString()) {
                                if((double.parse(widget.product?.auctionInitialPrice?.toString() ?? '')) < double.parse(open.bidPrice.replaceAll(',', '')) ) {
                                  if (isPriceLessThanOrEqualToExistingBids(
                                      double.parse(
                                          open.bidPrice.replaceAll(',', ''))) ==
                                      false) {
                                    await showLogOutALert(
                                        context,
                                        _priceController.text ?? bidList[0],
                                        productId,
                                        userId,
                                        widget.productId,
                                        widget.product?.userId);
                                    sendNotifications();
                                    getProductDetail();
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
                              // open.makeField();
                              // _panelKey.currentState!.re;
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


  List<int> calculateBidList(int highestBid, List<int> baseValues) {

    // Calculate the new bid values
    List<int> newBidList = [];
    for (int value in baseValues) {
      int newBid = highestBid + value;
      newBidList.add(newBid);
    }

    return newBidList;
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
                          wrapListAd: wrapListAd,
                          wrapList1: wrapList1,
                          subCategoryName: subCategoryName,
                          userRating: userRating,
                          isProperty: isProperty,
                          loopLimit: loopLimit,
                          propertyOwner: propertyAttributes.owner,
                          hireStatus: jobAttributes.hireStatus,
                        ),
                        const AddDivider(),
                        SellerDetailWidget(
                          authorizationToken: authorizationToken,
                          product: product,
                          userRating: userRating,
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
                        if (userId.toString() != widget.product?.userId.toString() ||
                            propertyAttributes.catName == 'Property for Rent' ||
                            propertyAttributes.catName == 'Property for Sale')
                          const AddDivider(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dubai Property Rules Section
                  if (categoryName == 'Property for Rent' || categoryName == 'Property for Sale')
                    const DubaiPropertyRules(),

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
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
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

          widget.product = responseData["data"][0];
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

  void sendNotifications() {
    Set<String> notifiedUsers = {}; // Create a set to store user IDs

    for (var bid in bids) {
      String userId = bid.userId!.toString();

      // Check if the user hasn't been notified yet and is not the current user
      if (!notifiedUsers.contains(userId) && userId != Provider.of<ProfileApiProvider>(context, listen: false).profileData['id'].toString()) {

        // Send notification
        SendNotification.sendNotification(
          context: context,
          userId: int.parse(userId),
          sellerId: userId,
          buyerId: pref.getString(PrefKey.userId)!,
          text: "Make a higher bid to claim this product!",
          type: "${capitalizeWords(Provider.of<ProfileApiProvider>(context, listen: false).profileData['name'])} made a higher bid",
          typeId: bid.productId!.toString(),
          status: "unread",
        );

        // Add the user to the set after sending the notification
        notifiedUsers.add(userId);
      }
    }
  }








}
