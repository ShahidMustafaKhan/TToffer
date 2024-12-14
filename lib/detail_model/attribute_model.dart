import 'dart:convert';

class FashionAttributes {
  final String fabric;
  final String suitType;
  final String location;

  FashionAttributes({
    required this.suitType,
    required this.fabric,
    required this.location,
  });

  factory FashionAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return FashionAttributes(
      suitType: json?['suitType'] ?? '',
      fabric: json?['fabric'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class MobileAttributes {
  dynamic categoryId;
  final String condition;
  final String brand;
  final String storage;
  final String color;
  final String location;

  MobileAttributes({
    required this.brand,
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
      condition: json?['condition'] ?? '',
      brand: json?['brand'] ?? '',
      storage: json?['storage'] ?? '',
      color: json?['color'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class VehicleAttributes {
  dynamic categoryId;
  final String mileAge;
  final String makeModel;
  final String owner;
  final String year;
  final String color;
  final String fuelType;
  final String location;

  VehicleAttributes({
    required this.makeModel,
    required this.owner,
    required this.year,
    required this.mileAge,
    required this.color,
    required this.fuelType,
    required this.location,
  });

  factory VehicleAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return VehicleAttributes(
      makeModel: json?['makeAndModel'] ?? '',
      owner: json?['owner'] ?? '',
      mileAge: json?['kilometres'] ?? '',
      year: json?['year'] ?? '',
      color: json?['color'] ?? '',
      fuelType: json?['fuelType'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class ProductAttributes {
  dynamic categoryId;
  dynamic subcategory;

  ProductAttributes({
    required this.subcategory,
  });

  factory ProductAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ProductAttributes(
      subcategory: json?['sub_category_name'] ?? '',
    );
  }
}

class PropertyAttributes {
  dynamic categoryId;
  final String bedroom;
  final String yearBuilt;
  final String area;
  final String owner;
  final dynamic features;
  final String completion;
  final String furnished;
  final String bathroom;
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

  PropertyAttributes({
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
    required this.maintenanceFee,
    required this.occupancyStatus,
  });

  factory PropertyAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return PropertyAttributes(
      yearBuilt: json?['yearBuilt'] ?? '',
      owner: json?['owner'] ?? '',
      completion: json?['completion'] ?? '',
      furnished: json?['furnished'] ?? '',
      bathroom: json?['bathroom'] ?? '',
      area: json?['area'] ?? '',
      bedroom: json?['bedrooms'] ?? '',
      features: json?['feature'] ?? '',
      location: json?['location'] ?? '',
      totalClosingFee: json?['totalClosingFee'] ?? '',
      annualCommunityFee: json?['annualCommunityFee'] ?? '',
      propertyReferenceID: json?['propertyReferenceID'] ?? '',
      buyTransferFee: json?['buyTransferFee'] ?? '',
      sellerTransferFee: json?['sellerTransferFee'] ?? '',
      maintenanceFee: json?['maintenanceFee'] ?? '',
      occupancyStatus: json?['occupancyStatus'] ?? '',
      developer: json?['developer'] ?? '',
      zoneFor: json?['zoneFor'] ?? '',
    );
  }
}

class JobAttributes {
  dynamic categoryId;
  final String type;
  final String education;
  final String experience;
  final String salary;
  final String salaryPeriod;
  final String positionType;
  final String companyName;
  final String linkedinProfile;
  final String description;
  final String hireStatus;
  final String location;

  JobAttributes({
    required this.type,
    required this.education,
    required this.companyName,
    required this.salary,
    required this.salaryPeriod,
    required this.experience,
    required this.positionType,
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
      type: json?['type'] ?? '',
      education: json?['education'] ?? '',
      salaryPeriod: json?['salaryPeriod'] ?? '',
      positionType: json?['positionType'] ?? '',
      salary: json?['salary'] ?? '',
      experience: json?['experienceLevel'] ?? '',
      linkedinProfile: json?['linkedinProfile'] ?? '',
      companyName: json?['companyName'] ?? '',
      location: json?['location'] ?? '',
      hireStatus: json?['hireStatus'] ?? '',
      description: json?['description'] ?? '',
    );
  }
}

class BikeAttributes {
  final String subCategoryName;
  final String engineCapacity;
  final String? description;
  final String model;
  final String location;

  BikeAttributes({
    required this.description,
    required this.engineCapacity,
    required this.subCategoryName,
    required this.model,
    required this.location,
  });

  factory BikeAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return BikeAttributes(
      description: json?['description'] ?? '',
      engineCapacity: json?['engineCapacity'] ?? '',
      subCategoryName: json?['sub_category_name'] ?? '',
      model: json?['model'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class ServicesAttributes {
  final String subCategoryName;
  final String car;
  final String? description;
  final String location;

  ServicesAttributes({
    required this.subCategoryName,
    required this.description,
    required this.car,
    required this.location,
  });

  factory ServicesAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ServicesAttributes(
      description: json?['description'] ?? '',
      subCategoryName: json?['sub_category_name'] ?? '',
      car: json?['car'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class KidsAttributes {
  final String condition;
  final String toy;
  final String? description;
  final String location;

  KidsAttributes({
    required this.description,
    required this.toy,
    required this.condition,
    required this.location,
  });

  factory KidsAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return KidsAttributes(
      description: json?['description'] ?? '',
      condition: json?['condition'] ?? '',
      toy: json?['toy'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class AnimalsAttributes {
  final String age;
  final String breed;
  final String? description;
  final String location;

  AnimalsAttributes({
    required this.description,
    required this.age,
    required this.breed,
    required this.location,
  });

  factory AnimalsAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return AnimalsAttributes(
      description: json?['description'] ?? '',
      age: json?['age'] ?? '',
      breed: json?['breed'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class FurnitureAttributes {
  dynamic categoryId;
  final String condition;
  final String type;
  final String price;
  final String color;
  final String? description;
  final String location;

  FurnitureAttributes({
    required this.type,
    required this.condition,
    required this.color,
    required this.description,
    required this.price,
    required this.location,
  });

  factory FurnitureAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return FurnitureAttributes(
      condition: json?['condition'] ?? '',
      description: json?['description'],
      type: json?['type'] ?? '',
      price: json?['price'] ?? '',
      color: json?['color'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}

class ElectronicApplianceAttributes {
  dynamic categoryId;
  final String condition;
  final String brand;
  final String price;
  final String color;
  final String location;

  ElectronicApplianceAttributes({
    required this.brand,
    required this.condition,
    required this.price,
    required this.color,
    required this.location,
  });

  factory ElectronicApplianceAttributes.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ElectronicApplianceAttributes(
      condition: json?['condition'] ?? '',
      brand: json?['brand'] ?? '',
      price: json?['price'] ?? '',
      color: json?['color'] ?? '',
      location: json?['location'] ?? '',
    );
  }
}
