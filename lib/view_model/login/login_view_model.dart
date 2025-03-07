import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../data/app_exceptions.dart';
import '../../models/user_model.dart';
import '../../repository/auth_api/auth_repository.dart';
import '../services/session_manager/session_controller.dart';


class LoginViewModel with ChangeNotifier {

  AuthRepository authRepository ;
  LoginViewModel({required this.authRepository});

  bool _loginLoading = false ;
  bool get loginLoading => _loginLoading ;

  setLoginLoading(bool value){
    _loginLoading = value;
    notifyListeners();
  }

  //creating getter method to store value of input email
  String _email = '' ;
  String get email => _email ;

  setEmail(String email){
    _email = email ;
  }

  //creating getter method to store value of input password
  String _password = '' ;
  String get password => _password ;

  setPassword(String password){
    _password = password ;
  }

  Future<UserModel> loginApiWithEmail(dynamic data) async {

    try {
      setLoginLoading(true);
      final response = await authRepository.loginApiWithEmail(data);
      await SessionController().saveUserInPreference(response.data?.user, response.data?.token);
      await SessionController().getUserFromPreference();
      setLoginLoading(false);
      return response.data!.user! ;
    }catch(e){
      setLoginLoading(false);
      throw AppException(e);
    }

  }

  Future<UserModel> loginApiWithPhone(dynamic data) async {

    try {
      setLoginLoading(true);
      final response = await authRepository.loginApiWithPhone(data);
      await SessionController().saveUserInPreference(response.data?.user, response.data?.token);
      await SessionController().getUserFromPreference();
      setLoginLoading(false);
      return response.data!.user!;
    }catch(e){
      setLoginLoading(false);
      throw AppException(e);
    }

  }

}