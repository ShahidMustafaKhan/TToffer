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
      subCatName: json['sub_category_name'] ?? '',
      suitType: json['suitType'] ?? '',
      fabric: json['fabric'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class MobileAttributes {
  dynamic categoryId;
  final String catName;
  final String subCatName;
  final String condition;

  final String brand;
  final String storage;
  final String color;

  final String location;

  MobileAttributes({
    required this.categoryId,
    required this.brand,
    required this.catName,
    required this.subCatName,
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
      subCatName: json['sub_category_name'] ?? '',
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
  final String owner;

  final String year;
  final String color;
  final String FuelType;
  final String subCatName;

  final String location;

  VehicleAttributes({
    required this.categoryId,
    required this.makeModel,
    required this.catName,
    required this.owner,
    required this.subCatName,
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
      subCatName: json['sub_category_name'] ?? '',
      owner: json['owner'] ?? '',
      mileAge: json['kilometres'] ?? '',
      year: json['year'] ?? '',
      color: json['color'] ?? '',
      FuelType: json['fuelType'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class ProductAttributes {
  dynamic categoryId;
  dynamic subcategory;



  ProductAttributes({
    required this.categoryId,
    required this.subcategory,
  });

  factory ProductAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ProductAttributes(
      categoryId: json['category_id'],
      subcategory: json['sub_category_name'],
    );
  }
}

class PropertyAttributes {
  dynamic categoryId;
  final String catName;
  final String bedroom;
  final String yearBuilt;
  final String area;
  final String owner;
  final dynamic features;
  final String completion;
  final String furnished;
  final String bathroom;
  final String subCatName;
  final String location;
  final String totalClosingFee;
  final String developer;
  final String annualCommunityFee;
  final String propertyReferenceID;
  final String buyTransferFee;
  final String sellerTransferFee;
  final String maintenanceFee;
  final String occupancyStatus;
  final String zoneFor;

  PropertyAttributes(
     {
    required this.categoryId,
    required this.catName,
    required this.subCatName,
    required this.yearBuilt,
    required this.owner,
    required this.completion,
    required this.furnished,
    required this.area,
    required this.features,
    required this.bedroom,
    required this.bathroom,
    required this.location,
    required this.totalClosingFee,
       required this.developer,
       required this.annualCommunityFee,
       required this.propertyReferenceID,
       required this.buyTransferFee,
       required this.sellerTransferFee,
       required this.zoneFor,
       required this.maintenanceFee, required this.occupancyStatus,
  });

  factory PropertyAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return PropertyAttributes(
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      subCatName: json['sub_category_name'] ?? '',
      yearBuilt: json['yearBuilt'] ?? '',
      owner: json['owner'] ?? '',
      completion: json['completion'] ?? '',
      furnished: json['furnished'] ?? '',
      bathroom: json['bathroom'] ?? '',
      area: json['area'] ?? '',
      bedroom: json['bedrooms'] ?? '',
      features: json['feature'] ?? '',
      location: json['location'] ?? '',
      totalClosingFee: json['totalClosingFee'] ?? '',
      annualCommunityFee: json['annualCommunityFee'] ?? '',
      propertyReferenceID: json['propertyReferenceID'] ?? '',
      buyTransferFee: json['buyTransferFee'] ?? '',
      sellerTransferFee: json['sellerTransferFee'] ?? '',
      maintenanceFee: json['maintenanceFee'] ?? '',
      occupancyStatus: json['occupancyStatus'] ?? '',
      developer: json['developer'] ?? '',
      zoneFor: json['zoneFor'] ?? '',
    );
  }
}


class JobAttributes {
  dynamic categoryId;
  final String catName;
  final String subCatName;
  final String type;
  final String education;
  final String experience;
  final String salary;
  final String salaryPeriod;
  final String possitionType;
  final String companyName;
  final String linkedinProfile;
  final String description;
  final String hireStatus;

  final String location;

  JobAttributes({
    required this.categoryId,
    required this.type,
    required this.catName,
    required this.subCatName,
    required this.education,
    required this.companyName,
    required this.salary,
    required this.salaryPeriod,
    required this.experience,
    required this.possitionType,
    required this.linkedinProfile,
    required this.description,
    required this.location,
    required this.hireStatus,
  });

  factory JobAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return JobAttributes(
      categoryId: json['category_id'],
      type: json['type'] ?? '',
      catName: json['category_name'] ?? '',
      subCatName: json['sub_category_name'] ?? '',
      education: json['education'] ?? '',
      salaryPeriod: json['salaryPeriod'] ?? '',
      possitionType: json['possitionType'] ?? '',
      salary: json['salary'] ?? '',
      experience: json['experienceLevel'] ?? '',
      linkedinProfile: json['linkedinProfile'] ?? '',
      companyName: json['companyName'] ?? '',
      location: json['location'] ?? '',
      hireStatus: json['hireStatus'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class BikeAttributes {
  dynamic categoryId;
  dynamic subCategoryId;
  String subCategoryName;
  final String catName;
  final String engineCapacity;
  final String? description;
  final String model;

  final String location;

  BikeAttributes({
    required this.categoryId,
    required this.description,
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
      description: json['description'],
      engineCapacity: json['engineCapacity'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
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
  final String? description;
  final String location;

  ServicesAttributes({
    required this.categoryId,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.description,
    required this.car,
    required this.catName,
    required this.location,
  });

  factory ServicesAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ServicesAttributes(
      description: json['description'],
      categoryId: json['category_id'],
      catName: json['category_name'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
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
  final String? description;

  final String location;

  KidsAttributes({
    required this.categoryId,
    required this.description,
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
      description: json['description'],
      subCategoryId: json['subCatId'] ?? '',
      subCatName: json['sub_category_name'] ?? '',
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
  final String? description;

  final String location;

  AnimalsAttributes({
    required this.categoryId,
    required this.subCategoryId,
    required this.subCatName,
    required this.description,
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
      description: json['description'],
      subCategoryId: json['subcategoryId'] ?? '',
      subCatName: json['sub_category_name'] ?? '',
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
  final String subCatName;
  final String? description;

  final String location;

  FurnitureAttributes({
    required this.categoryId,
    required this.type,
    required this.condition,
    required this.color,
    required this.catName,
    required this.description,
    required this.subCatName,
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
      subCatName: json['sub_category_name'] ?? '',
      condition: json['condition'] ?? '',
      description: json['description'],
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
  final String subCatName;

  final String location;

  ElectronicApplicanceAttributes({
    required this.categoryId,
    required this.condition,
    required this.brand,
    required this.color,
    required this.catName,
    required this.subCatName,
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
      subCatName: json['sub_category_name'] ?? '',
      brand: json['brand'] ?? '',
      condition: json['condition'] ?? '',
      price: json['price'] ?? '',
      color: json['color'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
