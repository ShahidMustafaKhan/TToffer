import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/repository/verification_api/verification_repository.dart';



class VerificationViewModel with ChangeNotifier {

  VerificationRepository verificationRepository ;
  VerificationViewModel({required this.verificationRepository});



  bool _loading = false ;
  bool get loading => _loading ;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }




  Future<void> verifyEmail(String? email) async {

    setLoading(true);

    dynamic data = {
      "email" : email
    };

    try {
      final response = await verificationRepository.verifyEmail(data);
      setLoading(false);
      return response;

    } catch(e){
      setLoading(false);
      log("verify email ${e.toString()} ");
      log("verify email ${e.toString()} ");
      throw AppException(e.toString());

    }

  }

  Future<void> verifyEmailOtp(String? email, int? otp) async {

    setLoading(true);

    dynamic data = {
      "email" : email,
      "otp" : otp
    };

    try {
      final response = await verificationRepository.verifyEmailOtp(data);
      setLoading(false);
      return response;

    } catch(e){
      setLoading(false);
      log("verify email OTP ${e.toString()} ");
      log("verify email OTP ${e.toString()} ");
      throw AppException(e.toString());

    }

  }

  Future<void> forgetPasswordEmailVerification(String? email) async {

    setLoading(true);

    dynamic data = {
      "email" : email
    };

    try {
      final response = await verificationRepository.forgetPasswordEmailVerification(data);
      setLoading(false);
      return response;

    } catch(e){
      setLoading(false);
      log("forget password verify email ${e.toString()} ");
      log("forget password verify email ${e.toString()} ");
      throw AppException(e.toString());

    }

  }

  Future<void> forgetPasswordEmailOtpVerification(String? email, int? otp) async {

    setLoading(true);

    dynamic data = {
      "email" : email,
      "code" : otp
    };

    try {
      final response = await verificationRepository.forgetPasswordEmailOtpVerification(data);
      setLoading(false);
      return response;

    } catch(e){
      setLoading(false);
      log("forget password OTP ${e.toString()} ");
      log("forget passwordOTP ${e.toString()} ");
      throw AppException(e.toString());
    }

  }

  Future<void> resetPassword(String? email, String? password, String? confirmPassword) async {

    setLoading(true);

    dynamic data = {
      "email" : email,
      "password" : password,
      "password_confirmation" : confirmPassword
    };

    try {
      final response = await verificationRepository.resetPassword(data);
      setLoading(false);
      return response;

    } catch(e){
      setLoading(false);
      log("resetPassword ${e.toString()} ");
      log("resetPassword ${e.toString()} ");
      throw AppException(e.toString());

    }

  }














}