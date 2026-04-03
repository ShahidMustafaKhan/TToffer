import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/advertisement_banner.dart';

import '../../data/network/network_api_services.dart';
import '../../models/banner_model.dart';
import 'banner_repository.dart';

class BannerHttpRepository implements BannerRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<BannerModel> getBanner() async {
    dynamic response = await _apiServices
        .getGetApiResponse(AppUrls.baseUrl + AppUrls.getBanners);
    return BannerModel.fromJson(response);
  }

  @override
  Future<AdvertisementBannerModel> getAdvertisementBanner() async {
    dynamic response = await _apiServices
        .getGetApiResponse(AppUrls.baseUrl + AppUrls.getAdvertisementBanners);
    return AdvertisementBannerModel.fromJson(response);
  }
}
