import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../data/app_exceptions.dart';
import '../../models/user_model.dart';
import '../../repository/auth_api/auth_repository.dart';
import '../services/session_manager/session_controller.dart';


class RegisterViewModel with ChangeNotifier {

  AuthRepository authRepository ;
  RegisterViewModel({required this.authRepository});

  bool _registerLoading = false ;
  bool get registerLoading => _registerLoading ;

  setRegisterLoading(bool value){
    _registerLoading = value;
    notifyListeners();
  }
  

  Future<UserModel> registerApi(dynamic data) async {

    try {
      setRegisterLoading(true);
      final response = await authRepository.registerApi(data);
      await SessionController().saveUserInPreference(response.data?.user, response.data?.token);
      await SessionController().getUserFromPreference();
      setRegisterLoading(false);
      return response.data!.user!;
    }catch(e){
      setRegisterLoading(false);
      throw AppException(e);
    }

  }


}