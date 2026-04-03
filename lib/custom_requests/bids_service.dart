import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/providers/bids_provider.dart';


class BidsService {


  Future getBidsService({required BuildContext context,required int  productId}) async {
    try {
      Map<String, dynamic> body = {'product_id': productId};

      var res = await customPostRequest.httpPostRequest(url: 'get-placed-bids', body: body);

      if (res['success'] == true) {
        BidsModel bidsModel = BidsModel.fromJson(res);
        Provider.of<BidsProvider>(context, listen: false)
            .getBids(newBids: bidsModel.data!);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
