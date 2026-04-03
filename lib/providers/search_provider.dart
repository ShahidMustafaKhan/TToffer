import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/selling_serach_model.dart';

class SearchProvider extends ChangeNotifier {
  List<SearchData> selling = [];

  void getSellingData({required List<SearchData> newSelling}) {
    selling = newSelling;
    notifyListeners(); // Notify listeners when data changes
  }


}
