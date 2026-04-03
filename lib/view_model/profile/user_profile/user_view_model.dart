import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/saved_model.dart';
import 'package:tt_offer/models/transaction_model.dart';
import 'package:tt_offer/repository/profile_api/user_profile/profile_repository.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/chat/chat_list_view_model/chat_list_view_model.dart';
import 'package:tt_offer/view_model/chat/chat_list_view_model/chat_view_model.dart';
import 'package:tt_offer/view_model/notification/notification_view_model.dart';

import '../../../data/response/api_response.dart';
import '../../../models/user_model.dart';
import '../../../models/wishlist_model.dart';
import '../../../providers/selling_purchase_provider.dart';
import '../../../views/Authentication screens/login_screen.dart';

class UserViewModel with ChangeNotifier {
  ProfileRepository profileRepository;
  UserViewModel({required this.profileRepository});

  ApiResponse<UserModel> userModel = ApiResponse.loading();

  setUserModel(ApiResponse<UserModel> response) {
    userModel = response;
    notifyListeners();
  }

  ApiResponse<List<WishList>> wishList = ApiResponse.notStarted();

  setWishList(ApiResponse<List<WishList>> response) {
    wishList = response;
    notifyListeners();
  }

  ApiResponse<List<SaveList>> saveList = ApiResponse.notStarted();

  setSaveItemList(ApiResponse<List<SaveList>> response) {
    saveList = response;
    notifyListeners();
  }

  ApiResponse<TransactionModel> transactionList = ApiResponse.loading();

  setTransactionList(ApiResponse<TransactionModel> response) {
    transactionList = response;
    notifyListeners();
  }

  bool _updateProfileLoading = false;
  bool get updateProfileLoading => _updateProfileLoading;

  setUpdateProfileLoading(bool value) {
    _updateProfileLoading = value;
    notifyListeners();
  }

  List<int> _userWishList = [];
  List<int> get userWishList => _userWishList;

  updateUserWishList(int value) {
    _userWishList.add(value);
    notifyListeners();
  }

  emptyUserWishList() {
    _userWishList = [];
  }

  List<int> _userSaveItemList = [];
  List<int> get userSavedList => _userSaveItemList;

  updateUserSavedItemList(int value) {
    _userSaveItemList.add(value);
    notifyListeners();
  }

  emptyUserSavedItemList() {
    _userSaveItemList = [];
  }

  bool _reviewLoading = false;
  bool get reviewLoading => _reviewLoading;

  int _savedItemsCount = 0;
  int get savedItemsCount => _savedItemsCount;

  setSavedItemsCount(int value) {
    _savedItemsCount = value;
    notifyListeners();
  }

  setReviewLoading(bool value) {
    _reviewLoading = value;
    notifyListeners();
  }

  bool _toggleSaveLoading = false;
  bool get toggleSaveLoading => _toggleSaveLoading;

  setToggleSaveLoading(bool value) {
    _toggleSaveLoading = value;
    notifyListeners();
  }

  bool _toggleFollowLoading = false;
  bool get toggleFollowLoading => _toggleFollowLoading;

  updateToggleFollowLoading(bool value) {
    _toggleFollowLoading = value;
    notifyListeners();
  }

  List<bool> _toggleSaveLoadingList = [];
  List<bool> get toggleSaveLoadingList => _toggleSaveLoadingList;

  setToggleSaveLoadingList() {
    _toggleSaveLoadingList.add(false);
  }

  emptyToggleSaveLoadingList() {
    _toggleSaveLoadingList = [];
  }

  updateToggleSaveLoadingValue(bool value, int index) {
    _toggleSaveLoadingList[index] = value;
    notifyListeners();
  }

  List<bool> _wishlistLoadingList = [];
  List<bool> get wishlistLoadingList => _wishlistLoadingList;

  setToggleWishLoadingList() {
    _wishlistLoadingList.add(false);
  }

  emptyToggleWishLoadingList() {
    _wishlistLoadingList = [];
  }

  updateToggleWishLoadingValue(bool value, int index) {
    _wishlistLoadingList[index] = value;
    notifyListeners();
  }

  Future<void> getUserProfile() async {
    try {
      final response = await profileRepository.getProfileApi();
      setUserModel(ApiResponse.completed(response.userModel));
    } catch (e) {
      log("profile ${e.toString()}");
      log("profile ${e.toString()}");
      setUserModel(ApiResponse.error(e.toString()));
    }
  }

  Future<UserModel?> toggleFollowApi(int? userId) async {
    dynamic data = {'user_id': userId};

    try {
      updateToggleFollowLoading(true);
      await profileRepository.toggleFollowApi(data);
      final response = await getSellerProfile(userId);
      updateToggleFollowLoading(false);
      return response;
    } catch (e) {
      log("follow ${e.toString()}");
      log("follow ${e.toString()}");
      updateToggleFollowLoading(false);
      throw AppException(e.toString());
    }
  }

  Future<UserModel?> getSellerProfile(int? sellerId) async {
    try {
      int? userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

      dynamic data = {'user_id': userId};

      final response =
          await profileRepository.getSellerProfileApi(sellerId, data);
      return response;
    } catch (e) {
      log("seller profile ${e.toString()}");
      log("seller profile ${e.toString()}");
      throw AppException(e.toString());
    }
  }

  Future<void> updateUserProfileAndImage(int? userId, String imagePath) async {
    try {
      dynamic data = {"user_id": userId};

      final response =
          await profileRepository.updateCompleteProfile(data, imagePath);
      setUserModel(ApiResponse.completed(response.userModel));
    } catch (e) {
      setUserModel(ApiResponse.error(e.toString()));
      throw AppException(e.toString());
    }
  }

  Future<void> updateUserProfile(dynamic data) async {
    try {
      setUpdateProfileLoading(true);
      final response = await profileRepository.updateProfile(data);
      setUserModel(ApiResponse.completed(response.userModel));
      setUpdateProfileLoading(false);
    } catch (e) {
      setUserModel(ApiResponse.error(e.toString()));
      setUpdateProfileLoading(false);
      throw AppException(e.toString());
    }
  }

  Future<void> updatePassword(dynamic data) async {
    try {
      setUpdateProfileLoading(true);
      final response = await profileRepository.updatePassword(data);
      setUserModel(ApiResponse.completed(response.userModel));
      setUpdateProfileLoading(false);
    } catch (e) {
      setUserModel(ApiResponse.error(e.toString()));
      setUpdateProfileLoading(false);
      throw AppException(e.toString());
    }
  }

  Future<void> toggleWishList(int? userId, int? productId, BuildContext context,
      {int? itemIndex}) async {
    if (itemIndex != null) {
      updateToggleWishLoadingValue(true, itemIndex);
    }
    try {
      dynamic data = {
        "user_id": userId,
        "product_id": productId,
      };

      await profileRepository.toggleWishList(data);
      await getWishList(hideLoading: itemIndex != null);
      if (itemIndex != null) {
        updateToggleWishLoadingValue(false, itemIndex);
      }
    } catch (e) {
      if (itemIndex != null) {
        updateToggleWishLoadingValue(false, itemIndex);
      }
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getWishList({bool hideLoading = false}) async {
    int? userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
    String? authorization = pref.getString(PrefKey.authorization);

    if (userId != null && authorization != null) {
      try {
        dynamic data = {
          "user_id": userId,
        };

        final response = await profileRepository.getWishListItems(data);
        setWishList(ApiResponse.completed(response.data ?? []));
        updateUserWishListData();
      } catch (e) {
        setWishList(ApiResponse.error(e.toString()));
        log("wishlist get ${e.toString()}");
        log("wishlist get ${e.toString()}");
      }
    }
  }

  Future<void> addSavedItem(int? userId, int? productId, BuildContext context,
      {int? index, int? saveItemIndex}) async {
    savedItemLoading(true, context, index: index, saveItemIndex: saveItemIndex);
    try {
      dynamic data = {
        "user_id": userId,
        "product_id": productId,
      };

      await profileRepository.addSavedItem(data);
      Provider.of<CartViewModel>(context, listen: false)
          .removeCartItem(productId, userId);
      savedItemLoading(false, context,
          index: index, saveItemIndex: saveItemIndex);
    } catch (e) {
      savedItemLoading(false, context,
          index: index, saveItemIndex: saveItemIndex);
      showSnackBar(context, e.toString());
    }
  }

  Future<void> deleteSavedItem(int? id, BuildContext context,
      {int? index, int? saveItemIndex}) async {
    savedItemLoading(true, context, index: index, saveItemIndex: saveItemIndex);
    try {
      await profileRepository.deleteSavedItem(id);
      getSavedItemList();
      savedItemLoading(false, context,
          index: index, saveItemIndex: saveItemIndex);
    } catch (e) {
      savedItemLoading(false, context,
          index: index, saveItemIndex: saveItemIndex);
      throw AppException(e.toString());
    }
  }

  Future<void> getSavedItemList({bool hideLoading = false}) async {
    try {
      if (hideLoading == false) {
        setSaveItemList(ApiResponse.loading());
      }

      final response = await profileRepository.getSavedItem();
      setSaveItemList(ApiResponse.completed(response.data?.saveList ?? []));
      setSavedItemsCount(response.data?.saveList?.length ?? 0);
      updateUserSavedItemListData();
    } catch (e) {
      setSaveItemList(ApiResponse.error(e.toString()));
      log("savedList get ${e.toString()}");
      log("savedList get ${e.toString()}");
      throw AppException(e.toString());
    }
  }

  void savedItemLoading(bool value, BuildContext context,
      {int? index, int? saveItemIndex}) {
    if (index != null) {
      Provider.of<CartViewModel>(context, listen: false)
          .updateToggleSaveLoadingValue(value, index);
    } else if (saveItemIndex != null) {
      updateToggleSaveLoadingValue(value, saveItemIndex);
    } else {
      setToggleSaveLoading(value);
    }
  }

  void updateUserWishListData() {
    emptyUserWishList();
    emptyToggleWishLoadingList();
    wishList.data?.forEach((element) {
      if (element.productId != null) {
        updateUserWishList(element.productId!);
        setToggleWishLoadingList();
      }
    });
  }

  void updateUserSavedItemListData() {
    emptyUserSavedItemList();
    emptyToggleSaveLoadingList();
    saveList.data?.forEach((element) {
      if (element.productId != null) {
        updateUserSavedItemList(element.productId!);
        setToggleSaveLoadingList();
      }
    });
  }

  bool isProductInSavedList(int? productId) {
    if (productId == null) {
      return false;
    }

    bool result = userSavedList.contains(productId);
    return result;
  }

  bool isProductInWishList(int? productId) {
    if (productId == null) {
      return false;
    }

    bool result = userWishList.contains(productId);
    return result;
  }

  Future<void> updateVerification(int? userId,
      {bool verifyPhone = false}) async {
    try {
      Map<String, dynamic> data;

      if (verifyPhone == true) {
        data = {
          "user_id": userId,
          "phone_verified_at": DateTime.now().toString(),
        };
      } else {
        data = {
          "user_id": userId,
          "image_verified_at": DateTime.now().toString(),
        };
      }

      final response = await profileRepository.updateProfile(data);
      setUserModel(ApiResponse.completed(response.userModel));
    } catch (e) {
      setUserModel(ApiResponse.error(e.toString()));
      throw AppException(e.toString());
    }
  }

  Future<void> updateShowContact(int? userId, int showPhone) async {
    try {
      Map<String, dynamic> data;

      data = {
        "user_id": userId,
        "show_contact": showPhone,
      };

      final response = await profileRepository.updateProfile(data);
      setUserModel(ApiResponse.completed(response.userModel));
    } catch (e) {
      setUserModel(ApiResponse.error(e.toString()));
      throw AppException(e.toString());
    }
  }

  Future<void> addSellerReview(dynamic data, int? userId) async {
    setReviewLoading(true);
    try {
      final response = await profileRepository.addSellerReview(data, userId);
      setReviewLoading(false);
      return response;
    } catch (e) {
      setReviewLoading(false);
      throw AppException(e.toString());
    }
  }

  Future<void> addBuyerReview(dynamic data, int? userId) async {
    setReviewLoading(true);
    try {
      final response = await profileRepository.addBuyerReview(data, userId);
      setReviewLoading(false);
      return response;
    } catch (e) {
      setReviewLoading(false);
      throw AppException(e.toString());
    }
  }

  Future<void> addProductReview(dynamic data, int? productId) async {
    setReviewLoading(true);
    try {
      final response =
          await profileRepository.addProductReview(data, productId);
      setReviewLoading(false);
      return response;
    } catch (e) {
      setReviewLoading(false);
      throw AppException(e.toString());
    }
  }

  Future<void> addDeviceToken(int? userId, dynamic token) async {
    dynamic data = {"user_id": userId, "token": token};

    try {
      await profileRepository.addDeviceToken(data);
    } catch (e) {
      log("device token api ... ${e.toString()}");
      throw AppException(e.toString());
    }
  }

  Future<void> deleteDeviceToken(int? userId) async {
    try {
      await profileRepository.removeDeviceToken(userId);
    } catch (e) {
      log("delete device token api ... ${e.toString()}");
      throw AppException(e.toString());
    }
  }

  Future<void> getAllTransaction(int? userId) async {
    try {
      final response = await profileRepository.getAllTransactions(userId);
      setTransactionList(ApiResponse.completed(response));
    } catch (e) {
      log("transaction ... ${e.toString()}");
      throw AppException(e.toString());
    }
  }

  Future<void> overViewApi(int? userId, BuildContext context) async {
    try {
      final response = await profileRepository.overViewApi(userId);
      Provider.of<CartViewModel>(context, listen: false)
          .setCartItemsCount(response.cartItemCount ?? 0);
      Provider.of<ChatViewModel>(context, listen: false)
          .toggleUnReadMessageIndicator((response.chatCount ?? 0) != 0);
      Provider.of<NotificationViewModel>(context, listen: false)
          .setIndicatorCount(response.unreadNotifications ?? 0);
      setSavedItemsCount(response.savedForLaterCount ?? 0);
    } catch (e) {
      log("overView ... ${e.toString()}");
      throw AppException(e.toString());
    }
  }

  logout(BuildContext context, userId) {
    Navigator.of(context).pop();
    deleteDeviceToken(userId);
    clearCacheAndSignOut();
    Provider.of<SellingPurchaseProvider>(context, listen: false)
        .sellingProductsModel = null;
    Provider.of<CartViewModel>(context, listen: false).setCartItemsCount(0);
    Provider.of<CartViewModel>(context, listen: false)
        .setCartList(ApiResponse.notStarted());
    Provider.of<ChatListViewModel>(context, listen: false)
        .setBuyingChat(ApiResponse.loading());
    Provider.of<ChatListViewModel>(context, listen: false)
        .setSellingChat(ApiResponse.loading());
    Provider.of<SellingPurchaseProvider>(context, listen: false)
        .sellingProductsModel = null;
    userModel = ApiResponse.notStarted();
    pushUntil(context, const SigInScreen());
  }
}
