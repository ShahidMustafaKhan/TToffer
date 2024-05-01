import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/View/Auction%20Info/auction_info.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({Key? key}) : super(key: key);

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var savedProducts;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserId();
    super.initState();
  }

  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString(PrefKey.userId);
    getSavedProducts(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Saved items",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SavedItemListView(
          data: savedProducts,
        ),
      ),
    );
  }

  void getSavedProducts({userId}) async {
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
    };
    try {
      response = await dio.post(path: AppUrls.getSavedProducts, data: params);
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
          savedProducts = responseData["data"];
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
}

class SavedItemListView extends StatefulWidget {
  final data;
  const SavedItemListView({
    super.key,
    this.data,
  });

  @override
  State<SavedItemListView> createState() => _SavedItemListViewState();
}

class _SavedItemListViewState extends State<SavedItemListView> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.data[index]["product"]["fix_price"] == null) {
                    getAuctionProductDetail(
                        productId: widget.data[index]["product_id"]);
                  } else {
                    getFeatureProductDetail(
                        productId: widget.data[index]["product_id"]);
                  }
                },
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                "assets/images/auction1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.appText(
                                  "${widget.data[index]["product"]["title"]}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppTheme.txt1B20),
                              AppText.appText(
                                  "${widget.data[index]["product"]["location"]}",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppTheme.lighttextColor),
                              AppText.appText(
                                  formatTimestamp(
                                      "${widget.data[index]["product"]["created_at"]}"),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppTheme.appColor)
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText.appText(
                              formatTimestamp(
                                  "${widget.data[index]["created_at"]}"),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.lighttextColor),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const CustomDivider()
          ],
        );
      },
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(timestamp);

    Duration difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour ago";
    } else if (difference.inDays == 1) {
      return "yesterday";
    } else {
      return "${time.day}/${time.month}/${time.year}";
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
              ));
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
          push(
              context,
              AuctionInfoScreen(
                detailResponse: detailResponse[0],
              ));
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
}
