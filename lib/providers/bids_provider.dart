import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/bids_model.dart';

class BidsProvider extends ChangeNotifier {
  List<BidsData> bids = [];

  getBids({required List<BidsData> newBids}) {
    bids = newBids;
    notifyListeners();
  }
}
