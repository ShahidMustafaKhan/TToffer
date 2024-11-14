import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SubCategoriesModel {
  int? id;
  int? categoryId;
  String? title;

  SubCategoriesModel({this.title, this.id, this.categoryId});
}

class SubCategoriesProvider extends ChangeNotifier {
  List<SubCategoriesModel> subCategories = [];

  getSubCategories({required List<SubCategoriesModel> newSubCategories}) {
    subCategories = newSubCategories;
    // notifyListeners();
  }
}

class SubCategoriesService {
  Future subCategoriesService({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = {
        "data": [
          {"id": 1, "category_id": 1, "title": "Accessories"},
          {"id": 2, "category_id": 1, "title": "Smart Watches"},
          {"id": 0, "category_id": 1, "title": "Mobile Phones"},
          {"id": 3, "category_id": 1, "title": "Tablets"},
          {"id": 4, "category_id": 1, "title": "Others"},

          {"id": 7, "category_id": 3, "title": "Apartments & Flats"},
          {"id": 8, "category_id": 3, "title": "Commercial Space"},
          {"id": 6, "category_id": 3, "title": "Houses"},
          {"id": 5, "category_id": 3, "title": "Lands & Plots"},
          {"id": 10, "category_id": 3, "title": "Others"},
          {"id": 9, "category_id": 3, "title": "Portions & Floors"},

          {"id": 14, "category_id": 5, "title": "Buses, Vans & Trucks"},
          {"id": 18, "category_id": 5, "title": "Boats & Yachts"},
          {"id": 12, "category_id": 5, "title": "Car Accessories"},
          {"id": 11, "category_id": 5, "title": "Cars"},
          {"id": 17, "category_id": 5, "title": "Cars on Installments"},
          {"id": 19, "category_id": 5, "title": "Other Vehicles"},
          {"id": 13, "category_id": 5, "title": "Parts"},
          {"id": 16, "category_id": 5, "title": "Tractors & Trailers"},

          {"id": 22, "category_id": 4, "title": "Apartments & Flats"},
          {"id": 23, "category_id": 4, "title": "Commercial Space"},
          {"id": 21, "category_id": 4, "title": "Houses"},
          {"id": 27, "category_id": 4, "title": "Others"},
          {"id": 20, "category_id": 4, "title": "Portions & Floors"},
          {"id": 26, "category_id": 4, "title": "Roommates & Paying Guests"},
          {"id": 24, "category_id": 4, "title": "Rooms"},
          {"id": 25, "category_id": 4, "title": "Vacation Rentals"},

          {"id": 30, "category_id": 2, "title": "AC & Coolers"},
          {"id": 34, "category_id": 2, "title": "Cameras & Accessories"},
          {"id": 28, "category_id": 2, "title": "Computer & Accessories"},
          {"id": 37, "category_id": 2, "title": "Fans"},
          {"id": 35, "category_id": 2, "title": "Games & Entertainment"},
          {"id": 31, "category_id": 2, "title": "Generators, UPS & Power Solutions"},
          {"id": 43, "category_id": 2, "title": "Heater & Geysers"},
          {"id": 36, "category_id": 2, "title": "Kitchen Appliances"},
          {"id": 40, "category_id": 2, "title": "Microwaves & Ovens"},
          {"id": 32, "category_id": 2, "title": "Refrigerators & Freezers"},
          {"id": 41, "category_id": 2, "title": "Sewing Machines"},
          {"id": 42, "category_id": 2, "title": "Water Dispensers"},
          {"id": 39, "category_id": 2, "title": "Washing Machines & Dryers"},
          {"id": 45, "category_id": 2, "title": "Other Home Appliances"},
          {"id": 29, "category_id": 2, "title": "Television & Accessories"},
          {"id": 38, "category_id": 2, "title": "Video"},

          {"id": 51, "category_id": 6, "title": "ATV & Quads"},
          {"id": 47, "category_id": 6, "title": "Bicycles"},
          {"id": 49, "category_id": 6, "title": "Bikes Accessories"},
          {"id": 148, "category_id": 6, "title": "Electronic Bicycles"},
          {"id": 46, "category_id": 6, "title": "Motorcycles"},
          {"id": 52, "category_id": 6, "title": "Other Bikes"},
          {"id": 48, "category_id": 6, "title": "Parts"},
          {"id": 50, "category_id": 6, "title": "Scooters"},

          {"id": 75, "category_id": 7, "title": "Advertising & PR"},
          // {"id": 54, "category_id": 7, "title": "Architecture & Interior Design"},
          {"id": 65, "category_id": 7, "title": "Accounting & Finance"},
          // {"id": 56, "category_id": 7, "title": "Content Writing"},
          {"id": 60, "category_id": 7, "title": "Customer Service"},
          {"id": 62, "category_id": 7, "title": "Domestic Staff"},
          {"id": 67, "category_id": 7, "title": "Delivery Riders"},
          {"id": 69, "category_id": 7, "title": "Engineering"},
          // {"id": 55, "category_id": 7, "title": "Education"},
          {"id": 151, "category_id": 7, "title": "Full time remote"},
          {"id": 53, "category_id": 7, "title": "Full time on-site"},
          {"id": 73, "category_id": 7, "title": "Human Resources"},
          {"id": 66, "category_id": 7, "title": "IT & Networking"},
          {"id": 72, "category_id": 7, "title": "Management & Administration"},
          {"id": 150, "category_id": 7, "title": "Part time on-site"},
          {"id": 57, "category_id": 7, "title": "Part time remote"},
          {"id": 61, "category_id": 7, "title": "Restaurants & Hospitality"},
          {"id": 74, "category_id": 7, "title": "Real Estate"},
          {"id": 70, "category_id": 7, "title": "Security"},
          // {"id": 64, "category_id": 7, "title": "Graphic Design"},

          {"id": 68, "category_id": 7, "title": "Hotel & Tourism"},
          {"id": 71, "category_id": 7, "title": "Manufacturing"},
          {"id": 63, "category_id": 7, "title": "Medical"},
          {"id": 76, "category_id": 7, "title": "Internships"},
          {"id": 77, "category_id": 7, "title": "Other Jobs"},
          {"id": 58, "category_id": 7, "title": "Sales"},
          {"id": 59, "category_id": 7, "title": "Marketing"},

          {"id": 81, "category_id": 8, "title": "Car Rental"},
          {"id": 149, "category_id": 8, "title": "Cleaning Services"},
          {"id": 82, "category_id": 8, "title": "Domestic Help"},
          {"id": 88, "category_id": 8, "title": "Delivery & Courier"},
          {"id": 87, "category_id": 8, "title": "Drivers & Taxi"},
          {"id": 85, "category_id": 8, "title": "Electronics & Computer Repair"},
          {"id": 80, "category_id": 8, "title": "Home & Office Repair"},
          {"id": 78, "category_id": 8, "title": "Insurance Services"},
          {"id": 86, "category_id": 8, "title": "Movers & Packers"},
          {"id": 89, "category_id": 8, "title": "Others"},
          {"id": 84, "category_id": 8, "title": "Travel & Visa"},
          {"id": 79, "category_id": 8, "title": "Tuitions & Academies"},
          {"id": 83, "category_id": 8, "title": "Web Development"},

          {"id": 118, "category_id": 9, "title": "Bathroom & Accessories"},
          {"id": 117, "category_id": 9, "title": "Beds & Wardrobes"},
          {"id": 124, "category_id": 9, "title": "Curtain & Blinds"},
          {"id": 122, "category_id": 9, "title": "Garden & Outdoor"},
          {"id": 120, "category_id": 9, "title": "Home Decoration"},
          {"id": 121, "category_id": 9, "title": "Office Furniture"},
          {"id": 123, "category_id": 9, "title": "Painting & Mirrors"},
          {"id": 116, "category_id": 9, "title": "Sofa & Chairs"},
          {"id": 125, "category_id": 9, "title": "Rugs & Carpets"},
          {"id": 119, "category_id": 9, "title": "Tables & Dining"},
          {"id": 126, "category_id": 9, "title": "Others"},

          {"id": 96, "category_id": 10, "title": "Accessories"},
          {"id": 97, "category_id": 10, "title": "Beauty Products"},
          {"id": 93, "category_id": 10, "title": "Fashion"},
          {"id": 98, "category_id": 10, "title": "Home Decor"},
          {"id": 95, "category_id": 10, "title": "Jewelry"},
          {"id": 94, "category_id": 10, "title": "Shoes"},
          {"id": 99, "category_id": 10, "title": "Others"},

          {"id": 100, "category_id": 11, "title": "Electronic"},
          {"id": 103, "category_id": 11, "title": "Furnishing"},
          {"id": 101, "category_id": 11, "title": "Household"},
          {"id": 102, "category_id": 11, "title": "Kitchen"},
          {"id": 104, "category_id": 11, "title": "Others"},

          {"id": 100, "category_id": 12, "title": "Birds"},
          // {"id": 102, "category_id": 12, "title": "Livestock"},
          {"id": 103, "category_id": 12, "title": "Cats"},
          {"id": 104, "category_id": 12, "title": "Dogs"},
          {"id": 101, "category_id": 12, "title": "Exotic Animal"},
          {"id": 108, "category_id": 12, "title": "Fish"},
          {"id": 114, "category_id": 12, "title": "Horses"},
          {"id": 105, "category_id": 12, "title": "Pet Food & Accessories"},
          // {"id": 106, "category_id": 12, "title": "Pigeons"},
          {"id": 107, "category_id": 12, "title": "Rabbits"},
          // {"id": 109, "category_id": 12, "title": "Other Birds"},
          // {"id": 110, "category_id": 12, "title": "Doves"},
          // {"id": 111, "category_id": 12, "title": "Fertile Eggs"},
          // {"id": 112, "category_id": 12, "title": "Ducks"},
          // {"id": 113, "category_id": 12, "title": "Peacocks"},
          {"id": 115, "category_id": 12, "title": "Other Animals"},
        ]


      };

      List<SubCategoriesModel> model = [];

      response['data'].forEach((element) {
        model.add(SubCategoriesModel(
          id: element['id'],
          categoryId: element['category_id'],
          title: element['title'],
        ));
      });

      Provider.of<SubCategoriesProvider>(context, listen: false)
          .getSubCategories(newSubCategories: model);
      return true;
    } catch (err) {
      print(err);
    }
  }
}
