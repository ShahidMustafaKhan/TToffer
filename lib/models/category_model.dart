import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CategoryModel {
  int? id;
  String? image;
  String? title;
  Color? color;

  CategoryModel({this.color, this.id, this.title, this.image});
}

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> category = [];

  getCategories({required List<CategoryModel> newCategory}) {
    category = newCategory;
    // notifyListeners();
  }
}

class BlockedUserServices {
  Future getBlockedUser({required BuildContext context}) async {
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

    List<CategoryModel> blockedUsers = [];
    response['data'].forEach((element) {
      blockedUsers.add(CategoryModel(
        id: element['id'],
        title: element['title'],
        image: element['image'],
        color: element['color'],
      ));
    });

    Provider.of<CategoryProvider>(context, listen: false)
        .getCategories(newCategory: blockedUsers);
    return true;
  }
}

String mobile = 'assets/images/mobile.png';
String hut = 'assets/images/hut.png';
String car = 'assets/images/car.png';
String rent = 'assets/images/rent.png';
String cam = 'assets/images/cam.png';
String bike = 'assets/images/newBike.png';
String tractor = 'assets/images/tracter.png';
String paint = 'assets/images/paint.png';
String suite = 'assets/images/suite.png';
String animal = 'assets/images/dog.png';
String fashion = 'assets/images/fashion.png';
String furniture = 'assets/images/furniture.png';
String kids = 'assets/images/kids.png';
