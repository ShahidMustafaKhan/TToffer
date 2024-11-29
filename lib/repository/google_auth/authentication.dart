import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:tt_offer/data/app_exceptions.dart';


class GoogleAuthRepository {

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
      if (kIsWeb) {
        // Web sign-in
        GoogleAuthProvider authProvider = GoogleAuthProvider();
       userCredential =
        await auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } else {
        // Mobile sign-in
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;

          // Handle new user logic if needed
          bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
          if (isNewUser) {
            // Perform actions for a new user
            if (kDebugMode) {
              print('New user signed in: ${user?.email}');
            }
          } else {
            // Existing user logic
            if (kDebugMode) {
              print('Existing user signed in: ${user?.email}');
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
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
}

