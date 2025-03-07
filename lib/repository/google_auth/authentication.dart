import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:tt_offer/data/app_exceptions.dart';

import '../../config/app_urls.dart';
import '../../data/network/network_api_services.dart';
import '../../models/authentication_model.dart';


class GoogleAuthRepository {

  final _apiServices = NetworkApiService() ;


  Future<FirebaseApp> initializeFirebase(
  ) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  Future<UserCredential?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential? userCredential;
    User? user;

    try {
      // Mobile sign-in
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      debugPrint('GoogleSignInAccount: $googleSignInAccount');

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        debugPrint(
            'GoogleSignInAuthentication: AccessToken=${googleSignInAuthentication.accessToken}, IdToken=${googleSignInAuthentication.idToken}');

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        debugPrint('AuthCredential: $credential');

        userCredential = await auth.signInWithCredential(credential);

        debugPrint('UserCredential: ${userCredential.toString()}');

        user = userCredential.user;

        debugPrint('User: ${user?.toString()}');

        // Handle new user logic if needed
        bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        if (isNewUser) {
          // Perform actions for a new user
          debugPrint('New user signed in: ${user?.email}');
        } else {
          // Existing user logic
          debugPrint('Existing user signed in: ${user?.email}');
        }
      } else {
        debugPrint('GoogleSignInAccount is null. User canceled the sign-in.');
      }
    }
    on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      if (e.code == 'account-exists-with-different-credential') {
        throw AppException(
          'The account already exists with a different credential.',
        );
      } else if (e.code == 'invalid-credential') {
        throw AppException(
          'Error occurred while accessing credentials. Try again.',
        );
      } else {
        throw AppException('FirebaseAuthException: ${e.message}');
      }
    } catch (e) {
      // Handle any other exceptions
      throw AppException('FirebaseAuthException: An error occurred. Please try again');

    }

    return userCredential;
  }


  Future<AuthenticationModel> authenticateThruGoogle(dynamic data )async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.googleAuthentication, data);
    return AuthenticationModel.fromJson(response) ;
  }
}

