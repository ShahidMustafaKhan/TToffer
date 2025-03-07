class InventoryModel {
  int? code;
  bool? status;
  String? message;
  Inventory? inventory;

  InventoryModel({this.code, this.status, this.message, this.inventory});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    inventory = json['data'] != null ? Inventory.fromJson(json['data']) : null;
  }

}



class Inventory {
  int? id;
  int? productId;
  int? totalStock;
  int? availableStock;
  int? thresholdLowStock;

  Inventory(
      {this.id,
        this.productId,
        this.totalStock,
        this.availableStock,
        this.thresholdLowStock});

  Inventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    totalStock = json['total_stock'];
    availableStock = json['available_stock'];
    thresholdLowStock = json['threshold_low_stock'];
  }

}