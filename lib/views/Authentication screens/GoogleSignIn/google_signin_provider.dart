import 'package:flutter/foundation.dart';

class GoogleSignInProvider extends ChangeNotifier{
  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  void setSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }
}