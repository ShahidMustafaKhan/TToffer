// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/models/sub_categories_model.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/views/Post%20screens/set_price_screen.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class PostDetailScreen extends StatefulWidget {
  final productId;
  String title;
  Selling? selling;

  PostDetailScreen(
      {super.key, this.productId, required this.title, this.selling});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  subCategoriesHandler() async {
    await SubCategoriesService().subCategoriesService(context: context);
  }

  String? _selectedCategory = '';
  String? _selectedSubCategory = '';
  String _selectedCondition = "";
  var catagoryId;
  var subCatagoryId;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _millageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _modelYearController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _authenticityController = TextEditingController();
  final TextEditingController _editionController = TextEditingController();

  bool _isLoading = false;
  AppLogger logger = AppLogger();
  var catagoryData;
  var subCatagoryData;

  bool _dataInitialized = false; // Flag to prevent reinitialization

  @override
  void initState() {
    logger.init();
    getCatagories(search: "");
    getSubCatagories(search: "");

    subCategoriesHandler();
    super.initState();
  }

  List<CategoryModel> catModel = [];
  List<SubCategoriesModel> subCatModel = [];

  List<String> makeModel = ['Audi', 'BMW', 'Corolla'];
  List<String> year = ['2021', '2000', '2001'];
  List<String> condition = ["New", "Good", "Open Box", "Refurnished"];
  List<String> priceRange = ["Under\$10,000"];
  List<String> mileage = ['Under 10,000 miles', ''];
  List<String> fuelType = ['Diesel', 'Petrol', 'Gas'];
  List<String> color = ['White', 'Black', 'Red', 'Pink'];
  List<String> location = ['America'];

  bool owner = false;
  bool dealer = false;

  String? typeProperty = '';
  String? bedrooms = '';
  String? area = '';
  String? yearBuilt = '';
  String? features = '';
  String? amenities = '';

  List<String> typePropertyList = ['Apartment'];
  List<String> bedroomList = ['1', '2', '3', '4', '5', '6+', 'Studio'];
  List<String> areaSizeList = ['1,000 sqft', '2,000 sqft', '3,000 sqft'];
  List<String> yearBuiltList = ['2020', '2021', '2000', '2001', '2005', '2007'];
  List<String> featuresList = ['Apartment'];
  List<String> amenitiesList = ['Apartment'];

  String? brand = '';
  String? storage = '';

  List<String> brandList = [
    'Samsung',
    'Infinix',
    'Xiaomi',
    'Motorola',
    'Huawei',
    'Apple'
  ];
  List<String> storageList = [
    '32GB',
    '16GB',
    '64GB',
    '128GB',
    '256GB',
    '512GB',
    '1 TB+'
  ];

  String? engineCapacity = '';
  String? model = '';

  List<String> engineList = [
    '50cc',
    '60cc',
    '150cc',
    '250cc',
    '500cc',
    '1000cc'
  ];
  List<String> modelList = ['Yamaha R1', 'Honda 125', 'Kawasaki'];

  String? car = '';

  List<String> carList = [
    'Corolla',
    'Alto',
    'Honda',
    'Sonata',
    'Toyota',
    'Hyundai'
  ];

  //Jobs

  String? jobType = '';
  String? experience = '';
  String? education = '';
  String? salary = '';
  String? salaryPeriod = '';
  String? companyName = '';
  String? possitionType = '';
  String? careerLevel = '';

  List<String> jobTypeList = [
    'Graphic Design',
    'Software Engineer',
    'Electric Engineer',
    'Mechanic',
    'Painter'
  ];
  List<String> experienceList = ['Fresh', 'Intermediate'];
  List<String> educationList = ['Intermediate'];
  List<String> salaryList = ["\$30,000", '\$50,000', '\$60,000'];
  List<String> salaryPeriodList = ['Monthly', 'Daily', 'Weekly'];
  List<String> companyNameList = ['DevSinc', 'Systems Limited', 'Neon System'];
  List<String> possitionTypeList = ['Full Time', 'Half Time'];
  List<String> careerLevelList = ['Mid - Senior Level', 'Full - Senior Level'];

  String? age = '';
  String? breed = '';

  List<String> ageList = ['1 year', '2 year', '3 year', '5 year'];
  List<String> breedList = ['Husky', 'Bully', 'Pointer'];

  String? furnitureType = '';

  List<String> furnitureList = ['1 seater', '2 seater', '3 seater', '4 seater'];

  String? kids = '';

  List<String> kidsList = ['Doll', 'Car'];

  String? fabric = '';
  String? suitType = '';

  List<String> fabricList = ['Cotton', 'Khadar', 'Washing Ware'];
  List<String> suitTypeList = ['Tuxedo'];

  TextEditingController priceController = TextEditingController();
  TextEditingController mileAgeController = TextEditingController();

  String? catId;

  //ElectronicAmplience

  List<String> electricBrand = [
    'Dawlence',
    'Pel',
    'LG',
    'Samsung',
    'Bosch',
    'Kenmore',
    'Amana'
  ];
  String? selectElectricBrand;

  VehicleAttributes? vehicleAttributes;
  MobileAttributes? mobileAttributes;
  FashionAttributes? fashionAttributes;
  PropertyAttributes? propertyAttributes;
  JobAttributes? jobAttributes;
  BikeAttributes? bikeAttributes;
  ServicesAttributes? servicesAttributes;
  KidsAttributes? kidsAttributes;
  AnimalsAttributes? animalsAttributes;
  FurnitureAttributes? furnitureAttributes;
  ElectronicApplicanceAttributes? electronicApplicanceAttributes;

  @override
  Widget build(BuildContext context) {
    print("object$_selectedCategory");
    return Consumer2<CategoryProvider, SubCategoriesProvider>(
        builder: (context, category, subCat, _) {
      final parseData = widget.selling?.attributes ?? {};

      if (!_dataInitialized &&
          subCatModel.isNotEmpty &&
          widget.selling != null &&
          parseData != null) {
        vehicleAttributes = VehicleAttributes.fromJson(parseData);
        mobileAttributes = MobileAttributes.fromJson(parseData);
        fashionAttributes = FashionAttributes.fromJson(parseData);
        propertyAttributes = PropertyAttributes.fromJson(parseData);
        jobAttributes = JobAttributes.fromJson(parseData);
        bikeAttributes = BikeAttributes.fromJson(parseData);
        servicesAttributes = ServicesAttributes.fromJson(parseData);
        kidsAttributes = KidsAttributes.fromJson(parseData);
        animalsAttributes = AnimalsAttributes.fromJson(parseData);
        furnitureAttributes = FurnitureAttributes.fromJson(parseData);
        electronicApplicanceAttributes =
            ElectronicApplicanceAttributes.fromJson(parseData);

        _selectedCategory = vehicleAttributes?.catName ?? '';
        _selectedCategory = mobileAttributes?.catName ?? '';
        brand = mobileAttributes?.brand ?? '';
        colorSelect = mobileAttributes!.color;
        typeProperty = propertyAttributes!.type;
        conditionSelect = 'New';
        storage = mobileAttributes?.storage ?? '';
        _colorController.text = mobileAttributes?.color ?? '';
        bedrooms = propertyAttributes!.bedroom;
        area = propertyAttributes!.area;
        features = propertyAttributes!.features;
        selectMakeModel = vehicleAttributes!.makeModel;
        yearModel = vehicleAttributes!.year;
        conditionSelect = 'New';
        mileAgeSelect = vehicleAttributes!.mileAge;
        yearBuilt = vehicleAttributes!.year;
        fuelTypeSelect = vehicleAttributes!.FuelType;
        colorSelect = vehicleAttributes!.color;
        mileAgeController.text=vehicleAttributes!.mileAge;
        amenities = propertyAttributes!.amenities;
        yearBuilt = propertyAttributes!.yearBuilt;

        brand = electronicApplicanceAttributes!.brand;
        conditionSelect = electronicApplicanceAttributes!.condition;
        colorSelect = electronicApplicanceAttributes!.color;

        catagoryId = vehicleAttributes!.categoryId;
        catagoryId = propertyAttributes!.categoryId;
        catagoryId = mobileAttributes!.categoryId;
        catagoryId = electronicApplicanceAttributes!.categoryId;
        catagoryId = bikeAttributes!.categoryId;
        catagoryId = jobAttributes!.categoryId;
        catagoryId = servicesAttributes!.categoryId;
        catagoryId = animalsAttributes!.categoryId;
        catagoryId = furnitureAttributes!.categoryId;
        catagoryId = fashionAttributes!.categoryId;
        catagoryId = kidsAttributes!.categoryId;

        print('catCat------>${catagoryId}');

        engineCapacity = bikeAttributes!.engineCapacity;
        model = bikeAttributes!.model;
        subCatagoryId = bikeAttributes!.subCategoryId;
        _selectedSubCategory = bikeAttributes!.subCategoryName;

        jobType = jobAttributes!.type;
        experience = jobAttributes!.experience;
        salary = jobAttributes!.salary;
        salaryPeriod = 'Monthly';
        companyName = jobAttributes!.companyName;

        car = servicesAttributes!.car;
        subCatagoryId = servicesAttributes!.subCategoryId;
        _selectedSubCategory = servicesAttributes!.subCategoryName;

        age = animalsAttributes!.age;
        breed = animalsAttributes!.breed;
        subCatagoryId = animalsAttributes!.subCategoryId;
        _selectedSubCategory = animalsAttributes!.subCatName;

        furnitureType = furnitureAttributes!.type;
        colorSelect = furnitureAttributes!.color;

        fabric = fashionAttributes!.fabric;
        suitType = fashionAttributes!.suitType;
        subCatagoryId = fashionAttributes!.subCategoryId;
        _selectedSubCategory = fashionAttributes!.subCatName;

        kids = kidsAttributes!.toy;
        subCatagoryId = kidsAttributes!.subCategoryId;
        _selectedSubCategory = kidsAttributes!.subCatName;

        // Mark data as initialized
        _dataInitialized = true;
      }

      catModel = category.category;
      subCatModel = subCat.subCategories;

      Map<String, dynamic> mobileJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'brand': brand ?? '',
        'condition': conditionSelect ?? '',
        'price': priceController.text.trim() ?? '',
        'storage': storage ?? '',
        'color': colorSelect ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> propertyForSaleJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'type': typeProperty ?? '',
        'bedrooms': bedrooms ?? '',
        'area': area ?? '',
        'condition': 'New',
        'yearBuilt': yearBuilt ?? '',
        'feature': features ?? '',
        'Amenities': amenities ?? '',
        'price': priceController.text.trim() ?? '',
        'storage': storage ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> vehiclesJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'makeAndModel': selectMakeModel ?? '',
        'year': yearModel ?? '',
        'condition': conditionSelect ?? '',
        'mileage': mileAgeController.text.trim() ?? '',
        'fuelType': fuelTypeSelect ?? '',
        'color': colorSelect ?? '',
        'price': priceController.text.trim() ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> propertyForRentJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'type': typeProperty ?? '',
        'bedrooms': bedrooms ?? '',
        'area': area ?? '',
        'condition': 'New',
        'yearBuilt': yearBuilt ?? '',
        'feature': features ?? '',
        'Amenities': amenities ?? '',
        'price': priceController.text.trim() ?? '',
        'storage': storage ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> bikeJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'subCatId': subCatagoryId ?? '',
        'subCatName': _selectedSubCategory ?? '',
        'condition': 'New',
        'engineCapacity': engineCapacity ?? '',
        'model': model ?? '',
        'price': priceController.text.trim() ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> jobJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'type': jobType ?? '',
        'experience': experience ?? '',
        'education': education ?? '',
        'salary': salary ?? '',
        'condition': 'New',
        'salaryPeriod': salaryPeriod ?? '',
        'companyName': companyName ?? '',
        'possitionType': possitionType ?? '',
        'carrierLevel': careerLevel ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> servicesJson = {
        'category_id': catagoryId ?? '',
        'subCategoryName': _selectedSubCategory ?? '',
        'subCategoryId': subCatagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'subcategory': subCatagoryId ?? '',
        'condition': conditionSelect ?? '',
        'price': priceController.text.trim() ?? '',
        'car': car ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> animalsJson = {
        'category_id': catagoryId ?? '',
        'subCatName': _selectedSubCategory ?? '',
        'subcategoryId': subCatagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'condition': 'New',
        'subcategory': subCatagoryId ?? '',
        'age': age ?? '',
        'price': priceController.text.trim() ?? '',
        'breed': breed ?? '',
        'location': locationSelect ?? '',
      };
      Map<String, dynamic> furnitureJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'subcategory': subCatagoryId ?? '',
        'type': furnitureType ?? '',
        'condition': conditionSelect ?? '',
        'color': colorSelect ?? '',
        'price': priceController.text.trim() ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> fashionJson = {
        'category_id': catagoryId ?? '',
        'subCatName': _selectedSubCategory ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'subCategoryId': subCatagoryId ?? '',
        'condition': 'New',
        'fabric': fabric ?? '',
        'suitType': suitType ?? '',
        'price': priceController.text ?? '',
        'location': locationSelect ?? '',
      };
      Map<String, dynamic> kidsJson = {
        'category_id': catagoryId ?? '',
        'subCatName': _selectedSubCategory ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'subcategoryId': subCatagoryId ?? '',
        'condition': conditionSelect ?? '',
        'toy': kids ?? '',
        'price': priceController.text.trim() ?? '',
        'location': locationSelect ?? '',
      };

      Map<String, dynamic> electricApplianceJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'condition': conditionSelect ?? '',
        'brand': selectElectricBrand ?? '',
        'price': priceController.text.trim() ?? '',
        'location': locationSelect ?? '',
      };

      return Scaffold(
        appBar: CustomAppBar1(
          title: "Detail",
          action: true,
          img: "assets/images/cross.png",
          actionOntap: () {
            pushUntil(context, const BottomNavView());
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                StepsIndicator(
                  conColor1: AppTheme.appColor,
                  circleColor1: AppTheme.appColor,
                  circleColor2: AppTheme.appColor,
                  conColor2: AppTheme.appColor,
                ),
                const SizedBox(
                  height: 20,
                ),

                _selectedCategory == 'Property for Rent' ||
                        _selectedCategory == 'Property for Sale'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customCheckBox(owner, (val) {
                            owner = val!;
                            dealer = false;
                            setState(() {});
                          }, 'Owner'),
                          customCheckBox(dealer, (val) {
                            dealer = val!;
                            owner = false;
                            setState(() {});
                          }, 'Dealer'),
                        ],
                      )
                    : SizedBox.shrink(),

                customRow(
                    onTap: () {
                      _showCategoryBottomSheet(context);
                    },
                    title: "Category(required)",
                    selectText: _selectedCategory ?? 'Select Category'),

                _selectedCategory == 'Electronic & Appliance'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeElectricBrand(context);
                              },
                              title: 'Brand',
                              selectText:
                                  selectElectricBrand ?? 'Select Brand'),
                          customRow(
                              onTap: () {
                                conditionBottom(context);
                              },
                              title: 'Condition',
                              selectText:
                                  conditionSelect ?? 'Select Condition'),
                          // PostTextField(
                          //     txt: 'Price',
                          //     textEditingController: priceController),
                          customRow(
                              onTap: () {
                                colorTypeBottom(context);
                              },
                              title: 'Color',
                              selectText: colorSelect ?? 'Select Color'),
                          // customRow(
                          //     onTap: () {
                          //       locationTypeBottom(context);
                          //     },
                          //     title: 'Location',
                          //     selectText: locationSelect ?? 'Select Location'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Fashion (dress) and beauty'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeSubCategoriesBottom(context);
                              },
                              title: 'Subcategories',
                              selectText: _selectedSubCategory ??
                                  'Select Subcategories'),
                          customRow(
                              onTap: () {
                                makeFabricTypeBottom(context);
                              },
                              title: 'Fabric',
                              selectText: fabric ?? 'Select Fabric'),

                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),
                          customRow(
                              onTap: () {
                                makeSuitTypeTypeBottom(context);
                              },
                              title: 'Suit Type',
                              selectText: suitType ?? 'Select Suit Type'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Kids'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeSubCategoriesBottom(context);
                              },
                              title: 'Subcategories',
                              selectText: _selectedSubCategory ??
                                  'Select Subcategories'),
                          customRow(
                              onTap: () {
                                conditionBottom(context);
                              },
                              title: 'Condition',
                              selectText:
                                  conditionSelect ?? 'Select Condition'),
                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),

                          customRow(
                              onTap: () {
                                makeKidsTypeBottom(context);
                              },
                              title: 'Toy',
                              selectText: kids ?? 'Select Toy'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Furniture and home decor'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeFurnitureTypeBottom(context);
                              },
                              title: 'Choose Type',
                              selectText: furnitureType ?? 'Select Type'),
                          customRow(
                              onTap: () {
                                conditionBottom(context);
                              },
                              title: 'Condition',
                              selectText:
                                  conditionSelect ?? 'Select Condition'),

                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),
                          customRow(
                              onTap: () {
                                colorTypeBottom(context);
                              },
                              title: 'Color',
                              selectText: colorSelect ?? 'Select Color'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Animals'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeSubCategoriesBottom(context);
                              },
                              title: 'Subcategories',
                              selectText: _selectedSubCategory ??
                                  'Select Subcategories'),
                          customRow(
                              onTap: () {
                                makeAgeTypeBottom(context);
                              },
                              title: 'Age',
                              selectText: age ?? 'Select Age'),

                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),
                          customRow(
                              onTap: () {
                                makeBreedTypeBottom(context);
                              },
                              title: 'Breed',
                              selectText: breed ?? 'Select Breed'),
                          // customRow(
                          //     onTap: () {
                          //       locationTypeBottom(context);
                          //     },
                          //     title: 'Location',
                          //     selectText: locationSelect ?? 'Select Location'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Job'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeJobTypeBottom(context);
                              },
                              title: 'Type',
                              selectText: jobType ?? 'Select Job Type'),
                          customRow(
                              onTap: () {
                                makeExperienceBottom(context);
                              },
                              title: 'Experience',
                              selectText: experience ?? 'Select Experience'),
                          customRow(
                              onTap: () {
                                makeEducationBottom(context);
                              },
                              title: 'Education',
                              selectText: education ?? 'Select Education'),
                          customRow(
                              onTap: () {
                                makeSalaryBottom(context);
                              },
                              title: 'Salary',
                              selectText: salary ?? 'Select Salary'),
                          customRow(
                              onTap: () {
                                makeSalaryPeriodBottom(context);
                              },
                              title: 'Salary Period',
                              selectText:
                                  salaryPeriod ?? 'Select Salary Period'),
                          customRow(
                              onTap: () {
                                makeCompanyNameBottom(context);
                              },
                              title: 'Company Name',
                              selectText: companyName ?? 'Select Company Name'),
                          customRow(
                              onTap: () {
                                makePossitionTypeBottom(context);
                              },
                              title: 'Position Type',
                              selectText: jobType ?? 'Select Position Type'),
                          customRow(
                              onTap: () {
                                makeCarrieLevelBottom(context);
                              },
                              title: 'Carrie Level',
                              selectText: careerLevel ?? 'Select Carrie Level'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Services'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeSubCategoriesBottom(context);
                              },
                              title: 'Subcategories',
                              selectText: _selectedSubCategory ??
                                  'Select Subcategories'),
                          customRow(
                              onTap: () {
                                conditionBottom(context);
                              },
                              title: 'Condition',
                              selectText:
                                  conditionSelect ?? 'Select Condition'),

                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),
                          customRow(
                              onTap: () {
                                makeCarBottom(context);
                              },
                              title: 'Car',
                              selectText: car ?? 'Select Car'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Bike'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeSubCategoriesBottom(context);
                              },
                              title: 'Subcategories',
                              selectText: _selectedSubCategory ??
                                  'Select Subcategories'),
                          customRow(
                              onTap: () {
                                makeEngineCapacityBottom(context);
                              },
                              title: 'Engine Capacity',
                              selectText: engineCapacity ?? 'Select Capacity'),

                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),
                          customRow(
                              onTap: () {
                                makeBikeModelBottom(context);
                              },
                              title: 'Model',
                              selectText: model ?? 'Select Model'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Mobiles'
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeBrandBottom(context);
                              },
                              title: 'Brand',
                              selectText: brand ?? 'Select Brand'),
                          customRow(
                              onTap: () {
                                conditionBottom(context);
                              },
                              title: 'Condition',
                              selectText:
                                  conditionSelect ?? 'Select Condition'),

                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),
                          customRow(
                              onTap: () {
                                makeStorageBottom(context);
                              },
                              title: 'Storage Capacity',
                              selectText: storage ?? 'Select Storage'),
                          customRow(
                              onTap: () {
                                colorTypeBottom(context);
                              },
                              title: 'Color',
                              selectText: colorSelect ?? 'Select Color'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Property for Sale' ||
                        _selectedCategory == 'Property for Rent'
                    ? Column(children: [
                        customRow(
                            onTap: () {
                              makeTypeBottom(context);
                            },
                            title: 'Type',
                            selectText: typeProperty ?? 'Select Property Type'),
                        customRow(
                            onTap: () {
                              makeBedroomBottom(context);
                            },
                            title: 'Bedrooms',
                            selectText: bedrooms ?? 'Select Bedrooms'),

                        // customRow(
                        //     onTap: () {
                        //       priceRangeBottom(context);
                        //     },
                        //     title: 'Price',
                        //     selectText: priceRangeSelect ?? 'Select Price'),
                        customRow(
                            onTap: () {
                              areaBottom(context);
                            },
                            title: 'Area/Size',
                            selectText: area ?? 'Select Area'),
                        customRow(
                            onTap: () {
                              makeYearBottom(context);
                            },
                            title: 'Year Built',
                            selectText: yearBuilt ?? 'Select Year Built'),
                        customRow(
                            onTap: () {
                              makeFeaturesBottom(context);
                            },
                            title: 'Features',
                            selectText: features ?? 'Select Features'),
                        customRow(
                            onTap: () {
                              makeAmenitiesBottom(context);
                            },
                            title: 'Amenities',
                            selectText: amenities ?? 'Select Amenities'),
                      ])
                    : const SizedBox.shrink(),

                _selectedCategory != 'Vehicles'
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          _selectedCategory == null
                              ? const SizedBox.shrink()
                              : customRow(
                                  onTap: () {
                                    // _showCategoryBottomSheet(context);

                                    makeModelBottom(context);
                                  },
                                  title: _selectedCategory == 'Vehicles'
                                      ? "Make And Model:"
                                      : "",
                                  selectText:
                                      selectMakeModel ?? 'Select Model'),
                          _selectedCategory == null
                              ? const SizedBox.shrink()
                              : customRow(
                                  onTap: () {
                                    yearBottom(context);
                                  },
                                  title: _selectedCategory == 'Vehicles'
                                      ? "Year"
                                      : "",
                                  selectText: yearModel ?? 'Select Year'),
                          _selectedCategory == null
                              ? const SizedBox.shrink()
                              : customRow(
                                  onTap: () {
                                    conditionBottom(context);
                                  },
                                  title: _selectedCategory == 'Vehicles'
                                      ? "Condition"
                                      : "",
                                  selectText:
                                      conditionSelect ?? 'Select Condition'),

                          _selectedCategory == null
                              ? const SizedBox.shrink()
                              : PostTextField(
                                  txt: 'Mileage',
                                  textEditingController: mileAgeController),

                          // customRow(
                          //         onTap: () {
                          //           mileageBottom(context);
                          //         },
                          //         title: _selectedCategory == 'Vehicles'
                          //             ? "Mileage"
                          //             : "",
                          //         selectText:
                          //             mileAgeSelect ?? 'Select Mileage'),
                          _selectedCategory == null
                              ? const SizedBox.shrink()
                              : customRow(
                                  onTap: () {
                                    fuelTypeBottom(context);
                                  },
                                  title: _selectedCategory == 'Vehicles'
                                      ? "Fuel Type"
                                      : "",
                                  selectText:
                                      fuelTypeSelect ?? 'Select Fuel Type'),
                          _selectedCategory == null
                              ? const SizedBox.shrink()
                              : customRow(
                                  onTap: () {
                                    colorTypeBottom(context);
                                  },
                                  title: _selectedCategory == 'Vehicles'
                                      ? "Color"
                                      : "",
                                  selectText: colorSelect ?? 'Select Color'),
                        ],
                      ),
                // customRow(
                //   onTap: () {
                //     _showSubCategoryBottomSheet(context);
                //   },
                //   title: "Sub-category(optional)",
                //   selectText: _selectedSubCategory,
                // ),
                // customRow(
                //   onTap: () {
                //     _showConditionBottomSheet(context);
                //   },
                //   title: "Condition (required)",
                //   selectText: _selectedCondition,
                // ),
                // lableFields(
                //     lableTtxt: "Year, Make & Model(Optional)",
                //     controller: _modelYearController),
                // lableFields(
                //     lableTtxt: "Mileage (Optional)",
                //     controller: _millageController),
                // lableFields(
                //     lableTtxt: "Color (optional)",
                //     controller: _colorController),
                // lableFields(
                //     lableTtxt: "Brand (optional)",
                //     controller: _brandController),
                // lableFields(
                //     lableTtxt: "Model (optional)",
                //     controller: _modelController),
                // lableFields(
                //     lableTtxt: "Edition (optional)",
                //     controller: _editionController),
                // lableFields(
                //     lableTtxt: "Authenticity (optional)",
                //     controller: _authenticityController),
                _isLoading == true
                    ? LoadingDialog()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: AppButton.appButton("Next", onTap: () {
                          print("object $catagoryId  $subCatagoryId");
                          addProductDetail(_selectedCategory == 'Mobiles'
                              ? mobileJson
                              : _selectedCategory == 'Property for Sale'
                                  ? propertyForSaleJson
                                  : _selectedCategory == 'Vehicles'
                                      ? vehiclesJson
                                      : _selectedCategory == 'Property for Rent'
                                          ? propertyForRentJson
                                          : _selectedCategory == 'Bike'
                                              ? bikeJson
                                              : _selectedCategory == 'Job'
                                                  ? jobJson
                                                  : _selectedCategory ==
                                                          'Services'
                                                      ? servicesJson
                                                      : _selectedCategory ==
                                                              'Animals'
                                                          ? animalsJson
                                                          : _selectedCategory ==
                                                                  'Furniture and home decor'
                                                              ? furnitureJson
                                                              : _selectedCategory ==
                                                                      'Fashion (dress) and beauty'
                                                                  ? fashionJson
                                                                  : _selectedCategory ==
                                                                          'Kids'
                                                                      ? kidsJson
                                                                      : _selectedCategory ==
                                                                              'Electronic & Appliance'
                                                                          ? electricApplianceJson
                                                                          : {});
                        },
                            height: 53,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            radius: 32.0,
                            backgroundColor: AppTheme.appColor,
                            textColor: AppTheme.whiteColor),
                      )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget lableFields({lableTtxt, controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          LableTextField(
              labelTxt: "$lableTtxt",
              lableColor: AppTheme.hintTextColor,
              hintTxt: "",
              controller: controller),
          const CustomDivider(),
        ],
      ),
    );
  }

  Widget customRow({Function()? onTap, title, selectText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("$title",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.hintTextColor),
                  Image.asset(
                    "assets/images/arrowDown.png",
                    height: 14,
                    width: 14,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AppText.appText("$selectText",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.textColor),
              const SizedBox(
                height: 20,
              ),
              const CustomDivider()
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////   category bottom sheet ///////////////////////
  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AppText.appText(
                      "Categories",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomAppFormField(
                    radius: 15.0,
                    prefixIcon: Image.asset(
                      "assets/images/search.png",
                      height: 17,
                      color: AppTheme.textColor,
                    ),
                    texthint: "Search",
                    controller: _searchController,
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildCategoryList(setState)),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        _selectedCategory = _selectedCategory;
      });
    });
  }

  Widget _kidsData() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: kidsList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: kids == kidsList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      kids = kidsList[index];
                    } else {
                      kids = null;
                    }
                  });
                },
              ),
              AppText.appText(kidsList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //furniture

  Widget _ageType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: ageList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: age == ageList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      age = ageList[index];
                    } else {
                      age = null;
                    }
                  });
                },
              ),
              AppText.appText(ageList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //animals

  Widget _seaterType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: furnitureList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: furnitureType == furnitureList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      furnitureType = furnitureList[index];
                    } else {
                      furnitureType = null;
                    }
                  });
                },
              ),
              AppText.appText(furnitureList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _breedType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: breedList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: breed == breedList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      breed = breedList[index];
                    } else {
                      breed = null;
                    }
                  });
                },
              ),
              AppText.appText(breedList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //JobListData

  Widget _jobType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: jobTypeList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: jobType == jobTypeList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      jobType = jobTypeList[index];
                    } else {
                      jobType = null;
                    }
                  });
                },
              ),
              AppText.appText(jobTypeList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _experience() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: experienceList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: experience == experienceList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      experience = experienceList[index];
                    } else {
                      experience = null;
                    }
                  });
                },
              ),
              AppText.appText(experienceList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _education() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: educationList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: education == educationList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      education = educationList[index];
                    } else {
                      education = null;
                    }
                  });
                },
              ),
              AppText.appText(educationList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _salary() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: salaryList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: salary == salaryList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      salary = salaryList[index];
                    } else {
                      salary = null;
                    }
                  });
                },
              ),
              AppText.appText(salaryList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _salaryPeriod() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: salaryPeriodList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: salaryPeriod == salaryPeriodList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      salaryPeriod = salaryPeriodList[index];
                    } else {
                      salaryPeriod = null;
                    }
                  });
                },
              ),
              AppText.appText(salaryPeriodList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _companyName() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: companyNameList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: companyName == companyNameList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      companyName = companyNameList[index];
                    } else {
                      companyName = null;
                    }
                  });
                },
              ),
              AppText.appText(companyNameList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _possitiontype() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: possitionTypeList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: possitionType == possitionTypeList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      possitionType = possitionTypeList[index];
                    } else {
                      possitionType = null;
                    }
                  });
                },
              ),
              AppText.appText(possitionTypeList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _careerLevel() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: careerLevelList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: careerLevel == careerLevelList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      careerLevel = careerLevelList[index];
                    } else {
                      careerLevel = null;
                    }
                  });
                },
              ),
              AppText.appText(careerLevelList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //servicesData
  Widget _services() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: carList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: car == carList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      car = carList[index];
                    } else {
                      car = null;
                    }
                  });
                },
              ),
              AppText.appText(carList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  // bikeData

  Widget _engineCapacity() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: engineList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: engineCapacity == engineList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      engineCapacity = engineList[index];
                    } else {
                      engineCapacity = null;
                    }
                  });
                },
              ),
              AppText.appText(engineList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //suits

  Widget _fabric() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: fabricList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: fabric == fabricList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      fabric = fabricList[index];
                    } else {
                      fabric = null;
                    }
                  });
                },
              ),
              AppText.appText(fabricList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _suitType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: suitTypeList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: suitType == suitTypeList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      suitType = suitTypeList[index];
                    } else {
                      suitType = null;
                    }
                  });
                },
              ),
              AppText.appText(suitTypeList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _model() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: modelList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: model == modelList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      model = modelList[index];
                      print('model---?$model');
                    } else {
                      model = null;
                    }
                  });
                },
              ),
              AppText.appText(modelList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //SubCategories

  // Widget _buildSubCategoryList() {
  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       return Column(
  //         children:
  //             subCatModel.where((element) => element.id == catagoryId).map((e) {
  //           return Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(
  //               e.title.toString(),
  //               // Assuming `e.title` is the data you want to display
  //               style: TextStyle(fontSize: 16, color: Colors.black),
  //             ),
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  // }

  Widget _buildSubCategoryList() {
    return StatefulBuilder(
      builder: (context, setState) {
        final filteredSubCatModel =
            subCatModel.where((element) => element.id == int.parse(catagoryId)).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filteredSubCatModel.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value:
                      _selectedSubCategory == filteredSubCatModel[index].title,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        subCatagoryId = filteredSubCatModel[index].id;
                        print('subCatagoryId---->$subCatagoryId');
                        _selectedSubCategory =
                            filteredSubCatModel[index].title!;
                        catagoryId = filteredSubCatModel[index].id;
                      } else {
                        _selectedSubCategory = "";
                      }
                    });
                  },
                ),
                AppText.appText(
                  filteredSubCatModel[index].title!,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor,
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Categories
  Widget _buildCategoryList(StateSetter setState) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: catModel.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              checkColor: AppTheme.whiteColor,
              activeColor: AppTheme.appColor,
              // value: _selectedCategory == catagoryData[index]["name"],
              value: _selectedCategory == catModel[index].title,
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    // _selectedCategory = catagoryData[index]["name"];
                    _selectedCategory = catModel[index].title!;
                    catagoryId = catModel[index].id;
                    _selectedSubCategory = '';

                    print('catCat------>${catagoryId}');
                  } else {
                    _selectedCategory = "";
                  }
                });
              },
            ),
            AppText.appText(catModel[index].title!,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: AppTheme.textColor),
          ],
        );
      },
    );
  }

  //mobiles

  Widget _brand() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: brandList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: brand == brandList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      brand = brandList[index];
                    } else {
                      typeProperty = null;
                    }
                  });
                },
              ),
              AppText.appText(brandList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

//
  Widget _storage() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: storageList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: storage == storageList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      storage = storageList[index];
                    } else {
                      storage = null;
                    }
                  });
                },
              ),
              AppText.appText(storageList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _propertyType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: typePropertyList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: typeProperty == typePropertyList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      typeProperty = typePropertyList[index];
                    } else {
                      typeProperty = null;
                    }
                  });
                },
              ),
              AppText.appText(typePropertyList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _bedrooms() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: bedroomList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: bedrooms == bedroomList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      bedrooms = bedroomList[index];
                    } else {
                      bedrooms = null;
                    }
                  });
                },
              ),
              AppText.appText(bedroomList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _area() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: areaSizeList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: area == areaSizeList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      area = areaSizeList[index];
                    } else {
                      area = null;
                    }
                  });
                },
              ),
              AppText.appText(areaSizeList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _yearBuilt() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: yearBuiltList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: yearBuilt == yearBuiltList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      yearBuilt = yearBuiltList[index];
                    } else {
                      yearBuilt = null;
                    }
                  });
                },
              ),
              AppText.appText(yearBuiltList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _features() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: featuresList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: features == featuresList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      features = featuresList[index];
                    } else {
                      features = null;
                    }
                  });
                },
              ),
              AppText.appText(featuresList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _amenities() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: amenitiesList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: amenities == amenitiesList[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      amenities = amenitiesList[index];
                    } else {
                      amenities = null;
                    }
                  });
                },
              ),
              AppText.appText(amenitiesList[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  Widget _electricBrand() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: electricBrand.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: selectElectricBrand == electricBrand[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      selectElectricBrand = electricBrand[index];
                    } else {
                      selectElectricBrand = null;
                    }
                  });
                },
              ),
              AppText.appText(electricBrand[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //makeModel

  String? selectMakeModel = '';

  Widget _makeModel() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: makeModel.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: selectMakeModel == makeModel[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      selectMakeModel = makeModel[index];
                    } else {
                      selectMakeModel = null;
                    }
                  });
                },
              ),
              AppText.appText(makeModel[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //yearModel

  String? yearModel = '';

  Widget _yearModel() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: year.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: yearModel == year[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      yearModel = year[index];
                    } else {
                      yearModel = null;
                    }
                  });
                },
              ),
              AppText.appText(year[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  //conditionModel

  String? conditionSelect = '';

  Widget _condition() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: condition.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: conditionSelect == condition[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      conditionSelect = condition[index];
                    } else {
                      conditionSelect = null;
                    }
                  });
                },
              ),
              AppText.appText(condition[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  String? priceRangeSelect = '';

  Widget _priceRange() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: priceRange.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: priceRangeSelect == priceRange[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      priceRangeSelect = priceRange[index];
                    } else {
                      priceRangeSelect = null;
                    }
                  });
                },
              ),
              AppText.appText(priceRange[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  String? fuelTypeSelect = '';

  Widget _fuelType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: fuelType.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: fuelTypeSelect == fuelType[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      fuelTypeSelect = fuelType[index];
                    } else {
                      fuelTypeSelect = null;
                    }
                  });
                },
              ),
              AppText.appText(fuelType[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  String? mileAgeSelect;

  Widget _mileage() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: mileage.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: mileAgeSelect == mileage[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      mileAgeSelect = mileage[index];
                    } else {
                      mileAgeSelect = null;
                    }
                  });
                },
              ),
              AppText.appText(mileage[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  String? colorSelect = '';

  Widget _colorBottom() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: color.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: colorSelect == color[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      colorSelect = color[index];
                    } else {
                      colorSelect = null;
                    }
                  });
                },
              ),
              AppText.appText(color[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  String? locationSelect;

  Widget _locationBottom(StateSetter setState) {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: mileage.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                checkColor: AppTheme.whiteColor,
                activeColor: AppTheme.appColor,
                value: locationSelect == location[index],
                onChanged: (bool? value) {
                  setStatee(() {
                    if (value != null && value) {
                      locationSelect = location[index];
                    } else {
                      locationSelect = null;
                    }
                  });
                },
              ),
              AppText.appText(location[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ],
          );
        },
      );
    });
  }

  void makeElectricBrand(BuildContext context) {
    return customBottomSheet(context, 'Brand', _searchController,
        _electricBrand(), selectElectricBrand ?? '');
  }

  void makeFabricTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Choose Fabric', _searchController, _fabric(), fabric ?? '');
  }

  void makeSuitTypeTypeBottom(BuildContext context) {
    return customBottomSheet(context, 'Choose Suit Type', _searchController,
        _suitType(), suitType ?? '');
  }

  //furniture

  void makeFurnitureTypeBottom(BuildContext context) {
    return customBottomSheet(context, 'Choose Type', _searchController,
        _seaterType(), furnitureType ?? '');
  }

  //kids
  void makeKidsTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Choose Toy', _searchController, _kidsData(), kids ?? '');
  }

  //animals

  void makeAgeTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Age', _searchController, _ageType(), age ?? '');
  }

  void makeBreedTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Breed', _searchController, _breedType(), breed ?? '');
  }

  //JobsData

  void makeJobTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Job Type', _searchController, _jobType(), jobType ?? '');
  }

  void makeExperienceBottom(BuildContext context) {
    return customBottomSheet(context, 'Experience', _searchController,
        _experience(), experience ?? '');
  }

  void makeEducationBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Education', _searchController, _education(), education ?? '');
  }

  void makeSalaryBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Salary', _searchController, _salary(), salary ?? '');
  }

  void makeSalaryPeriodBottom(BuildContext context) {
    return customBottomSheet(context, 'Salary Period', _searchController,
        _salaryPeriod(), salaryPeriod ?? '');
  }

  void makeCompanyNameBottom(BuildContext context) {
    return customBottomSheet(context, 'Company Name', _searchController,
        _companyName(), companyName ?? '');
  }

  void makePossitionTypeBottom(BuildContext context) {
    return customBottomSheet(context, 'Position Type', _searchController,
        _possitiontype(), possitionType ?? '');
  }

  void makeCarrieLevelBottom(BuildContext context) {
    return customBottomSheet(context, 'Carrier Level', _searchController,
        _careerLevel(), careerLevel ?? '');
  }

  //servicesData
  void makeCarBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Car', _searchController, _services(), car ?? '');
  }

  //bikeData

  void makeEngineCapacityBottom(BuildContext context) {
    return customBottomSheet(context, 'Engine Capacity', _searchController,
        _engineCapacity(), engineCapacity ?? '');
  }

  void makeBikeModelBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Model', _searchController, _model(), model ?? '');
  }

  //subCategoriuesData

  void makeSubCategoriesBottom(BuildContext context) {
    return customBottomSheet(context, 'Subcategories', _searchController,
        _buildSubCategoryList(), _selectedSubCategory ?? '');
  }

  // mobileData

  void makeBrandBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Brand', _searchController, _brand(), brand ?? '');
  }

  void makeStorageBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Storage', _searchController, _storage(), storage ?? '');
  }

  //properties Data

  void makeTypeBottom(BuildContext context) {
    return customBottomSheet(context, 'Property Type', _searchController,
        _propertyType(), typeProperty ?? '');
  }

  void makeBedroomBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Bedrooms', _searchController, _bedrooms(), bedrooms ?? '');
  }

  void areaBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Area', _searchController, _area(), area ?? '');
  }

  void makeYearBottom(BuildContext context) {
    return customBottomSheet(context, 'Year Built', _searchController,
        _yearBuilt(), yearBuilt ?? '');
  }

  void makeFeaturesBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Features', _searchController, _features(), features ?? '');
  }

  void makeAmenitiesBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Amenities', _searchController, _amenities(), amenities ?? '');
  }

  void makeModelBottom(BuildContext context) {
    return customBottomSheet(context, 'Make and Model ', _searchController,
        _makeModel(), selectMakeModel ?? '');
  }

  void yearBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Year', _searchController, _yearModel(), yearModel ?? '');
  }

  void conditionBottom(BuildContext context) {
    return customBottomSheet(context, 'Condition', _searchController,
        _condition(), conditionSelect ?? '');
  }

  void priceRangeBottom(BuildContext context) {
    return customBottomSheet(context, 'Price Range', _searchController,
        _priceRange(), priceRangeSelect ?? '');
  }

  void mileageBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Mileage', _searchController, _mileage(), mileAgeSelect ?? '');
  }

  void fuelTypeBottom(BuildContext context) {
    return customBottomSheet(context, 'Fuel Type', _searchController,
        _fuelType(), fuelTypeSelect ?? '');
  }

  void colorTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Color', _searchController, _colorBottom(), colorSelect ?? '');
  }

  void locationTypeBottom(BuildContext context) {
    return customBottomSheet(context, 'Location', _searchController,
        _locationBottom(setState), locationSelect ?? '');
  }

  void customBottomSheet(BuildContext context, String? title,
      TextEditingController controller, Widget? child, String selectedValue) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AppText.appText(
                      title!,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomAppFormField(
                    radius: 15.0,
                    prefixIcon: Image.asset(
                      "assets/images/search.png",
                      height: 17,
                      color: AppTheme.textColor,
                    ),
                    texthint: "Search",
                    controller: controller,
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: child!),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        selectedValue = selectedValue;
      });
    });
  }

  void getCatagories({search}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "search": "$search",
      "limit": null,
    };
    try {
      response = await dio.post(path: AppUrls.categories, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          catagoryData = responseData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong $e");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getSubCatagories({search}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "category_id": "",
      "search": null,
      "limit": null,
      "id": "",
    };
    try {
      response = await dio.post(path: AppUrls.subCategories, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          subCatagoryData = responseData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong $e");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void addProductDetail(Map<String, dynamic> mapData) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "category_id": "${widget.selling == null ? catagoryId : catagoryId}",
      "product_id": "${widget.productId}",
      "condition": conditionSelect,
      "sub_category_id": "$subCatagoryId",
      "make_and_model": selectMakeModel,
      "mileage": _millageController.text,
      "color": colorSelect,
      "brand": selectMakeModel,
      "model": selectMakeModel,
      "edition": _editionController.text,
      "authenticity": _authenticityController.text,
    };

    print('addPostParamsNewwewew--->$mapData');
    try {
      response = await dio.post(
          path: widget.selling != null
              ? AppUrls.updateProductDetail
              : AppUrls.addProductDetail,
          data: mapData);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          pushReplacement(
              context,
              SetPostPriceScreen(
                selling: widget.selling,
                // productId: widget.productId,
                productId: widget.productId,
                title: widget.title,
              ));
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Something went Wrong $e");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class ImageDeleteService {
  Future<bool> imageDeleteService(
      {required BuildContext context,
      required int id,
      required int productId}) async {
    try {
      Map body = {'id': id, 'product_id': productId};

      // Assuming CustomPostRequest().httpPostRequest returns a Map
      var res = await CustomPostRequest()
          .httpPostRequest(url: AppUrls.deleteImage, body: body);

      // Check the response type
      if (res is bool) {
        // If it's already a boolean value, return it directly
        return res;
      } else if (res is Map) {
        // If it's a map, check if the response indicates success
        // For example, assuming 'success' key in the response
        if (res['success'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        // Handle other types of responses if needed
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}

// void _showSubCategoryBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return Container(
//             decoration: BoxDecoration(
//                 color: AppTheme.whiteColor,
//                 borderRadius: BorderRadius.circular(30)),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Align(
//                   alignment: Alignment.center,
//                   child: AppText.appText(
//                     "Sub Categories",
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 CustomAppFormField(
//                   radius: 15.0,
//                   prefixIcon: Image.asset(
//                     "assets/images/search.png",
//                     height: 17,
//                     color: AppTheme.textColor,
//                   ),
//                   texthint: "Search",
//                   controller: _searchController,
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: _buildSubCategoryList(setState),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   ).then((value) {
//     setState(() {
//       _selectedSubCategory = _selectedSubCategory;
//     });
//   });
// }
//
// Widget _buildSubCategoryList(StateSetter setState) {
//   return ListView.builder(
//     shrinkWrap: true,
//     itemCount: subCatagoryData.length,
//     itemBuilder: (context, index) {
//       return Row(
//         children: [t
//           Checkbox(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20)),
//             checkColor: AppTheme.whiteColor,
//             activeColor: AppTheme.appColor,
//             value: _selectedSubCategory == subCatagoryData[index]["name"],
//             onChanged: (bool? value) {
//               setState(() {
//                 if (value != null && value) {
//                   _selectedSubCategory = subCatagoryData[index]["name"];
//                   subCatagoryId = subCatagoryData[index]["id"];
//                   print('subbbbb----->${subCatagoryId}');
//                 } else {
//                   _selectedSubCategory = "";
//                 }
//               });
//             },
//           ),
//           AppText.appText(subCatagoryData[index]["name"],
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               textColor: AppTheme.textColor),
//         ],
//       );
//     },
//   );
// }
//
// /////////////////////////////  Condition bottom sheet ///////////////////////
// void _showConditionBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return Container(
//             decoration: BoxDecoration(
//                 color: AppTheme.whiteColor,
//                 borderRadius: BorderRadius.circular(30)),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Align(
//                   alignment: Alignment.center,
//                   child: AppText.appText(
//                     "Condition",
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 CustomAppFormField(
//                   radius: 15.0,
//                   prefixIcon: Image.asset(
//                     "assets/images/search.png",
//                     height: 17,
//                     color: AppTheme.textColor,
//                   ),
//                   texthint: "Search",
//                   controller: _searchController,
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: _buildConditionList(setState),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   ).then((value) {
//     setState(() {
//       _selectedCondition = _selectedCondition;
//     });
//   });
// }
//
// Widget _buildConditionList(StateSetter setState) {
//   List<String> conditions = [
//     "New",
//     "Good",
//     "Open Box",
//     "Refurnished",
//     "For Part or Not Working"
//   ];
//
//   return ListView.builder(
//     shrinkWrap: true,
//     itemCount: conditions.length,
//     itemBuilder: (context, index) {
//       return Row(
//         children: [
//           Checkbox(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20)),
//             checkColor: AppTheme.whiteColor,
//             activeColor: AppTheme.appColor,
//             value: _selectedCondition == conditions[index],
//             onChanged: (bool? value) {
//               setState(() {
//                 if (value != null && value) {
//                   _selectedCondition = conditions[index];
//                 } else {
//                   _selectedCondition = "";
//                 }
//               });
//             },
//           ),
//           AppText.appText(conditions[index],
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               textColor: AppTheme.textColor),
//         ],
//       );
//     },
//   );
// }

Widget customCheckBox(bool val, Function(bool?)? onChanged, String? title) {
  return SizedBox(
    // width: 10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.transparent;
            }
            if (states.contains(MaterialState.selected)) {
              return AppTheme.appColor;
            }
            return Colors.transparent; // Default color
          }),
          value: val,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        const SizedBox(width: 5),
        AppText.appText(title!)
      ],
    ),
  );
}

class PostTextField extends StatefulWidget {
  String? txt;
  TextEditingController? textEditingController;

  TextInputType? textInputType;

  PostTextField(
      {super.key,
      this.txt,
      this.textEditingController,
      this.textInputType = TextInputType.number});

  @override
  State<PostTextField> createState() => _PostTextFieldState();
}

class _PostTextFieldState extends State<PostTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: widget.textInputType,
          controller: widget.textEditingController,
          decoration: InputDecoration(
              labelText: widget.txt,
              border: InputBorder.none,
              labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.hintTextColor)),
        ),
        const CustomDivider()
      ],
    );
  }
}
