
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:tt_offer/detail_model/attribute_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/category_model.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/models/sub_categories_model.dart';
import 'package:tt_offer/view_model/product/post_product/post_product_viewmodel.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/views/Post%20screens/indicator.dart';
import 'package:tt_offer/views/Post%20screens/set_price_screen.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

import '../../models/product_model.dart';

class PostDetailScreen extends StatefulWidget {
  final productId;
  final String title;
  final Product? product;

  const PostDetailScreen(
      {super.key, this.productId, required this.title, this.product});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  subCategoriesHandler() async {
    await SubCategoriesService().subCategoriesService(context: context);
  }

  String? _selectedCategory = '';
  String? _selectedSubCategory = '';
  var catagoryId;
  var subCatagoryId;
  var subCategory;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  var catagoryData;
  var subCatagoryData;

  bool _dataInitialized = false; // Flag to prevent reinitialization

  @override
  void initState() {

    subCategoriesHandler();
    super.initState();
  }

  List<CategoryModel> catModel = [];
  List<SubCategoriesModel> subCatModel = [];

  List<String> makeModel = [
    'Acura',
    'Alfa Romeo',
    'Audi',
    'BMW',
    'Buick',
    'Cadillac',
    'Chevrolet',
    'Chrysler',
    'Citroën',
    'Dodge',
    'Fiat',
    'Ford',
    'Genesis',
    'GMC',
    'Honda',
    'Hyundai',
    'Infiniti',
    'Jaguar',
    'Jeep',
    'Kia',
    'Land Rover',
    'Lexus',
    'Lincoln',
    'Mazda',
    'Mercedes-Benz',
    'Mini',
    'Mitsubishi',
    'Nissan',
    'Pagani',
    'Porsche',
    'Ram',
    'Rolls-Royce',
    'Saab',
    'Subaru',
    'Suzuki',
    'Tesla',
    'Toyota',
    'Volkswagen',
    'Volvo',
    'Aston Martin',
    'Bentley',
    'Bugatti',
    'Ferrari',
    'Lamborghini',
    'Maserati',
    'McLaren',
    'Maybach',
    'Peugeot',
    'Rivian',
    'Seat',
    'Skoda',
    'Smart',
    'Tata',
    'Zenos',
    'Others'
  ];

  List<String> condition = ["New", "Good", "Open Box", "Used", "Others"];
  List<String> priceRange = ["Under\$10,000", "Others"];
  List<String> mileage = ['Under 10,000 miles', '', "Others"];
  List<String> fuelType = ['Diesel', 'Petrol', "Others"];
  List<String> color = [
    'White',
    'Black',
    'Red',
    'Pink',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Purple',
    'Brown',
    'Gray',
    'Cyan',
    'Magenta',
    'Lime',
    'Indigo',
    'Violet',
    'Turquoise',
    'Teal',
    'Maroon',
    'Olive',
    'Navy',
    'Coral',
    'Beige',
    'Lavender'
    , "Others"
  ];
  List<String> location = ['America'];

  bool owner = false;
  bool dealer = false;

  String? typeProperty = '';
  String? bedrooms = '';
  TextEditingController area = TextEditingController();
  List features = [];
  String? amenities = '';
  String? occupancyStatus = '';

  List<String> typePropertyList = ['Apartment', "Others"];
  List<String> bedroomList = ['Studio','1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12','12+', "Others"];
  List<String> bedroomHousesList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12','12+', "Others"];
  List<String> areaSizeList = ['1,000 sqft', '2,000 sqft', '3,000 sqft', "Others"];
  List<String> featuresListCustom = [
    'Servant Quarters',
    'Drawing Room',
    'Dining Room',
    'Kitchen',
    'Study Room',
    'Prayer Room',
    'Powder Room',
    '24-hour security',
    'Gym',
    'Storage Room',
    'Steam Room',
    'Guest Room',
    'Laundry Room',
    'Home Theater',
    'Office',
    'Library',
    'Wine Cellar',
    'Basement',
    'Attic',
    'Balcony',
    'Terrace',
    'Garden',
    'Swimming Pool',
    'Garage'
  ];

  List<String> featuresList = [];

  List<String> featuresListShop = [
    'Shared Spa',
    'Shared Gym',
    'Covered Gym',
    'View of Water',
    'View of Landmark',
    'Conference Room',
    'Available Furnished',
    'Available Networked',
    'Dinning in Building',
    'Retail in Building'
  ];
  List<String> amenitiesList = ['Apartment', "Others"];
  List<String> occupancyList = ['Vacant', "Tenanted"];

  String? brand = '';
  String? storage = '';
  String? bathroom = '';
  String? zoneFor = '';

  List<String> brandList = [
    'Samsung',
    'Infinix',
    'Xiaomi',
    'Motorola',
    'Huawei',
    'Apple', "Others"
  ];
  List<String> storageList = [
    '16GB',
    '32GB',
    '64GB',
    '128GB',
    '256GB',
    '512GB',
    '1 TB+', "Others"
  ];

  String? engineCapacity = '';

  List<String> engineList = [
    '50cc',
    '60cc',
    '150cc',
    '250cc',
    '500cc',
    '1000cc', "Others"
  ];
  List<String> modelList = ['Yamaha R1', 'Honda 125', 'Kawasaki', "Others"];

  String? car = '';

  List<String> carList = [
    'Corolla',
    'Alto',
    'Honda',
    'Sonata',
    'Toyota',
    'Hyundai', "Others"
  ];

  List<String> bathroomList = [
    'no bathroom',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  List<String> zoneList = [
    'Shop',
    'Offices'
  ];

  //Jobs

  String? jobType = '';
  String? education = '';
  String? salaryPeriod = '';
  String? experienceLevel = '';
  String? possitionType = '';
  String? careerLevel = '';


  Map<String, List<String>> jobTypeList = {
    'Advertising & PR': [
      'Copywriter',
      'Graphic Designer',
      'Public Relations Specialist',
      'Brand Manager',
      'Social Media Manager',
      'Creative Director',
      'Content Strategist',
      'SEO Specialist',
      'Media Buyer',
      'Event Planner',
      'Others',
    ],
    'Architecture & Interior Design': [
      'Architect',
      'Interior Designer',
      'Landscape Architect',
      'Urban Planner',
      'Draftsperson',
      'Project Manager',
      'Interior Decorator',
      'Design Consultant',
      'CAD Technician',
      'Construction Manager',
      'Others',
    ],
    'Accounting & Finance': [
      'Accountant',
      'Financial Analyst',
      'Tax Consultant',
      'Auditor',
      'Bookkeeper',
      'Payroll Specialist',
      'Investment Analyst',
      'Finance Manager',
      'Controller',
      'Accounts Payable Clerk',
      'Others',
    ],
    'Customer Service': [
      'Customer Support Representative',
      'Call Center Agent',
      'Technical Support Specialist',
      'Customer Success Manager',
      'Help Desk Coordinator',
      'Client Service Manager',
      'Customer Experience Specialist',
      'Service Desk Analyst',
      'Billing Specialist',
      'Account Coordinator',
      'Others',
    ],
    'Domestic Staff': [
      'Housekeeper',
      'Cook',
      'Nanny',
      'Butler',
      'Driver',
      'Gardener',
      'Personal Assistant',
      'Maid',
      'Babysitter',
      'Elderly Caregiver',
      'Others',
    ],
    'Delivery Riders': [
      'Bike Courier',
      'Package Delivery Driver',
      'Food Delivery Rider',
      'Freight Handler',
      'Courier Driver',
      'Logistics Assistant',
      'Parcel Delivery Driver',
      'Amazon Delivery Partner',
      'Warehouse Associate',
      'Express Delivery Rider',
      'Others',
    ],
    'Engineering': [
      'Software Engineer',
      'Electrical Engineer',
      'Mechanical Engineer',
      'Civil Engineer',
      'Chemical Engineer',
      'Project Engineer',
      'Industrial Engineer',
      'Aerospace Engineer',
      'Automation Engineer',
      'Marine Engineer',
      'Others',
    ],
    'Education': [
      'Teacher',
      'Tutor',
      'School Administrator',
      'Librarian',
      'Guidance Counselor',
      'Special Education Teacher',
      'Curriculum Developer',
      'Education Consultant',
      'Researcher',
      'Academic Advisor',
      'Others',
    ],
    'Security': [
      'Security Guard',
      'Security Supervisor',
      'Loss Prevention Officer',
      'CCTV Operator',
      'Bouncer',
      'Security Manager',
      'Event Security Staff',
      'Surveillance Operator',
      'Firewatch Security Guard',
      'Armed Security Officer',
      'Others',
    ],
    'Restaurants & Hospitality': [
      'Waiter',
      'Chef',
      'Bartender',
      'Host/Hostess',
      'Dishwasher',
      'Hotel Manager',
      'Room Service Attendant',
      'Event Coordinator',
      'Concierge',
      'Food Runner',
      'Others',
    ],
    'Real Estate': [
      'Real Estate Agent',
      'Property Manager',
      'Leasing Consultant',
      'Real Estate Broker',
      'Real Estate Appraiser',
      'Real Estate Assistant',
      'Mortgage Broker',
      'Real Estate Developer',
      'Property Inspector',
      'Title Examiner',
      'Others',
    ],
    'Management & Administration': [
      'Office Manager',
      'Administrative Assistant',
      'Executive Assistant',
      'Operations Manager',
      'Facilities Manager',
      'Administrative Coordinator',
      'Project Coordinator',
      'Secretary',
      'Data Entry Clerk',
      'Personal Assistant',
      'Others',
    ],
    'Human Resources': [
      'HR Manager',
      'Recruiter',
      'HR Generalist',
      'Payroll Administrator',
      'HR Specialist',
      'Talent Acquisition Specialist',
      'Compensation Analyst',
      'Employee Relations Manager',
      'Benefits Coordinator',
      'HR Consultant',
      'Others',
    ],
    'IT & Networking': [
      'Network Engineer',
      'IT Support Specialist',
      'Systems Administrator',
      'Cloud Architect',
      'IT Consultant',
      'Network Administrator',
      'Database Administrator',
      'Cybersecurity Specialist',
      'Technical Support Engineer',
      'DevOps Engineer',
      'Others',
    ],
    'Part time on-site': [
      'Part-Time Receptionist',
      'Part-Time Sales Assistant',
      'Part-Time Warehouse Worker',
      'Part-Time Barista',
      'Part-Time Retail Associate',
      'Part-Time Cashier',
      'Part-Time Stock Clerk',
      'Part-Time Delivery Driver',
      'Part-Time Maintenance Worker',
      'Part-Time Event Staff',
      'Others',
    ],
    'Part time remote': [
      'Web Developer',
      'Mobile App Developer',
      'UI/UX Designer',
      'Digital Marketer',
      'Content Writer',
      'SEO Specialist',
      'Social Media Manager',
      'Virtual Assistant',
      'Online Tutor',
      'Data Analyst',
      'E-commerce Manager',
      'Customer Support Representative',
      'Video Editor',
      'Affiliate Marketer',
      'Online Consultant',
      'Copywriter',
      'Transcriptionist',
      'Freelance Photographer',
      'Animator',
      'Others'
    ],
    'Full time remote': [
      'Web Developer',
      'Mobile App Developer',
      'UI/UX Designer',
      'Digital Marketer',
      'Content Writer',
      'SEO Specialist',
      'Social Media Manager',
      'Virtual Assistant',
      'Online Tutor',
      'Data Analyst',
      'E-commerce Manager',
      'Customer Support Representative',
      'Video Editor',
      'Affiliate Marketer',
      'Online Consultant',
      'Copywriter',
      'Transcriptionist',
      'Freelance Photographer',
      'Animator',
      'Others'
    ],
    'Full time on-site': [
      'Full-Time Project Manager',
      'Full-Time Store Manager',
      'Full-Time Sales Associate',
      'Full-Time Maintenance Technician',
      'Full-Time Office Administrator',
      'Full-Time Construction Worker',
      'Full-Time Electrician',
      'Full-Time Marketing Manager',
      'Full-Time Security Officer',
      'Full-Time Factory Worker',
      'Others',
    ],
    'Hotel & Tourism': [
      'Hotel Manager',
      'Tour Guide',
      'Front Desk Agent',
      'Housekeeping Supervisor',
      'Travel Agent',
      'Bellhop',
      'Concierge',
      'Event Planner',
      'Resort Manager',
      'Guest Relations Officer',
      'Others',
    ],
    'Manufacturing': [
      'Factory Worker',
      'Assembly Line Worker',
      'Machine Operator',
      'Production Supervisor',
      'Quality Control Inspector',
      'Manufacturing Technician',
      'Welder',
      'Maintenance Technician',
      'Warehouse Worker',
      'Forklift Operator',
      'Others',
    ],
    'Medical': [
      'Doctor',
      'Nurse',
      'Pharmacist',
      'Medical Assistant',
      'Lab Technician',
      'Physical Therapist',
      'Radiologist',
      'Paramedic',
      'Dentist',
      'Surgeon',
      'Others',
    ],
    'Internships': [
      'Marketing Intern',
      'Software Engineer Intern',
      'HR Intern',
      'Accounting Intern',
      'Operations Intern',
      'Design Intern',
      'Sales Intern',
      'Finance Intern',
      'Business Development Intern',
      'Product Management Intern',
      'Others',
    ],
    'Other Jobs': [
      'Mechanic',
      'Painter',
      'Plumber',
      'Carpenter',
      'Electrician',
      'Gardener',
      'Cleaner',
      'Hairdresser',
      'Makeup Artist',
      'Others',
    ],
    'Sales': [
      'Sales Executive',
      'Retail Sales Associate',
      'Sales Manager',
      'Inside Sales Representative',
      'Account Executive',
      'Business Development Manager',
      'Territory Sales Manager',
      'Sales Consultant',
      'Sales Analyst',
      'Sales Engineer',
      'Others',
    ],
    'Marketing': [
      'Marketing Manager',
      'Social Media Coordinator',
      'Content Creator',
      'Brand Manager',
      'Digital Marketing Specialist',
      'SEO Manager',
      'PPC Specialist',
      'Market Research Analyst',
      'Email Marketing Manager',
      'Public Relations Coordinator',
      'Others',
    ],
  };




  List<String> educationList = ['Intermediate', 'High School', 'Bachelor\'s Degree', 'Master\'s Degree', 'PhD', 'Others',];
  List<String> salaryList = ["\$30,000", '\$50,000', '\$60,000', "Others"];
  List<String> salaryPeriodList = ['Monthly', 'Daily', 'Weekly', "Others"];
  List<String> experienceList = ["Entry-level", "Intermediate", "Expert"];
  List<String> companyNameList = ['DevSinc', 'Systems Limited', 'Neon System', "Others"];
  List<String> possitionTypeList = ['Full Time', 'Part Time', "Others"];
  List<String> careerLevelList = ['Mid - Senior Level', 'Full - Senior Level', "Others"];

  String? age = '';

  List<String> ageList = ['1 year', '2 year', '3 year', '5 year', "Others"];
  List<String> breedList = ['Husky', 'Bully', 'Pointer', "Others"];

  String? furnitureType = '';

  Map<String, List<String>> furnitureList = {
    'Sofa & Chairs': ['1 seater', '2 seater', '3 seater', '4 seater', 'Others'],
    'Beds & Wardrobes': ['Single Bed', 'Double Bed', 'Queen Size Bed', 'King Size Bed', 'Wardrobes', 'Others'],
    'Bathroom & Accessories': ['Bathroom Cabinets', 'Shelves', 'Mirrors', 'Towel Racks', 'Others'],
    'Tables & Dining': ['Dining Tables', 'Coffee Tables', 'Side Tables', 'Others'],
    'Home Decoration': ['Wall Art', 'Vases', 'Clocks', 'Candles', 'Others'],
    'Office Furniture': ['Office Chairs', 'Desks', 'Filing Cabinets', 'Others'],
    'Garden & Outdoor': ['Garden Chairs', 'Outdoor Tables', 'Lounge Chairs', 'Others'],
    'Painting & Mirrors': ['Wall Paintings', 'Mirrors', 'Others'],
    'Curtain & Blinds': ['Curtains', 'Blinds', 'Others'],
    'Rugs & Carpets': ['Area Rugs', 'Carpets', 'Doormats', 'Others'],
    'Others': ['Miscellaneous Furniture Items']
  };


  List<String> kidsList = ['Doll', 'Car', "Others"];

  String? fabric = '';
  String? suitType = '';

  String? furnished = '';
  String? completion = '';

  List<String> fabricList = ['Cotton', 'Khadar', 'Washing Ware', "Others"];
  List<String> suitTypeList = ['Tuxedo', "Others"];

  List<String> furnishedList = ["Furnished", "Unfurnished"];

  List<String> completionList = ['Off Plan', "Ready", "Others"];

  TextEditingController priceController = TextEditingController();
  TextEditingController kilometresController = TextEditingController();
  TextEditingController toyController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearBuiltController = TextEditingController();
  TextEditingController totalClosingFeeController = TextEditingController();
  TextEditingController annualCommunityFeeController = TextEditingController();
  TextEditingController developerController = TextEditingController();
  TextEditingController propertyReferenceController = TextEditingController();
  TextEditingController buyTransferController = TextEditingController();
  TextEditingController sellTransferController = TextEditingController();
  TextEditingController maintenanceFeeController = TextEditingController();
  TextEditingController occupancyStatusController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController linkedinProfileController = TextEditingController();

  String? catId;

  //ElectronicAmplience

  String? selectDealer;
  String? selectJobType = "hiring";



  Map<String, List<String>> electricBrand = {
    'Computer & Accessories': [
      'Dell', 'HP', 'Apple', 'Lenovo', 'Asus', 'Acer', 'MSI', 'Razer', 'Microsoft', 'Logitech', 'Others'
    ],
    'Television & Accessories': [
      'Samsung', 'LG', 'Sony', 'Panasonic', 'TCL', 'Vizio', 'Sharp', 'Hisense', 'Philips', 'Toshiba', 'Others'
    ],
    'AC & Coolers': [
      'Daikin', 'LG', 'Samsung', 'Voltas', 'Blue Star', 'Carrier', 'Hitachi', 'Midea', 'Whirlpool', 'Godrej', 'Others'
    ],
    'Generators, UPS & Power Solutions': [
      'Honda', 'Cummins', 'Generac', 'Schneider', 'Eaton', 'Briggs & Stratton', 'Kohler', 'Yamaha', 'Tata', 'Himoinsa', 'Others'
    ],
    'Refrigerators & Freezers': [
      'Whirlpool', 'LG', 'Samsung', 'Haier', 'Godrej', 'Electrolux', 'Bosch', 'Panasonic', 'Siemens', 'Kelvinator', 'Others'
    ],
    'Air Purifiers & Humidifiers': [
      'Philips', 'Dyson', 'Honeywell', 'Blueair', 'Coway', 'Levoit', 'Sharp', 'Winix', 'GermGuardian', 'Boneco', 'Others'
    ],
    'Cameras & Accessories': [
      'Canon', 'Nikon', 'Sony', 'Fujifilm', 'Panasonic', 'Olympus', 'GoPro', 'Leica', 'Sigma', 'DJI', 'Others'
    ],
    'Games & Entertainment': [
      'Sony', 'Microsoft', 'Nintendo', 'Razer', 'Logitech', 'Corsair', 'SteelSeries', 'Alienware', 'Turtle Beach', 'HyperX', 'Others'
    ],
    'Kitchen Appliances': [
      'Philips', 'Bosch', 'Panasonic', 'Prestige', 'Bajaj', 'KitchenAid', 'Breville', 'Cuisinart', 'Morphy Richards', 'Kenwood', 'Others'
    ],
    'Fans': [
      'Orient', 'Havells', 'Bajaj', 'Usha', 'Crompton', 'V-Guard', 'Lasko', 'Midea', 'Atomberg', 'Westinghouse', 'Others'
    ],
    'Video': [
      'Sony', 'Bose', 'JBL', 'Sennheiser', 'Marshall', 'Klipsch', 'Pioneer', 'Yamaha', 'Denon', 'Harman Kardon', 'Others'
    ],
    'Audio': [
      'Sony', 'Bose', 'JBL', 'Sennheiser', 'Marshall', 'Klipsch', 'Pioneer', 'Yamaha', 'Denon', 'Harman Kardon', 'Others'
    ],
    'Washing Machines & Dryers': [
      'LG', 'Samsung', 'Whirlpool', 'Bosch', 'IFB', 'Haier', 'Panasonic', 'Electrolux', 'Godrej', 'Siemens', 'Others'
    ],
    'Microwaves & Ovens': [
      'LG', 'Samsung', 'Whirlpool', 'Panasonic', 'IFB', 'Sharp', 'Toshiba', 'GE', 'Kenmore', 'Black+Decker', 'Others'
    ],
    'Sewing Machines': [
      'Singer', 'Usha', 'Brother', 'Janome', 'Juki', 'Bernina', 'Elna', 'Pfaff', 'Baby Lock', 'Necchi', 'Others'
    ],
    'Water Dispensers': [
      'Voltas', 'Blue Star', 'Haier', 'Kent', 'Whirlpool', 'AquaGuard', 'Primo', 'Brio', 'Clover', 'Avalon', 'Others'
    ],
    'Heater & Geysers': [
      'Bajaj', 'AO Smith', 'Havells', 'Racold', 'Crompton', 'Venus', 'Usha', 'Kenstar', 'Hindware', 'V-Guard', 'Others'
    ],
    'Irons & Steamers': [
      'Philips', 'Bajaj', 'Morphy Richards', 'Havells', 'Usha', 'Rowenta', 'Tefal', 'Panasonic', 'Black+Decker', 'Singer', 'Others'
    ],
    'Other Home Appliances': [
      'Dyson', 'Panasonic', 'LG', 'Whirlpool', 'Philips', 'Bosch', 'Samsung', 'Electrolux', 'Miele', 'Sharp', 'Others'
    ],
  };


  String? selectElectricBrand;

  bool isBack = false;

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
  ElectronicApplianceAttributes? electronicApplicanceAttributes;


  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  void _scrollByPx(double px) {
    final double newOffset = _scrollController.offset + px;

    _scrollController.animateTo(
      newOffset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      ), // Ensures the new offset stays within scroll bounds
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }


  @override
  Widget build(BuildContext context) {

    print("object$_selectedCategory");
    return Consumer2<CategoryProvider, SubCategoriesProvider>(
        builder: (context, category, subCat, _) {
      final parseData = widget.product?.attributes ?? {};

      if(_selectedCategory=='Mobiles'){
        if(_selectedSubCategory != 'Accessories') {
          condition = ["New", "Used", "Open Box", "Refurbished", "Others"];
        }
        else{
          condition = ["New", "Used", "Open Box", "Others"];
        }
      }
      else if(_selectedCategory=="Electronics & Appliance"){
        condition = ["New", "Used", "Refurbished", "Others"];
      }
      else if(_selectedCategory=="Kids"){
        condition = ["New", "Used", "Open Box", "Others"];
      }
      else if(_selectedCategory=="Vehicles"){
        condition = ["New", "Used", "Others"];
      }
      else{
        condition = ["New", "Used", "Refurbished", "Others"];
      }

      if(_selectedSubCategory == 'Commercial Space' && zoneFor == 'Shop'){
        featuresList = featuresListShop;
      }
      else{
        featuresList = featuresListCustom;
      }



      catModel = category.category;
      subCatModel = subCat.subCategories;

      if (!_dataInitialized &&
          widget.product != null) {
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
            ElectronicApplianceAttributes.fromJson(parseData);

        _selectedCategory = widget.product?.category!.name!;
        _selectedSubCategory =widget.product?.subCategory!.name!;

        catagoryId =widget.product!.categoryId.toString();
        subCatagoryId =widget.product!.subCategory!.id.toString();


        brand = mobileAttributes?.brand ?? '';
        colorSelect = mobileAttributes!.color;
        furnished = propertyAttributes!.furnished;
        conditionSelect = 'New';
        storage = mobileAttributes?.storage ?? '';
        _colorController.text = mobileAttributes?.color ?? '';
        bedrooms = propertyAttributes!.bedroom;
        bathroom = propertyAttributes!.bathroom;
        zoneFor = propertyAttributes!.zoneFor;
        totalClosingFeeController.text =  propertyAttributes!.totalClosingFee;
        annualCommunityFeeController.text = propertyAttributes!.annualCommunityFee;
        developerController.text = propertyAttributes!.developer;
        propertyReferenceController.text = propertyAttributes!.propertyReferenceID;
        buyTransferController.text = propertyAttributes!.buyTransferFee;
        sellTransferController.text = propertyAttributes!.sellerTransferFee;
        maintenanceFeeController.text = propertyAttributes!.maintenanceFee;
        occupancyStatus = propertyAttributes!.occupancyStatus;
        area.text = propertyAttributes!.area;
        if(propertyAttributes!.features is List) {
          features = propertyAttributes!.features;
        }
        selectMakeModel = vehicleAttributes!.makeModel;
        yearBuiltController.text = vehicleAttributes!.year;
        conditionSelect = 'New';
        kilometresController.text = vehicleAttributes!.mileAge;
        yearBuiltController.text = vehicleAttributes!.year;
        fuelTypeSelect = vehicleAttributes!.fuelType;
        colorSelect = vehicleAttributes!.color;
        kilometresController.text = vehicleAttributes!.mileAge;
        completion = propertyAttributes!.completion;
        yearBuiltController.text = propertyAttributes!.yearBuilt;

        brand = electronicApplicanceAttributes!.brand;
        conditionSelect = electronicApplicanceAttributes!.condition;
        colorSelect = electronicApplicanceAttributes!.color;


        print('catCat------>${catagoryId}');

        engineCapacity = bikeAttributes!.engineCapacity;
        modelController.text = bikeAttributes!.model;


        jobType = jobAttributes!.type;
        descriptionController.text = jobAttributes!.description;
        _salaryController.text = jobAttributes!.salary;
        salaryPeriod = 'Monthly';
        companyNameController.text = jobAttributes!.companyName;

        car = servicesAttributes!.car;

        age = animalsAttributes!.age;
        _breedController.text = animalsAttributes!.breed;

        _typeController.text = furnitureAttributes!.type;
        colorSelect = furnitureAttributes!.color;

        fabric = fashionAttributes!.fabric;
        suitType = fashionAttributes!.suitType;

        toyController.text = kidsAttributes!.toy;

        // Mark data as initialized
        _dataInitialized = true;
      }



      Map<String, dynamic> mobileJson = {
        'category_id': catagoryId ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'brand': brand ?? '',
          'condition': conditionSelect ?? '',
          'price': priceController.text.trim() ?? '',
          'storage': storage ?? '',
          'color': colorSelect ?? '',
        }

      };

      Map<String, dynamic> propertyForSaleJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'bedrooms': bedrooms ?? '',
          'area': area.text ?? '-',
          'yearBuilt': yearBuiltController.text ?? '',
          'feature': features,
          'price': priceController.text.trim() ?? '',
          'storage': storage ?? '',
          'owner': selectDealer ?? '',
          'bathroom': bathroom ?? '',
          'completion':completion ?? '',
          'totalClosingFee': totalClosingFeeController.text ?? '',
          'developer': developerController.text ?? '',
          'annualCommunityFee': annualCommunityFeeController.text ?? '',
          'propertyReferenceID': propertyReferenceController.text ?? '',
          'buyTransferFee': buyTransferController.text ?? '',
          'sellerTransferFee': sellTransferController.text ?? '',
          'maintenanceFee': maintenanceFeeController.text ?? '',
          'occupancyStatus': occupancyStatus ?? '',
          'furnished': furnished ?? '',
          'zoneFor': zoneFor ?? ''
        },

      };

      Map<String, dynamic> propertyForRentJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'bedrooms': bedrooms ?? '',
          'feature': features,
          'area': area.text ?? '',
          'yearBuilt': yearBuiltController.text ?? '',
          'price': priceController.text.trim() ?? '',
          'storage': storage ?? '',
          'location': locationSelect ?? '',
          'owner': selectDealer ?? '',
          'bathroom': bathroom ?? '',
          'furnished': furnished ?? '',
          'zoneFor': zoneFor ?? ''
        },

      };

      Map<String, dynamic> vehiclesJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'subcategory': _selectedCategory ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'makeAndModel': selectMakeModel ?? '',
          'year': yearBuiltController.text ?? '',
          'condition': conditionSelect ?? '',
          'kilometres': kilometresController.text.trim() ?? '',
          'fuelType': fuelTypeSelect ?? '',
          'color': colorSelect ?? '',
          'price': priceController.text.trim() ?? '',
          'owner': selectDealer ?? '',
          'location': locationSelect ?? '',
        },

      };


      Map<String, dynamic> bikeJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'condition': 'New',
        'attributes': {
          'engineCapacity': engineCapacity ?? '',
          'model': modelController.text ?? '',
          'price': priceController.text.trim() ?? '',
          'location': locationSelect ?? '',
          'description': descriptionController.text,
        }

      };

      Map<String, dynamic> jobJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'type': jobType ?? '',
          'description': descriptionController.text ?? '',
          'education': education ?? '',
          'salary': _salaryController.text ?? '',
          'salaryPeriod': salaryPeriod ?? '',
          'companyName': companyNameController.text ?? '',
          'linkedinProfile': linkedinProfileController.text ?? '',
          'possitionType' : possitionType ?? '',
          'experienceLevel' : experienceLevel ?? '',
          'hireStatus': selectJobType ?? '',
          'location': locationSelect ?? '',
        }

      };

      Map<String, dynamic> servicesJson = {
        'category_id': catagoryId ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'description': descriptionController.text,
          'price': priceController.text.trim() ?? '',
          'car': car ?? '',
          'location': locationSelect ?? '',
        },

      };

      Map<String, dynamic> animalsJson = {
        'category_id': catagoryId ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'age': age ?? '',
          'price': priceController.text.trim() ?? '',
          'breed': _breedController.text,
          'description': descriptionController.text,
          'location': locationSelect ?? '',
        }
      };

      Map<String, dynamic> furnitureJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'attributes': {
          'type': _typeController.text ?? '',
          'condition': conditionSelect ?? '',
          'color': colorSelect ?? '',
          'price': priceController.text.trim() ?? '',
          'location': locationSelect ?? '',
        }

      };

      Map<String, dynamic> fashionJson = {
        'category_id': catagoryId ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'description': descriptionController.text,
          'price': priceController.text ?? '',
          'location': locationSelect ?? '',
        }

      };
      Map<String, dynamic> kidsJson = {
        'category_id': catagoryId ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'category_name': _selectedCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'condition': conditionSelect ?? '',
          'description': descriptionController.text,
          'price': priceController.text.trim() ?? '',
          'location': locationSelect ?? '',
        }

      };

      Map<String, dynamic> electricApplianceJson = {
        'category_id': catagoryId ?? '',
        'category_name': _selectedCategory ?? '',
        'sub_category_id': subCatagoryId ?? '',
        'sub_category_name': _selectedSubCategory ?? '',
        'product_id': widget.productId,
        'attributes': {
          'condition': conditionSelect ?? '',
          'brand': selectElectricBrand ?? '',
          'price': priceController.text.trim() ?? '',
          'location': locationSelect ?? '',
          'color': colorSelect ?? '',
        }

      };


      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar1(
          title: "Detail",
          action: true,
          img: "assets/images/cross.png",
          // actionOntap: () {
          //   // Navigator.pop(context, {'product_id' : widget.productId});
          //   // pushUntil(context, const BottomNavView());
          // },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            controller: _scrollController,
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
                  categoryNameJob: _selectedCategory == 'Jobs',
                ),
                const SizedBox(
                  height: 20,
                ),

                // (_selectedCategory == 'Property for Rent' ||
                //         _selectedCategory == 'Property for Sale')
                //     ? Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           customCheckBox(
                //               propertyAttributes!=null ?  propertyAttributes!.owner=='Owner'
                //                   ? true
                //                   : owner : owner, (val) {
                //             owner = val!;
                //             dealer = false;
                //             selectDealer = 'Owner';
                //             print(selectDealer);
                //             setState(() {});
                //           }, 'Owner'),
                //           customCheckBox(
                //               propertyAttributes!=null ? propertyAttributes!.owner=='Dealer'
                //                   ? true
                //                   : dealer :  dealer, (val) {
                //             dealer = val!;
                //             selectDealer = 'Dealer';
                //             print(selectDealer);
                //
                //             owner = false;
                //             setState(() {});
                //           }, 'Dealer'),
                //         ],
                //       )
                //     : SizedBox.shrink(),
                //     : SizedBox.shrink(),


                (_selectedCategory == 'Property for Rent' ||
                    _selectedCategory == 'Property for Sale' || _selectedCategory == 'Vehicles' )
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppButton.appButton(
                          "Owner",
                          height: 35.h,
                        fontWeight: FontWeight.w500,
                        padding : EdgeInsets.symmetric(horizontal: 40.w, vertical: 2.h),
                        fontSize: 15,
                        radius: 40.0,
                        backgroundColor: owner == true ? AppTheme.yellowColor : null,
                        textColor: owner == true ? AppTheme.whiteColor : null,
                          borderColor:  owner == true ? AppTheme.yellowColor : null,
                          onTap:(){
                          owner = true;
                          dealer = false;
                          selectDealer = 'Owner';
                          setState(() {});}
                      ),
                    ),
                    SizedBox(width:18.w),
                    Expanded(
                      child: AppButton.appButton(
                          _selectedCategory == 'Vehicles' ? 'Dealer' : "Agent",
                          height: 35.h,
                          padding : EdgeInsets.symmetric(horizontal: 40.w,),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          radius: 40.0,
                          borderColor:  dealer == true ? AppTheme.yellowColor : null,
                          backgroundColor: dealer == true ? AppTheme.yellowColor : null,
                          textColor: dealer == true ? AppTheme.whiteColor : null,
                          onTap:(){
                            dealer = true;
                            owner = false;
                            selectDealer =  _selectedCategory == 'Vehicles' ? 'Dealer' : 'Agent';
                            setState(() {});}
                      )
                      ,
                    ),

                    // customCheckBox(
                    //     propertyAttributes!=null ?  propertyAttributes!.owner=='Owner'
                    //         ? true
                    //         : owner : owner, (val) {
                    //   owner = val!;
                    //   dealer = false;
                    //   selectDealer = 'Owner';
                    //   print(selectDealer);
                    //   setState(() {});
                    // }, 'Owner'),
                    // customCheckBox(
                    //     propertyAttributes!=null ? propertyAttributes!.owner=='Dealer'
                    //         ? true
                    //         : dealer :  dealer, (val) {
                    //   dealer = val!;
                    //   selectDealer = 'Dealer';
                    //   print(selectDealer);
                    //
                    //   owner = false;
                    //   setState(() {});
                    // }, 'Dealer'),
                  ],
                )
                    : SizedBox.shrink(),

                ( _selectedCategory == 'Jobs' )
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppButton.appButton(
                          "Hiring" ,
                          height: 35.h,
                          fontWeight: FontWeight.w500,
                          padding : EdgeInsets.symmetric(horizontal: 40.w, vertical: 2.h),
                          fontSize: 15,
                          radius: 40.0,
                          backgroundColor: selectJobType == "hiring" ? AppTheme.yellowColor : null,
                          textColor: selectJobType == "hiring"? AppTheme.whiteColor : null,
                          borderColor:  selectJobType == "hiring" ? AppTheme.yellowColor : null,
                          onTap:(){
                            selectJobType = "hiring" ;
                            setState(() {});}
                      ),
                    ),
                    SizedBox(width:18.w),
                    Expanded(
                      child: AppButton.appButton(
                          'Looking',
                          height: 35.h,
                          padding : EdgeInsets.symmetric(horizontal: 40.w,),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          radius: 40.0,
                          borderColor:  selectJobType == "looking" ? AppTheme.yellowColor : null,
                          backgroundColor: selectJobType == "looking" ? AppTheme.yellowColor : null,
                          textColor: selectJobType == "looking" ? AppTheme.whiteColor : null,
                          onTap:(){
                            selectJobType = "looking";
                            setState(() {});}
                      )
                      ,
                    ),

                    // customCheckBox(
                    //     propertyAttributes!=null ?  propertyAttributes!.owner=='Owner'
                    //         ? true
                    //         : owner : owner, (val) {
                    //   owner = val!;
                    //   dealer = false;
                    //   selectDealer = 'Owner';
                    //   print(selectDealer);
                    //   setState(() {});
                    // }, 'Owner'),
                    // customCheckBox(
                    //     propertyAttributes!=null ? propertyAttributes!.owner=='Dealer'
                    //         ? true
                    //         : dealer :  dealer, (val) {
                    //   dealer = val!;
                    //   selectDealer = 'Dealer';
                    //   print(selectDealer);
                    //
                    //   owner = false;
                    //   setState(() {});
                    // }, 'Dealer'),
                  ],
                )
                    : SizedBox.shrink(),

                customRow(
                    onTap: () {
                      _showCategoryBottomSheet(context);
                    },
                    title: "Category(required)",
                    selectText: _selectedCategory ?? 'Select Category'),

                if( _selectedCategory != null && _selectedCategory!.isNotEmpty)
                  customRow(
                      onTap: () {
                        makeSubCategoriesBottom(context);
                      },
                      title: 'Subcategories(required)',
                      selectText: _selectedSubCategory ??
                          'Select Subcategories'),

                _selectedCategory == 'Electronics & Appliance' && _selectedSubCategory!.isNotEmpty
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
                          if(_selectedSubCategory != 'Generators, UPS & Power Solutions')
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

                _selectedCategory == 'Fashion & beauty' && _selectedSubCategory!.isNotEmpty
                    ? Column(
                        children: [
                          descriptionTextField(title : 'Product description')
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Kids' && _selectedSubCategory!.isNotEmpty
                    ? Column(
                        children: [
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

                          descriptionTextField()
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Furniture & home decor' && _selectedSubCategory!.isNotEmpty
                    ? Column(
                        children: [
                          customRowTextField(
                              onTap: () {
                              },
                              title: 'Type',
                              textEditingController: _typeController),
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

                _selectedCategory == 'Animals' && _selectedSubCategory!.isNotEmpty
                    ? Column(
                        children: [

                          if(_selectedSubCategory != 'Pet Food & Accessories') ... [
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
                          customRowTextField(
                              title: 'Breed',
                              hintText: 'Enter breed', textEditingController: _breedController)
                          ]
                          else
                            descriptionTextField()
                          // customRow(
                          //     onTap: () {
                          //       locationTypeBottom(context);
                          //     },
                          //     title: 'Location',
                          //     selectText: locationSelect ?? 'Select Location'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Jobs' && _selectedSubCategory!.isNotEmpty
                    ? Column(
                        children: [
                          customRow(
                              onTap: () {
                                makeJobTypeBottom(context);
                              },
                              title: 'Type',
                              selectText: jobType ?? 'Select Job Type'),
                          descriptionTextField(),
                          customRow(
                              onTap: () {
                                makeEducationBottom(context);
                              },
                              title: 'Education',
                              selectText: education ?? 'Select Education'),
                          // customRowTextField(
                          //     onTap: () {
                          //     },
                          //     title: 'Salary',
                          //     textEditingController: _salaryController),
                          if(selectJobType == 'hiring' )
                          customRow(
                              onTap: () {
                                makeSalaryPeriodBottom(context);
                              },
                              title: 'Salary Period',
                              selectText:
                                  salaryPeriod ?? 'Select Salary Period')
                          else
                            customRow(
                                onTap: () {
                                  makeExperienceLevelBottom(context);
                                },
                                title: 'Experience Level',
                                selectText:
                                experienceLevel ?? 'Select Experience Level'),
                          customRowTextField(
                              title: selectJobType == 'hiring' ? 'Company Name' : 'Linkedin Profile(link)',
                              textEditingController: selectJobType == 'Hiring' ?  companyNameController : linkedinProfileController),
                          customRow(
                              onTap: () {
                                makePossitionTypeBottom(context);
                              },
                              title: selectJobType == 'hiring' ? 'Position Type' : 'Preferred Employment Type',
                              selectText: possitionType),
                          // customRow(
                          //     onTap: () {
                          //       makeCarrieLevelBottom(context);
                          //     },
                          //     title: 'Carrier Level',
                          //     selectText: careerLevel ?? 'Select Carrier Level'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Services' && _selectedSubCategory!.isNotEmpty
                    ? Column(
                        children: [
                          descriptionTextField()

                          // customRow(
                          //     onTap: () {
                          //       priceRangeBottom(context);
                          //     },
                          //     title: 'Price',
                          //     selectText: priceRangeSelect ?? 'Select Price'),
                          // customRow(
                          //     onTap: () {
                          //       makeCarBottom(context);
                          //     },
                          //     title: 'Car',
                          //     selectText: car ?? 'Select Car'),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Bikes' && _selectedSubCategory!.isNotEmpty
                    ? Column(
                        children: [

                          customRow(
                              onTap: () {
                                conditionBottom(context);
                              },
                              title: 'Condition',
                              selectText:
                              conditionSelect ?? 'Select Condition'),

                          if(_selectedSubCategory != 'Bicycles' && _selectedSubCategory != 'Bikes Accessories' && _selectedSubCategory != 'Parts')
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
                          if(_selectedSubCategory == 'Bikes Accessories')
                          customRowTextField(
                              onTap: () {
                              },
                              title: 'Accessories description',
                              textEditingController: descriptionController),

                          customRowTextField(
                              onTap: () {
                              },
                              title: 'Model',
                              textEditingController: modelController),
                        ],
                      )
                    : const SizedBox.shrink(),

                _selectedCategory == 'Mobiles' && _selectedSubCategory!.isNotEmpty
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
                          if(_selectedSubCategory!='Accessories' && _selectedSubCategory!='Smart Watches')
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

                (_selectedCategory == 'Property for Sale' ||
                        _selectedCategory == 'Property for Rent') && _selectedSubCategory!.isNotEmpty
                    ? Column(children: [

                      if(_selectedSubCategory == 'Commercial Space')
                        customRow(
                            onTap: () {
                              makeZoneBottom(context);
                            },
                            title: 'Zoned For',
                            selectText: zoneFor ?? 'Zoned for'),


                        if(_selectedSubCategory == 'Commercial Space' && zoneFor != '' || _selectedSubCategory != 'Commercial Space') ...[

                        if(_selectedSubCategory != 'Commercial Space')
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
                        customRowTextField(
                            onTap: () {
                            },
                            title: 'Area/Size' ,
                            textInputType: TextInputType.number,
                            hintText: 'sqft',
                           textEditingController: area),

                        customRow(
                            onTap: () {
                              makeBathroomBottom(context);
                            },
                            title: 'Bathroom',
                            selectText: bathroom ?? 'Select Year Built'),

                        customRowTextField(
                            onTap: () {
                            },
                            title: 'Year Built', textEditingController: yearBuiltController,),
                        customRow(
                            onTap: () {
                              makeFeaturesBottom(context);
                            },
                            title: 'Features',
                            selectText: features.join(', ') ?? 'Select Features'),
                        if(zoneFor != 'Shop')
                        customRow(
                            onTap: () {
                              makeAmenitiesBottom(context);
                            },
                            title: 'Furnished',
                            selectText: furnished ?? 'Select Furnished'),
                  if(_selectedCategory != 'Property for Rent')...[
                        customRowTextField(
                          onTap: () {
                          },
                          textInputType: TextInputType.number,
                          title: 'Total closing fee',  textEditingController: totalClosingFeeController, ),
                        customRowTextField(
                          onTap: () {
                          },
                          title: 'Developer', textEditingController: developerController,),
                        customRowTextField(
                          onTap: () {
                          },
                          textInputType: TextInputType.number,
                          title: 'Annual community fee', textEditingController: annualCommunityFeeController,),
                        customRowTextField(
                          onTap: () {
                          },
                          textInputType: TextInputType.number,
                          title: 'Property Reference ID #', textEditingController: propertyReferenceController,),
                        customRowTextField(
                          onTap: () {
                          },
                          textInputType: TextInputType.number,
                          title: 'Buy Transfer Fee', textEditingController: buyTransferController,),
                        customRowTextField(
                          onTap: () {
                          },
                          textInputType: TextInputType.number,
                          title: 'Seller Transfer Fee', textEditingController: sellTransferController,),
                        customRowTextField(
                          onTap: () {
                          },
                          textInputType: TextInputType.number,
                          title: 'Maintenance Fee', textEditingController: maintenanceFeeController,),
                        customRow(
                            onTap: () {
                              occupancyStatusBottom(context);
                            },
                            title: 'Occupancy Status',
                            selectText: occupancyStatus ?? 'Select Occupancy Status'),],

                      if(_selectedCategory != 'Property for Rent')
                      customRow(
                          onTap: () {
                            makeCompletionBottom(context);
                          },
                          title: 'Completion',
                          selectText: completion ?? 'Select Completion'),
                      ]
                      ])
                    : const SizedBox.shrink(),

                     if(_selectedCategory == 'Vehicles' && _selectedSubCategory!.isNotEmpty)
                     Column(
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
                              : customRowTextField(
                                  onTap: () {
                                    // yearBottom(context);
                                  },
                                  title: _selectedCategory == 'Vehicles'
                                      ? "Year"
                                      : "",
                                   textEditingController: yearBuiltController),
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
                              : _selectedSubCategory!= 'Car Accessories' && _selectedSubCategory!= 'Parts'
                                  ? customRowTextField(
                                  title: 'Kilometers',
                                  textEditingController: kilometresController) : const SizedBox.shrink(),

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
                              : _selectedSubCategory!= 'Car Accessories' && _selectedSubCategory!= 'Parts' ?
                               customRow(
                                  onTap: () {
                                    fuelTypeBottom(context);
                                  },
                                  title: _selectedCategory == 'Vehicles'
                                      ? "Fuel Type"
                                      : "",
                                  selectText:
                                      fuelTypeSelect ?? 'Select Fuel Type') : const SizedBox.shrink(),
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

                Consumer<PostProductViewModel>(
                    builder: (context, provider, child){
                      return  Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: provider.secondStepLoading == true
                                ? const CircularProgressIndicator()
                                : AppButton.appButton("Next", onTap: () {
                              addProductDetail(_selectedCategory == 'Mobiles'
                                  ? mobileJson
                                  : _selectedCategory == 'Property for Sale'
                                  ? propertyForSaleJson
                                  : _selectedCategory == 'Vehicles'
                                  ? vehiclesJson
                                  : _selectedCategory == 'Property for Rent'
                                  ? propertyForRentJson
                                  : _selectedCategory == 'Bikes'
                                  ? bikeJson
                                  : _selectedCategory == 'Jobs'
                                  ? jobJson
                                  : _selectedCategory ==
                                  'Services'
                                  ? servicesJson
                                  : _selectedCategory ==
                                  'Animals'
                                  ? animalsJson
                                  : _selectedCategory ==
                                  'Furniture & home decor'
                                  ? furnitureJson
                                  : _selectedCategory ==
                                  'Fashion & beauty'
                                  ? fashionJson
                                  : _selectedCategory ==
                                  'Kids'
                                  ? kidsJson
                                  : _selectedCategory ==
                                  'Electronics & Appliance'
                                  ? electricApplianceJson
                                  : {}, provider);
                            },
                                height: 53,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                radius: 32.0,
                                backgroundColor: AppTheme.appColor,
                                textColor: AppTheme.whiteColor),
                          );
                  }
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

  Widget customRowTextField({Function()? onTap, String? title, required TextEditingController textEditingController, String hintText='', TextInputType? textInputType}) {
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
                ],
              ),
              SizedBox(
                height: _selectedCategory == 'Bikes' ||_selectedCategory == 'Jobs' || _selectedCategory == 'Vehicles' || title!.contains('Description') ||
                    _selectedCategory == 'Property for Rent' || _selectedCategory == 'Animals' || _selectedCategory == 'Furniture & home decor' ||
              _selectedCategory == 'Property for Sale' ? 12 :  _selectedCategory == 'Vehicles' ? 8 : 18,
              ),
            PostTextField(textEditingController: textEditingController, txt: title, textInputType: textInputType ?? (_selectedCategory == 'Kids' || _selectedCategory == 'Animals' || _selectedCategory == 'Bikes' || (_selectedCategory == 'Property For Sale' || title != 'Year Built') ? TextInputType.name : TextInputType.number), hintText: hintText,)
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
      isScrollControlled: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.fromLTRB(8.w,40.h,12.w,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Center(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close_sharp, size: 30.w),
                        ),
                      ),
                      Spacer(),
                      AppText.appText(
                        'Categories',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      Spacer(),
                      SizedBox(width: 34.w,)
                    ],
                  ),
                  // const SizedBox(height: 16),
                  // CustomAppFormField(
                  //   radius: 15.0,
                  //   // prefixIcon: Image.asset(
                  //   //   "assets/images/search.png",
                  //   //   height: 17,
                  //   //   color: AppTheme.textColor,
                  //   // ),
                  //   texthint: "Search",
                  //   controller: _searchController,
                  // ),
                  SizedBox(height: 10.h),
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

  // Widget _kidsData() {
  //   return StatefulBuilder(builder: (context, setStatee) {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: kidsList.length,
  //       itemBuilder: (context, index) {
  //         return Row(
  //           children: [
  //             Checkbox(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               checkColor: AppTheme.whiteColor,
  //               activeColor: AppTheme.appColor,
  //               value: kids == kidsList[index],
  //               onChanged: (bool? value) {
  //                 setStatee(() {
  //                   if (value != null && value) {
  //                     kids = kidsList[index];
  //                   } else {
  //                     kids = null;
  //                   }
  //                 });
  //               },
  //             ),
  //             AppText.appText(kidsList[index],
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 textColor: AppTheme.textColor),
  //           ],
  //         );
  //       },
  //     );
  //   });
  // }

  //furniture

  Widget descriptionTextField({String? title}){
    return customRowTextField(
        onTap: () {
        },
        title: title ?? 'Description',
        textEditingController: descriptionController);
  }


  Widget _ageType() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: ageList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              age = ageList[index];

            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: age == ageList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
        itemCount: furnitureList[_selectedSubCategory]!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              furnitureType = furnitureList[_selectedSubCategory]![index];

            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: furnitureType == furnitureList[_selectedSubCategory]![index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        furnitureType = furnitureList[_selectedSubCategory]![index];
                      } else {
                        furnitureType = null;
                      }
                    });
                  },
                ),
                AppText.appText(furnitureList[_selectedSubCategory]![index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
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
        itemCount: jobTypeList[_selectedSubCategory]!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              jobType = jobTypeList[_selectedSubCategory]![index];
              _scrollToBottom();
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: jobType ==  jobTypeList[_selectedSubCategory]![index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        jobType = jobTypeList[_selectedSubCategory]![index];
                      } else {
                        jobType = null;
                      }
                    });
                    _scrollToBottom();

                  },
                ),
                AppText.appText(jobTypeList[_selectedSubCategory]![index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  // Widget _experience() {
  //   return StatefulBuilder(builder: (context, setStatee) {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: experienceList.length,
  //       itemBuilder: (context, index) {
  //         return InkWell(
  //           onTap: (){
  //             Navigator.of(context).pop();
  //             setState(() {
  //
  //             });
  //             experience = experienceList[index];
  //           },
  //           child: Row(
  //             children: [
  //               Checkbox(
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20)),
  //                 checkColor: AppTheme.whiteColor,
  //                 activeColor: AppTheme.appColor,
  //                 value: experience == experienceList[index],
  //                 onChanged: (bool? value) {
  //                   Navigator.of(context).pop();
  //                   setStatee(() {
  //                     if (value != null && value) {
  //                       experience = experienceList[index];
  //                     } else {
  //                       experience = null;
  //                     }
  //                   });
  //                 },
  //               ),
  //               AppText.appText(experienceList[index],
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w500,
  //                   textColor: AppTheme.textColor),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  Widget _education() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: educationList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              education = educationList[index];
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: education == educationList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              salaryPeriod = salaryPeriodList[index];
              _scrollToBottom();
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: salaryPeriod == salaryPeriodList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        salaryPeriod = salaryPeriodList[index];
                      } else {
                        salaryPeriod = null;
                      }
                    });
                    _scrollToBottom();
                  },
                ),
                AppText.appText(salaryPeriodList[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _experiencePeriod() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: experienceList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              experienceLevel = experienceList[index];
              _scrollToBottom();
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: experienceLevel == experienceList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        experienceLevel = experienceList[index];
                      } else {
                        experienceLevel = null;
                      }
                    });
                    _scrollToBottom();
                  },
                ),
                AppText.appText(experienceList[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              possitionType = possitionTypeList[index];
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: possitionType == possitionTypeList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              careerLevel = careerLevelList[index];
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: careerLevel == careerLevelList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();

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
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              car = carList[index];
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: car == carList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {

              });
              engineCapacity = engineList[index];
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: engineCapacity == engineList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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

  // Widget _model() {
  //   return StatefulBuilder(builder: (context, setStatee) {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: modelList.length,
  //       itemBuilder: (context, index) {
  //         return Row(
  //           children: [
  //             Checkbox(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               checkColor: AppTheme.whiteColor,
  //               activeColor: AppTheme.appColor,
  //               value: model == modelList[index],
  //               onChanged: (bool? value) {
  //                 setStatee(() {
  //                   if (value != null && value) {
  //                     model = modelList[index];
  //                     print('model---?$model');
  //                   } else {
  //                     model = null;
  //                   }
  //                 });
  //               },
  //             ),
  //             AppText.appText(modelList[index],
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 textColor: AppTheme.textColor),
  //           ],
  //         );
  //       },
  //     );
  //   });
  // }

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
        final filteredSubCatModel = subCatModel
            .where((element) => element.categoryId == catagoryId)
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: filteredSubCatModel.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                setState(() {
                    subCatagoryId = filteredSubCatModel[index].id;
                    subCategory = _selectedSubCategory;
                    print('subCatagoryId---->$subCatagoryId');
                    _selectedSubCategory =
                    filteredSubCatModel[index].title!;
                    catagoryId = filteredSubCatModel[index].categoryId;
                    Navigator.of(context).pop();
                });
              },
              child: Row(
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
                          subCategory = _selectedSubCategory;
                          print('subCatagoryId---->$subCatagoryId');
                          _selectedSubCategory =
                              filteredSubCatModel[index].title!;
                          catagoryId = filteredSubCatModel[index].categoryId;
                          Navigator.of(context).pop();
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
              ),
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
        return InkWell(
          onTap: (){
            setState(() {
                // _selectedCategory = catagoryData[index]["name"];
                _selectedCategory = catModel[index].title!;
                catagoryId = catModel[index].id;
                _selectedSubCategory = '';

                setState((){});
                Navigator.of(context).pop();

                print('catCat------>${catagoryId}');
            });
          },
          child: Row(
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

                      setState((){});
                      Navigator.of(context).pop();

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
          ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                brand = brandList[index];
              });
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: brand == brandList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                storage = storageList[index];
              });
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: storage == storageList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                typeProperty = typePropertyList[index];
              });
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: typeProperty == typePropertyList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
          );
        },
      );
    });
  }

  Widget _bedrooms() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _selectedSubCategory == 'Houses' ? bedroomHousesList.length :bedroomList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                bedrooms = _selectedSubCategory == 'Houses' ? bedroomHousesList[index] : bedroomList[index];
              });
              _scrollByPx(300);
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: bedrooms == (_selectedSubCategory == 'Houses' ? bedroomHousesList[index] : bedroomList[index]),
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        bedrooms = (_selectedSubCategory == 'Houses' ? bedroomHousesList[index] : bedroomList[index]);
                      } else {
                        bedrooms = null;
                      }
                    });
                    _scrollByPx(300);
                  },
                ),
                AppText.appText((_selectedSubCategory == 'Houses' ? bedroomHousesList[index] : bedroomList[index]),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  // Widget _area() {
  //   return StatefulBuilder(builder: (context, setStatee) {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: areaSizeList.length,
  //       itemBuilder: (context, index) {
  //         return Row(
  //           children: [
  //             Checkbox(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               checkColor: AppTheme.whiteColor,
  //               activeColor: AppTheme.appColor,
  //               value: area == areaSizeList[index],
  //               onChanged: (bool? value) {
  //                 setStatee(() {
  //                   if (value != null && value) {
  //                     area.text = areaSizeList[index];
  //                   } else {
  //                     area = null;
  //                   }
  //                 });
  //               },
  //             ),
  //             AppText.appText(areaSizeList[index],
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 textColor: AppTheme.textColor),
  //           ],
  //         );
  //       },
  //     );
  //   });
  // }

  // Widget _yearBuilt() {
  //   return StatefulBuilder(builder: (context, setStatee) {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: yearBuiltList.length,
  //       itemBuilder: (context, index) {
  //         return InkWell(
  //           onTap: (){
  //             Navigator.of(context).pop();
  //             setState(() {
  //               yearBuilt = yearBuiltList[index];
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Checkbox(
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20)),
  //                 checkColor: AppTheme.whiteColor,
  //                 activeColor: AppTheme.appColor,
  //                 value: yearBuilt == yearBuiltList[index],
  //                 onChanged: (bool? value) {
  //                   Navigator.of(context).pop();
  //                   setStatee(() {
  //                     if (value != null && value) {
  //                       yearBuilt = yearBuiltList[index];
  //                     } else {
  //                       yearBuilt = null;
  //                     }
  //                   });
  //                 },
  //               ),
  //               AppText.appText(yearBuiltList[index],
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w500,
  //                   textColor: AppTheme.textColor),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  Widget _bathroomBuilt() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: bathroomList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                bathroom = bathroomList[index];
              });
              _scrollByPx(200);
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: bathroom == bathroomList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        bathroom = bathroomList[index];
                      } else {
                        bathroom = null;
                      }
                    });
                    _scrollByPx(200);
                  },
                ),
                AppText.appText(bathroomList[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _zoneForBuilt() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: zoneList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                zoneFor = zoneList[index];
              });
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: zoneFor == zoneList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        zoneFor = zoneList[index];
                      } else {
                        zoneFor = null;
                      }
                    });
                  },
                ),
                AppText.appText(zoneList[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _features() {
    List temp = [];
    temp.addAll(features);
    return StatefulBuilder(builder: (context, setStatee) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
            shrinkWrap: true,
            itemCount: featuresList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  // Navigator.of(context).pop();
                    if (temp.contains(featuresList[index])) {
                      temp.remove(featuresList[index]);
                    } else {
                      temp.add(featuresList[index]);
                    }
                    setStatee(() {});
                },
                child: Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      checkColor: AppTheme.whiteColor,
                      activeColor: AppTheme.appColor,
                      value: temp.contains(featuresList[index]),
                      onChanged: (bool? value) {
                        // Navigator.of(context).pop();
                        setStatee(() {
                          if (value != null && value) {
                            temp.add(featuresList[index]);
                          } else {
                            temp.remove(featuresList[index]);
                          }
                        });
                      },
                    ),
                    AppText.appText(featuresList[index],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppTheme.textColor),
                  ],
                ),
              );
            },
                    ),
          ),
          SizedBox(
            height: 60.w,
            child: Center(
              child: AppButton.appButton('Done',height: 45.h,
                  onTap: (){
                    features=temp;
                    setState(() {

                    });
                    Navigator.of(context).pop();
                  },
                  fontWeight: FontWeight.w500,
                  fontSize: 14.5.sp,
                  radius: 32.0,
                  width: 350.w,
                  borderColor: AppTheme.hintTextColor,
                  backgroundColor: temp.isEmpty ? null : AppTheme.appColor,
                  textColor: temp.isEmpty ? AppTheme.hintTextColor : AppTheme.whiteColor),
            ),
          )
      ]
      );
    });
  }

  Widget _furnished() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: furnishedList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
              furnished = furnishedList[index];
              setState(() {

              });
              _scrollByPx(300);

            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: furnished == furnishedList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setState(() {
                      if (value != null && value) {
                        furnished = furnishedList[index];
                      } else {
                        furnished = null;
                      }
                    });
                    _scrollByPx(300);
                  },
                ),
                AppText.appText(furnishedList[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }


  Widget _occupancyStatus() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: occupancyList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
              occupancyStatus = occupancyList[index];
              setState(() {

              });
              _scrollToBottom();

            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: occupancyStatus == occupancyList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setState(() {
                      if (value != null && value) {
                        occupancyStatus = occupancyList[index];
                      } else {
                        occupancyStatus = null;
                      }
                    });
                    _scrollToBottom();
                  },
                ),
                AppText.appText(occupancyList[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _completion() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: completionList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                completion = completionList[index];
              });
              _scrollToBottom();
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: completion == completionList[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        completion = completionList[index];
                      } else {
                        completion = null;
                      }
                    });
                    _scrollToBottom();
                  },
                ),
                AppText.appText(completionList[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _electricBrand() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: electricBrand[_selectedSubCategory]!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                selectElectricBrand = electricBrand[_selectedSubCategory]![index];
              });
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: selectElectricBrand == electricBrand[_selectedSubCategory]![index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        selectElectricBrand = electricBrand[_selectedSubCategory]![index];
                      } else {
                        selectElectricBrand = null;
                      }
                    });
                  },
                ),
                AppText.appText(electricBrand[_selectedSubCategory]![index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                selectMakeModel = makeModel[index];
              });
              _scrollByPx(300);
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: selectMakeModel == makeModel[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        selectMakeModel = makeModel[index];
                      } else {
                        selectMakeModel = null;
                      }
                    });
                    _scrollByPx(300);
                  },
                ),
                AppText.appText(makeModel[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
          );
        },
      );
    });
  }

  //yearModel

  // String? yearModel = '';
  //
  // Widget _yearModel() {
  //   return StatefulBuilder(builder: (context, setStatee) {
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: year.length,
  //       itemBuilder: (context, index) {
  //         return  InkWell(
  //           onTap: (){
  //             Navigator.of(context).pop();
  //             setState(() {
  //               yearModel = year[index];
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Checkbox(
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20)),
  //                 checkColor: AppTheme.whiteColor,
  //                 activeColor: AppTheme.appColor,
  //                 value: yearModel == year[index],
  //                 onChanged: (bool? value) {
  //                   Navigator.of(context).pop();
  //                   setStatee(() {
  //                     if (value != null && value) {
  //                       yearModel = year[index];
  //                     } else {
  //                       yearModel = null;
  //                     }
  //                   });
  //                 },
  //               ),
  //               AppText.appText(year[index],
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w500,
  //                   textColor: AppTheme.textColor),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  //conditionModel

  String? conditionSelect = '';

  Widget _condition() {
    return StatefulBuilder(builder: (context, setStatee) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount:  condition.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                conditionSelect = condition[index];
              });
              _scrollToBottom();
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: conditionSelect == condition[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
                    setStatee(() {
                      if (value != null && value) {
                        conditionSelect = condition[index];
                      } else {
                        conditionSelect = null;
                      }
                    });
                    _scrollToBottom();
                  },
                ),
                AppText.appText( condition[index],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.textColor),
              ],
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                fuelTypeSelect = fuelType[index];
              });
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: fuelTypeSelect == fuelType[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
          return InkWell(
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                  colorSelect = color[index];
              });
            },
            child: Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  checkColor: AppTheme.whiteColor,
                  activeColor: AppTheme.appColor,
                  value: colorSelect == color[index],
                  onChanged: (bool? value) {
                    Navigator.of(context).pop();
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
            ),
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
  // void makeKidsTypeBottom(BuildContext context) {
  //   return customBottomSheet(
  //       context, 'Choose Toy', _searchController, _kidsData(), kids ?? '');
  // }

  //animals

  void makeAgeTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Age', _searchController, _ageType(), age ?? '');
  }


  //JobsData

  void makeJobTypeBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Job Type', _searchController, _jobType(), jobType ?? '');
  }

  // void makeExperienceBottom(BuildContext context) {
  //   return customBottomSheet(context, 'Experience', _searchController,
  //       _experience(), experience ?? '');
  // }

  void makeEducationBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Education', _searchController, _education(), education ?? '');
  }


  void makeSalaryPeriodBottom(BuildContext context) {
    return customBottomSheet(context, 'Salary Period', _searchController,
        _salaryPeriod(), salaryPeriod ?? '');
  }

  void makeExperienceLevelBottom(BuildContext context) {
    return customBottomSheet(context, 'Experience Level', _searchController,
        _experiencePeriod(), experienceLevel ?? '');
  }


  void makePossitionTypeBottom(BuildContext context) {
    return customBottomSheet(context, selectJobType == 'hiring' ? 'Position Type' : 'Preferred Employment Type', _searchController,
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

  // void makeBikeModelBottom(BuildContext context) {
  //   return customBottomSheet(
  //       context, 'Model', _searchController, _model(), model ?? '');
  // }

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

  // void areaBottom(BuildContext context) {
  //   return customBottomSheet(
  //       context, 'Area', _searchController, _area(), area ?? '');
  // }

  // void makeYearBottom(BuildContext context) {
  //   return customBottomSheet(context, 'Year Built', _searchController,
  //       _yearBuilt(), yearBuilt ?? '');
  // }

  void makeZoneBottom(BuildContext context) {
    return customBottomSheet(context, 'Zone For', _searchController,
        _zoneForBuilt(), zoneFor ?? '');
  }

  void makeBathroomBottom(BuildContext context) {
    return customBottomSheet(context, 'Bathroom', _searchController,
        _bathroomBuilt(), bathroom ?? '');
  }

  void makeFeaturesBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Features', _searchController, _features(), '');
  }

  void makeAmenitiesBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Furnished', _searchController, _furnished(), amenities ?? '');
  }

  void occupancyStatusBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Occupancy Status', _searchController, _occupancyStatus(), occupancyStatus ?? '');
  }

  void makeCompletionBottom(BuildContext context) {
    return customBottomSheet(
        context, 'Completion', _searchController, _completion(), completion ?? '');
  }

  void makeModelBottom(BuildContext context) {
    return customBottomSheet(context, 'Make and Model ', _searchController,
        _makeModel(), selectMakeModel ?? '');
  }

  // void yearBottom(BuildContext context) {
  //   return customBottomSheet(
  //       context, 'Year', _searchController, _yearModel(), yearModel ?? '');
  // }

  void conditionBottom(BuildContext context) {
    return customBottomSheet(context, 'Condition', _searchController,
        _condition(), conditionSelect ?? '');
  }

  void priceRangeBottom(BuildContext context) {
    return customBottomSheet(context, 'Price Range', _searchController,
        _priceRange(), priceRangeSelect ?? '');
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
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              padding: EdgeInsets.fromLTRB(8.w,40.h,12.w,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Center(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close_sharp, size: 30.w),
                        ),
                      ),
                      Spacer(),
                      AppText.appText(
                        title!,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      Spacer(),
                      SizedBox(width: 30.w,)
                    ],
                  ),



                  SizedBox(height: 10.h),
                  // CustomAppFormField(
                  //   radius: 15.0,
                  //   prefixIcon: Image.asset(
                  //     "assets/images/search.png",
                  //     height: 17,
                  //     color: AppTheme.textColor,
                  //   ),
                  //   texthint: "Search",
                  //   controller: controller,
                  // ),
                  // const SizedBox(height: 16),
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
        if((title != 'Job Type' && title != 'Zone For' && title != "Subcategories") && selectedValue.isNotEmpty) {
          // _scrollBy100Px();
        }
      });
    });
  }



  void addProductDetail(Map<String, dynamic> mapData, PostProductViewModel provider ) async {
    if ((_selectedCategory == 'Property for Rent' || _selectedCategory == 'Vehicles' ||
        _selectedCategory == 'Property for Sale') && owner == false &&
        dealer == false) {
      showSnackBar(context, "Please select whether you are an owner or a ${_selectedCategory == 'Vehicles' ? 'dealer' : 'agent'}.");
    }

    else if (_selectedSubCategory!.isEmpty ) {
      showSnackBar(context, "Subcategory is required. Please add it.");
    }
    else if ((_selectedCategory == 'Mobiles' || _selectedCategory == 'Vehicles' ||
        _selectedCategory == 'Electronics & Appliance' || _selectedCategory == 'Furniture & home decor' ||
        _selectedCategory == 'Kids')
        && conditionSelect!.isEmpty ) {
      showSnackBar(context, "Condition is required. Please add it.");
    }
    else {


      provider.addProductSecondStep(
          mapData, update: widget.product != null || isBack == true).then((value){
        Navigator.push(context, CupertinoPageRoute(builder: (_) =>
            SetPostPriceScreen(
                product: widget.product,
                productId: value.data!.productId,
                title: widget.title,
                categoryName: _selectedCategory,
                productType: _selectedCategory == 'Jobs' ? selectJobType : null,
            ))).then((value){
          setState(() {
            isBack = true;
          });
        });
        provider.setSecondStepLoading(false);

      }).onError((error, stackTrace){
        provider.setSecondStepLoading(false);
        showSnackBar(context, error.toString());
      });

    }
  }

  Widget PostTextField({String? txt,
    TextEditingController? textEditingController,
    String? hintText,

    TextInputType? textInputType}){
    return Column(
      children: [
        TextField(
          keyboardType: textInputType == TextInputType.number ? TextInputType.number : TextInputType.visiblePassword,
          controller: textEditingController,
          style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[ -~]'), // This regex allows all printable ASCII characters
            ),
          ],
          decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColor
              ),
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: 8.h)
          ),
          onChanged: (_){
            setState(() {

            });
          },
        ),
        const CustomDivider()
      ],
    );
  }


}

class ImageDeleteService {
  Future<bool> imageDeleteService(
      {required BuildContext context,
      required int id,
      required int productId}) async {
    try {
      Map body = {'photo_id': id, 'product_id': productId};

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




