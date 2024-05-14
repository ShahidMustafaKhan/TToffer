import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/models/user_info_model.dart';

class ProfileInfoProvider extends ChangeNotifier {
  List<ProductsDataInfo> data = [];

  getProfileInfoProduct({required List<ProductsDataInfo> newData}) {
    data = newData;
    notifyListeners();
  }
}
