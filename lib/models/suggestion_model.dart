class SuggestionModel {
  int? code;
  bool? status;
  String? message;
  List<Data>? data;

  SuggestionModel({this.code, this.status, this.message, this.data});

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

}

class Data {
  String? name;
  String? description;
  String? type;

  Data({this.name, this.description, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
  }

}