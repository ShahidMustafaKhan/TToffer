import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  static final DynamicLinkService _instance = DynamicLinkService._internal();

  factory DynamicLinkService() {
    return _instance;
  }

  DynamicLinkService._internal();

  // Method to create a dynamic link
  Future<String> createDynamicLink(String productId, String productType) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://ttoffer.page.link',  // Replace with your actual domain
      link: Uri.parse('https://ttoffer.page.link?productId=$productId&productType=$productType'),
      androidParameters: AndroidParameters(
        packageName: 'com.ttoffer.app',
        fallbackUrl: Uri.parse('https://play.google.com/store/apps/details?id=com.example.yourapp'),
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.ttoffer.app', // Replace with your iOS bundle ID
        appStoreId: 'your_app_store_id',  // Optional: replace with your App Store ID
      ),
    );

    final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }

// Method to handle incoming dynamic links
  void handleDynamicLinks(Function(String productId, String productType) onLinkFound) {
    // This handles when the app is opened with a dynamic link (foreground, background)
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
      final Uri deepLink = data.link;
      final productId = deepLink.queryParameters['productId'];
      final productType = deepLink.queryParameters['productType'];

      if (productId != null && productType != null) {
        onLinkFound(productId, productType);
      }
    }).onError((error) {
      print('Error in handling dynamic link: $error');
    });

    // This handles when the app is started with a dynamic link (cold start)
  }

}
