import 'package:tt_offer/models/advertisement_banner.dart';

import '../../models/banner_model.dart';
import 'banner_repository.dart';

class BannerMockRepository implements BannerRepository {
  @override
  Future<BannerModel> getBanner() async {
    return BannerModel(data: [
      Data(img: "https://www.infinitesweeps.com/static/i/p/287948/"),
    ]);
  }

  @override
  Future<AdvertisementBannerModel> getAdvertisementBanner() async {
    return AdvertisementBannerModel(
      data: [
        AdvertisementBanner(
            path:
                "https://images.pexels.com/photos/5624976/pexels-photo-5624976.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      ],
    );
  }
}
