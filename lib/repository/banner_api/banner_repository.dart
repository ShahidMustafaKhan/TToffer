import 'package:tt_offer/models/advertisement_banner.dart';

import '../../models/banner_model.dart';

abstract class BannerRepository {
  Future<BannerModel> getBanner();

  Future<AdvertisementBannerModel> getAdvertisementBanner();
}
