import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/views/Authentication%20screens/login_screen.dart';

import '../Constants/app_logger.dart';
import '../Controller/APIs Manager/notification_api.dart';
import '../config/app_urls.dart';
import '../config/dio/app_dio.dart';
import '../config/keys/pref_keys.dart';
import '../main.dart';
import '../providers/screen_state_notifier.dart';
import '../views/All Featured Products/feature_info.dart';
import '../views/Auction Info/auction_info.dart';
import '../views/Auction Info/reschdule_acution_time.dart';
import '../views/ChatScreens/offer_chat_screen.dart';
import '../views/Notification/notification_screen.dart';
import '../views/Sellings/new_sold_screen.dart';
import '../views/Sellings/rating_screen.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize(BuildContext context, AppDio dio) async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken().then((String? token) {
      print("Firebase Messaging Token: $token");
      if(token!=null){
      pref.setString('device-token' , token);}
    });

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (notificationResponse){

      List<String> parts = notificationResponse.payload!.split('/');

      String title = parts[0];
      String body = parts[1];
      String typeId = parts[2];

      navigateToScreen(title, body, typeId, context, dio);
    }
    );



    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        // Handle the message when the app is launched from a terminated state
        // _showNotification(message);
        navigateToScreen(message.notification!.title ?? '', message.notification!.body ?? '' , message.data['type_id'], context , dio);

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      bool isChatScreenActive =
          Provider.of<ScreenStateNotifier>(context, listen: false)
              .isChatScreenActive;
      NotificationService().notificationService(context: context);

      if(isChatScreenActive == true && message.notification?.title == 'conversation') {
      }
      else{
        _showNotification(message);
      }
    });






    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      navigateToScreen(message.notification!.title ?? '', message.notification!.body ?? '' , message.data['type_id'], context , dio);
    });

  }

  navigateToScreen(String title, String body, String typeId, BuildContext context, AppDio dio){

    String? authenticationToken = pref.getString(PrefKey.authorization);

    if(authenticationToken!=null){
      if(title == 'conversation' || title ==  'Make Offer' || title ==  'MakeOffer'){
        push(context, OfferChatScreen(
          conversationId: typeId,
        ));}
      // else if(title == 'MakeOffer'){
      //   getOffer(dio: dio, context: context, offerId: typeId);
      // }

      else if(title == 'auction'){
        getBid(dio: dio, context: context, offerId:  typeId,
            markSold: false);
      }

      else if(title.contains('Final Price')){
        getAuctionProductDetail(productId:  typeId, context: context);
      }

      else if(title  == 'Review'){
        push(context, RatingScreen(
          sellerId:typeId.split('0000')[0],
          productId:typeId.split('0000')[1],
        ));
      }

      else if (title == 'Auction Expire') {
        push(context, RescheduleTimeProduct(
          productId: typeId,
        ));
      }
    }
    else{
      if(title == 'auction'){
        getBid(dio: dio, context: context, offerId:  typeId,
            markSold: false);
      }

      else if(title.contains('Final Price')){
        getAuctionProductDetail(productId:  typeId, context: context);
      }

      else{
        push(context, const SigInScreen());

      }

    }



  }



  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,

    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title == 'conversation' ? 'New Chat Message' :
      message.notification?.title == 'auction' && message.notification!.body!.contains('Final Price')  ? 'Final Price Reached!' :
      message.notification?.title == 'auction' && message.notification!.body!.contains('Final Price') == false  ? 'Bid Placed' :
      message.notification?.title == 'Customer Review' ? 'New Customer Rating' :
      message.notification?.title == 'Review' ? 'Pending Review' :
      message.notification?.title == 'MarkAsSold' ? 'Item Sold' :
      message.notification?.title == 'MakeOffer' ? 'New Offer Received' :
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: '${message.notification?.title}/${message.notification?.body}/${message.data['type_id']}',

    );


  }


  Future<void> getBid({
    offerId,
    required dio,
    required context,
    required bool markSold,
  }) async {

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
      } else if (response.statusCode == responseCode401) {
      } else if (response.statusCode == responseCode404) {

      } else if (response.statusCode == responseCode500) {

      } else if (response.statusCode == responseCode422) {
      } else if (response.statusCode == responseCode200) {
        if(responseData["data"].isNotEmpty ) {
          allOfferData = responseData["data"];
          getAuctionProductDetail(productId:allOfferData["product_id"], context: context,  markAsSold: markSold);

        }
      }
    } catch (e) {
      showSnackBar(context, "Something went Wrong.");
    }
  }

  void getAuctionProductDetail({productId, limit, context, bool markAsSold = false}) async {

    push(context, AuctionInfoScreen(productId: productId.toString() , fromDynamicLink: true,));
  }

  void getFeatureProductDetail({productId, limit, context}) async {

    push(context, FeatureInfoScreen(productId: productId.toString() , fromDynamicLink: true,));

  }
  
}
