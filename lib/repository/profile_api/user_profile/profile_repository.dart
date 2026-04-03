import 'package:tt_offer/models/overview_model.dart';
import 'package:tt_offer/models/saved_model.dart';
import 'package:tt_offer/models/transaction_model.dart';
import 'package:tt_offer/models/wishlist_model.dart';

import '../../../models/user_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfileApi();

  Future<void> toggleFollowApi(dynamic data);

  Future<UserModel> getSellerProfileApi(int? sellerId, dynamic data);

  Future<ProfileModel> updateCompleteProfile(dynamic data, String filePath);

  Future<ProfileModel> updateProfile(dynamic data);

  Future<ProfileModel> updatePassword(dynamic data);

  Future<dynamic> toggleWishList(dynamic data);

  Future<WishListModel> getWishListItems(dynamic data);

  Future<dynamic> addSavedItem(dynamic data);

  Future<dynamic> deleteSavedItem(int? productId);

  Future<SavedListModel> getSavedItem();

  Future<dynamic> addSellerReview(dynamic data, int? sellerId);

  Future<dynamic> addBuyerReview(dynamic data, int? buyerId);

  Future<dynamic> addProductReview(dynamic data, int? productId);

  Future<dynamic> addDeviceToken(dynamic data);

  Future<dynamic> removeDeviceToken(int? userId);

  Future<TransactionModel> getAllTransactions(int? userId);

  Future<OverViewModel> overViewApi(int? userId);
}
