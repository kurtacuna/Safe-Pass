import 'dart:convert';

CommonJsonModel commonJsonModelFromJson(String str) => CommonJsonModel.fromJson(json.decode(str));

String commonJsonModelToJson(CommonJsonModel data) => json.encode(data.toJson());

class CommonJsonModel {
    String detail;

    CommonJsonModel({
        required this.detail,
    });

    factory CommonJsonModel.fromJson(Map<String, dynamic> json) => CommonJsonModel(
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "detail": detail,
    };
}