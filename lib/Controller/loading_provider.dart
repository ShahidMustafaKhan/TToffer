import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/main.dart';

class LoadingProvider extends ChangeNotifier {
  bool loading=false;
  
  
  changeLoadingStatus(bool value){
     loading = value;
     notifyListeners();
  }
  
}
