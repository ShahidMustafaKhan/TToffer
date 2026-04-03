import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Controller/provider_class.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/custom_requests/custom_get_request.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/firebase_options.dart';
import 'package:tt_offer/providers/bids_provider.dart';
import 'package:tt_offer/providers/chat_list_provider.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/providers/payment_fee_provider.dart';
import 'package:tt_offer/providers/screen_state_notifier.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/repository/auth_api/auth_mock_repository.dart';
import 'package:tt_offer/repository/auth_api/auth_repository.dart';
import 'package:tt_offer/repository/banner_api/banner_mock_repository.dart';
import 'package:tt_offer/repository/banner_api/banner_repository.dart';
import 'package:tt_offer/repository/bids_api/bids_repository.dart';
import 'package:tt_offer/repository/cart_api/cart_mock_repository.dart';
import 'package:tt_offer/repository/cart_api/cart_repository.dart';
import 'package:tt_offer/repository/categories_api/categories_mock_repository.dart';
import 'package:tt_offer/repository/categories_api/categories_repository.dart';
import 'package:tt_offer/repository/chat_api/chat_mock_repository.dart';
import 'package:tt_offer/repository/chat_api/chat_repository.dart';
import 'package:tt_offer/repository/coupon_api/coupon_mock_repository.dart';
import 'package:tt_offer/repository/coupon_api/coupon_repository.dart';
import 'package:tt_offer/repository/google_auth/authentication.dart';
import 'package:tt_offer/repository/notification/notification_mock_repository.dart';
import 'package:tt_offer/repository/notification/notification_repository.dart';
import 'package:tt_offer/repository/offer_api/offer_repository.dart';
import 'package:tt_offer/repository/payment_api/payment_mock_repository.dart';
import 'package:tt_offer/repository/payment_api/payment_repository.dart';
import 'package:tt_offer/repository/product_api/get_product_api/get_product_mock_repository.dart';
import 'package:tt_offer/repository/product_api/get_product_api/get_product_repository.dart';
import 'package:tt_offer/repository/product_api/post_products_api/post_product_mock_repository.dart';
import 'package:tt_offer/repository/product_api/post_products_api/post_product_repository.dart';
import 'package:tt_offer/repository/profile_api/user_profile/profile_mock_repository.dart';
import 'package:tt_offer/repository/profile_api/user_profile/profile_repository.dart';
import 'package:tt_offer/repository/selling_api/selling_mock_repository.dart';
import 'package:tt_offer/repository/selling_api/selling_repository.dart';
import 'package:tt_offer/repository/suggestion_api/suggestion_mock_repository.dart';
import 'package:tt_offer/repository/suggestion_api/suggestion_repository.dart';
import 'package:tt_offer/repository/verification_api/verification_repository.dart';
import 'package:tt_offer/splash_screen.dart';
import 'package:tt_offer/view_model/bids/bids_view_model.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/category/category_view_model.dart';
import 'package:tt_offer/view_model/chat/chat_list_view_model/chat_list_view_model.dart';
import 'package:tt_offer/view_model/chat/chat_list_view_model/chat_view_model.dart';
import 'package:tt_offer/view_model/coupon/coupon_viewmodel.dart';
import 'package:tt_offer/view_model/google_auth/google_auth_view_model.dart';
import 'package:tt_offer/view_model/login/login_view_model.dart';
import 'package:tt_offer/view_model/notification/notification_view_model.dart';
import 'package:tt_offer/view_model/offer/offer_view_model.dart';
import 'package:tt_offer/view_model/payment/payment_view_model.dart';
import 'package:tt_offer/view_model/product/post_product/post_product_viewmodel.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';
import 'package:tt_offer/view_model/register/register_view_model.dart';
import 'package:tt_offer/view_model/selling/selling_view_model.dart';
import 'package:tt_offer/view_model/subscription/subscription_view_model.dart';
import 'package:tt_offer/view_model/suggestion/suggestion_view_model.dart';
import 'package:tt_offer/view_model/verification/verificaiton_view_model.dart';
import 'package:tt_offer/views/Authentication%20screens/GoogleSignIn/google_signin_provider.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';

import 'Controller/loading_provider.dart';
import 'Utils/utils.dart';
import 'custom_requests/dynmaic_link_service.dart';
import 'view_model/banner/banner_view_model.dart';

String? title;
String? imagePath;

String? location;

bool isAlready = false;
bool isRegister = false;
bool unAuthorized = false;

int? firstTimeProductId;

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
  showFlutterNotification(
      message); // If you're going to use other Firebase services in the background, such as Firestore,
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
      message.notification?.title == 'conversation'
          ? 'New Chat Message'
          : message.notification?.title == 'auction' &&
                  message.notification!.body!.contains('Final Price')
              ? 'Final Price Reached!'
              : message.notification?.title == 'auction' &&
                      message.notification!.body!.contains('Final Price') ==
                          false
                  ? 'Bid Placed'
                  : message.notification?.title == 'Customer Review'
                      ? 'New Customer Rating'
                      : message.notification?.title == 'Review'
                          ? 'Pending Review'
                          : message.notification?.title == 'MarkAsSold'
                              ? 'Item Sold'
                              : message.notification?.title == 'MakeOffer'
                                  ? 'New Offer Received'
                                  : message.notification?.title,
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

GetIt getIt = GetIt.instance;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  getIt.registerLazySingleton<AuthRepository>(() => AuthMockRepository());
  getIt.registerLazySingleton<GoogleAuthRepository>(
      () => GoogleAuthRepository());
  getIt.registerLazySingleton<PostProductRepository>(
      () => PostProductMockRepository());
  getIt.registerLazySingleton<ProductRepository>(() => ProductMockRepository());
  getIt.registerLazySingleton<BidsRepository>(() => BidsRepository());
  getIt.registerLazySingleton<OfferRepository>(() => OfferRepository());
  getIt.registerLazySingleton<CartRepository>(() => CartMockRepository());
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileMockRepository());
  getIt.registerLazySingleton<ChatRepository>(() => ChatMockRepository());
  getIt.registerLazySingleton<SellingRepository>(() => SellingMockRepository());
  getIt.registerLazySingleton<NotificationRepository>(
      () => NotificationMockRepository());
  getIt.registerLazySingleton<PaymentRepository>(() => PaymentMockRepository());
  getIt.registerLazySingleton<VerificationRepository>(
      () => VerificationRepository());
  getIt.registerLazySingleton<BannerRepository>(() => BannerMockRepository());
  getIt.registerLazySingleton<SuggestionRepository>(
      () => SuggestionMockRepository());
  getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryMockRepository());
  getIt.registerLazySingleton<CouponRepository>(() => CouponMockRepository());

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51KYostE8QrqFGDryFAGuteKleAUUz2lVDCM7RWCuSPPMj4A82H1fpaYoS3Za6yE12RHpPtXqtE9FWWBN0kmGB7bk00Gu3R9WRh";
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
    DynamicLinkService().handleDynamicLinks((productId, productType) {
      if (productType == 'featured') {
        push(
            navigatorKey.currentContext,
            FeatureInfoScreen(
              fromDynamicLink: true,
              productId: productId.toString(),
            ));
      } else if (productType == 'auction') {
        push(
            navigatorKey.currentContext,
            AuctionInfoScreen(
              fromDynamicLink: true,
              productId: productId.toString(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xfff6f6f6),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<GoogleSignInProvider>(
                  create: (_) => GoogleSignInProvider()),
              ChangeNotifierProvider<NotifyProvider>(
                  create: (_) => NotifyProvider()),
              ChangeNotifierProvider<ImageNotifyProvider>(
                  create: (_) => ImageNotifyProvider()),
              ChangeNotifierProvider(create: (_) => SellingPurchaseProvider()),
              ChangeNotifierProvider(create: (_) => ChatListProvider()),
              ChangeNotifierProvider(create: (_) => ChatProvider()),
              ChangeNotifierProvider(create: (_) => SearchProvider()),
              ChangeNotifierProvider(create: (_) => BidsProvider()),
              ChangeNotifierProvider(create: (_) => PaymentFeeProvider()),
              ChangeNotifierProvider(create: (_) => ScreenStateNotifier()),
              ChangeNotifierProvider(create: (_) => LoadingProvider()),
              ChangeNotifierProvider(
                  create: (_) => LoginViewModel(authRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => RegisterViewModel(authRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) =>
                      GoogleAuthViewModel(googleAuthRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) =>
                      PostProductViewModel(postProductRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => ProductViewModel(productRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => BidsViewModel(bidsRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => OfferViewModel(offerRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => CartViewModel(cartRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => UserViewModel(profileRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => ChatListViewModel(chatRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => SellingViewModel(sellingRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => ChatViewModel(chatRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) =>
                      NotificationViewModel(notificationRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => PaymentViewModel(paymentRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) =>
                      VerificationViewModel(verificationRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => BannerViewModel(bannerRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) =>
                      SuggestionViewModel(suggestionRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) =>
                      CategoryViewModel(categoryRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) =>
                      SubscriptionViewModel(paymentRepository: getIt())),
              ChangeNotifierProvider(
                  create: (_) => CouponViewModel(couponRepository: getIt())),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'TT Offer',
              theme: ThemeData(primaryColor: Colors.red),
              home: const SplashScreen(),
              // home: const SearchPageLocation(),
              // home:  TimeScreen(),
              // home:  CardHomeScreen(),
            ),
          );
        });
  }
}
