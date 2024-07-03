import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/views/Auction%20Info/full_image_page.dart';
import 'package:tt_offer/views/Auction%20Info/make_offer_screen.dart';
import 'package:tt_offer/views/ChatScreens/offer_chat_screen.dart';
import 'package:tt_offer/views/Seller%20Profile/seller_profile.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../controller/APIs Manager/chat_api.dart';

class FeatureInfoScreen extends StatefulWidget {
  var detailResponse;

  FeatureInfoScreen({super.key, this.detailResponse});

  @override
  State<FeatureInfoScreen> createState() => _FeatureInfoScreenState();
}

class _FeatureInfoScreenState extends State<FeatureInfoScreen> {
  int _currentPage = 0;
  final panelController = PanelController();
  bool isLoading = false;
  bool isFav = false;
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
  var userId = pref.getString(PrefKey.userId);
  AppLogger logger = AppLogger();

  static List<String> wrapList1 = [];

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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dio = AppDio(context);
      // getUserId();
      logger.init();

      // markProductView();
    });

    // wrapList1 = [
    //   '${widget.detailResponse["condition"]}',
    //   'Samsung ',
    //   'Galaxy M02',
    //   "2/32",
    //   "Original"
    // ];

    super.initState();

    final String AttributesJson = widget.detailResponse['attributes'];
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

    wrapList1 = [
      '${animalsAttributes.catName == 'Animals' ? animalsAttributes.age : servicesAttributes.catName == 'Services' ? servicesAttributes.car : jobAttributes.catName == 'Job' ? jobAttributes.companyName : widget.detailResponse["condition"] ?? 'NA'}',
      (furnitureAttributes.catName == 'Furniture and home decor'
          ? furnitureAttributes.type
          : fashionAttributes.catName == 'Fashion (dress) and beauty'
              ? fashionAttributes.fabric.toString()
              : fashionAttributes.catName == 'Mobiles'
                  ? mobileAttributes.brand
                  : vehicleAttributes.catName == 'Vehicles'
                      ? vehicleAttributes.FuelType
                      : propertyAttributes.catName == 'Property for Sale' ||
                              propertyAttributes.catName == 'Property for Rent'
                          ? propertyAttributes.type
                          : jobAttributes.catName == 'Job'
                              ? jobAttributes.experience
                              : bikeAttributes.catName == 'Bike'
                                  ? bikeAttributes.model
                                  : kidsAttributes.catName == 'Kids'
                                      ? kidsAttributes.toy
                                      : ''),
      (furnitureAttributes.catName == 'Furniture and home decor'
          ? furnitureAttributes.color
          : animalsAttributes.catName == 'Animals'
              ? animalsAttributes.breed
              : fashionAttributes.catName == 'Fashion (dress) and beauty'
                  ? fashionAttributes.suitType.toString()
                  : fashionAttributes.catName == 'Mobiles'
                      ? mobileAttributes.storage
                      : vehicleAttributes.catName == 'Vehicles'
                          ? vehicleAttributes.color
                          : propertyAttributes.catName == 'Property for Sale' ||
                                  propertyAttributes.catName ==
                                      'Property for Rent'
                              ? propertyAttributes.area
                              : jobAttributes.catName == 'Job'
                                  ? jobAttributes.salary
                                  : bikeAttributes.catName == 'Bike'
                                      ? bikeAttributes.engineCapacity
                                      : ''),
      (fashionAttributes.catName == 'Mobiles'
          ? mobileAttributes.color
          : propertyAttributes.catName == 'Property for Sale' ||
                  propertyAttributes.catName == 'Property for Rent'
              ? propertyAttributes.features
              : jobAttributes.catName == 'Job'
                  ? jobAttributes.type
                  : ''),
      // '${widget.detailResponse["authenticity"] ?? 'NA'}',
      // "2/32",
      // "Original"
    ];
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

  @override
  Widget build(BuildContext context) {
    List<String> wrapList = [
      animalsAttributes.catName == 'Animals'
          ? 'Age'
          : servicesAttributes.catName == 'Services'
              ? 'Car'
              : jobAttributes.catName == 'Job'
                  ? 'Company Name'
                  : 'Condition',
      furnitureAttributes.catName == 'Furniture and home decor'
          ? "Type"
          : animalsAttributes.catName == 'Animals'
              ? 'Breed'
              : fashionAttributes.catName == 'Fashion (dress) and beauty'
                  ? 'Fabric'
                  : mobileAttributes.catName == 'Mobiles'
                      ? 'Brand'
                      : vehicleAttributes.catName == 'Vehicles'
                          ? 'Fuel Type'
                          : propertyAttributes.catName == 'Property for Sale' ||
                                  propertyAttributes.catName ==
                                      'Property for Rent'
                              ? 'Type'
                              : jobAttributes.catName == 'Job'
                                  ? 'Experience'
                                  : bikeAttributes.catName == 'Bike'
                                      ? 'Model'
                                      : kidsAttributes.catName == 'Kids'
                                          ? 'Toys'
                                          : '',
      furnitureAttributes.catName == 'Furniture and home decor'
          ? "Color"
          : fashionAttributes.catName == 'Fashion (dress) and beauty'
              ? 'SuitType'
              : mobileAttributes.catName == 'Mobiles'
                  ? 'Storage Capacity'
                  : vehicleAttributes.catName == 'Vehicles'
                      ? 'Color'
                      : propertyAttributes.catName == 'Property for Sale' ||
                              propertyAttributes.catName == 'Property for Rent'
                          ? 'Area'
                          : jobAttributes.catName == 'Job'
                              ? 'Salary'
                              : bikeAttributes.catName == 'Bike'
                                  ? 'Engine Capacity'
                                  : '',
      mobileAttributes.catName == 'Mobiles'
          ? "Color"
          : propertyAttributes.catName == 'Property for Sale' ||
                  propertyAttributes.catName == 'Property for Rent'
              ? 'Features'
              : jobAttributes.catName == 'Job'
                  ? 'Job Type'
                  : '',
      // "Authenticity"
    ];

    wrapListAd = wrapList;

    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          final apiProvider =
              Provider.of<ProductsApiProvider>(context, listen: false);
          apiProvider.getFeatureProducts(
            dio: dio,
            context: context,
          );
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

                Map body = {
                  "sender_id": pref.getString(PrefKey.userId),
                  "receiver_id": widget.detailResponse["user"]["id"],
                };

                var responce = await customPostRequest.httpPostRequest(
                    body: body, url: AppUrls.createConversationUrl);

                log("responce for createConversationUrl = $responce ");

                getConversation(
                  dio: dio,
                  context: context,
                  conversationId: responce["data"],
                  title: "${widget.detailResponse["user"]["name"]}",
                  recieverId: widget.detailResponse["user"]["id"],
                );

                log("widget.detailResponse = ${widget.detailResponse}");

                // push(
                //     context,
                //     OfferChatScreen(
                //       recieverId: widget.detailResponse["user"]["id"],
                //       title: "${widget.detailResponse["user"]["name"]}",
                //       isOffer: true,
                //     ));
              },
                  height: 53,
                  width: 150,
                  radius: 32.0,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  backgroundColor: AppTheme.appColor,
                  textColor: AppTheme.whiteColor),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                push(context, MakeOfferScreen(data: widget.detailResponse));
              },
              child: AppButton.appButton("Make Offer",
                  height: 53,
                  width: 150,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  radius: 32.0,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: AppText.appText(
                    "${widget.detailResponse["description"] ?? ''}",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.lighttextColor),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: AppText.appText(getFormattedTimestamp(),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.blackColor),
                ),
              ),
              Container(
                height: 1,
                width: screenWidth,
                decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  height: 102,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AppText.appText(
                              "\$${widget.detailResponse["fix_price"] ?? ''}",
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              textColor: AppTheme.appColor),
                          const SizedBox(
                            width: 20,
                          ),
                          AppText.appText(
                              widget.detailResponse["firm_on_price"] == 1
                                  ? "Non Negotiable"
                                  : "Neg0tiable",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.lighttextColor),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // showSnackBar(
                                  // context, "move to SellerProfileScreen");
                                  push(
                                      context,
                                      SellerProfileScreen(
                                          detailResponse:
                                              widget.detailResponse));
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: widget.detailResponse["user"]
                                                  ["img"] ==
                                              null
                                          ? const AssetImage(
                                                  "assets/images/user.png")
                                              as ImageProvider<Object>
                                          : NetworkImage(widget
                                                  .detailResponse["user"]
                                              ["img"]) as ImageProvider<Object>,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              AppText.appText(
                                  "${widget.detailResponse["user"]["name"] ?? ''}",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppTheme.blackColor),
                            ],
                          ),
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: AppText.appText(
                            formatTimestamp(
                                "${widget.detailResponse["user"]["created_at"] ?? ''}"),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            textColor: AppTheme.lighttextColor),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                width: screenWidth,
                decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
              ),
              const SizedBox(width: 5),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 20.0),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: SizedBox(
              //       width: MediaQuery.sizeOf(context).width / 1.3,
              //       child: Wrap(
              //         alignment: WrapAlignment.start,
              //         spacing: 10,
              //         runSpacing: 10,
              //         children: [
              //           // for (int i = 0; i <= 4; i++)
              //           widget.detailResponse["condition"] == null
              //               ? const SizedBox.shrink()
              //               : const Text(
              //                   'Condition:',
              //                   style: TextStyle(fontWeight: FontWeight.w300),
              //                 ),
              //           const SizedBox(width: 3),
              //
              //           AppText.appText(
              //               widget.detailResponse["condition"] ?? '',
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //               textColor: AppTheme.blackColor),
              //
              //           const SizedBox(width: 20),
              //
              //           widget.detailResponse["brand"] == null
              //               ? const SizedBox.shrink()
              //               : const Text(
              //                   'Brand:',
              //                   style: TextStyle(fontWeight: FontWeight.w300),
              //                 ),
              //           const SizedBox(width: 3),
              //
              //           AppText.appText(widget.detailResponse["brand"] ?? '',
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //               textColor: AppTheme.blackColor),
              //           const SizedBox(width: 22),
              //
              //           widget.detailResponse["model"] == null
              //               ? const SizedBox.shrink()
              //               : const Text(
              //                   'Model:',
              //                   style: TextStyle(fontWeight: FontWeight.w300),
              //                 ),
              //           const SizedBox(width: 5),
              //
              //           AppText.appText(widget.detailResponse["model"] ?? '',
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //               textColor: AppTheme.blackColor),
              //
              //           const SizedBox(width: 25),
              //
              //           widget.detailResponse["edition"] == null
              //               ? const SizedBox.shrink()
              //               : const Text(
              //                   'Edition:',
              //                   style: TextStyle(fontWeight: FontWeight.w300),
              //                 ),
              //           const SizedBox(width: 4),
              //
              //           AppText.appText(widget.detailResponse["edition"] ?? '',
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //               textColor: AppTheme.blackColor),
              //           const SizedBox(width: 20),
              //
              //           widget.detailResponse["authenticity"] == null
              //               ? const SizedBox.shrink()
              //               : const Text(
              //                   'Authenticity:',
              //                   style: TextStyle(fontWeight: FontWeight.w300),
              //                 ),
              //           AppText.appText(
              //               widget.detailResponse["authenticity"] ?? '',
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //               textColor: AppTheme.blackColor),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i <= 3; i++)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                AppText.appText("${wrapListAd[i]}  ",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: AppTheme.lighttextColor),
                                AppText.appText(wrapList1[i],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    textColor: AppTheme.textColor),
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),

              Container(
                height: 1,
                width: screenWidth,
                decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
              )
            ],
          ),
        ],
      ),
    );
  }

  String getFormattedTimestamp() {
    String timestampStr = "2024-04-06T00:52:00.000000Z";
    DateTime timestamp = DateTime.parse(widget.detailResponse["created_at"]);
    DateTime convertedTime = timestamp.toLocal();
    String formattedTimestamp =
        DateFormat('yyyy-MM-dd   hh:mm a').format(convertedTime);
    return "Posted on  $formattedTimestamp in ${widget.detailResponse["location"]}";
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat.yMMMM().format(dateTime);

    return "Member since $formattedDate";
  }

  Widget bodyColumn() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 350,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: widget.detailResponse["photo"].length,
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 300,
                                  child: InkWell(
                                    onTap: () {
                                      push(
                                          context,
                                          FullImagePage(
                                              detailResponse:
                                                  widget.detailResponse));
                                    },
                                    child: Image.network(
                                      "${widget.detailResponse["photo"][index]["src"]}",
                                      fit: BoxFit.fill,
                                    ),
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
                                Navigator.pop(context);
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
                                          "assets/images/arrow-left.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            iconContainer(
                                ontap: () {
                                  Navigator.pop(context);
                                },
                                alignment: Alignment.topLeft,
                                img: "assets/images/arrow-left.png",
                                isFavourite: false),
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
                                    widget.detailResponse["wishlist"].isNotEmpty
                                        ? true
                                        : false,
                                alignment: Alignment.topRight,
                                img: "assets/images/heart.png")
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 70,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              color: AppTheme.whiteColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 10, left: 20, right: 20),
                            child: AppText.appText(
                                "${widget.detailResponse["title"]}",
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                textColor: AppTheme.textColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                customColumn(),
              ],
            ),
          ),
        ),
        if (userId.toString() != widget.detailResponse["user_id"].toString())
          Align(
            alignment: Alignment.bottomCenter,
            child: featureBottomCard(),
          )
      ],
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
                  child: isFavourite == false
                      ? Image.asset(
                          "$img",
                        )
                      : Icon(
                          Icons.favorite_sharp,
                          color: AppTheme.appColor,
                        ))),
        ),
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
          isLoading = false;
          getAuctionProductDetail();
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
          isFav = true;
          getAuctionProductDetail();
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

  void getAuctionProductDetail() async {
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
      "id": widget.detailResponse["id"],
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
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
          widget.detailResponse = responseData["data"][0];
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
          title: title,
          userImgUrl: receiverImg,
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
