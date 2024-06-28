import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/search_location_page.dart';
import 'package:tt_offer/splash_screen.dart';
import 'package:tt_offer/views/Authentication%20screens/GoogleSignIn/google_signin_provider.dart';
import 'package:tt_offer/views/SearchPage/search_page.dart';

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

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51O7mVXJayAXqf3Vq8gnj64IGw9woyYdaSUTgkdh07uYy22MN6qg8VEMzJZvhdV4HnANed3rqsN4crMBBy6CkH8eo00u6HHRwj0";
  //my "pk_test_51JUUldDdNsnMpgdhSlxjCo0yQBGHy9RsTQojb3YENwH5llfYiEmqqFjkc6SmsSQpLb9BH40OKQb0fwTlfifqJhFd00Cy7xTNwd";
  await Stripe.instance.applySettings();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) {
      log("initializeApp");
      runApp(const MyApp());
    });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessagingService().initialize();

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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
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
}
