import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import '../../../data/response/api_response.dart';
import '../../Utils/widgets/others/delete_notification_dialog.dart';
import '../../data/app_exceptions.dart';
import '../../models/product_model.dart';
import '../../models/selling_products_model.dart';
import '../../repository/selling_api/selling_repository.dart';


class SellingViewModel with ChangeNotifier {

  SellingRepository sellingRepository ;
  SellingViewModel({required this.sellingRepository});


  ApiResponse<List<Product>> selling = ApiResponse.loading();

  setSellingProduct(ApiResponse<List<Product>> response){
    selling = response ;
    notifyListeners();
  }

  ApiResponse<List<Product>> buying = ApiResponse.loading();

  setBuyingProduct(ApiResponse<List<Product>> response){
    buying = response ;
    notifyListeners();
  }

  ApiResponse<List<Product>> history = ApiResponse.loading();

  setHistoryProduct(ApiResponse<List<Product>> response){
    history = response ;
    notifyListeners();
  }

  bool _markSoldLoading = false ;
  bool get markSoldLoading => _markSoldLoading ;

  setMarkSoldLoading(bool value){
    _markSoldLoading = value;
    notifyListeners();
  }




  Future<void> getSellingProduct() async {
    try {

      final response = await sellingRepository.getSellingProducts() ;

      setSellingProduct(ApiResponse.completed(response.data?.selling?.data ?? []));
      setBuyingProduct(ApiResponse.completed(response.data?.buying?.data ?? []));
      setHistoryProduct(ApiResponse.completed(response.data?.history?.data ?? []));

    } catch(e){

      setSellingProduct(ApiResponse.error(e.toString()));
      setBuyingProduct(ApiResponse.error(e.toString()));
      setHistoryProduct(ApiResponse.error(e.toString()));

      log("selling api ${e.toString()} ");
      log("selling api ${e.toString()} ");
    }

  }


  Future<void> markSoldProductApi(int? buyerId, int? productId) async {

    setMarkSoldLoading(true);
    try {

      dynamic data = {
        'product_id' : productId,
        if(buyerId != null)
        'buyer_id' : buyerId,
      };

      await sellingRepository.markSold(data);
      setMarkSoldLoading(false);


    } catch(e){
      
      log("selling api ${e.toString()} ");
      log("selling api ${e.toString()} ");
      setMarkSoldLoading(false);

      throw AppException(e.toString());

    }

  }


  Future<void> markSoldProduct(int? buyerId, int? productId , BuildContext context, Function() then)async {
    CustomAlertDialog(
      title: "Update Item Status",
      description: "Do you want mark item as sold ?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes, Mark as sold",
      context: context,
      loading: false,

      onTap: () async {

        markSoldProductApi(buyerId, productId).then((value){
          Navigator.of(context).pop();
          showSnackBar(context, "Congratulations! Your item has been sold.", title: 'Congratulations!');
          then();
        }).onError((error, stackTrace){
          Navigator.of(context).pop();
          showSnackBar(context, error.toString());
        });

      },
    );
  }










}