
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LoadingProvider extends ChangeNotifier {
  bool loading=false;
  
  
  changeLoadingStatus(bool value){
     loading = value;
     notifyListeners();
  }
  
}
