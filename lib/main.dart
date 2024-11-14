import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Controller/APIs%20Manager/cart_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/constants.dart';
import 'package:tt_offer/custom_requests/custom_get_request.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/custom_requests/firebase_messaging_service.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/firebase_options.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/sub_categories_model.dart';
import 'package:tt_offer/providers/bids_provider.dart';
import 'package:tt_offer/providers/chat_list_provider.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/providers/notification_provider.dart';
import 'package:tt_offer/providers/payment_fee_provider.dart';
import 'package:tt_offer/providers/profile_info_provider.dart';
import 'package:tt_offer/providers/screen_state_notifier.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/search_location_page.dart';
import 'package:tt_offer/splash_screen.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';
import 'package:tt_offer/views/Authentication%20screens/GoogleSignIn/google_signin_provider.dart';
import 'package:tt_offer/views/SearchPage/search_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'Controller/APIs Manager/banner_api.dart';
import 'Controller/loading_provider.dart';
import 'Utils/utils.dart';
import 'custom_requests/dynmaic_link_service.dart';

String? title;
String? imagePath;

String? location;

bool isAlready = false;
bool isRegister = false;

int? firstTimeProductId;
UserCredential? userCredential;

late SharedPreferences pref;
late CustomPostRequest customPostRequest;
late CustomGetRequest customGetRequest;
late AppDio dio;

bool? navigate;

bool? updateCharge;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);



  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      message.notification?.title == 'conversation' ? 'New Chat Message' :
      message.notification?.title == 'auction' && message.notification!.body!.contains('Final Price')  ? 'Final Price Reached!' :
      message.notification?.title == 'auction' && message.notification!.body!.contains('Final Price') == false  ? 'Bid Placed' :
      message.notification?.title == 'Customer Review' ? 'New Customer Rating' :
      message.notification?.title == 'Review' ? 'Pending Review' :
      message.notification?.title == 'MarkAsSold' ? 'Item Sold' :
      message.notification?.title == 'MakeOffer' ? 'New Offer Received' :
      message.notification?.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51O7mVXJayAXqf3Vq8gnj64IGw9woyYdaSUTgkdh07uYy22MN6qg8VEMzJZvhdV4HnANed3rqsN4crMBBy6CkH8eo00u6HHRwj0";
  //my "pk_test_51JUUldDdNsnMpgdhSlxjCo0yQBGHy9RsTQojb3YENwH5llfYiEmqqFjkc6SmsSQpLb9BH40OKQb0fwTlfifqJhFd00Cy7xTNwd";
  await Stripe.instance.applySettings();

  tz.initializeTimeZones();



  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }


  FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  pref = await SharedPreferences.getInstance();
  customPostRequest = CustomPostRequest();
  customGetRequest = CustomGetRequest();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    dio = AppDio(context);
    DynamicLinkService().handleDynamicLinks((productId,productType){
      if(productType == 'featured'){
        push(navigatorKey.currentContext
            , FeatureInfoScreen(fromDynamicLink: true, productId: productId.toString(),));
      }
      else if(productType == 'auction'){
        push(navigatorKey.currentContext
            , AuctionInfoScreen(fromDynamicLink: true, productId: productId.toString(),));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xfff6f6f6),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark
    ));
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_ , child) {
          return MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(
                create: (_) => GoogleSignInProvider()),
            ChangeNotifierProvider<NotifyProvider>(create: (_) => NotifyProvider()),
            ChangeNotifierProvider<ImageNotifyProvider>(
                create: (_) => ImageNotifyProvider()),
            ChangeNotifierProvider<ProductsApiProvider>(
                create: (_) => ProductsApiProvider()),
            ChangeNotifierProvider<ChatApiProvider>(
                create: (_) => ChatApiProvider()),
            ChangeNotifierProvider<ProfileApiProvider>(
                create: (_) => ProfileApiProvider()),
            ChangeNotifierProvider<NotificationProvider>(
                create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => SellingPurchaseProvider()),
            ChangeNotifierProvider(create: (_) => ChatListProvider()),
            ChangeNotifierProvider(create: (_) => ChatProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(create: (_) => BidsProvider()),
            ChangeNotifierProvider(create: (_) => ProfileInfoProvider()),
            ChangeNotifierProvider(create: (_) => PaymentFeeProvider()),
            ChangeNotifierProvider(create: (_) => CategoryProvider()),
            ChangeNotifierProvider(create: (_) => SubCategoriesProvider()),
            ChangeNotifierProvider(create: (_) => ScreenStateNotifier()),
            ChangeNotifierProvider(create: (_) => BannerController()),
            ChangeNotifierProvider(create: (_) => LoadingProvider()),
            ChangeNotifierProvider(create: (_) => CartApiProvider()),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'TT Offer',
            home: const SplashScreen(),
            // home: const SearchPageLocation(),
            // home:  TimeScreen(),
            // home:  CardHomeScreen(),
          ),
        );
      }
    );
  }
}
