import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/models/post_product_model.dart';

import '../../../data/app_exceptions.dart';
import '../../../models/product_model.dart';
import '../../../repository/product_api/post_products_api/post_product_repository.dart';


class PostProductViewModel with ChangeNotifier {

  PostProductRepository postProductRepository ;
  PostProductViewModel({required this.postProductRepository});

  bool _firstStepLoading = false ;
  bool get firstStepLoading => _firstStepLoading ;

  bool _secondStepLoading = false ;
  bool get secondStepLoading => _secondStepLoading ;

  bool _thirdStepLoading = false ;
  bool get thirdStepLoading => _thirdStepLoading ;

  bool _lastStepLoading = false ;
  bool get lastStepLoading => _lastStepLoading ;

  bool _imageDeleteLoading = false ;
  bool get imageDeleteLoading => _imageDeleteLoading ;

  bool _videoDeleteLoading = false ;
  bool get videoDeleteLoading => _videoDeleteLoading ;


  setFirstStepLoading(bool value){
    _firstStepLoading = value;
    notifyListeners();
  }

  setSecondStepLoading(bool value){
    _secondStepLoading = value;
    notifyListeners();
  }

  setThirdStepLoading(bool value){
    _thirdStepLoading = value;
    notifyListeners();
  }

  setLastStepLoading(bool value){
    _lastStepLoading = value;
    notifyListeners();
  }

  setVideoDeleteLoading(bool value){
    _videoDeleteLoading = value;
    notifyListeners();
  }

  setImageDeleteLoading(bool value){
    _imageDeleteLoading = value;
    notifyListeners();
  }


  Future<PostProductModel> addProductFirstStep(dynamic data, List<String> filePath, {bool update = false, String? videoPath}) async {

    try {
      setFirstStepLoading(true);
      final response =  update == true ? await postProductRepository.updateProductFirstStepApi(data, filePath, videoPath: videoPath) :
      await postProductRepository.addProductFirstStepApi(data,filePath, videoPath: videoPath);

      setFirstStepLoading(false);
      return response;
    }catch(e){
      setFirstStepLoading(false);
      throw AppException(e);
    }

  }

  Future<PostProductModel> addProductSecondStep(dynamic data, {bool update = false}) async {

    try {
      setSecondStepLoading(true);
      final response =  update == true ? await postProductRepository.updateProductSecondStepApi(data) :
      await postProductRepository.addProductSecondStepApi(data);

      setSecondStepLoading(false);
      return response;
    }catch(e){
      setSecondStepLoading(false);
      throw AppException(e);
    }

  }

  Future<PostProductModel> addProductThirdStep(dynamic data, {bool update = false}) async {

    try {
      setThirdStepLoading(true);
      final response =  update == true ? await postProductRepository.updateProductThirdStepApi(data) :
      await postProductRepository.addProductThirdStepApi(data);

      setThirdStepLoading(false);
      return response;
    }catch(e){
      setThirdStepLoading(false);
      throw AppException(e);
    }

  }


  Future<Product?> addProductLastStep(dynamic data, {bool update = false}) async {

    try {
      setLastStepLoading(true);
      final response =  update == true ? await postProductRepository.updateProductLastStepApi(data) :
      await postProductRepository.addProductLastStepApi(data);

      setLastStepLoading(false);
      return response.product;
    }catch(e){
      setLastStepLoading(false);
      throw AppException(e);
    }

  }

  Future<void> deleteImage(int? id, int? productId) async {

    Map dynamic = {'photo_id': id, 'product_id': productId};

    try {
      setImageDeleteLoading(true);
      final response = await postProductRepository.deleteImage(dynamic);
      setImageDeleteLoading(false);
      return response;
    } catch(e){
      setImageDeleteLoading(false);
      throw AppException(e);
    }}


  Future<void> deleteVideo(int? id, int? productId) async {

    Map dynamic = {'video_id': id, 'product_id': productId};

    try {
      setVideoDeleteLoading(true);
      final response = await postProductRepository.deleteVideo(dynamic);
      setVideoDeleteLoading(false);
      return response;
    } catch(e){
      setVideoDeleteLoading(false);
      throw AppException(e);
    }}






}