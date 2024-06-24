import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SubCategoriesModel {
  int? id;

  String? title;

  SubCategoriesModel({this.title, this.id});
}

class SubCategoriesProvider extends ChangeNotifier {
  List<SubCategoriesModel> subCategories = [];

  getSubCategories({required List<SubCategoriesModel> newSubCategories}) {
    subCategories = newSubCategories;
    notifyListeners();
  }
}

class SubCategoriesService {
  Future subCategoriesService({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = {
        "data": [
          {"id": 1, "title": "Mobile Phones"},
          {"id": 1, "title": "Accessories"},
          {"id": 1, "title": "Smart Watches"},
          {"id": 1, "title": "Tablets"},
          {"id": 2, "title": "Lands & Plots"},
          {"id": 2, "title": "Houses"},
          {"id": 2, "title": "Apartments & Flats"},
          {"id": 2, "title": "Shops - Offices - Commercial Space"},
          {"id": 2, "title": "Portions & Floors"},
          {"id": 3, "title": "Cars"},
          {"id": 3, "title": "Cars Accessories"},
          {"id": 3, "title": "Spare Parts"},
          {"id": 3, "title": "Buses, Vans & Trucks"},
          {"id": 3, "title": "Rickshaw & Chingchi"},
          {"id": 3, "title": "Tractors & Trailers"},
          {"id": 3, "title": "Cars on Installments"},
          {"id": 3, "title": "Other Vehicles"},
          {"id": 3, "title": "Boats"},
          {"id": 4, "title": "Portions & Floors"},
          {"id": 4, "title": "Houses"},
          {"id": 4, "title": "Apartments & Flats"},
          {"id": 4, "title": "Shops - Offices - Commercial Space "},
          {"id": 4, "title": "Rooms"},
          {"id": 4, "title": "Vacation Rentals - Guest Houses"},
          {"id": 4, "title": "Roommates & Paying Guests"},
          {"id": 5, "title": "Computer & Accessories"},
          {"id": 5, "title": "Television & Accessories"},
          {"id": 5, "title": "AC & Coolers"},
          {"id": 5, "title": "Generators, UPS & Power Solutions"},
          {"id": 5, "title": "Refrigerators & Freezers"},
          {"id": 5, "title": "Other Home Appliances"},
          {"id": 5, "title": "Cameras & Accessories"},
          {"id": 5, "title": "Games & Entertainment"},
          {"id": 5, "title": "Kitchen Appliances"},
          {"id": 5, "title": "Fans"},
          {"id": 5, "title": "Video-Audios"},
          {"id": 5, "title": "Washing Machines & Dryers"},
          {"id": 5, "title": "Microwaves & Ovens"},
          {"id": 5, "title": "Sewing Machines"},
          {"id": 5, "title": "Water Dispensers"},
          {"id": 5, "title": "Heater & Geysers"},
          {"id": 5, "title": "Irons & Steamers"},
          {"id": 5, "title": "Air Purifiers & Humidifiers"},
          {"id": 6, "title": "Motorcycles"},
          {"id": 6, "title": "Bicycles"},
          {"id": 6, "title": "Spare Parts"},
          {"id": 6, "title": "Bikes Accessories"},
          {"id": 6, "title": "Scooters"},
          {"id": 6, "title": "ATV & Quads"},
          {"id": 7, "title": "Online"},
          {"id": 7, "title": "Other Jobs"},
          {"id": 7, "title": "Education"},
          {"id": 7, "title": "Content Writing"},
          {"id": 7, "title": "Part time"},
          {"id": 7, "title": "Sales"},
          {"id": 7, "title": "Marketing"},
          {"id": 7, "title": "Customer Service"},
          {"id": 7, "title": "Restaurants & Hospitality"},
          {"id": 7, "title": "Domestic Staff"},
          {"id": 7, "title": "Medical"},
          {"id": 7, "title": "Graphic Design"},
          {"id": 7, "title": "Accounting & Finance"},
          {"id": 7, "title": "IT & Networking"},
          {"id": 7, "title": "Delivery Riders"},
          {"id": 7, "title": "Hotel & Tourism"},
          {"id": 7, "title": "Engineering"},
          {"id": 7, "title": "Security"},
          {"id": 7, "title": "Manufacturing"},
          {"id": 7, "title": "Clerical & Administration"},
          {"id": 7, "title": "Human Resources"},
          {"id": 7, "title": "Real Estate"},
          {"id": 7, "title": "Advertising & PR"},
          {"id": 7, "title": "Internships"},
          {"id": 7, "title": "Architecture & Interior Design"},
          {"id": 8, "title": "Other Services"},
          {"id": 8, "title": "Tuitions & Academies"},
          {"id": 8, "title": "Home & Office Repair"},
          {"id": 8, "title": "Car Rental"},
          {"id": 8, "title": "Domestic Help"},
          {"id": 8, "title": "Web Development"},
          {"id": 8, "title": "Travel & Visa"},
          {"id": 8, "title": "Electronics & Computer Repair"},
          {"id": 8, "title": "Movers & Packers"},
          {"id": 8, "title": "Drivers & Taxi"},
          {"id": 8, "title": "Health & Beauty"},
          {"id": 8, "title": "Event Services"},
          {"id": 8, "title": "Construction Services"},
          {"id": 8, "title": "Farm & Fresh Food"},
          {"id": 8, "title": "Consultancy Services"},
          {"id": 8, "title": "Architecture & Interior Design"},
          {"id": 8, "title": "Video & Photography"},
          {"id": 8, "title": "Renting Services"},
          {"id": 8, "title": "Catering & Restaurant"},
          {"id": 8, "title": "Car Services"},
          {"id": 8, "title": "Catering & Restaurant"},
          {"id": 8, "title": "Tailor Services"},
          {"id": 8, "title": "Insurance Services"},
          {"id": 9, "title": "Hens"},
          {"id": 9, "title": "Parrots"},
          {"id": 9, "title": "Livestock"},
          {"id": 9, "title": "Cats"},
          {"id": 9, "title": "Dogs"},
          {"id": 9, "title": "Pet Food & Accessories"},
          {"id": 9, "title": "Pigeons"},
          {"id": 9, "title": "Rabbits"},
          {"id": 9, "title": "Fish"},
          {"id": 9, "title": "Other Birds"},
          {"id": 9, "title": "Doves"},
          {"id": 9, "title": "Fertile Eggs"},
          {"id": 9, "title": "Ducks"},
          {"id": 9, "title": "Peacocks"},
          {"id": 9, "title": "Other Animal"},
          {"id": 9, "title": "Horses"},
          {"id": 10, "title": "Sofa & Chairs"},
          {"id": 10, "title": "Beds & Wardrobes"},
          {"id": 10, "title": "Other Household Items"},
          {"id": 10, "title": "Tables & Dining"},
          {"id": 10, "title": "Home Decoration"},
          {"id": 10, "title": "Office Furniture"},
          {"id": 10, "title": "Garden & Outdoor"},
          {"id": 10, "title": "Painting & Mirrors"},
          {"id": 10, "title": "Curtain & Blinds"},
          {"id": 10, "title": "Rugs & Carpets"},
          {"id": 10, "title": "Bathroom & Accessories"},
          {"id": 11, "title": "Clothes"},
          {"id": 11, "title": "Watches"},
          {"id": 11, "title": "Wedding"},
          {"id": 11, "title": "Footwear"},
          {"id": 11, "title": "Skin & Hair"},
          {"id": 11, "title": "Jewellery"},
          {"id": 11, "title": "Bags"},
          {"id": 11, "title": "Makeup"},
          {"id": 11, "title": "Fragrance"},
          {"id": 11, "title": "Fashion Accessories"},
          {"id": 11, "title": "Other Fashion"},
          {"id": 12, "title": "Sofa & Chairs"},
          {"id": 12, "title": "Beds & Wardrobes"},
          {"id": 12, "title": "Other Household Items"},
          {"id": 12, "title": "Tables & Dining"},
          {"id": 12, "title": "Home Decoration"},
          {"id": 12, "title": "Office Furniture"},
          {"id": 12, "title": "Garden & Outdoor"},
          {"id": 12, "title": "Painting & Mirrors"},
          {"id": 12, "title": "Curtain & Blinds"},
          {"id": 12, "title": "Rugs & Carpets"},
          {"id": 12, "title": "Bathroom & Accessories"},
          {"id": 13, "title": "Clothes"},
          {"id": 13, "title": "Watches"},
          {"id": 13, "title": "Wedding"},
          {"id": 13, "title": "Footwear"},
          {"id": 13, "title": "Skin & Hair"},
          {"id": 13, "title": "Jewellery"},
          {"id": 13, "title": "Bags"},
          {"id": 13, "title": "Makeup"},
          {"id": 13, "title": "Fragrance"},
          {"id": 13, "title": "Fashion Accessories"},
          {"id": 13, "title": "Other Fashion"},
          {"id": 14, "title": "Toys"},
          {"id": 14, "title": "Kids Vehicles"},
          {"id": 14, "title": "Baby Gear"},
          {"id": 14, "title": "Kids Furniture"},
          {"id": 14, "title": "Swings & Slides"},
          {"id": 14, "title": "Kids Accessories"},
          {"id": 14, "title": "Kids Clothing"},
          {"id": 14, "title": "Bath & Diapers"},
        ]
      };

      List<SubCategoriesModel> model = [];

      response['data'].forEach((element) {
        model.add(SubCategoriesModel(
          id: element['id'],
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
