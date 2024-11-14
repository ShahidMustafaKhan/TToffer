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
import 'package:tt_offer/views/Auction%20Info/full_image_page.dart';
import 'package:tt_offer/views/Auction%20Info/make_offer_screen.dart';
import 'package:tt_offer/views/ChatScreens/offer_chat_screen.dart';
import 'package:tt_offer/views/Seller%20Profile/seller_profile.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/views/ShoppingFlow/cart/cart_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/APIs Manager/chat_api.dart';
import '../Authentication screens/login_screen.dart';
import '../BottomNavigation/navigation_bar.dart';
import '../Profile Screen/profile_screen.dart';
import 'feature_container.dart';

class FeatureInfoScreen extends StatefulWidget {
  var detailResponse;
  String? productId;
  bool fromDynamicLink;
  bool popToBottomNav;

  FeatureInfoScreen({super.key, this.detailResponse, this.fromDynamicLink=false, this.popToBottomNav=false, this.productId});

  @override
  State<FeatureInfoScreen> createState() => _FeatureInfoScreenState();
}

class _FeatureInfoScreenState extends State<FeatureInfoScreen> {
  int _currentPage = 0;
  final panelController = PanelController();
  bool isLoading = false;
  bool isPageLoading = false;
  bool isFav = false;
  bool isProperty=false;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  static const List<String> wrapList = [
    'Condition',
    'Brand',
    'Model',
    "Edition",
    "Authenticity"
  ];

  // static List<String> wrapList1 = [];
  late AppDio dio;
  var userId;
  String? authorizationToken;
  AppLogger logger = AppLogger();

  static List wrapList1 = [];

  double? userRating;

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
    userRating = await getUserRating(widget.detailResponse['user_id'].toString());
    setState(() {

    });
  }

  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
      userId = pref.getString(PrefKey.userId);
      authorizationToken = pref.getString(PrefKey.authorization);
      setState(() {

      });
  }

   late CartApiProvider cartProvider;


  @override
  void initState() {

    cartProvider = Provider.of<CartApiProvider>(context, listen: false);


    dio = AppDio(context);
    logger.init();

    getProductData();

    super.initState();


  }


  Future<void> getProductData() async {
    if(widget.detailResponse!= null){
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
    final AttributesJson = widget.detailResponse["attributes"];
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
          ? propertyAttributes.subCatName
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
      propertyAttributes.catName == 'Property for Sale' ||
          propertyAttributes.catName == 'Property for Rent'
          ? propertyAttributes.yearBuilt
          : '',

      propertyAttributes.catName == 'Property for Sale' ||
          propertyAttributes.catName == 'Property for Rent'
          ? propertyAttributes.features
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

    if(authorizationToken!=null && widget.detailResponse["wishlist"]!=null) {
      isFav = widget.detailResponse["wishlist"].isNotEmpty
        ? true
        : false;
    }

    if(widget.fromDynamicLink == true){
        isPageLoading = false;
        setState(() {

        });
    }

  }



  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // getUserId() async {
  //   setState(() {
  //     userId = pref.getString(PrefKey.userId);
  //   });
  // }

  bool isChatBtnLoading = false;

  List<String> wrapListAd = [];

  // String? receiverId;
  // String? receiverName;

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

      if (mobileAttributes.catName == 'Bikes' &&
          (mobileAttributes.subCatName == 'Bicycles' ||
              mobileAttributes.subCatName == 'Bikes Accessories' ||
              mobileAttributes.subCatName == 'Parts')) {
        if (wrapList.contains("Engine Capacity")) {
          wrapList1.remove('-');
          wrapList.remove("Engine Capacity");
        }
      }

      if (mobileAttributes.catName == 'Mobiles' &&
          (mobileAttributes.subCatName == 'Accessories' ||
              mobileAttributes.subCatName == 'Smart Watches')) {
        if (wrapList.contains("Storage Capacity")) {
          wrapList1.remove('-');
          wrapList.remove("Storage Capacity");
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
    }


    // for (int i = 0; i < wrapList1.length; i++) {
    //   if (wrapList1[i]!=null && wrapList1[i].isEmpty) {
    //     wrapList1[i] = '-';
    //   }
    // }





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

////////////////////////////////////////////////// feature ///////////////////////////////////
  Widget featureBottomCard() {
    log("//-- userId = $userId");
    log("//-- widget.detailResponse user id =${widget.detailResponse["user_id"]} ");
    // receiverId = widget.detailResponse["user"]["id"];
    // receiverName = widget.detailResponse["user"]["name"];
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      elevation: 20,
      shadowColor: Colors.grey,
      child: Container(
        height: 110,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isChatBtnLoading)
              Center(
                  child: CircularProgressIndicator(
                color: AppTheme.appColor,
              ))
            else
              AppButton.appButton("Chat", onTap: () async {
                // setState(() {
                //   isChatBtnLoading = true;
                // });
                if(authorizationToken!=null){
                  push(
                      context,
                      OfferChatScreen(
                        title: "${widget.detailResponse["user"]["name"]}",
                        userImgUrl: widget.detailResponse["user"]["img"],
                        recieverId: widget.detailResponse["user"]["id"],
                        sellerId: widget.detailResponse["user"]["id"],
                        productId: widget.detailResponse["id"].toString(),
                        buyerId: userId,
                        isFromFeatureProduct: true,
                      ));

                  log("widget.detailResponse = ${widget.detailResponse}");
                }
                else{
                  push(context, const SigInScreen());

                }

                // push(
                //     context,
                //     OfferChatScreen(
                //       recieverId: widget.detailResponse["user"]["id"],
                //       title: "${widget.detailResponse["user"]["name"]}",
                //       isOffer: true,
                //     ));
              },
                  height: 53.h,
                  width: 106.w,
                  radius: 32.r,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  backgroundColor:Colors.transparent,
                  borderWidth: 2,
                  textColor: AppTheme.appColor),
            const SizedBox(
              width: 10,
            ),
            if(widget.detailResponse["user"]!=null && widget.detailResponse["user"]["phone"] != null && (widget.detailResponse["user"]['show_contact']=='1') )
            GestureDetector(
              onTap: () async {
                if(authorizationToken != null){
                  var url = Uri.parse("tel:${widget.detailResponse["user"]["phone"]}");

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                }
                else{
                  push(context, const SigInScreen());
                }

              },
              child: AppButton.appButton("Call",
                  height: 53.h,
                  width: 106.w,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  radius: 32.r,
                  backgroundColor: Colors.transparent,
                  borderWidth: 2,
                  textColor: AppTheme.appColor),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                if(authorizationToken!=null){
                  push(context, MakeOfferScreen(data: widget.detailResponse));
                }
                else{
                  push(context, const SigInScreen());
                }
              },
              child: AppButton.appButton("Make Offer",
                  height: 53.h,
                  width: 106.w,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  radius: 32.r,
                  backgroundColor: AppTheme.appColor,
                  textColor: AppTheme.whiteColor),
            )
          ],
        ),
      ),
    );
  }

////////////////////////////////////////////////// custom ///////////////////////////////////

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
                              propertyAttributes.catName == 'Property for Sale' || jobAttributes.catName == 'Jobs')
                            SizedBox(height: jobAttributes.catName == 'Jobs' ? 11 : 14,),


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
                                widget.detailResponse["wishlist"] != null && widget.detailResponse["wishlist"].isNotEmpty
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
                              if(authorizationToken!=null){
                              reportProduct(
                                context,
                                widget.detailResponse['id'],
                                int.parse(userId)
                              );}
                              else{
                                push(context, const SigInScreen());

                              }
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
                    
                    if(userId.toString() != widget.detailResponse["user_id"].toString())
                    Container(
                      height: 1,
                      width: screenWidth,
                      decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
                    ),

                    productInteractiveContainer(),

                    if(propertyAttributes.catName == 'Property for Rent' || propertyAttributes.catName == 'Property for Sale')
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

                    SizedBox(height: 28.h,),
                  ]
                ],
              ),
            )








          ],
        ),
      ],
    );
  }

  void showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Added to cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for the product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                      child: Image.network(widget.detailResponse["photo"][0]["src"], fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.detailResponse["title"],
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'AED ${widget.detailResponse["fix_price"]}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          '+ AED 0 shipping',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21),
              AppButton.appButton("Go to cart", onTap: () async {
                Navigator.of(context).pop();
                push(context, CartScreen());
              },
                  height: 45.h,
                  radius: 32.r,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  backgroundColor: AppTheme.appColor,
                  borderWidth: 1,
                  textColor: AppTheme.white),
            ],
          ),
        );
      },
    );
  }



  String getLocation() {

    String location = widget.detailResponse["location"];

    return location;
  }

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
    return "Posted $formattedTimestamp ";
  }


  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks week${weeks > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    } else {
      int years = (difference.inDays / 365).floor();
      return "$years year${years > 1 ? 's' : ''} ago";
    }}

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

  Widget bodyColumn() {

    return Stack(
      children: [
        if(isPageLoading==true)
          const Center(child: CircularProgressIndicator())
        else
        SizedBox(
          // height: userId.toString() == widget.detailResponse["user_id"].toString() ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 450.h,
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
                                child: iconSvg()),

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
        // if (userId.toString() != widget.detailResponse["user_id"].toString())
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: featureBottomCard(),
        //   )
      ],
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
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                backgroundColor: AppTheme.appColor,
                borderWidth: 1,
                textColor: AppTheme.white),
            SizedBox(height: 7.w,),
            if(authorizationToken!=null && (propertyAttributes.catName != 'Property for Rent' && propertyAttributes.catName == 'Property for Sale' && propertyAttributes.catName == 'Vehicles' ))...[
            AppButton.appButton("Add to cart",
                onTap: () async {
                  bool? response = await cartProvider.addCartItems(dio: dio, context: context, productId: widget.detailResponse["id"]);
                  if(response== true){
                    showCartBottomSheet(context);
                  }
                },
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                textColor: AppTheme.appColor),
            SizedBox(height: 7.w,),],
            AppButton.appButton("Make Offer",
                onTap: () async {
                  if(authorizationToken!=null){
                    push(context, MakeOfferScreen(data: widget.detailResponse));
                  }
                  else{
                    push(context, const SigInScreen());
                  }
                },
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                textColor: AppTheme.appColor),
            SizedBox(height: 7.w,),
            AppButton.appButton("Ask Seller",
                onTap: () async {
                  if(authorizationToken!=null){
                    push(
                        context,
                        OfferChatScreen(
                          title: "${widget.detailResponse["user"]["name"]}",
                          userImgUrl: widget.detailResponse["user"]["img"],
                          recieverId: widget.detailResponse["user"]["id"],
                          sellerId: widget.detailResponse["user"]["id"],
                          productId: widget.detailResponse["id"].toString(),
                          buyerId: userId,
                          isFromFeatureProduct: true,
                        ));
                  }
                  else{
                    push(context, const SigInScreen());

                  }
                },
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                textColor: AppTheme.appColor),
            SizedBox(height: 7.w,),
            if(widget.detailResponse['user']['phone']!=null && widget.detailResponse['user']['show_contact']==1)
            AppButton.appButton("Call Seller",
                onTap: () async {
                  if(authorizationToken != null){
                    var url = Uri.parse("tel:${widget.detailResponse["user"]["phone"]}");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  }
                  else{
                    push(context, const SigInScreen());
                  }
                },
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                textColor: AppTheme.appColor),
            SizedBox(height: 7.w,),
            AppButton.appButton(authorizationToken==null ? "Add to wishlist" : isFav ? "Remove from wishlist" : "Add to wishlist",
                onTap: () async {
                  if(authorizationToken!=null ){
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
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                imagePath: isFav && authorizationToken!=null ? "assets/svg/ic_heart_dark.svg" : "assets/svg/ic_heart.svg",
                imageColor: isFav && authorizationToken!=null  ? null : AppTheme.appColor,
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
              GestureDetector(
                onTap: (){shareProductLink();},
                child: SvgPicture.asset(
                  "assets/svg/ic_share.svg",
                   height: 30.h
                ),
              ),
              if(userId.toString() != widget.detailResponse["user_id"].toString() && authorizationToken!=null && (propertyAttributes.catName != 'Property for Rent' && propertyAttributes.catName == 'Property for Sale' && propertyAttributes.catName == 'Vehicles' ))...[
              SizedBox(width: 18.w),
                Consumer<CartApiProvider>(
                    builder: (context, s, child) {
                      return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap:(){
                            push(context, CartScreen());
                          },
                          child: SvgPicture.asset(
                          "assets/svg/ic_cart.svg",
                            height: 30.h

                                        ),
                        ),
                        if(cartProvider.numberOfItems!= null && cartProvider.numberOfItems!=0)
                          Positioned(
                            top: -3,
                            right: -3,
                            child: Container(
                              height: 15.w, // Adjust the size as needed
                              width: 15.w,  // Adjust the size as needed
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: AppText.appText('${cartProvider.numberOfItems}', textColor: Colors.white, fontSize: 7.sp, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    );
                  }
                ),]
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
                  "AED ${abbreviateNumber(widget.detailResponse["fix_price"] ?? '')}",
                  textColor: Colors.white,
                  fontSize: 19.sp

              ),)),
      ),
    );
  }

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
          isFav = true;
          getProductDetail();
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
          isFav = false;
          getProductDetail();
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

  Future<void> shareProductLink() async {
    String shareLink = await DynamicLinkService().createDynamicLink(widget.detailResponse["id"].toString(), "featured");
    Share.share('Check out this ad: $shareLink');
  }

  void markProductView() {
    Map body = {"product_id": widget.detailResponse["id"]};
    customPostRequest.httpPostRequest(
        url: AppUrls.increaseProductCount, body: body);
  }

  void getConversation({
    required dio,
    required context,
    required conversationId,
    required recieverId,
    required sellerId,
    required buyerId,
    required title,
    // required isOffer,
  }) async {
    isLoading = true;
    var response;

    log("conversationId in getConversation= $conversationId");
    log("recieverId in getConversation= $recieverId");

    // try {
    response = await customGetRequest.httpGetRequest(
        url: "${AppUrls.getConverstaion}$conversationId");
    // var responseData = response;
    // if (response.statusCode == 200) {
    isLoading = false;

    log("responseData for chat in feature info = $response");
    ChatModel? model;
    log("response data  = ${response["data"]}");
    if (response["data"] is List && response["data"].isEmpty) {
      log("widget.detailResponse user id = ${widget.detailResponse["user"]["id"]}");
      log("widget.detailResponse user name = ${widget.detailResponse["user"]["name"]}");
      model = ChatModel(
          message: "No chat found",
          success: false,
          data: Data(
            conversation: [],
            participant1: Participant(
              id: widget.detailResponse["user"]["id"],
              name: widget.detailResponse["user"]["name"],
              username: widget.detailResponse["user"]["name"],
            ),
            participant2: Participant(
                id: int.parse(userId!),
                name: PrefKey.fullName,
                username: PrefKey.userName),
          ));
      Provider.of<ChatProvider>(context, listen: false).updateChatData(model);
    } else {
      model = ChatModel.fromJson(response);
      Provider.of<ChatProvider>(context, listen: false).updateChatData(model);
    }

    setState(() {
      isChatBtnLoading = false;
    });

    String? receiverImg;
    if (recieverId == model.data!.participant1!.id) {
      receiverImg = model.data!.participant1!.img;
    } else {
      receiverImg = model.data!.participant2!.img;
    }
    push(
        context,
        OfferChatScreen(
          recieverId: recieverId,
          buyerId: int.parse(buyerId),
          sellerId: sellerId,
          title: title,
          userImgUrl: receiverImg,
          contactNumber: widget.detailResponse["user"]["phone"],
          // isOffer: true,
          // offerPrice: widget.detailResponse["fix_price"],
          // userImgUrl: widget.detailResponse["user"]["img"],
        ));
    // }
    // } catch (e) {
    //   log("Something went Wrong $e");
    //   showSnackBar(context, "Something went Wrong.");
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }
}
