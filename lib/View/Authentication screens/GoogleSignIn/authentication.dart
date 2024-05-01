
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/View/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // User? user = FirebaseAuth.instance.currentUser;
    // // print("usr_id ${user?.uid}  ${user.uid}");
    // if (user != null) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => const UserProfileScreen(
    //           // user: user,
    //           ),
    //     ),
    //   );sh
    // }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      print("kiswebmelfff");

      final GoogleSignIn googleSignIn = GoogleSignIn();
             print("object Signin");
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        print("nk4fn4nfk43kfk4nnf;");
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
          String? userEmail = user?.email;
          bool newUser = userCredential.additionalUserInfo!.isNewUser;
          String? displayName = user?.displayName;
          print(
              "This is the UID: ${user!.uid} newuser $newUser name $displayName");

          print("getting_user_date of birth ${user} credentials ${credential}");
        }
         on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop();
      pushReplacement(context, const SigInScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}

// void login({
//   required String userId,
//   context,
//   required bool isNewUser,
//   required String name,
//   required String email,
// }) async {
//   var response;
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<String> dietaryRestrictionsList = [];
//   List<String> allergiesList = [];
//   const int responseCode200 = 200; // For successful request.
//   const int responseCode400 = 400; // For Bad Request.
//   const int responseCode401 = 401; // For Unauthorized access.
//   const int responseCode404 = 404; // For For data not found
//   const int responseCode500 = 500; // Internal server error.

//   Map<String, dynamic> params = {
//     "google": userId,
//   };
//   try {
//     response = await AppDio(context).post(path: AppUrls.loginUrl, data: params);
//     var responseData = response.data;
//     if (response.statusCode == responseCode404) {
//       showSnackBar(context, "${responseData["message"]}");
//     } else if (response.statusCode == responseCode400) {
//       print(" Bad Request.");
//       showSnackBar(context, "${responseData["message"]}");
//     } else if (response.statusCode == responseCode401) {
//       print(" Unauthorized access.");
//       showSnackBar(context, "${responseData["message"]}");
//     } else if (response.statusCode == responseCode500) {
//       print("Internal server error.");
//       showSnackBar(context, "${responseData["message"]}");
//     } else if (response.statusCode == responseCode200) {
//       if (responseData["status"] == false) {
//         if(responseData["data"]["statusCode"] ==  403){
//           alertDialogErrorBan(context: context,message:"${responseData["message"]}");
//         }else{
//           showSnackBar(context, "${responseData["message"]}");
//           return;
//         }

//       } else {
//         var token = responseData['data']['token'];
//         var username = responseData['data']['user']['name'];
//         var usermail = responseData['data']['user']['email'];
//         var id = responseData['data']['user']['id'];
//         var DOB = responseData['data']['user']['DOB']??"";
//         var measuringUnit = responseData['data']['user']['measuring_unit'];
//         var dietary_restrictions =
//             responseData['data']['user']['dietary_restrictions'];
//         var allergies = responseData['data']['user']['allergies'];
//         for (var data0 in dietary_restrictions) {
//           dietaryRestrictionsList.addAll({'${data0['id']}:${data0['name']}'});
//         }
//         for (var data0 in allergies) {
//           allergiesList.addAll({'${data0['id']}:${data0['name']}'});
//         }
//         prefs.setStringList(PrefKey.dataonBoardScreenAllergies, allergiesList);
//         prefs.setStringList(PrefKey.dataonBoardScreenDietryRestriction,
//             dietaryRestrictionsList);
//         prefs.setString(PrefKey.authorization, token ?? '');
//         prefs.setString(PrefKey.userName, username ?? name);
//         prefs.setString(PrefKey.id, id ?? "");
//         prefs.setString(PrefKey.email, usermail ?? email);
//         prefs.setString(PrefKey.unit, measuringUnit);
//         prefs.setString(PrefKey.socialId, userId);

//         if (isNewUser) {
//           pushReplacement(context, const UserProfileScreen());
//         } else {
//           prefs.setInt(PrefKey.conditiontoLoad, 1);
//           pushReplacement(
//               context,
//               BottomNavView(
//                 type: 0,
//                 allergies: allergiesList,
//                 dietaryRestrictions: dietaryRestrictionsList,
//               ));
//         }
//         prefs.setString(PrefKey.dateOfBirth, DOB);
//         showSnackBar(context, "${responseData["message"]}");
//       }
//     }
//   } catch (e) {
//     print("Something went Wrong ${e}");
//     // showSnackBar(context, "Something went Wrong.");
//   }
// }
