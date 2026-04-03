import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/no_data_found.dart';
import 'package:tt_offer/custom_requests/notification_delete_request.dart';
import 'package:tt_offer/models/notifications_model.dart';
import 'package:tt_offer/view_model/notification/notification_view_model.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/views/Products/Auction%20Product/widgets/reschdule_acution_time.dart';

import '../../Constants/app_logger.dart';
import '../../config/dio/app_dio.dart';
import '../../config/keys/pref_keys.dart';
import '../../main.dart';
import '../ChatScreens/offer_chat_screen.dart';
import '../Rating/user_rating_screen.dart';

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

    await Provider.of<NotificationViewModel>(context, listen: false)
        .getNotifications();

    setState(() {
      loading = false;
    });

    notification = Provider.of<NotificationViewModel>(context, listen: false)
        .notifications;
    checks = List.generate(notification.length, (index) => false);
    Provider.of<NotificationViewModel>(context, listen: false)
        .changeAllNotificationStatus(notification, context);

    setState(() {});
  }

  getNotificationHandlerWithoutLoader() async {
    await Provider.of<NotificationViewModel>(context, listen: false)
        .getNotifications();

    notification = Provider.of<NotificationViewModel>(context, listen: false)
        .notifications;
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

    String? authorizationToken = pref.getString(PrefKey.authorization);

    getUserId();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (authorizationToken != null) {
        getNotificationHandler();
      }
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
    userId = pref.getString(PrefKey.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        title: AppText.appText('Notifications',
            fontSize: 16.sp, textColor: const Color(0xff1E293B)),
        centerTitle: true,
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
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
          : notification.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: NoDataFound.noDataFound(
                            spacer: 0, bottomPadding: 70.h)),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 18),
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
                                onTap: () {
                                  if (notification[index].type ==
                                          'conversation' ||
                                      notification[index].type ==
                                          'Make Offer' ||
                                      notification[index].type == 'MakeOffer') {
                                    if (notification[index].user != null &&
                                        notification[index].typeId != null) {
                                      push(
                                          context,
                                          OfferChatScreen(
                                            participantModel:
                                                notification[index].user,
                                            product:
                                                notification[index].product,
                                            conversationId: notification[index]
                                                .typeId
                                                .toString(),
                                            receiverId:
                                                notification[index].user!.id!,
                                          ));
                                    } else {
                                      push(
                                          context,
                                          OfferChatScreen(
                                            participantModel:
                                                notification[index].user,
                                            product:
                                                notification[index].product,
                                            conversationId: notification[index]
                                                .typeId
                                                .toString(),
                                          ));
                                    }
                                  } else if (notification[index].type ==
                                      'auction') {
                                    getProductDetail(
                                      productId: notification[index].typeId,
                                    );
                                  } else if (notification[index].type ==
                                      'auction_final_price') {
                                    getProductDetail(
                                      productId:
                                          notification[index].product?.id,
                                    );
                                  } else if (notification[index].type ==
                                      'MarkAsSold') {
                                    getProductDetail(
                                      productId:
                                          notification[index].product?.id,
                                    );
                                  } else if (notification[index].type ==
                                      'Auction Expire') {
                                    push(
                                        context,
                                        RescheduleTimeProduct(
                                          productId: notification[index]
                                              .typeId
                                              .toString(),
                                        ));
                                  } else if (notification[index]
                                      .text
                                      .toString()
                                      .contains(
                                          'higher bid to claim this product')) {
                                    getProductDetail(
                                        productId: notification[index].typeId);
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
                                                    BorderRadius.circular(
                                                        32.0)),
                                            child: SingleChildScrollView(
                                              child: Container(
                                                height: 346,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20.0),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      AppText.appText(
                                                          'Confirm Delete',
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          textColor:
                                                              const Color(
                                                                  0xff14181B)),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      Container(
                                                        child: AppText.appText(
                                                            'Are you sure want to delete this notification',
                                                            textAlign: TextAlign
                                                                .center,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            textColor:
                                                                const Color(
                                                                    0xff14181B)),
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      delLoading
                                                          ? CircularProgressIndicator(
                                                              color: AppTheme
                                                                  .appColor)
                                                          : AppButton.appButton(
                                                              'Delete',
                                                              onTap: () async {
                                                              deleteHandler(
                                                                  notification[
                                                                          index]
                                                                      .id);

                                                              setStatess(() {});

                                                              await Provider.of<
                                                                          NotificationViewModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getNotifications();
                                                              setStatess(() {});
                                                            },
                                                              height: 53,
                                                              fontSize: 14,
                                                              radius: 32.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor: AppTheme
                                                                  .whiteColor,
                                                              backgroundColor:
                                                                  AppTheme
                                                                      .appColor),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      AppButton.appButton(
                                                          'Cancel', onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                          height: 53,
                                                          fontSize: 14,
                                                          radius: 32.0,
                                                          border: true,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          textColor: AppTheme
                                                              .blackColor,
                                                          backgroundColor:
                                                              AppTheme
                                                                  .whiteColor)
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
                                                  checkBoxId.add(
                                                      notification[index].id!);
                                                } else {
                                                  // Remove the ID from checkBoxId when the checkbox is unchecked
                                                  checkBoxId.remove(
                                                      notification[index].id!);
                                                }
                                                print(
                                                    'checkBoxId: $checkBoxId');
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
                                                color: notification[index]
                                                            .user
                                                            ?.img !=
                                                        null
                                                    ? Colors.transparent
                                                    : Colors.amber,
                                                image: notification[index]
                                                            .user
                                                            ?.img !=
                                                        null
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                            notification[index]
                                                                .user!
                                                                .img!),
                                                        fit: BoxFit.fill,
                                                      )
                                                    : const DecorationImage(
                                                        image: AssetImage(
                                                          'assets/images/gallery.png',
                                                        ),
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 9.w),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText.appText(
                                              notification[index]
                                                  .text
                                                  .toString(),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              textColor:
                                                  const Color(0xff1E293B)),
                                          if (notification[index].type !=
                                              'Seller Review') ...[
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            AppText.appText(
                                              timeAgo(DateTime.parse(
                                                  notification[index]
                                                      .createdAt!)),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              textColor:
                                                  const Color(0xff878787),
                                            )
                                          ] else ...[
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Row(
                                              children: [
                                                AppButton.appButton('Proceed',
                                                    onTap: () {
                                                  push(
                                                      context,
                                                      UserRatingScreen(
                                                        userModel:
                                                            notification[index]
                                                                .user,
                                                        id: notification[index]
                                                            .fromUserId
                                                            .toString(),
                                                        productId:
                                                            notification[index]
                                                                .typeId
                                                                ?.toString()
                                                                .split(
                                                                    '0000')[1],
                                                      ));
                                                },
                                                    backgroundColor:
                                                        AppTheme.appColor,
                                                    textColor: Colors.white,
                                                    fontSize: 12.sp,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.w,
                                                            vertical: 1.h)),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                AppButton.appButton('Skip',
                                                    onTap: () {
                                                  NotificationDeleteRequest()
                                                      .notificationDeleteRequest(
                                                          context: context,
                                                          notificationId:
                                                              notification[
                                                                      index]
                                                                  .id);
                                                  notification.removeAt(index);
                                                  setState(() {});
                                                },
                                                    backgroundColor:
                                                        AppTheme.disableColor,
                                                    borderColor:
                                                        AppTheme.disableColor,
                                                    textColor: Colors.white,
                                                    fontSize: 12.sp,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 1.h))
                                              ],
                                            )
                                          ]
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 60.w,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                            color: notification[index]
                                                        .product
                                                        ?.photo
                                                        ?.isNotEmpty ??
                                                    false
                                                ? Colors.transparent
                                                : Colors.amber,
                                            image: notification[index]
                                                        .product
                                                        ?.photo
                                                        ?.isNotEmpty ??
                                                    false
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        notification[index]
                                                            .product!
                                                            .photo![0]
                                                            .url!),
                                                    fit: BoxFit.fill,
                                                  )
                                                : const DecorationImage(
                                                    image: AssetImage(
                                                      'assets/images/gallery.png',
                                                    ),
                                                  ),
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                          ),
                                        ),
                                        if (notification[index].product != null)
                                          Positioned(
                                              bottom: 0,
                                              child: Container(
                                                  height: 25.h,
                                                  width: 60.w,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black38,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                16.r),
                                                        bottomRight:
                                                            Radius.circular(
                                                                16.r),
                                                      )),
                                                  child: Center(
                                                      child: AppText.appText(
                                                          productPriceForImage(
                                                              notification[
                                                                      index]
                                                                  .product),
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          textAlign:
                                                              TextAlign.center,
                                                          textColor: Colors
                                                              .white
                                                              .withOpacity(
                                                                  0.85))))),
                                      ],
                                    ),
                                  ],
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 23.h,
                              child: const Center(
                                  child: Divider(
                                color: Color(0xfff0eeee),
                              )),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  String messageTitle(String title) {
    if (title.contains("You have got a new message from")) {
      return 'New Message';
    } else if (title.contains("rejected your bid")) {
      return 'Bid Rejected';
    } else if (title
        .contains("placed a bid and it has reached your Final Price")) {
      return 'Final Price Reached!';
    } else if (title.contains("placed a bid on your product")) {
      return 'Bid Placed';
    } else if (title.contains("accepted your bid")) {
      return 'Bid Accepted';
    } else if (title.contains("accepted your Offer")) {
      return 'Offer Accepted';
    } else if (title.contains("rejected your Offer")) {
      return 'Offer Rejected';
    } else if (title.contains("made an offer for your listed product")) {
      return 'Offer Made';
    } else if (title.contains("is sold")) {
      return 'Product Sold';
    } else if (title.contains("Review")) {
      return 'Leave a Seller Review';
    } else if (title.contains("rating")) {
      return 'Leave a Seller Review';
    } else if (title.contains("expire") || title.contains("expired")) {
      return 'Auction Time Expired';
    } else {
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

  void getProductDetail({productId}) async {
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);
    productViewModel.navigateToProductPage(
        productId is String ? int.parse(productId) : productId, context);
  }
}
