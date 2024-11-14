import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/constants.dart';
import 'package:tt_offer/custom_requests/search_service.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/views/All%20Aucton%20Products/all_auction_procucts.dart';
import 'package:tt_offer/views/All%20Aucton%20Products/auction_container.dart';
import 'package:tt_offer/views/All%20Categories/all_caetgories.dart';
import 'package:tt_offer/views/All%20Categories/catagory_container.dart';
import 'package:tt_offer/views/All%20Categories/category_products.dart';
import 'package:tt_offer/views/All%20Categories/sub_categories_screen.dart';
import 'package:tt_offer/views/All%20Featured%20Products/all_feature_products.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_container.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';
import 'package:tt_offer/views/Homepage/home_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/Homepage/search_screen.dart';
import 'package:tt_offer/views/SearchPage/search_page.dart';

import '../../Controller/APIs Manager/banner_api.dart';
import '../../Controller/APIs Manager/cart_api.dart';
import '../../Controller/APIs Manager/notification_api.dart';
import '../../Controller/APIs Manager/send_notification_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  late ProductsApiProvider apiProvider;

  String? authenticationToken;

  var subCatagoryData;
  static const List<String> _imagePaths = [
    "assets/images/sliderImg.png",
    "assets/images/sliderImg.png",
    "assets/images/sliderImg.png",
  ];
  static const List<String> newBannerImage = [
    "assets/images/newBanner.png",
  ];
  late AppDio dio;
  AppLogger logger = AppLogger();

  getLocation() {
    location = pref.getString('myLocation');
    print('mylosodsd_--->${location}');
    setState(() {});
  }

  @override
  void initState() {
    // getLocation();

    handler();

    dio = AppDio(context);
    logger.init();
    final profileApi = Provider.of<ProfileApiProvider>(context, listen: false);
    profileApi.getProfile(
      dio: dio,
      context: context,
    );


    apiProvider =
        Provider.of<ProductsApiProvider>(context, listen: false);
    // apiProvider.getCatagories(
    //   dio: dio,
    //   context: context,
    // );
    apiProvider.getAuctionProducts(
      dio: dio,
      context: context,
    );
    apiProvider.getFeatureProducts(
      dio: dio,
      context: context,
    );

    getNotificationHandler();

    cartProvider = Provider.of<CartApiProvider>(context, listen: false);
    authenticationToken = pref.getString(PrefKey.authorization);

    if(authenticationToken!=null) {
      cartProvider.getCartItems(dio: dio, context: context);
    }





    super.initState();
  }

  Future<void> getData() async {

    // apiProvider.getCatagories(
    //   dio: dio,
    //   context: context,
    // );
    apiProvider.getAuctionProducts(
      dio: dio,
      context: context,
    );
    apiProvider.getFeatureProducts(
      dio: dio,
      context: context,
    );
    apiProvider.getAllProducts(
      dio: dio,
      context: context,
    );
  }

  List<SearchData> provider = [];

  handler() async {
    await BlockedUserServices().getBlockedUser(context: context);
  }

  void searchHandler(BuildContext context) async {
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.appColor,
                  ),
                ],
              ),
            ));

    bool res = await SearchService().searchService(
      context: context,
      query: _searchController.text.trim(),
    );
    Navigator.pop(context);

    if (res) {
      push(context, const SearchPage(), then: (){
        getData();
      });
    }

    provider = Provider.of<SearchProvider>(context, listen: false).selling;
    print('provider---->${provider}');
    setState(() {});
  }

  getNotificationHandler() async {
    await NotificationService().notificationService(context: context);
  }

  late CartApiProvider cartProvider;



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // getData();
    // final apiProvider = Provider.of<ProductsApiProvider>(context);
    final profileApi = Provider.of<ProfileApiProvider>(context);
    if (profileApi.profileData != null) {
      location = profileApi.profileData["location"];
    } else {
      // Handle the case where profileData is null
    }

    final apiProvider1 = Provider.of<CategoryProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar(context: context, authenticationCode: authenticationToken, searchHandler: (){ searchHandler(context);}, searchController: _searchController, setState: setState,),
      body: Consumer<ProductsApiProvider>(
          builder: (context, apiProvider, child) {
            if(_searchController.text.isNotEmpty) {
              return const ViewSearchedProducts();
            } else {
              return Consumer<BannerController>(
                  builder: (context, bannerController, child) {
                      return Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if(bannerController.firstBanner.isNotEmpty)
                      Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 16 / 7.0,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: bannerController.firstBanner.map((String imagePath) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                double screenWidth = MediaQuery.of(context).size.width;
                                double bannerHeight = screenWidth * (7 / 16);

                                return Container(
                                  height: bannerHeight,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: imagePath,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: SizedBox(
                                          height: 30.h,
                                          child: CircularProgressIndicator(color: AppTheme.yellowColor),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => SizedBox(),
                                      cacheKey: imagePath,
                                      maxWidthDiskCache: 200,
                                      fadeInDuration: const Duration(milliseconds: 500),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),


                      if(bannerController.firstBanner.isNotEmpty)
                          const SizedBox(
                          height: 15,
                        ),
                        if(bannerController.secondBanner.isNotEmpty)
                          Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 16 / 7.0,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: bannerController.secondBanner.map((String imagePath) {
                              return Container(
                                height: 154,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: imagePath,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: SizedBox(
                                        height: 30.h,
                                        child: CircularProgressIndicator(color: AppTheme.yellowColor,),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => SizedBox(),
                                    cacheKey: imagePath, // Cache key to identify this image
                                    maxWidthDiskCache: 200, // Specify disk cache size to optimize loading
                                    fadeInDuration: Duration(milliseconds: 500), // Smooth fade-in effect
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if(bannerController.secondBanner.isNotEmpty)
                          const SizedBox(
                          height: 15,
                        ),
                        if(bannerController.thirdBanner.isNotEmpty)...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 3,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: bannerController.thirdBanner.map((String imagePath) {
                              return Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: imagePath,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: SizedBox(
                                        height: 30.h,
                                        child: CircularProgressIndicator(color: AppTheme.yellowColor,),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Center(
                                      child: SizedBox(
                                        height: 30.h,
                                        child: CircularProgressIndicator(color: AppTheme.yellowColor,),
                                      ),
                                    ),
                                    cacheKey: imagePath, // Cache key to identify this image
                                    maxWidthDiskCache: 200, // Specify disk cache size to optimize loading
                                    fadeInDuration: Duration(milliseconds: 500), // Smooth fade-in effect
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),],
                        customRow(
                            txt1: "Categories",
                            txt2: "View All",
                            txt3: "",
                            onTap: () {
                              push(
                                  context,
                                  AllCategories(
                                    data: apiProvider.catagoryData,
                                    isList: false,
                                  ), then: () {
                                getData();
                              });
                            }),
                        // apiProvider.catagoryData == null
                        //     ? Center(
                        //         child: AppText.appText("Loading...."),
                        //       )
                        //     :
                        SizedBox(
                          height: 110.h,
                          width: screenWidth,
                          child: ListView.builder(
                            padding: EdgeInsets.only(right: 5.w),
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              // Color color = Color(int.parse(apiProvider
                              //     .catagoryData[index]["color"]
                              //     .replaceFirst('#', '0xFF')));

                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        push(
                                            context,
                                            SubCategoriesScreen(
                                              title: apiProvider1.category[index]
                                                  .title,
                                              id: apiProvider1.category[index].id,
                                            ), then: () {
                                          getData();
                                        });
                                      },
                                      child: CatagoryContainer(
                                        color: apiProvider1.category[index].color,
                                        img: apiProvider1.category[index].image,
                                        txt: apiProvider1.category[index].title,
                                        isList: true,
                                      ),
                                    ),
                                    // if (index ==
                                    //     apiProvider.catagoryData.length - 1)
                                    //   const SizedBox(
                                    //     width: 20,
                                    //   )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // Image.asset('assets/images/divide.png'),
                        const SizedBox(
                          height: 20,
                        ),
                        customRow(
                            onTap: () {
                              push(context, const ViewAllAuctionProducts(),
                                  then: () {
                                    getData();
                                  });
                            },
                            txt1: "Auction Products",
                            txt2: "View All",
                            txt3: "Hurry up! The auction is ending soon."),
                        const SizedBox(
                          height: 20,
                        ),
                        apiProvider.allauctionProductsData == null
                            ? Center(
                          child: AppText.appText("Loading...."),
                        )
                            : apiProvider.allauctionProductsData.isEmpty
                            ? Center(
                          child:
                          AppText.appText("No Auction Product Added Yet"),
                        )
                            : SizedBox(
                            height: 290.h,
                            width: screenWidth,
                            child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 0),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            apiProvider.allauctionProductsData.length > 4
                                ? 4
                                : apiProvider.allauctionProductsData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 14.w),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          // getAuctionProductDetail(
                                          //     productId: apiProvider
                                          //             .allauctionProductsData[
                                          //         index]["id"]);
                                          push(context, AuctionInfoScreen(
                                              detailResponse: apiProvider
                                                  .allauctionProductsData[index]),
                                              then: () {
                                                getData();
                                              });
                                        },
                                        child: AuctionProductContainer(
                                          data: apiProvider
                                              .allauctionProductsData[index],
                                        )),
                                    if (index ==
                                        apiProvider
                                            .allauctionProductsData.length -
                                            1)
                                      const SizedBox(
                                        width: 20,
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customRow(
                            onTap: () {
                              push(context, const ViewFeaturedProducts(), then: () {
                                getData();
                              });
                            },
                            txt1: "Feature Products",
                            txt2: "View All",
                            txt3: "Act fast! These featured products won't last long."),

                        apiProvider.allfeatureProductsData == null
                            ? Center(
                          child: AppText.appText("Loading...."),
                        )
                            : apiProvider.allfeatureProductsData.isEmpty
                            ? Center(
                          child:
                          AppText.appText("No Feature Product Added Yet"),
                        )
                            :
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 15.h,
                                crossAxisSpacing: 12,
                                crossAxisCount: 2,
                                childAspectRatio: screenWidth / (2.6 * 220),
                              ),
                              shrinkWrap: true,
                              itemCount: apiProvider.allfeatureProductsData.length >
                                  4
                                  ? 4
                                  : apiProvider.allfeatureProductsData.length,
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      push(
                                          context,
                                          FeatureInfoScreen(
                                            detailResponse: apiProvider
                                                .allfeatureProductsData[index],
                                          ), then: () {
                                        getData();
                                      });
                                      // getFeatureProductDetail(
                                      //     productId: apiProvider
                                      //         .allfeatureProductsData[index]["id"]);
                                    },
                                    child: FeatureProductContainer(
                                        data:
                                        apiProvider.allfeatureProductsData[index]));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                              );
                }
              );
            }
          }),
    );
  }

  Widget customRow({txt1, txt2, txt3, onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("$txt1",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.textColor),
              GestureDetector(
                onTap: onTap,
                child: AppText.appText("$txt2",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    textColor: AppTheme.textColor),
              )
            ],
          ),
          AppText.appText("$txt3",
              fontSize: 10,
              fontWeight: FontWeight.w300,
              textColor: AppTheme.textColor),
        ],
      ),
    );
  }

/////////////////////////////////////
  void getAuctionProductDetail({productId, limit}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    setState(() {
      pr.show();
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
      "limit": limit,
    };
    try {
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
      var responseData = response.data;

      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          push(context, AuctionInfoScreen(detailResponse: detailResponse[0]),then: (){
            getData();
          });
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }

  void getFeatureProductDetail({productId, limit}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    setState(() {
      pr.show();
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
      "limit": limit,
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          push(
              context,
              FeatureInfoScreen(
                detailResponse: detailResponse[0],
              ), then: (){
            getData();
          });
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }

  void getSubCatagories({catId, search, limit, id}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );
    setState(() {
      pr.show();
    });

    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "category_id": catId,
      "search": search,
      "limit": limit,
      "id": id,
    };
    try {
      response = await dio.post(path: AppUrls.subCategories, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          subCatagoryData = responseData;
          pr.dismiss();
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      pr.dismiss();
    }
  }
}
