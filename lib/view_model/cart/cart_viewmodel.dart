import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/shipping_detail_model.dart';
import 'package:tt_offer/repository/cart_api/cart_repository.dart';

import '../../../data/app_exceptions.dart';
import '../../../data/response/api_response.dart';
import '../../Utils/utils.dart';
import '../../models/cart_model.dart';
import '../../views/ShoppingFlow/account_info_form/AlmostThere.dart';
import '../../views/ShoppingFlow/checkout/checkout_screen.dart';


class CartViewModel with ChangeNotifier {

  CartRepository cartRepository ;
  CartViewModel({required this.cartRepository});


  ApiResponse<CartModel> cartItemList = ApiResponse.loading();

  setCartList(ApiResponse<CartModel> response){
    cartItemList = response ;
    notifyListeners();
  }

  addCartItemInList(Cart cart){
    cartItemList.data?.data?.add(cart);
    notifyListeners();
  }

  ApiResponse<Shipping> shippingDetails = ApiResponse.notStarted();

  setShipping(ApiResponse<Shipping> response){
    shippingDetails = response;
    notifyListeners();
  }

  int _cartItemsCount = 0;
  int get cartItemsCount => _cartItemsCount ;

  setCartItemsCount(int value){
    _cartItemsCount = value;
    notifyListeners();
  }


  bool _addCartLoading = false ;
  bool get addCartLoading => _addCartLoading ;

  setAddCartLoading(bool value){
    _addCartLoading = value;
    notifyListeners();
  }

  List<bool> _removeCartLoadingList = [] ;
  List<bool> get removeCartLoadingList => _removeCartLoadingList ;

  setRemoveCartLoadingList(bool value){
    _removeCartLoadingList.add(false);
  }

  emptyRemoveCartLoadingList(){
    _removeCartLoadingList = [];
  }

  updateRemoveCartLoadingList(bool value, int index){
    _removeCartLoadingList[index] = value;
    notifyListeners();
  }


  List<bool> _toggleSaveLoadingList = [] ;
  List<bool> get toggleSaveLoadingList => _toggleSaveLoadingList ;

  setToggleSaveLoadingList(bool value){
    _toggleSaveLoadingList.add(false);
  }

  emptyToggleSaveLoadingList(){
    _toggleSaveLoadingList = [];
  }

  updateToggleSaveLoadingValue(bool value, int index){
    _toggleSaveLoadingList[index] = value;
    notifyListeners();
  }

  List<bool> _buyNowLoadingList = [] ;
  List<bool> get buyNowLoadingList => _buyNowLoadingList ;

  setBuyNowLoadingList(bool value){
    _buyNowLoadingList.add(false);
  }

  emptyBuyNowLoadingList(){
    _buyNowLoadingList = [];
  }

  updateBuyNowLoadingList(bool value, int index){
    _buyNowLoadingList[index] = value;
    notifyListeners();
  }

  bool _loading = false ;
  bool get loading => _loading ;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }



  Future<void> getCartList(int? userId) async {

    try {
      final response = await cartRepository.getCartItemsApi(userId);
      setCartList(ApiResponse.completed(response));
      setCartItemCount(response);
      updateLoadingList(response);

    } catch(e){
      setCartList(ApiResponse.error(e.toString()));
      emptyToggleSaveLoadingList();
      emptyRemoveCartLoadingList();
    }
  }


  bool isProductInCart(int? productId) {
    if (cartItemList.data?.data == null) return false;

    for (var element in cartItemList.data!.data!) {
      if (element.product?.id == productId) {
        return true;
      }
    }
    return false;
  }


  void updateLoadingList(CartModel cartModel){
    emptyToggleSaveLoadingList();
    emptyRemoveCartLoadingList();
    emptyBuyNowLoadingList();
    cartModel.data?.forEach((element) {
       setToggleSaveLoadingList(false);
       setRemoveCartLoadingList(false);
       setBuyNowLoadingList(false);
     });
  }


  void setCartItemCount(CartModel? cartModel){
    setCartItemsCount(0);
    if(cartModel!= null && cartModel.data!=null ){
      setCartItemsCount(cartModel.data?.length ?? 0);
    }
    notifyListeners();
  }

  Future<void> addCartItem({int? productId, int? price, int? quantity, int? userId, bool loading = true, bool callGetCartApi = false}) async {
    setAddCartLoading(loading);
    try {
      Map<String, dynamic> data = {
        "product_id": productId,
        "user_id": userId,
        "quantity": quantity,
        "price": price,
      };

      await cartRepository.addCartItemApi(data);
      if(loading == true || callGetCartApi == true){getCartList(userId);}
      setAddCartLoading(false);

    } catch(e){
      setAddCartLoading(false);
      throw AppException(e.toString());
    }

  }


  Future<void> removeCartItem(int? productId, int? userId, {int? index}) async {
    if(index != null){
      updateRemoveCartLoadingList(true, index);
    }
    try {
      Map<String, dynamic> data = {
        "product_id": productId,
        "user_id": userId,
      };

      await cartRepository.removeCartItemApi(data);
      getCartList(userId);
      if(index != null){
        updateRemoveCartLoadingList(false, index);
      }

    } catch(e){
      if(index != null){
        updateRemoveCartLoadingList(false, index);
      }
      throw AppException(e.toString());
    }

  }


  Future<void> getLastAddress({int? index}) async {

    if(index != null){
      updateBuyNowLoadingList(true, index);
    }
    else{
      setLoading(true);
    }
    try {
      final response = await cartRepository.getLastSaveAddress();
      setShipping(ApiResponse.completed(response.data));
      if(index != null){
        updateBuyNowLoadingList(false, index);
      }
      else{
        setLoading(false);
      }

    } catch(e){
      setShipping(ApiResponse.error(e.toString()));
      if(index != null){
        updateBuyNowLoadingList(false, index);
      }
      else{
        setLoading(false);
      }
      throw AppException(e.toString());
    }

  }


  Future<void> saveAddress(dynamic data) async {
    setLoading(true);

    try {
      await cartRepository.saveAddress(data);
    } catch (e) {
      setLoading(false);
      throw AppException(e.toString());
    }
  }

  Future<dynamic> fetchCountries() async {

    try {
      final response = await cartRepository.fetchCountries();
      return response;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<dynamic> fetchCities(dynamic data) async {

    try {
      final response = await cartRepository.fetchCities(data);
      return response;
    } catch (e) {
      throw AppException(e.toString());
    }
  }


    determineNextScreen(bool addressSaved, List<Cart>? cartDataList, BuildContext context){
    List<Cart>? data = List.from(cartDataList!);

    if(addressSaved==false){
      push(context, AlmostThereScreen(data: data));
    }
    else{
      push(context, CheckOutScreen(items: data,));
    }
  }


  Future<String?> addOrder(int? userId, int? addressId, dynamic chargeId, {bool googlePay = false}) async {

    dynamic data = {
      "user_id" : userId,
      "address_id" : addressId,
      "charge_id" : chargeId,
      "type" : googlePay ? 'google_pay' : 'stripe',
      if(googlePay == true)
      "google_pay_id" : chargeId,
    };

    try {
      final response = await cartRepository.addOrder(data);
      return response["data"]["order"]["order_number"];
    } catch (e) {
      throw AppException(e.toString());
    }
  }





}