import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/overview_model.dart';
import 'package:tt_offer/models/saved_model.dart';
import 'package:tt_offer/models/transaction_model.dart';
import 'package:tt_offer/models/wishlist_model.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/post_product_model.dart';
import '../../../models/user_model.dart';


class ProfileRepository {

  final _apiServices = NetworkApiService() ;


  Future<ProfileModel> getProfileApi() async {
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.getProfile);
    return ProfileModel.fromJson(response);
  }

  Future<void> toggleFollowApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.toggleFollow, data);
    return response;
  }

  Future<UserModel> getSellerProfileApi(int? sellerId, dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse("${AppUrls.baseUrl+AppUrls.getSellerProfile}/$sellerId", data);
    return UserModel.fromJson(response);
  }

  Future<ProfileModel> updateCompleteProfile(dynamic data, String filePath) async {
    dynamic response = await _apiServices.postSingleFileApiRequest(AppUrls.baseUrl+AppUrls.updateProfile, data, filePath);
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateProfile(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.updateProfile, data);
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updatePassword(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.updatePassword, data);
    return ProfileModel.fromJson(response);
  }

  Future<dynamic> toggleWishList(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.toggleWishlist, data);
    return response;
  }

  Future<WishListModel> getWishListItems(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.getWishlistProducts, data);
    return WishListModel.fromJson(response);
  }

  Future<dynamic> addSavedItem(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addSavedProduct, data);
    return response;
  }

  Future<dynamic> deleteSavedItem(int? productId) async {
    dynamic response = await _apiServices.getDeleteApiResponse("${AppUrls.baseUrl+AppUrls.deleteSavedProduct}/$productId", {});
    return response;
  }

  Future<SavedListModel> getSavedItem() async {
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.getSavedProducts);
    return SavedListModel.fromJson(response);
  }

  Future<dynamic> addSellerReview(dynamic data, int? sellerId) async {
    dynamic response = await _apiServices.getPostApiResponse("${AppUrls.baseUrl}seller/$sellerId/reviews", data);
    return response;
  }

  Future<dynamic> addBuyerReview(dynamic data, int? buyerId) async {
    dynamic response = await _apiServices.getPostApiResponse("${AppUrls.baseUrl}buyer/$buyerId/reviews", data);
    return response;
  }

  Future<dynamic> addProductReview(dynamic data, int? productId) async {
    dynamic response = await _apiServices.getPostApiResponse("${AppUrls.baseUrl}products/$productId/reviews", data);
    return response;
  }

  Future<dynamic> addDeviceToken(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.updateDeviceToken, data);
    return response;
  }

  Future<dynamic> removeDeviceToken(int? userId) async {
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl}users/$userId/device-token");
    return response;
  }

  Future<TransactionModel> getAllTransactions(int? userId) async {
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl+AppUrls.getTransaction}$userId");
    return TransactionModel.fromJson(response);
  }

  Future<OverViewModel> overViewApi(int? userId) async {
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl+AppUrls.overView}$userId");
    return OverViewModel.fromJson(response);
  }



}