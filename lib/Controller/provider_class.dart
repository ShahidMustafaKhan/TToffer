import 'package:flutter/cupertino.dart';

class NotifyProvider extends ChangeNotifier {
  bool isCustom = false;
  bool field = false;
  bool sheet = false;
  final scrollController = ScrollController();
  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  String bidPrice = "";
  int? indexbid;

  openclose() {
    isCustom = !isCustom;
    notifyListeners();
  }

  bidPrices({price}) {
    bidPrice = price;
    field = false;

    notifyListeners();
  }

  index({index}) {
    indexbid = index;
    notifyListeners();
  }

  makeField() {
    field = true;
    notifyListeners();
  }

  sheetTrue() {
    sheet = true;
    scrollToTop();
    notifyListeners();
  }

  sheetFalse() {
    sheet = false;
    scrollToTop();
    notifyListeners();
  }
}
