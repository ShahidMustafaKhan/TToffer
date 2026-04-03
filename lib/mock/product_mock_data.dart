import 'package:tt_offer/mock/category_mock_data.dart';
import 'package:tt_offer/mock/sub_category_mock_data.dart';
import 'package:tt_offer/mock/user_mock_data.dart';
import 'package:tt_offer/models/inventory_model.dart';

import '../models/product_model.dart';

List<Product> getMockFeatureProducts() {
  return [
    products[0],
    products[1],
    products[4],
  ];
}

List<Product> getMockAuctionProducts() {
  return [
    products[2],
    products[3],
  ];
}

Product getMockProductById(int id) {
  return products.firstWhere((element) => element.id == id);
}

List products = [
  Product(
    id: 1,
    title: "iPhone 14 Pro",
    condition: "New",
    location: "Karachi, Pakistan",
    deliveryType: ["Shipping", "Pick Up"],
    category: CategoriesMockService.findCategoryModel("Mobiles"),
    subCategory: SubCategoriesMockService.findSubCategoryModel("Mobile Phones"),
    categoryId: 1,
    subCategoryId: 1,
    qty: 12,
    viewsCount: 20,
    inventory: Inventory(availableStock: 10, totalStock: 10),
    attributes: {
      "color": "black",
      "storage": "128GB",
      "condition": "new",
      "brand": "apple",
      "model": "iphone 14 pro"
    },
    description: "Latest iPhone with A16 Bionic chip and 48MP camera.",
    userId: 2,
    user: getMockUserList()[0],
    productType: "featured",
    fixPrice: 1500,
    isSold: 0,
    reviewPercentage: 4,
    review: [
      ProductReviews(
        id: 1,
        reviewer: getMockUser(),
        rating: 5,
        comment: "Good Product",
      ),
      ProductReviews(
        id: 1,
        reviewer: getMockUserList()[1],
        rating: 3,
        comment: "Good Product",
      )
    ],
    totalReview: 2,
    photo: [
      Photo(
        id: 1,
        productId: 1,
        url:
            "https://images.pexels.com/photos/5081399/pexels-photo-5081399.jpeg?auto=compress&cs=tinysrgb&w=300",
      )
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 3)).toString(),
  ),
  Product(
    id: 2,
    title: "Electronics Appliances",
    location: "Karachi, Pakistan",
    condition: "New",
    viewsCount: 20,
    qty: 3,
    category:
        CategoriesMockService.findCategoryModel("Electronics & Appliance"),
    subCategory:
        SubCategoriesMockService.findSubCategoryModel("Kitchen Appliances"),
    attributes: {
      "color": "black",
      "condition": "new",
      "brand": "Dawlance",
    },
    inventory: Inventory(availableStock: 10, totalStock: 10),
    deliveryType: ["Shipping", "Local Delivery"],
    description: "Electronic Appliances",
    userId: 3,
    user: getMockUserList()[1],
    productType: "featured",
    fixPrice: 50000,
    isSold: 0,
    reviewPercentage: 5,
    review: [
      ProductReviews(
        id: 1,
        reviewer: getMockUserList()[0],
        rating: 5,
        comment: "Seller was very cooperative and helpful",
      ),
      ProductReviews(
        id: 1,
        reviewer: getMockUser(),
        rating: 5,
        comment: "Good Product",
      )
    ],
    photo: [
      Photo(
        id: 2,
        productId: 2,
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJR9CkljoLLu7ohGj7SOwvMNTNHbDe6J54WQ&s",
      )
    ],
    totalReview: 120,
    createdAt: DateTime.now().subtract(const Duration(days: 3)).toString(),
  ),
  Product(
    id: 3,
    title: "IPhone 14 Pro",
    condition: "New",
    location: "Karachi, Pakistan",
    viewsCount: 100,
    deliveryType: ["Shipping", "Pick Up"],
    description: "Latest iPhone with A16 Bionic chip and 48MP camera.",
    userId: 2,
    attributes: {
      "color": "black",
      "storage": "128GB",
      "condition": "new",
      "brand": "apple",
      "model": "iphone 14 pro"
    },
    user: getMockUserList()[0],
    reviewPercentage: 5,
    inventory: Inventory(availableStock: 0, totalStock: 0),
    review: [
      ProductReviews(
        id: 1,
        reviewer: getMockUser(),
        rating: 5,
        comment: "Good Product",
      )
    ],
    productType: "auction",
    category: CategoriesMockService.findCategoryModel("Mobiles"),
    subCategory: SubCategoriesMockService.findSubCategoryModel("Mobile Phones"),
    auctionInitialPrice: 30000,
    auctionFinalPrice: 70000,
    auctionEndingDate: DateTime.now().add(const Duration(days: 3)).toString(),
    auctionEndingDateTime:
        DateTime.now().add(const Duration(days: 3)).toString(),
    auctionStartingDate:
        DateTime.now().subtract(const Duration(days: 3)).toString(),
    isSold: 0,
    photo: [
      Photo(
        id: 1,
        productId: 3,
        url:
            "https://images.pexels.com/photos/5081399/pexels-photo-5081399.jpeg?auto=compress&cs=tinysrgb&w=300",
      )
    ],
    totalReview: 120,
    createdAt: DateTime.now().subtract(const Duration(days: 3)).toString(),
  ),
  Product(
    id: 4,
    title: "Electronics Appliances",
    location: "Karachi, Pakistan",
    condition: "New",
    deliveryType: ["Shipping", "Local Delivery"],
    description: "Electronic Appliances",
    attributes: {
      "color": "black",
      "condition": "new",
      "brand": "Dawlance",
    },
    inventory: Inventory(availableStock: 10, totalStock: 10),
    viewsCount: 10,
    category:
        CategoriesMockService.findCategoryModel("Electronics & Appliance"),
    subCategory:
        SubCategoriesMockService.findSubCategoryModel("Kitchen Appliances"),
    userId: 3,
    user: getMockUserList()[1],
    productType: "auction",
    auctionInitialPrice: 30000,
    auctionFinalPrice: 70000,
    auctionEndingDateTime:
        DateTime.now().add(const Duration(days: 3)).toString(),
    auctionEndingDate: DateTime.now().add(const Duration(days: 3)).toString(),
    auctionStartingDate:
        DateTime.now().subtract(const Duration(days: 3)).toString(),
    isSold: 0,
    reviewPercentage: 5,
    review: [
      ProductReviews(
        id: 1,
        reviewer: getMockUser(),
        rating: 5,
        comment: "Fast Delivery",
      ),
    ],
    photo: [
      Photo(
        id: 2,
        productId: 4,
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJR9CkljoLLu7ohGj7SOwvMNTNHbDe6J54WQ&s",
      )
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 3)).toString(),
  ),
  Product(
    id: 5,
    title: "Modern Office Desk and Ergonomic Chair Setup",
    location: "Dubai, UAE",
    condition: "New",
    deliveryType: ["Local Delivery"],
    description:
        "A well-organized and modern office desk setup featuring a wooden desk with a clean, minimalist design. The desk is accompanied by a comfortable ergonomic office chair with a mesh backrest. On the desk, there is a laptop, a wireless mouse, stationery items, and decorative elements such as a small potted plant. Natural light filters through vertical blinds, creating a bright and inviting workspace ideal for productivity.",
    attributes: {
      "color": "black",
      "condition": "new",
    },
    inventory: Inventory(availableStock: 10, totalStock: 10),
    viewsCount: 200,
    category: CategoriesMockService.findCategoryModel("Furniture & home decor"),
    subCategory:
        SubCategoriesMockService.findSubCategoryModel("Office Furniture"),
    userId: 3,
    user: getMockUser(),
    productType: "featured",
    fixPrice: 20000,
    isSold: 0,
    reviewPercentage: 5,
    viewSummary: [
      ViewsSummary(
        month: "December",
        views: 10,
      ),
      ViewsSummary(
        month: "January",
        views: 20,
      ),
      ViewsSummary(
        month: "February",
        views: 30,
      ),
      ViewsSummary(
        month: "March",
        views: 40,
      ),
      ViewsSummary(
        month: "April",
        views: 100,
      ),
    ],
    review: [
      ProductReviews(
        id: 1,
        reviewer: getMockUserById(2),
        rating: 5,
        comment:
            "This office setup is sleek and inviting! The natural light, organized desk, and ergonomic chair make it a perfect space for productivity. Love the minimal and modern vibe!",
      ),
    ],
    photo: [
      Photo(
        id: 2,
        productId: 5,
        url:
            "https://images.pexels.com/photos/1957478/pexels-photo-1957478.jpeg?auto=compress&cs=tinysrgb&w=600",
      )
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 3)).toString(),
  ),
];

class ViewSummary {}
