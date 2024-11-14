import 'package:flutter/material.dart';

class ScreenStateNotifier extends ChangeNotifier {
  bool _isChatScreenActive = false;

  bool get isChatScreenActive => _isChatScreenActive;

  void setChatScreenActive(bool isActive) {
    _isChatScreenActive = isActive;
    notifyListeners();
  }
}
