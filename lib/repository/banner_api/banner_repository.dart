import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/advertisement_banner.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/repository/google_auth/authentication.dart';

import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';
import '../../models/authentication_model.dart';
import '../../models/banner_model.dart';
import '../../models/user_model.dart';

class BannerRepository {

  final _apiServices = NetworkApiService() ;

  Future<BannerModel> getBanner() async {
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.getBanners);
    return BannerModel.fromJson(response) ;
  }

  Future<AdvertisementBannerModel> getAdvertisementBanner() async {
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.getAdvertisementBanners);
    return AdvertisementBannerModel.fromJson(response) ;
  }






}