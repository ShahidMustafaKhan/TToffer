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
import 'package:tt_offer/custom_requests/custom_get_request.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/firebase_options.dart';
import 'package:tt_offer/providers/chat_list_provider.dart';
import 'package:tt_offer/providers/notification_provider.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/splash_screen.dart';
import 'package:tt_offer/views/Authentication%20screens/GoogleSignIn/google_signin_provider.dart';

late SharedPreferences pref;
late CustomPostRequest customPostRequest;
late CustomGetRequest customGetRequest;
late AppDio dio;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51JUUldDdNsnMpgdhSlxjCo0yQBGHy9RsTQojb3YENwH5llfYiEmqqFjkc6SmsSQpLb9BH40OKQb0fwTlfifqJhFd00Cy7xTNwd";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

        //
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TT Offer',
        home: SplashScreen(),
      ),
    );
  }
}
