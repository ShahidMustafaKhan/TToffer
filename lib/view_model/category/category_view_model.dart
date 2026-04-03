import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/sub_categories_model.dart';
import 'package:tt_offer/repository/categories_api/categories_repository.dart';

import '../../../data/response/api_response.dart';

class CategoryViewModel with ChangeNotifier {
  CategoryRepository categoryRepository;
  CategoryViewModel({required this.categoryRepository});

  ApiResponse<List<CategoryModel>> categoryList = ApiResponse.loading();

  ApiResponse<List<SubCategoriesModel>> subCategoryList = ApiResponse.loading();

  setCategoryList(ApiResponse<List<CategoryModel>> response) {
    categoryList = response;
    notifyListeners();
  }

  setSubCategoryList(ApiResponse<List<SubCategoriesModel>> response) {
    subCategoryList = response;
    notifyListeners();
  }

  Future<void> getCategoryData() async {
    try {
      final response = await categoryRepository.categoryApi();
      // List<CategoryModel> tempCategoryData = [];
      // response['data'].forEach((element) {
      //   tempCategoryData.add(CategoryModel(
      //     id: element['id'],
      //     title: element['name'],
      //     image: element['ImgSrc'],
      //     color: Color(int.parse("0xff${element['color']}")),
      //   ));
      // });
      setCategoryList(ApiResponse.completed(response));
      getSubCategoryData();
    } catch (e) {
      if (categoryList.data?.isEmpty ?? true) {
        setCategoryList(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> getSubCategoryData() async {
    try {
      final response = await categoryRepository.subCategoryApi();
      // List<SubCategoriesModel> tempSubCategoryData = [];
      // response['data'].forEach((element) {
      //   tempSubCategoryData.add(SubCategoriesModel(
      //     id: element['id'],
      //     title: element['name'],
      //     categoryId: element['category_id'],
      //   ));
      // });
      setSubCategoryList(ApiResponse.completed(response));
    } catch (e) {
      if (subCategoryList.data?.isEmpty ?? true) {
        setSubCategoryList(ApiResponse.error(e.toString()));
      }
    }
  }
}
