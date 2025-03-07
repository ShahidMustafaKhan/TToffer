import 'dart:developer';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../data/app_exceptions.dart';
import '../../../data/response/api_response.dart';
import '../../../main.dart';
import '../../../models/inventory_model.dart';
import '../../../models/product_model.dart';
import '../../../repository/product_api/get_product_api/get_product_repository.dart';



class ProductViewModel with ChangeNotifier {

  ProductRepository productRepository ;
  ProductViewModel({required this.productRepository});


  ApiResponse<ProductModel> featureProductList = ApiResponse.loading();

  setFeatureProduct(ApiResponse<ProductModel> response){
    featureProductList = response ;
    notifyListeners();
  }

  ApiResponse<ProductModel> auctionProductList = ApiResponse.loading();

  setAuctionProduct(ApiResponse<ProductModel> response){
    auctionProductList = response ;
    notifyListeners();
  }

  bool _searchLoading = false ;
  bool get searchLoading => _searchLoading ;

  setSearchLoading(bool value){
    _searchLoading = value;
    notifyListeners();
  }

  ApiResponse<ProductModel> searchProductList = ApiResponse.notStarted();

  setSearchProduct(ApiResponse<ProductModel> response){
    searchProductList = response ;
    notifyListeners();
  }

  resetSearchProducts(){
    if(searchProductList.data?.data?.productList?.isNotEmpty ?? false){
    searchProductList = ApiResponse.notStarted();
    notifyListeners();
    }
  }

  bool _loading = false ;
  bool get loading => _loading ;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool _productDetailLoading = false ;
  bool get productDetailLoading => _productDetailLoading ;

  setProductDetailLoading(bool value){
    _productDetailLoading = value;
    notifyListeners();
  }

  bool _extendTimeLoading = false ;
  bool get extendTimeLoading => _extendTimeLoading ;

  setExtendTimeLoading(bool value){
    _extendTimeLoading = value;
    notifyListeners();
  }



  Future<void> getAuctionProducts() async {

    try {
      Map<String, dynamic> data = {
        "sort_by": "newest on top"
      };
      final response = await productRepository.getAuctionProducts(data);

      setAuctionProduct(ApiResponse.completed(response));

    } catch(e){

      if(auctionProductList.data?.data?.productList?.isEmpty ?? true){
        setAuctionProduct(ApiResponse.error(e.toString()));
      }
    }

  }

  Future<void> getFeatureProducts() async {
    try {
      Map<String, dynamic> data = {
        "sort_by": "newest on top"
      };

      final response = await productRepository.getFeatureProducts(data);
      setFeatureProduct(ApiResponse.completed(response));

    }catch(e){

      log(e.toString());


      if(featureProductList.data?.data?.productList?.isEmpty ?? true){
        setFeatureProduct(ApiResponse.error(e.toString()));
      }
    }

  }


  Future<void> searchAllProducts({search}) async {

    Map<String, dynamic> data = {
      "search": search,
    };

    try {
      setSearchProduct(ApiResponse.loading());
      final response = await productRepository.getAllProducts(data);


      setSearchProduct(ApiResponse.completed(response));
    } catch(e){
      setSearchProduct(ApiResponse.error(e.toString()));
    }

  }

  Future<dynamic> rescheduleAuctionTime (dynamic data) async {

    setExtendTimeLoading(true);


    try {
      final response = await productRepository.rescheduleAuctionTime(data);
      setExtendTimeLoading(false);
      return response;

    } catch(e){
      setExtendTimeLoading(false);
      log("reschedule ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<dynamic> submitProductReport(dynamic data) async {

    setLoading(true);

    try {
      final response = await productRepository.productReportApi(data);
      setLoading(false);
      return response;

    } catch(e){
      log("report product ${e.toString()}");
      setLoading(false);
      throw AppException(e.toString());
    }

  }



  Future<Product?> getProductDetails (int? productId) async {

    setProductDetailLoading(true);

    Map<String, dynamic> data = {
      "product_id": productId,
    };

    try {
      final response = await productRepository.getProductDetails(data);
      setProductDetailLoading(false);
      return response.product;

    } catch(e){
      setProductDetailLoading(false);
      log("detail product ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<void> navigateToProductPage(int? productId, BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    try{
      pr.show();

      Product? product = await getProductDetails(productId);

      pr.dismiss();

      if(product!=null){
        if(product.productType == 'auction'){
          push(context, AuctionInfoScreen(product: product,));
        }
        else{
          push(context, FeatureInfoScreen(product: product,));
        }
      }

    } catch(e){
        pr.dismiss();
       showSnackBar(context, e.toString());
    }

  }


  Future<int?> incrementProductViews (int? productId, int? userId) async {
    var authorizationToken = pref.getString(PrefKey.authorization);

    if(authorizationToken != null){

    Map<String, dynamic> data = {
      "product_id": productId,
      "user_id": userId,
    };

    try {
      await productRepository.incrementProductView(data);
      int views = await getProductTotalViews(productId);
      return views;

    } catch(e){
      log("product view ${e.toString()}");
      throw AppException(e.toString());
    }
    }
    return null;

  }

  Future<int> getProductTotalViews (int? productId) async {

    try {
      final response = await productRepository.getTotalProductViews(productId);
      return response.data?.totalViews ?? 0;

    } catch(e){
      log("get product view ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<Inventory?> productInventory(int? productId) async {
    var authorizationToken = pref.getString(PrefKey.authorization);
    if(authorizationToken != null){
    try {
      final response = await productRepository.productInventory(productId);
      return response.inventory;

    } catch(e){
      log("get product inventory ${e.toString()}");
      throw AppException(e.toString());
    }
    }
    else{
      throw AppException('unauthorized');
    }
  }






}