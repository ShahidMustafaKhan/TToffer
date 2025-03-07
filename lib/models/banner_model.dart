class BannerModel {
  List<Data>? data;
  String? message;

  BannerModel({ this.data, this.message});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }


}

class Data {
  int? id;
  String? img;
  String? status;
  String? pageName;
  String? position;
  String? sequence;
  String? startDatetime;
  String? endDatetime;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.img,
        this.status,
        this.pageName,
        this.position,
        this.sequence,
        this.startDatetime,
        this.endDatetime,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {

    img = json['img'];
    position = json['position'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['img'] = this.img;
    // data['status'] = this.status;
    data['page_name'] = this.pageName;
    data['position'] = this.position;
    // data['sequence'] = this.sequence;
    // data['start_datetime'] = this.startDatetime;
    // data['end_datetime'] = this.endDatetime;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    return data;
  }
}