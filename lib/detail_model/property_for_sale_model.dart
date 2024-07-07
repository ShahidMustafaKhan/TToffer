import 'dart:convert';

class FashionAttributes {
  dynamic categoryId;
  dynamic subCategoryId;
  final String catName;
  final String subCatName;
  final String fabric;
  final String suitType;

  final String location;

  FashionAttributes({
    required this.categoryId,
    required this.subCategoryId,
    required this.catName,
    required this.subCatName,
    required this.suitType,
    required this.fabric,
    required this.location,
  });

  factory FashionAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return FashionAttributes(
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      subCatName: json['subCatName'] ?? '',
      suitType: json['suitType'] ?? '',
      fabric: json['fabric'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class MobileAttributes {
  dynamic categoryId;
  final String catName;
  final String condition;

  final String brand;
  final String storage;
  final String color;

  final String location;

  MobileAttributes({
    required this.categoryId,
    required this.brand,
    required this.catName,
    required this.condition,
    required this.storage,
    required this.color,
    required this.location,
  });

  factory MobileAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return MobileAttributes(
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      condition: json['condition'] ?? '',
      brand: json['brand'] ?? '',
      storage: json['storage'] ?? '',
      color: json['color'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class VehicleAttributes {
  dynamic categoryId;
  final String catName;
  String mileAge;

  final String makeModel;

  final String year;
  final String color;
  final String FuelType;

  final String location;

  VehicleAttributes({
    required this.categoryId,
    required this.makeModel,
    required this.catName,
    required this.year,
    required this.mileAge,
    required this.color,
    required this.FuelType,
    required this.location,
  });

  factory VehicleAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return VehicleAttributes(
      categoryId: json['category_id'],
      makeModel: json['makeAndModel'] ?? '',
      catName: json['category_name'] ?? '',
      mileAge: json['mileage'] ?? '',
      year: json['year'] ?? '',
      color: json['color'] ?? '',
      FuelType: json['fuelType'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class PropertyAttributes {
  dynamic categoryId;
  final String catName;
  final String type;
  final String bedroom;
  final String yearBuilt;
  final String area;
  final String owner;
  final String features;
  final String amenities;

  final String location;

  PropertyAttributes({
    required this.categoryId,
    required this.type,
    required this.catName,
    required this.yearBuilt,
    required this.owner,
    required this.amenities,
    required this.area,
    required this.features,
    required this.bedroom,
    required this.location,
  });

  factory PropertyAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return PropertyAttributes(
      categoryId: json['category_id'],
      type: json['type'] ?? '',
      catName: json['category_name'] ?? '',
      yearBuilt: json['yearBuilt'] ?? '',
      owner: json['owner'] ?? '',
      amenities: json['Amenities'] ?? '',
      area: json['area'] ?? '',
      bedroom: json['bedrooms'] ?? '',
      features: json['feature'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class JobAttributes {
  dynamic categoryId;
  final String catName;
  final String type;
  final String education;
  final String experience;
  final String salary;
  final String salaryPeriod;
  final String possitionType;
  final String carrerLevel;
  final String companyName;

  final String location;

  JobAttributes({
    required this.categoryId,
    required this.type,
    required this.catName,
    required this.education,
    required this.companyName,
    required this.carrerLevel,
    required this.salary,
    required this.salaryPeriod,
    required this.experience,
    required this.possitionType,
    required this.location,
  });

  factory JobAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return JobAttributes(
      categoryId: json['category_id'],
      type: json['type'] ?? '',
      catName: json['category_name'] ?? '',
      education: json['education'] ?? '',
      salaryPeriod: json['salaryPeriod'] ?? '',
      carrerLevel: json['carrierLevel'] ?? '',
      possitionType: json['possitionType'] ?? '',
      salary: json['salary'] ?? '',
      experience: json['experience'] ?? '',
      companyName: json['companyName'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class BikeAttributes {
  dynamic categoryId;
  dynamic subCategoryId;
  String subCategoryName;
  final String catName;
  final String engineCapacity;
  final String model;

  final String location;

  BikeAttributes({
    required this.categoryId,
    required this.engineCapacity,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.catName,
    required this.model,
    required this.location,
  });

  factory BikeAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return BikeAttributes(
      categoryId: json['category_id'],
      engineCapacity: json['engineCapacity'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      subCategoryName: json['subCategoryName'] ?? '',
      catName: json['category_name'] ?? '',
      model: json['model'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class ServicesAttributes {
  dynamic categoryId;
  dynamic subCategoryId;
  final String catName;
  final String subCategoryName;
  final String car;

  final String location;

  ServicesAttributes({
    required this.categoryId,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.car,
    required this.catName,
    required this.location,
  });

  factory ServicesAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ServicesAttributes(
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      subCategoryName: json['subCategoryName'] ?? '',
      car: json['car'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class KidsAttributes {
  dynamic categoryId;
  dynamic subCategoryId;
  final String catName;
  final String subCatName;
  final String condition;
  final String toy;

  final String location;

  KidsAttributes({
    required this.categoryId,
    required this.subCategoryId,
    required this.toy,
    required this.catName,
    required this.subCatName,
    required this.condition,
    required this.location,
  });

  factory KidsAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return KidsAttributes(
      categoryId: json['category_id'] ?? '',
      subCategoryId: json['subCatId'] ?? '',
      subCatName: json['subCatName'] ?? '',
      condition: json['condition'] ?? '',
      catName: json['category_name'] ?? '',
      toy: json['toy'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class AnimalsAttributes {
  dynamic categoryId;
  dynamic subCategoryId;
  final String catName;
  final String subCatName;
  final String age;
  final String breed;

  final String location;

  AnimalsAttributes({
    required this.categoryId,
    required this.subCategoryId,
    required this.subCatName,
    required this.age,
    required this.breed,
    required this.catName,
    required this.location,
  });

  factory AnimalsAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return AnimalsAttributes(
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      subCategoryId: json['subcategoryId'] ?? '',
      subCatName: json['subCatName'] ?? '',
      age: json['age'] ?? '',
      breed: json['breed'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class FurnitureAttributes {
  dynamic categoryId;
  final String catName;
  final String condition;
  final String type;
  final String price;
  final String color;

  final String location;

  FurnitureAttributes({
    required this.categoryId,
    required this.type,
    required this.condition,
    required this.color,
    required this.catName,
    required this.price,
    required this.location,
  });

  factory FurnitureAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return FurnitureAttributes(
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      condition: json['condition'] ?? '',
      type: json['type'] ?? '',
      price: json['price'] ?? '',
      color: json['color'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class ElectronicApplicanceAttributes {
  dynamic categoryId;
  final String catName;
  final String condition;
  final String brand;
  final String price;
  final String color;

  final String location;

  ElectronicApplicanceAttributes({
    required this.categoryId,
    required this.condition,
    required this.brand,
    required this.color,
    required this.catName,
    required this.price,
    required this.location,
  });

  factory ElectronicApplicanceAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ElectronicApplicanceAttributes(
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      brand: json['brand'] ?? '',
      condition: json['condition'] ?? '',
      price: json['price'] ?? '',
      color: json['color'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
