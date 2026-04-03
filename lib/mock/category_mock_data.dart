import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/product_model.dart';

import '../models/category_model.dart';

class CategoriesMockService {
  static List<CategoryModel> getMockCategoryModelsList() {
    List<CategoryModel> mockCategoryModelList = [];
    response['data'].forEach((element) {
      mockCategoryModelList.add(CategoryModel(
        id: element['id'],
        title: element['title'],
        image: element['image'],
        color: element['color'],
      ));
    });

    return mockCategoryModelList;
  }

  static Category? findCategoryModel(String title) {
    for (var element in response['data']) {
      if (element['title'] == title) {
        return Category(
          id: element['id'],
          name: element['title'],
        );
      }
    }
    return null;
  }
}

String mobile = 'assets/images/categories/mobile.png';
String hut = 'assets/images/categories/hut.png';
String car = 'assets/images/categories/car.png';
String rent = 'assets/images/categories/rent.png';
String cam = 'assets/images/categories/cam.png';
String bike = 'assets/images/categories/bike.png';
String paint = 'assets/images/categories/paint.png';
String suite = 'assets/images/categories/suite.png';
String animal = 'assets/images/categories/animal.png';
String fashion = 'assets/images/categories/fashion.png';
String furniture = 'assets/images/categories/furniture.png';
String kids = 'assets/images/categories/toy.png';

Map<String, dynamic> response = {
  "data": [
    {
      "id": 1,
      "title": "Mobiles",
      "image": mobile,
      "color": const Color(0xffFF90CC),
    },
    {
      "id": 2,
      "title": "Electronics & Appliance",
      "image": cam,
      "color": const Color(0xffEDFFC1),
    },
    {
      "id": 3,
      "title": "Property for Sale",
      "image": hut,
      "color": const Color(0xffF6C1FF),
    },
    {
      "id": 4,
      "title": "Property for Rent",
      "image": rent,
      "color": const Color(0xffC1FFD8),
    },
    {
      "id": 5,
      "title": "Vehicles",
      "image": car,
      "color": const Color(0xffC1FFF0),
    },
    {
      "id": 6,
      "title": "Bikes",
      "image": bike,
      "color": const Color(0xffFFC656),
    },
    {
      "id": 7,
      "title": "Jobs",
      "image": suite,
      "color": const Color(0xffFFE8BB),
    },
    {
      "id": 8,
      "title": "Services",
      "image": paint,
      "color": const Color(0xffFFC8BC),
    },
    {
      "id": 9,
      "title": "Furniture & home decor",
      "image": furniture,
      "color": const Color(0xff00ecff),
    },
    {
      "id": 10,
      "title": "Fashion & beauty",
      "image": fashion,
      "color": const Color(0xff45FF84),
    },
    {
      "id": 11,
      "title": "Kids",
      "image": kids,
      "color": const Color(0xffEF25B7),
    },
    {
      "id": 12,
      "title": "Animals",
      "image": animal,
      "color": const Color(0xffEAFFAE),
    },
  ],
};
