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
import 'package:tt_offer/views/Auction%20Info/full_image_page.dart';
import 'package:tt_offer/views/Auction%20Info/panel_widget.dart';
import 'package:tt_offer/views/Seller%20Profile/seller_profile.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/APIs Manager/profile_apis.dart';
import '../../custom_requests/dynmaic_link_service.dart';
import '../../main.dart';
import '../All Featured Products/feature_container.dart';
import '../Authentication screens/login_screen.dart';
import '../BottomNavigation/navigation_bar.dart';
import '../ChatScreens/offer_chat_screen.dart';
import '../Profile Screen/profile_screen.dart';

class AuctionInfoScreen extends StatefulWidget {
  var detailResponse;
  String? productId;
  bool fromDynamicLink;
  bool popToBottomNav;

  AuctionInfoScreen({super.key, this.detailResponse,this.fromDynamicLink=false,this.popToBottomNav=false, this.productId});

  @override
  State<AuctionInfoScreen> createState() => _AuctionInfoScreenState();
}

class _AuctionInfoScreenState extends State<AuctionInfoScreen> {
  final GlobalKey<_AuctionInfoScreenState> _panelKey =
      GlobalKey<_AuctionInfoScreenState>();
  bool isLoading = false;
  bool isPageLoading = false;
  bool isFav = false;
  int _currentPage = 0;
  final panelController = PanelController();
  bool isProperty=false;
  double? userRating;
  String? authorizationToken;


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

    // log("widget.detailResponse = ${widget.detailResponse}");

    log("productId = $productId");

    super.initState();
  }

  setUserRating() async {
    userRating = await getUserRating(widget.detailResponse['user_id'].toString());
    setState(() {

    });
  }

  Future<void> getProductData() async {
    if(widget.detailResponse!= null){
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
    final AttributesJson = widget.detailResponse["attributes"];
    productId = widget.detailResponse["id"];

    fashionAttributes = FashionAttributes.fromJson(AttributesJson);
    mobileAttributes = MobileAttributes.fromJson(AttributesJson);
    vehicleAttributes = VehicleAttributes.fromJson(AttributesJson);
    propertyAttributes = PropertyAttributes.fromJson(AttributesJson);
    jobAttributes = JobAttributes.fromJson(AttributesJson);
    bikeAttributes = BikeAttributes.fromJson(AttributesJson);
    servicesAttributes = ServicesAttributes.fromJson(AttributesJson);
    kidsAttributes = KidsAttributes.fromJson(AttributesJson);
    animalsAttributes = AnimalsAttributes.fromJson(AttributesJson);
    furnitureAttributes = FurnitureAttributes.fromJson(AttributesJson);
    electronicApplicanceAttributes =
        ElectronicApplicanceAttributes.fromJson(AttributesJson);


    wrapList1 = [
      '${animalsAttributes.catName == 'Animals'  ? animalsAttributes.age : jobAttributes.catName == 'Jobs' ?
      jobAttributes.hireStatus == 'Hiring' ?  jobAttributes.companyName : jobAttributes.linkedinProfile  : animalsAttributes.catName == 'Fashion & beauty' ? furnitureAttributes.description : animalsAttributes.catName == 'Services' ? servicesAttributes.description : widget.detailResponse["condition"] ?? 'NA' }',
      (furnitureAttributes.catName == 'Furniture & home decor'
          ? furnitureAttributes.type
          :  fashionAttributes.catName == 'Mobiles'
          ? mobileAttributes.brand
          : vehicleAttributes.catName == 'Vehicles'
          ? vehicleAttributes.FuelType
          : propertyAttributes.catName == 'Property for Sale' ||
          propertyAttributes.catName == 'Property for Rent'
          ? propertyAttributes.furnished
          : jobAttributes.catName == 'Jobs'
          ? jobAttributes.possitionType
          : bikeAttributes.catName == 'Bikes'
          ? bikeAttributes.model
          : kidsAttributes.catName == 'Kids'
          ? kidsAttributes.description
          : electronicApplicanceAttributes
          .catName ==
          'Electronics & Appliance'
          ? electronicApplicanceAttributes.brand
          : animalsAttributes.catName == 'Animals'
          ? animalsAttributes.breed
          :''),

      (electronicApplicanceAttributes.catName == 'Electronics & Appliance'
          ? electronicApplicanceAttributes.color
          : furnitureAttributes.catName == 'Furniture & home decor'
          ? furnitureAttributes.color
          :   fashionAttributes.catName == 'Mobiles'
          ? mobileAttributes.subCatName == 'Accessories' ? mobileAttributes.color : mobileAttributes.storage
          : vehicleAttributes.catName == 'Vehicles'
          ? vehicleAttributes.color
          : propertyAttributes.catName ==
          'Property for Sale' ||
          propertyAttributes.catName ==
              'Property for Rent'
          ? propertyAttributes.area.isNotEmpty ? '${propertyAttributes.area} sqft' : ''
          : jobAttributes.catName == 'Jobs'
          ? jobAttributes.type
          : bikeAttributes.catName == 'Bikes'
          ? (bikeAttributes.subCategoryName == 'Bikes Accessories' ? bikeAttributes.description : bikeAttributes.engineCapacity)
          : ''),
      (fashionAttributes.catName == 'Mobiles'
          ? mobileAttributes.color
          : propertyAttributes.catName == 'Property for Sale' ||
          propertyAttributes.catName == 'Property for Rent'
          ? propertyAttributes.bathroom.isNotEmpty ? propertyAttributes.bathroom == 'no bathroom' ? propertyAttributes.bathroom : '${propertyAttributes.bathroom} BA' : ''
          : jobAttributes.catName == 'Jobs'
          ? jobAttributes.hireStatus == 'Hiring' ? jobAttributes.salaryPeriod : jobAttributes.experience:
      vehicleAttributes.catName == 'Vehicles'
          ? vehicleAttributes.mileAge
          : ''),
      (propertyAttributes.catName == 'Property for Sale' &&
          propertyAttributes.catName != 'Property for Rent'
          ? propertyAttributes.completion
          : propertyAttributes.catName != 'Property for Sale' &&
          propertyAttributes.catName == 'Property for Rent'
          ? propertyAttributes.yearBuilt
          : jobAttributes.catName == 'Jobs'
          ? jobAttributes.education
          : vehicleAttributes.catName == 'Vehicles'
          ? vehicleAttributes.makeModel
          : ''),
      propertyAttributes.catName == 'Property for Sale' ||
          propertyAttributes.catName == 'Property for Rent'
          ?  propertyAttributes.subCatName == 'Commercial Space' ?
      propertyAttributes.zoneFor :
      propertyAttributes.bedroom.isNotEmpty ? '${propertyAttributes.bedroom} ${propertyAttributes.bedroom!= "Studio" ? "BDRM" : ''}' : ''
          : vehicleAttributes.catName == 'Vehicles'
          ? vehicleAttributes.year
          : jobAttributes.catName == 'Jobs'
          ? jobAttributes.description : '',
      propertyAttributes.catName == 'Property for Sale'
          ? propertyAttributes.yearBuilt :
    propertyAttributes.catName == 'Property for Rent' ? propertyAttributes.features
          : '',

      propertyAttributes.catName == 'Property for Sale' ?
           propertyAttributes.features
          :
      vehicleAttributes.catName == 'Vehicles'
          ? vehicleAttributes.makeModel
          :  '',

      vehicleAttributes.catName == 'Vehicles' ? vehicleAttributes.year : '',
      vehicleAttributes.catName == 'Vehicles'
          ? vehicleAttributes.makeModel
          : '',
      vehicleAttributes.catName == 'Vehicles' ? vehicleAttributes.mileAge : '',

      // '${widget.detailResponse["authenticity"] ?? 'NA'}',
      // "2/32",
      // "Original"
    ];

     if(authorizationToken!=null && widget.detailResponse["wishlist"]!=null){
     isFav = widget.detailResponse["wishlist"].isNotEmpty
        ? true
        : false;}

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
        context: context, productId: int.parse(widget.detailResponse['id'].toString()));

    bids = Provider.of<BidsProvider>(context, listen: false).bids;

    setState(() {});

    setState(() {
      loading = false;
    });

    print('getBids--->${bids}');
    setState(() {});
  }

  // PropetyAttributes?propetyAttributes;

  // String?propetyAttributes;

  List<String> wrapListAd = [];

  int? loopLimit;

  @override
  Widget build(BuildContext context) {

    if(isPageLoading == false) {
      loopLimit = (propertyAttributes.subCatName == 'Commercial Space' &&
          (propertyAttributes.catName == 'Property for Sale')) ? 7 :
      propertyAttributes.catName == 'Property for Sale' ? 6 :
          propertyAttributes.catName == 'Property for Rent' ? 5
          : propertyAttributes.catName == 'Vehicles'
          ? 5
          : propertyAttributes.catName == 'Jobs'
          ? 5 :
      propertyAttributes.catName == 'Electronics & Appliance'
          ? 1
          : propertyAttributes.catName == 'Mobiles'
          ? propertyAttributes.subCatName == 'Accessories' ? 2 : 3
          : propertyAttributes.catName == 'Animals' ||
          propertyAttributes.catName == 'Kids'
          ? 1
          : animalsAttributes.catName == 'Fashion & beauty' ||
          animalsAttributes.catName == 'Services' ? 0 :
      mobileAttributes.catName == 'Bikes' ? (mobileAttributes.subCatName ==
          'Bicycles' || mobileAttributes.subCatName == 'Bikes Accessories' ||
          mobileAttributes.subCatName == 'Parts' ? 1 : 2)
          : 2;

      List<String> wrapList = [
        animalsAttributes.catName == 'Animals'
            ? 'Age'
            : jobAttributes.catName == 'Jobs'
            ? jobAttributes.hireStatus == 'Hiring'
            ? 'Company Name'
            : 'Linkedin Profile'
            : animalsAttributes.catName == 'Fashion & beauty' ||
            animalsAttributes.catName == 'Services'
            ? 'description'
            : 'Condition',
        electronicApplicanceAttributes.catName == 'Electronics & Appliance'
            ? 'Brand'
            : furnitureAttributes.catName == 'Furniture & home decor'
            ? "Type"
            : animalsAttributes.catName == 'Animals'
            ? 'Breed'
            : mobileAttributes.catName == 'Mobiles'
            ? 'Brand'
            : vehicleAttributes.catName == 'Vehicles'
            ? 'Fuel Type'
            : propertyAttributes.catName ==
            'Property for Sale' ||
            propertyAttributes.catName ==
                'Property for Rent'
            ? 'Furnished'
            : jobAttributes.catName == 'Jobs'
            ? jobAttributes.hireStatus == 'Hiring'
            ? 'Position Type'
            : 'Preferred Employment Type'
            : bikeAttributes.catName == 'Bikes'
            ? 'Model'
            : kidsAttributes.catName == 'Kids'
            ? 'description'
            : '',
        electronicApplicanceAttributes.catName == 'Electronics & Appliance'
            ? 'Color'
            : furnitureAttributes.catName == 'Furniture & home decor'
            ? "Color"
            : mobileAttributes.catName == 'Mobiles'
            ? 'Storage Capacity'
            : vehicleAttributes.catName == 'Vehicles'
            ? 'Color'
            : propertyAttributes.catName == 'Property for Sale' ||
            propertyAttributes.catName ==
                'Property for Rent'
            ? 'Area'
            : jobAttributes.catName == 'Jobs'
            ? 'Job Type'
            : bikeAttributes.catName == 'Bikes'
            ? mobileAttributes.subCatName == 'Bikes Accessories'
            ? 'Accessories description'
            : 'Engine Capacity'
            : '',
        mobileAttributes.catName == 'Mobiles'
            ? "Color" :
        vehicleAttributes.catName == 'Vehicles' ? 'Kilometers'
            : propertyAttributes.catName == 'Property for Sale' ||
            propertyAttributes.catName == 'Property for Rent'
            ? 'Bathrooms'
            : jobAttributes.catName == 'Jobs'
            ? jobAttributes.hireStatus == 'Hiring'
            ? 'Salary Period'
            : 'Experience Level'
            : '',
        propertyAttributes.catName == 'Property for Sale' &&
            propertyAttributes.catName != 'Property for Rent'
            ? 'Completion' :
        propertyAttributes.catName != 'Property for Sale' &&
            propertyAttributes.catName == 'Property for Rent'
            ? 'YearBuilt' :
        vehicleAttributes.catName == 'Vehicles' ? 'Make'
            : jobAttributes.catName == 'Jobs'
            ? 'Education'
            : '',
        propertyAttributes.catName == 'Property for Sale' ||
            propertyAttributes.catName == 'Property for Rent'
            ? propertyAttributes.subCatName == 'Commercial Space'
            ? 'Zone For'
            : 'Bedrooms'
            : vehicleAttributes.catName == 'Vehicles' ? 'Year'
            : jobAttributes.catName == 'Jobs'
            ? 'Description' : '',
        propertyAttributes.catName == 'Property for Sale'
            ? 'YearBuilt' :
             propertyAttributes.catName == 'Property for Rent' ? 'Features'
            : '',
        propertyAttributes.catName == 'Property for Sale'
            ? 'Features' :
        ''

      ];
      isProperty = propertyAttributes.catName == 'Property for Sale'
          || propertyAttributes.catName == 'Property for Rent';

      wrapListAd = wrapList;


      if (propertyAttributes.catName == 'Property for Sale' ||
          propertyAttributes.catName == 'Property for Rent' ||
          animalsAttributes.catName == 'Services' ||
          animalsAttributes.catName == 'Fashion') {
        wrapList.remove('Condition');
        wrapList1.remove('Condition');
      }


      // if (propertyAttributes.catName == 'Property for Rent') {
      //   for (int i = 0; i < wrapList.length; i++) {
      //     if (wrapList[i].isEmpty) {
      //       wrapList1.removeAt(i);
      //       wrapList.removeAt(i);
      //     }
      //   }
      // }

      if (mobileAttributes.catName == 'Mobiles' &&
          mobileAttributes.subCatName == 'Accessories') {
        if (wrapList.contains("Storage Capacity")) {
          wrapList1.remove('-');
          wrapList.removeAt(2);
        }
      }

      if (mobileAttributes.catName == 'Bikes' &&
          (mobileAttributes.subCatName == 'Bicycles' ||
              mobileAttributes.subCatName == 'Bikes Accessories' ||
              mobileAttributes.subCatName == 'Parts')) {
        if (wrapList.contains("Engine Capacity")) {
          wrapList1.remove('-');
          wrapList.remove("Engine Capacity");
        }
      }

      if (mobileAttributes.catName == 'Electronics & Appliance' &&
          mobileAttributes.subCatName == 'Generators, UPS & Power Solutions') {
        if (wrapList.contains("Color")) {
          wrapList1.remove('-');
          wrapList.removeAt(2);
        }
      }

      if (mobileAttributes.catName == 'Vehicles' &&
          (vehicleAttributes.subCatName == 'Car Accessories' ||
              vehicleAttributes.subCatName == 'Parts')) {
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

    // bidList = generateBidList(highestPrice);


    return PopScope(
      canPop: widget.popToBottomNav==true ? false : true,
      onPopInvoked: (didPop) {
        if(widget.popToBottomNav == true) {
          pushUntil(context, const BottomNavView());
        }
        // final apiProvider =
        //     Provider.of<ProductsApiProvider>(context, listen: false);
        // apiProvider.getAuctionProducts(
        //   dio: dio,
        //   context: context,
        // );
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
                    data: widget.detailResponse,
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
                        newBidList = calculateBidList(int.parse(widget.detailResponse["auction_price"]), [20,40,60,80,100]);
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
                              if(userId.toString() != widget.detailResponse["user_id"]) {
                                if((double.parse(widget.detailResponse["auction_price"])) < double.parse(open.bidPrice.replaceAll(',', '')) ) {
                                  if (isPriceLessThanOrEqualToExistingBids(
                                      double.parse(
                                          open.bidPrice.replaceAll(',', ''))) ==
                                      false) {
                                    await showLogOutALert(
                                        context,
                                        _priceController.text ?? bidList[0],
                                        productId,
                                        userId,
                                        widget.detailResponse['id'],
                                        widget.detailResponse['user_id']);
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


                            if (kDebugMode) {
                              print('id--->${productId}');
                              print('id--->${widget.detailResponse['id']}');
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
    // Determine the number of digits in the highest bid (excluding zeros)
    // int nonZeroDigitCount = highestBid.toString().replaceAll('0', '').length;
    //
    // // Determine the multiplier based on the number of non-zero digits
    // int multiplier = 1;
    // for (int i = 1; i < nonZeroDigitCount; i++) {
    //   multiplier += 20;
    // }

    // Calculate the new bid values
    List<int> newBidList = [];
    for (int value in baseValues) {
      int newBid = highestBid + value;
      newBidList.add(newBid);
    }

    return newBidList;
  }

////////////////////////////////////////////////// custom ///////////////////////////////////
  String getFormattedTimestamp() {
    String timestampStr = "2024-04-06T00:52:00.000000Z";
    DateTime timestamp = DateTime.parse(widget.detailResponse["created_at"]);
    DateTime convertedTime = timestamp.toLocal();
    String location = widget.detailResponse["location"];

// Check if the string ends with a period
    if (!location.endsWith('.')) {
      location += '.';
    }
    String formattedTimestamp =
    DateFormat('yyyy-MM-dd   hh:mm a').format(convertedTime);
    return "$location  Posted on $formattedTimestamp ";
  }

  Widget customColumn() {
    final screenWidth = MediaQuery.of(context).size.width;
    int thirdLength = 0;
    List<String> firstColumn = [];
    List<String> secondColumn = [];
    List<String> thirdColumn = [];
    List<String> stringList = [];


    if(isProperty){
      List featureList = wrapList1[6].split(',').map((item) => item.toString().trim()).toList();

      stringList = featureList.map((item) => item.toString()).toList();


      if (stringList.isNotEmpty) {
        // Calculate third length
        int thirdLength = (stringList.length / 3).ceil();

        // Create columns based on available length
        firstColumn = stringList.sublist(0, thirdLength);

        // Check if there are enough elements for the second column
        if (stringList.length > thirdLength) {
          secondColumn = stringList.sublist(
              thirdLength, (thirdLength * 2).clamp(0, stringList.length));
        }

        // Check if there are enough elements for the third column
        if (stringList.length > thirdLength * 2) {
          thirdColumn = stringList.sublist(thirdLength * 2, stringList.length);
        }
      }
    }
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children : [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 0),
                      child: AppText.appText(
                          "${widget.detailResponse["title"]}",
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          textColor: AppTheme.textColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, bottom: 0),
                      child: AppText.appText(getLocation(),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.textColor),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, bottom: 15),
                      child: AppText.appText("${formatTimestamp(widget.detailResponse["created_at"])}  ·  5 views",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.textColor),
                    ),

                    Container(
                      height: 1,
                      width: screenWidth,
                      decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 17.0, bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          propertyAttributes.catName == 'Property for Rent' || vehicleAttributes.catName == 'Vehicles' ||
                              propertyAttributes.catName == 'Property for Sale' || jobAttributes.catName == 'Jobs'
                              ? Row(
                            children: [
                              Transform.translate(
                                offset: Offset(-6.0, 0), // Adjust this offset as needed to remove the padding
                                child: Transform.scale(
                                  scale: 1.0,
                                  alignment: Alignment.centerLeft,
                                  child: Checkbox(
                                    activeColor: AppTheme.appColor,
                                    value: true,
                                    onChanged: (v) {},
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ),
                              SizedBox(width: 0.w,),
                              AppText.appText(
                                jobAttributes.catName == 'Jobs' ? jobAttributes.hireStatus : 'Sell by ${propertyAttributes.owner}',
                                fontSize: jobAttributes.catName == 'Jobs' ? 15.sp : 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ) : const SizedBox.shrink(),


                          if(propertyAttributes.catName == 'Property for Rent' || vehicleAttributes.catName == 'Vehicles' ||
                              propertyAttributes.catName == 'Property for Sale')
                            const SizedBox(height: 14,),


                          AppText.appText(
                              "Details",
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              textColor: AppTheme.blackColor),
                          SizedBox(height: 2.h,),

                          Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 160.w,
                                  child: AppText.appText(
                                      "Subcategory ",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      textColor: AppTheme.blackColor
                                  ),
                                ),
                                AppText.appText(
                                  vehicleAttributes.subCatName,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppTheme.textColor,
                                ),

                              ],
                            ),
                          ),

                          Column(
                            children: [
                                for (int i = 0; i <= loopLimit!; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 13.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      isProperty && i == 6 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                      children: [
                                          SizedBox(
                                            width: 160.w,
                                            child: AppText.appText(
                                                "${wrapListAd[i]} ",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                textColor: AppTheme.blackColor
                                            ),
                                          ),
                                          AppText.appText(
                                            wrapList1[i] == 'null' || wrapList1[i] == '' ? '-' : wrapList1[i] ?? '-',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            textColor: AppTheme.textColor,
                                          ),

                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 1,
                      width: screenWidth,
                      decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
                    ),

                    userDetailsContainer(),


                    Container(
                      height: 1,
                      width: screenWidth,
                      decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          AppText.appText(
                              "Description",
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              textColor: AppTheme.blackColor),
                          SizedBox(height: 4.h,),

                          AppText.appText(
                              widget.detailResponse["description"],
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              textColor: AppTheme.lighttextColor),


                        ],
                      ),
                    ),

                    Container(
                      height: 1,
                      width: screenWidth,
                      decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppButton.appButton("Save", onTap: () async {
                              if(authorizationToken!=null){
                                widget.detailResponse["wishlist"].isNotEmpty
                                    ? removeFavourite(
                                    wishId:
                                    widget.detailResponse["wishlist"]
                                    [0]["id"])
                                    : addToFavourite();}
                              else{
                                push(context, const SigInScreen());

                              }
                            },
                                height: 35.h,
                                width: MediaQuery.of(context).size.width*0.5,
                                radius: 32.r,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                backgroundColor: Color(0xffdfdde0),
                                borderColor: Colors.transparent,
                                borderWidth: 2,
                                imagePath: isFav ? "assets/svg/ic_heart_dark.svg" : "assets/svg/ic_heart.svg",
                                imageColor: isFav ? null : AppTheme.appColor,
                                textColor: AppTheme.appColor),
                          ),
                          if(userId.toString() != widget.detailResponse["user_id"].toString())
                            SizedBox(width: 10.w,),
                          if(userId.toString() != widget.detailResponse["user_id"].toString())
                            Expanded(
                              child: AppButton.appButton("Report", onTap: () async {
                                reportProduct(
                                    context,
                                    widget.detailResponse['id'],
                                    int.parse(userId)
                                );
                              },
                                  height: 35.h,
                                  width: MediaQuery.of(context).size.width*0.45,
                                  radius: 32.r,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  backgroundColor: Color(0xffdfdde0),
                                  borderColor: Colors.transparent,
                                  borderWidth: 2,
                                  imagePath: "assets/svg/ic_flag.svg",
                                  imageColor: AppTheme.appColor,
                                  textColor: AppTheme.appColor),
                            ),
                          SizedBox(width: 10.w,),
                          Expanded(
                            child: AppButton.appButton("Share", onTap: () async {
                              shareProductLink();
                            },
                                height: 35.h,
                                width: MediaQuery.of(context).size.width*0.35,
                                radius: 32.r,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                backgroundColor: Color(0xffdfdde0),
                                borderColor: Colors.transparent,
                                imagePath: "assets/svg/ic_share.svg",
                                imageColor: AppTheme.appColor,
                                borderWidth: 2,
                                textColor: AppTheme.appColor),
                          ),

                        ],
                      ),
                    ),


                    if(userId.toString() != widget.detailResponse["user_id"].toString() || propertyAttributes.catName == 'Property for Rent' || propertyAttributes.catName == 'Property for Sale')
                      Container(
                        height: 1,
                        width: screenWidth,
                        decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
                      ),




                  ]),
            ),

            const SizedBox(height: 12,),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  if(propertyAttributes.catName == 'Property for Rent' || propertyAttributes.catName == 'Property for Sale' )...[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                                color: AppTheme.borderColor
                            )
                        ),
                        child: Image.asset("assets/images/qr.png")
                    ),

                    SizedBox(height: 15.h,),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal:17.5.w, vertical: 11.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: const Color(0xffd8dbe0).withOpacity(0.25),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/icon.png', height: 40.w, width: 40.w,),
                            SizedBox(width: 15.w,),
                            RichText(
                              text: TextSpan(
                                text: "To know more about the rules \nand regulations visit the ",
                                style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                    text: "Dubai Land \nDepartment Website",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      color: Colors.black, // Optional: change the color to indicate it's clickable
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        const url = 'https://dubailand.gov.ae/en/#/';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                  ),
                                  TextSpan(text: "."),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),

                  ]
                ],
              ),
            ),

            SizedBox(height: 270.h,),
          ],
        ),
      ],
    );
  }


  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.detailResponse["photo"].length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat.yMMMM().format(dateTime);

    return "Member since $formattedDate";
  }

  Widget bodyColumn() {

    return SizedBox(
      // height: userId.toString() == widget.detailResponse["user_id"].toString() ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height - 100,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            children: [
              SizedBox(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 450.h,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: widget.detailResponse["photo"].length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 300,
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        push(
                                            context,
                                            FullImagePage(
                                                detailResponse:
                                                widget.detailResponse));
                                      },
                                      child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Image.network(
                                                "${widget.detailResponse["photo"][index]["src"]}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            if(widget.detailResponse["photo"].length>1)
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 30.h),
                                                  child: SmoothPageIndicator(
                                                    controller: _pageController,
                                                    count: widget.detailResponse["photo"].length,
                                                    effect: const ScrollingDotsEffect(
                                                      activeDotColor: Colors.blue,
                                                      dotColor: Colors.grey,
                                                      maxVisibleDots: 5,
                                                      dotHeight: 7.0,
                                                      dotWidth: 7.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if(widget.detailResponse["photo"].length>1 && index!=0 )
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: IconButton(
                                                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                                                  onPressed: _goToPreviousPage,
                                                  padding: EdgeInsets.only(left: 15),
                                                ),
                                              ),
                                            if(widget.detailResponse["photo"].length>1 && (index==0 || index!=(widget.detailResponse["photo"].length-1)) )
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: IconButton(
                                                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                                                  onPressed: _goToNextPage,
                                                  padding: EdgeInsets.only(right: 10),
                                                ),
                                              ),
                                          ]
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            },
                            onPageChanged: (int index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              if(widget.popToBottomNav == true) {
                                pushUntil(context, const BottomNavView());
                              }
                              else{
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 30),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.whiteColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/images/arrow-left.png",),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // iconContainer(
                          //     ontap: () {
                          //       Navigator.pop(context);
                          //     },
                          //     alignment: Alignment.topLeft,
                          //     img: "assets/images/arrow-left.png",
                          //     isFavourite: false),

                          Align(
                              alignment: Alignment.topRight,
                              child: iconSvg(ontap: (){shareProductLink();})),

                          priceTag(),

                          if(authorizationToken != null)
                            iconContainer(
                                ontap: () {
                                  widget.detailResponse["wishlist"].isNotEmpty
                                      ? removeFavourite(
                                      wishId:
                                      widget.detailResponse["wishlist"]
                                      [0]["id"])
                                      : addToFavourite();
                                },
                                isFavourite:
                                isFav,
                                alignment: Alignment.bottomRight,
                                img: "assets/images/heart.png")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              customColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userDetailsContainer(){
    final screenWidth = MediaQuery.of(context).size.width;

    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.detailResponse["user"] != null)
              InkWell(
                onTap: (){
                  if(authorizationToken!=null){
                    push(
                        context,
                        SellerProfileScreen(
                            detailResponse:
                            widget.detailResponse));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: widget.detailResponse["user"]==null || widget.detailResponse["user"]
                                  ["img"] ==
                                      null
                                      ? const AssetImage(
                                      'assets/images/auction2.png')
                                      : NetworkImage(
                                      "${widget.detailResponse["user"]["img"]}")
                                  as ImageProvider,
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2,),
                              GestureDetector(
                                onTap: (){
                                  if(authorizationToken!=null){
                                    push(
                                        context,
                                        SellerProfileScreen(
                                            detailResponse:
                                            widget.detailResponse));
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.appText(
                                        capitalizeWords(widget.detailResponse["user"]["name"] ?? ''),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppTheme.blackColor),

                                    SizedBox(width : 5.w),
                                    if(widget.detailResponse["user"]["email_verified_at"] !=null &&
                                        widget.detailResponse["user"]["image_verified_at"] !=null &&
                                        widget.detailResponse["user"]["phone_verified_at"] !=null)
                                      const Icon(Icons.check_circle, color: Colors.green, size: 19),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.h,),
                              GestureDetector(
                                onTap: (){
                                  if(authorizationToken!=null){
                                    push(
                                        context,
                                        SellerProfileScreen(
                                          detailResponse:
                                          widget.detailResponse,
                                          review: true,
                                        ));
                                  }
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      StarRating(
                                        percentage: userRating != null ? percentageOfFive(userRating.toString()) : 0,
                                        color: Colors.yellow,
                                        size: 18,
                                      ),
                                      SizedBox(width: 5.w,),
                                      if(userRating != null)
                                        AppText.appText(userRating==0 ? 'not rated yet' : "${userRating?.toStringAsFixed(1)}",
                                            textAlign: TextAlign.center,
                                            fontSize: 9.5.sp,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.txt1B20),
                                    ]),
                              )
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Icon(Icons.chevron_right)

                        ],
                      ),
                    ),
                    if(widget.detailResponse["user"]["email_verified_at"] !=null &&
                        widget.detailResponse["user"]["image_verified_at"] !=null &&
                        widget.detailResponse["user"]["phone_verified_at"] !=null)
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/verify.png",
                            height: 24,
                          ),
                          AppText.appText("Verified Member",
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              textColor: AppTheme.blackColor),
                        ],
                      ),
                  ],
                ),
              ),
            if(widget.detailResponse["user"] != null)
              if(widget.detailResponse["user"]["email_verified_at"] !=null &&
                  widget.detailResponse["user"]["image_verified_at"] !=null &&
                  widget.detailResponse["user"]["phone_verified_at"] !=null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: AppText.appText(
                      formatTimestamp(
                          "${widget.detailResponse["created_at"]}"),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.lighttextColor),
                ),
          ],
        ),
      ),
    );
  }


  Widget productInteractiveContainer(){
    return Visibility(
      visible : userId.toString() != widget.detailResponse["user_id"].toString(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppButton.appButton("Buy it Now", onTap: () async {},
                height: 39.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                backgroundColor: AppTheme.appColor,
                borderWidth: 1,
                textColor: AppTheme.white),
            SizedBox(height: 7.w,),
            AppButton.appButton(isFav ? "Remove from wishlist" : "Add to wishlist",
                onTap: () async {
                  widget.detailResponse["wishlist"].isNotEmpty
                      ? removeFavourite(
                      wishId:
                      widget.detailResponse["wishlist"]
                      [0]["id"])
                      : addToFavourite();
                },
                height: 39.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                imagePath: isFav ? "assets/svg/ic_heart_dark.svg" : "assets/svg/ic_heart.svg",
                imageColor: isFav ? null : AppTheme.appColor,
                textColor: AppTheme.appColor),

          ],
        ),
      ),
    );
  }

  Widget iconContainer({Function()? ontap, img, alignment, isFavourite}) {
    return GestureDetector(
        onTap: ontap,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Align(
              alignment: alignment,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppTheme.whiteColor),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      isFav ? "assets/svg/ic_heart_dark.svg" : "assets/svg/ic_heart.svg",
                      color: isFav? Colors.red : AppTheme.textColor,

                    )

                ),
              ),
            )));
  }

  Widget iconSvg({Function()? ontap, img,}) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.0, vertical: 35.h),
          child: SizedBox(
            width: 100.w,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                      "assets/svg/ic_share.svg",
                      height: 30.h
                  ),

                ]
            ),
          )
      ),
    );
  }

  Widget priceTag() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
        child: CustomPaint(
            painter: PriceTagPainter(),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 14),
              child: AppText.appText(
                  "AED ${abbreviateNumber(widget.detailResponse["auction_price"] ?? '')}",
                  textColor: Colors.white,
                  fontSize: 19.sp

              ),)),
      ),
    );
  }
  //////////////////////////Apis//////////////////////////////////////////////////////
  void addToFavourite() async {
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
      "user_id": userId,
      "product_id": widget.detailResponse["id"],
    };
    try {
      response = await dio.post(path: AppUrls.adddToFavorite, data: params);
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
          isLoading = false;
          isFav = true;
          getProductDetail();
          Provider.of<ProductsApiProvider>(context, listen: false).getAuctionProducts(
            dio: dio,
            context: context,
          );
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

  void removeFavourite({wishId}) async {
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
      "id": wishId,
      // "product_id": widget.detailResponse["id"],
    };
    try {
      response = await dio.post(path: AppUrls.removeFavorite, data: params);
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
          isLoading = false;
          isFav = false;
          getProductDetail();
          Provider.of<ProductsApiProvider>(context, listen: false).getAuctionProducts(
            dio: dio,
            context: context,
          );
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

  String getLocation() {

    String location = widget.detailResponse["location"];

    return location;
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
      "id": dynamicLink==true ? widget.productId! : widget.detailResponse["id"],
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

          widget.detailResponse = responseData["data"][0];
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


  Future<void> shareProductLink() async {
    String shareLink = await DynamicLinkService().createDynamicLink(widget.detailResponse["id"].toString(), "auction");
    Share.share('Check out this ad: $shareLink');
  }





}
