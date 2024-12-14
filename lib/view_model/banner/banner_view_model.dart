import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/advertisement_banner.dart';
import 'package:tt_offer/repository/banner_api/banner_repository.dart';

import '../../models/banner_model.dart';
import '../../repository/banner_api/banner_repository.dart';

class BannerViewModel extends ChangeNotifier {
  List<String> firstBanner = [];
  List<AdvertisementBanner> secondBanner = [];
  List<AdvertisementBanner> thirdBanner = [];

  BannerRepository bannerRepository ;
  BannerViewModel({required this.bannerRepository});


  Future<void> getBanner() async {

    try {
      final response = await bannerRepository.getBanner();
      addBanner(response);

    } catch(e){
      log("banner api error ${e.toString()}");
    }

  }

  Future<void> getAdvertisementBanner() async {

    try {
      final response = await bannerRepository.getAdvertisementBanner();
      addAdvertisementBanner(response);

    } catch(e){
      log("Advertisement banner api error ${e.toString()}");
    }

  }

  void callBannerApi(){
    getBanner();
    getAdvertisementBanner();
  }



  addBanner(BannerModel model) {
    List<String> firstBannerTemp = [];

    for (var element in model.data!) {
         if(element.img!=null) {
           firstBannerTemp.add(element.img!);
         }
    }

    firstBanner = firstBannerTemp;
    notifyListeners();
  }

  addAdvertisementBanner(AdvertisementBannerModel model) {
    List<AdvertisementBanner> secondBannerTemp = [];
    List<AdvertisementBanner> thirdBannerTemp = [];

    for (var element in model.data ?? []) {
         if(element !=null) {
           secondBannerTemp.add(element);
           thirdBannerTemp.add(element);
         }
    }

    secondBanner = secondBannerTemp;
    thirdBanner = thirdBannerTemp;
    notifyListeners();
  }

}



