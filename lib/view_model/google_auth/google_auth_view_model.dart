import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/repository/google_auth/authentication.dart';
import '../../data/network/network_api_services.dart';
import '../../models/user_model.dart';
import '../login/login_view_model.dart';
import '../register/register_view_model.dart';
import '../services/session_manager/session_controller.dart';

class GoogleAuthViewModel extends ChangeNotifier{
  GoogleAuthRepository googleAuthRepository ;

  GoogleAuthViewModel({required this.googleAuthRepository});

  bool _isSigningIn = false;
  bool isAlready = false;
  UserCredential? userCredential;


  bool get isSigningIn => _isSigningIn;

  void setSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }

  bool _loading = false ;
  bool get loading => _loading ;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }


  authenticationThruGoogle() async {
    try {
      await googleAuthRepository.initializeFirebase();
      await googleAuthRepository.signInWithGoogle().then((value)
      {
        userCredential = value;
        isAlready = userCredential?.additionalUserInfo?.isNewUser ?? false;
      });
    }
    catch(e){
      throw AppException(e.toString());
    }
  }

  Future<void> signInWithGoogle(LoginViewModel loginViewModel, RegisterViewModel registerViewModel) async {
    try {
      setSigningIn(true);

      // Google authentication logic
      await authenticationThruGoogle();

      if(userCredential!=null){
          Map<String, dynamic> data = {
            "uid": "${userCredential!.credential?.token}",
            "email": userCredential!.user!.email,
            "display_name": userCredential!.user!.displayName,
            "photo_url": userCredential!.user!.photoURL,
            "provider_id": "google.com",
          };
          await authenticateThroughGoogle(data);
          setSigningIn(false);

      }
      else{
        throw AppException('Google Authentication Failed');
      }
    } catch (e) {
      throw AppException(e.toString());
    } finally {
      setSigningIn(false);
    }
  }


  Future<UserModel> authenticateThroughGoogle(dynamic data )async {
    try {
      setLoading(true);
      final response = await googleAuthRepository.authenticateThruGoogle(data);
      await SessionController().saveUserInPreference(response.data?.user, response.data?.token);
      await SessionController().getUserFromPreference();
      setLoading(false);
      return response.data!.user!;
    }catch(e){
      setLoading(false);
      throw AppException(e);
    }
  }



}