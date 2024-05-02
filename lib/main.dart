import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Controller/APIs%20Manager/chat_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/custom_requests/custom_get_request.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/firebase_options.dart';
import 'package:tt_offer/splash_screen.dart';
import 'package:tt_offer/views/Authentication%20screens/GoogleSignIn/google_signin_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

late SharedPreferences pref;
late CustomPostRequest customPostRequest;
late CustomGetRequest customGetRequest;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  pref = await SharedPreferences.getInstance();
  customPostRequest = CustomPostRequest();
  customGetRequest = CustomGetRequest();

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TT Offer',
        home: SplashScreen(),
      ),
    );
  }
}
