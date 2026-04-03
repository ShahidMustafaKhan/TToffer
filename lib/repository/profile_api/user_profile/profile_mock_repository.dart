import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/mock/user_mock_data.dart';
import 'package:tt_offer/models/overview_model.dart';
import 'package:tt_offer/models/saved_model.dart';
import 'package:tt_offer/models/transaction_model.dart';
import 'package:tt_offer/models/wishlist_model.dart';
import 'package:tt_offer/repository/profile_api/user_profile/profile_repository.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/user_model.dart';

class ProfileMockRepository implements ProfileRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<ProfileModel> getProfileApi() async {
    return ProfileModel(userModel: getMockUser());
  }

  @override
  Future<void> toggleFollowApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.toggleFollow, data);
    return response;
  }

  @override
  Future<UserModel> getSellerProfileApi(int? sellerId, dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        "${AppUrls.baseUrl + AppUrls.getSellerProfile}/$sellerId", data);
    return UserModel.fromJson(response);
  }

  @override
  Future addBuyerReview(data, int? buyerId) async {
    await Future.delayed(const Duration(seconds: 1));
    return "";
  }

  @override
  Future addDeviceToken(data) {
    // TODO: implement addDeviceToken
    throw UnimplementedError();
  }

  @override
  Future addProductReview(data, int? productId) {
    // TODO: implement addProductReview
    throw UnimplementedError();
  }

  @override
  Future addSavedItem(data) {
    // TODO: implement addSavedItem
    throw UnimplementedError();
  }

  @override
  Future addSellerReview(data, int? sellerId) async {
    await Future.delayed(const Duration(seconds: 1));
    return "";
  }

  @override
  Future deleteSavedItem(int? productId) {
    // TODO: implement deleteSavedItem
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel> getAllTransactions(int? userId) {
    // TODO: implement getAllTransactions
    throw UnimplementedError();
  }

  @override
  Future<SavedListModel> getSavedItem() {
    // TODO: implement getSavedItem
    throw UnimplementedError();
  }

  @override
  Future<WishListModel> getWishListItems(data) {
    // TODO: implement getWishListItems
    throw UnimplementedError();
  }

  @override
  Future<OverViewModel> overViewApi(int? userId) {
    // TODO: implement overViewApi
    throw UnimplementedError();
  }

  @override
  Future removeDeviceToken(int? userId) {
    // TODO: implement removeDeviceToken
    throw UnimplementedError();
  }

  @override
  Future toggleWishList(data) {
    // TODO: implement toggleWishList
    throw UnimplementedError();
  }

  @override
  Future<ProfileModel> updateCompleteProfile(data, String filePath) {
    // TODO: implement updateCompleteProfile
    throw UnimplementedError();
  }

  @override
  Future<ProfileModel> updatePassword(data) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<ProfileModel> updateProfile(data) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
