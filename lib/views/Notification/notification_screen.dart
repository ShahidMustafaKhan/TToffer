import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/notification_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/custom_logout_pop_up.dart';
import 'package:tt_offer/Utils/widgets/others/delete_notification_dialog.dart';
import 'package:tt_offer/Utils/widgets/others/no_data_found.dart';
import 'package:tt_offer/custom_requests/notification_delete_request.dart';
import 'package:tt_offer/models/notifications_model.dart';
import 'package:tt_offer/providers/notification_provider.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/views/Auction%20Info/reschdule_acution_time.dart';

import '../../Constants/app_logger.dart';
import '../../Controller/APIs Manager/chat_api.dart';
import '../../Controller/APIs Manager/profile_apis.dart';
import '../../config/app_urls.dart';
import '../../config/dio/app_dio.dart';
import '../../models/selling_products_model.dart' as selling_model;
import '../Auction Info/auction_info.dart';
import '../ChatScreens/offer_chat_screen.dart';
import '../Sellings/new_sold_screen.dart';
import '../Sellings/rating_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool loading = false;
  bool delLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var userId;
  bool isLoading = false;
  List<NotificationData> notification = [];

  List<bool> checks = [];

  late ProgressDialog pr;

  getNotificationHandler() async {
    setState(() {
      loading = true;
    });

    await NotificationService().notificationService(context: context);

    setState(() {
      loading = false;
    });

    notification =
        Provider.of<NotificationProvider>(context, listen: false).notifications;
    Provider.of<NotificationProvider>(context, listen: false).changeAllNotificationStatus();
    checks = List.generate(notification.length, (index) => false);
    NotificationService().changeAllNotificationStatus(notification, context);


    setState(() {});
  }

  getNotificationHandlerWithoutLoader() async {
    await NotificationService().notificationService(context: context);

    notification =
        Provider.of<NotificationProvider>(context, listen: false).notifications;
    checks = List.generate(notification.length, (index) => false);

    setState(() {});
  }

  deleteHandler(int? id) async {
    setState(() {
      delLoading = true;
    });

    await NotificationDeleteRequest()
        .notificationDeleteRequest(context: context, notificationId: id);

    setState(() {
      delLoading = false;
    });
    getNotificationHandlerWithoutLoader();
    Navigator.pop(context);
  }

  deleteAllNotificationsHandler() async {
    setState(() {
      delLoading = true;
    });
    await NotificationDeleteRequest().deleteAllNotificationRequest(
        context: context, notifications: checkBoxId);
    setState(() {
      delLoading = false;
    });
    getNotificationHandlerWithoutLoader();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio = AppDio(context);
    logger.init();
    getUserId();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getNotificationHandler();
    });

    pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );
  }

  bool showCheck = false;

  List<int> checkBoxId = [];


  getUserId() async {
    if(Provider.of<ProfileApiProvider>(context, listen: false).profileData!=null){
      userId = Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"];}
    else{
      await Provider.of<ProfileApiProvider>(context, listen: false).getProfile(dio: dio, context: context);
      userId = Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"];}
  }

  @override
  Widget build(BuildContext context) {
    final chatApi = Provider.of<ChatApiProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        title: AppText.appText('Notifications', fontSize: 16.sp, textColor: const Color(0xff1E293B)),
        centerTitle: true,
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        // leading: InkWell(
        //     onTap: () {
        //       checks.first = false;
        //       showCheck = !showCheck;
        //       setState(() {});
        //     },
        //     child: const Center(child: Text('Clear'))),
        actions: [
          checks.isNotEmpty // Check if 'checks' is not empty
              ? checks.first == false // Check the first element if not empty
              ? const SizedBox.shrink()
              : InkWell(
              onTap: deleteAllNotificationsHandler,
              child: delLoading
                  ? CircularProgressIndicator(color: AppTheme.appColor)
                  : Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  CupertinoIcons.delete,
                  color: AppTheme.appColor,
                ),
              ))
              : const SizedBox.shrink(),
        ],
      ),
      body: loading
          ? Center(
          child: CircularProgressIndicator(
            color: AppTheme.appColor,
          ))
          : notification.isEmpty ? NoDataFound.noDataFound()
          :Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                reverse: true,
                itemCount: notification.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: (){
                        if(notification[index].type == 'conversation' || notification[index].type == 'Make Offer'|| notification[index].type == 'MakeOffer'){
                          if(notification[index].user!=null && notification[index].typeId!=null){
                            push(
                                context,
                                OfferChatScreen(
                                  userImgUrl: notification[index].user!.img ,
                                  conversationId: notification[index].typeId.toString(),
                                  title: notification[index].user!.name ?? '',
                                  recieverId: notification[index].user!.id!,
                                ));

                          }
                          else{
                            push(
                                context,
                                OfferChatScreen(
                                  conversationId: notification[index].typeId,
                                ));
                          }
                        }
                        else if(notification[index].type == 'Review'){
                          push(context, RatingScreen(
                            name: notification[index].user!.name,
                            sellerId: notification[index].user!.id.toString(),
                            img: notification[index].user!.img,
                            location: notification[index].user!.location,
                            // joinDate: notification[index].user!.createdAt,
                            productId: notification[index].typeId!.toString().split('0000')[1],

                          ));
                        }

                        else if(notification[index].type == 'auction'){
                          getBid(dio: dio, context: context, offerId: notification[index].typeId, markSold: false);
                        }

                        else if(notification[index].type == 'Auction Expire'){
                          push(context, RescheduleTimeProduct(
                            productId: notification[index].typeId.toString(),

                          ));                            }

                        else if(notification[index].text.toString().contains('higher bid to claim this product')){
                          getAuctionProductDetail(productId: notification[index].typeId);
                        }
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setStatess) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(32.0)),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: 346,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: AppTheme.whiteColor,
                                            borderRadius:
                                            BorderRadius.circular(32),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                AppText.appText(
                                                    'Confirm Delete',
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w700,
                                                    textColor: const Color(
                                                        0xff14181B)),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Container(
                                                  child: AppText.appText(
                                                      'Are you sure want to delete this notification',
                                                      textAlign:
                                                      TextAlign.center,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      textColor: const Color(
                                                          0xff14181B)),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                delLoading
                                                    ? CircularProgressIndicator(
                                                    color:
                                                    AppTheme.appColor)
                                                    : AppButton.appButton(
                                                    'Delete',
                                                    onTap: () async {
                                                      deleteHandler(
                                                          notification[index]
                                                              .id);

                                                      setStatess(() {});

                                                      await NotificationService()
                                                          .notificationService(
                                                          context:
                                                          context);
                                                      setStatess(() {});
                                                    },
                                                    height: 53,
                                                    fontSize: 14,
                                                    radius: 32.0,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    textColor:
                                                    AppTheme.whiteColor,
                                                    backgroundColor:
                                                    AppTheme.appColor),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                AppButton.appButton('Cancel',
                                                    onTap: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    height: 53,
                                                    fontSize: 14,
                                                    radius: 32.0,
                                                    border: true,
                                                    fontWeight: FontWeight.w500,
                                                    textColor:
                                                    AppTheme.blackColor,
                                                    backgroundColor:
                                                    AppTheme.whiteColor)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                });
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showCheck)
                                Checkbox(
                                  activeColor: AppTheme.appColor,
                                  value: checks[index],
                                  onChanged: (che) {
                                    setState(() {
                                      checks[index] = che!;
                                      if (che) {
                                        // Add the ID to checkBoxId when the checkbox is checked
                                        checkBoxId.add(notification[index].id!);
                                      } else {
                                        // Remove the ID from checkBoxId when the checkbox is unchecked
                                        checkBoxId.remove(notification[index].id!);
                                      }
                                      print('checkBoxId: $checkBoxId');
                                    });
                                  },
                                )
                              else
                                const SizedBox.shrink(),
                              Stack(
                                children: [
                                  Container(
                                    height: 60.w,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      color: getNotificationImage(index)=='product' || getNotificationImage(index)=='user' ? Colors.transparent : Colors.amber,
                                      image:  getNotificationImage(index)=='product' || getNotificationImage(index)=='user' ? DecorationImage(
                                        image: NetworkImage(getNotificationImage(index)=='product' ? notification[index].product!.imagePath!.src.toString() :  notification[index].user!.img!),
                                        fit: BoxFit.fill,
                                      ) : const DecorationImage(
                                        image: AssetImage('assets/images/gallery.png',
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  if(notification[index].product!=null)
                                  Positioned(
                                      bottom: 0,
                                      child: Container(
                                          height: 25.h,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16.r),
                                              bottomRight: Radius.circular(16.r),
                                            )
                                          ),
                                          child: Center(child: AppText.appText(notification[index].product!.productType == 'auction' ? "Auction" : "AED ${abbreviateNumber(notification[index].product!.fixPrice ?? '')}" ?? '', fontSize: 10.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textColor: Colors.white.withOpacity(0.85))))),
                                ],
                              ),
                              SizedBox(width: 11.w),
                            ],
                          ),


                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.appText(
                                    notification[index].text.toString(),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    textColor: Color(0xff1E293B)
                                ),
                                SizedBox(height: 3.h,),
                                AppText.appText(
                                  timeAgo(DateTime.parse(notification[index].createdAt!)),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  textColor: const Color(0xff878787),
                                ),
                              ],
                            ),
                          ),

                        ],
                      )

                  );
                }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 15.h,); },
              ),
            ],
          ),
        ),
      ),
    );
  }
  String messageTitle(String title) {
    if(title.contains("You have got a new message from")){
      return 'New Message';
    }
    else if(title.contains("rejected your bid")){
      return 'Bid Rejected';
    }
    else if(title.contains("placed a bid and it has reached your Final Price")){
      return 'Final Price Reached!';
    }
    else if(title.contains("placed a bid on your product")){
      return 'Bid Placed';
    }
    else if(title.contains("accepted your bid")){
      return 'Bid Accepted';
    }
    else if(title.contains("accepted your Offer")){
      return 'Offer Accepted';
    }
    else if(title.contains("rejected your Offer")){
      return 'Offer Rejected';
    }
    else if(title.contains("made an offer for your listed product")){
      return 'Offer Made';
    }
    else if(title.contains("is sold")){
      return 'Product Sold';
    }
    else if(title.contains("Review")){
      return 'Leave a Seller Review';
    }
    else if(title.contains("rating")){
      return 'Leave a Seller Review';
    }
    else if(title.contains("expire") || title.contains("expired")){
      return 'Auction Time Expired';
    }
    else{
      return title;
    }
  }



  String timeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds >= 1) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }


  Future<void> getOffer({
    offerId,
    required dio,
    required context,
  }) async {
    setState(() {
      pr.show();
      isLoading = true;
    });
    var response;
    var allOfferData;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": offerId,
    };
    try {
      response = await dio.post(path: AppUrls.getOffer, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        isLoading = false;
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        isLoading = false;
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        if(responseData["data"].isNotEmpty ) {
          allOfferData = responseData["data"];
          if(allOfferData["product"]["fix_price"] !=null) {
            getFeatureProductDetail(productId:allOfferData["product"]["id"]);
          }
          else{
            getAuctionProductDetail(productId:allOfferData["product"]["id"]);
          }
        }
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
    }
  }

  String getNotificationImage(int index){
    if(notification[index].product != null && notification[index].product!.imagePath!= null && notification[index].product!.imagePath!= null && notification[index].product!.imagePath!.src!= null){
      return 'product';
    }
    else if(notification[index].user != null && notification[index].user!.img != null && notification[index].user!.img != null && notification[index].user!.img != null){
      return 'user';
    }
    else{
      return 'default';
    }
  }

  Future<void> getBid({
    offerId,
    required bool markSold,
    required dio,
    required context,
  }) async {
    setState(() {
      pr.show();
      isLoading = true;
    });
    var response;
    var allOfferData;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": offerId,
    };
    try {
      response = await dio.post(path: AppUrls.getBid, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        isLoading = false;
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        isLoading = false;
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        setState(() {
        });
        if(responseData["data"].isNotEmpty ) {
          allOfferData = responseData["data"];
          getAuctionProductDetail(productId:allOfferData["product_id"] , markAsSold: markSold);


        }
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
    }
  }

  void getAuctionProductDetail({productId, limit, bool markAsSold = false}) async {

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
          if(detailResponse.isEmpty){
            showSnackBar(context, "Product no longer exists.");
          }
          else {
            if(markAsSold == false){
              push(context, AuctionInfoScreen(detailResponse: detailResponse[0]));}
            else{
              push(
                  context,
                  NewSoldScreen(
                    title: detailResponse[0]['title'],
                    productId: detailResponse[0]['id'].toString(),
                    fixPrice: detailResponse[0]['fix_price'],
                    auctionPrice: detailResponse[0]['auction_price'],
                    image: detailResponse[0]['photo']!=null && detailResponse[0]['photo'].isNotEmpty ? detailResponse[0]['photo'][0]['src'] : null,
                    auction: detailResponse[0]['fix_price'] != null ? false : true,
                    fromNotification: true,
                  ));
            }
          }


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
          if(detailResponse.isEmpty){
            showSnackBar(context, "The product is no longer available.");
          }
          else {
            push(context, FeatureInfoScreen(detailResponse: detailResponse[0]));
          }
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
