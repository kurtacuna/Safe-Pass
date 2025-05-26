import 'dart:convert';

JwtModel jwtModelFromJson(String str) => JwtModel.fromJson(json.decode(str));

String jwtModelToJson(JwtModel data) => json.encode(data.toJson());

class JwtModel {
    String refresh;
    String access;

    JwtModel({
        required this.refresh,
        required this.access,
    });

    factory JwtModel.fromJson(Map<String, dynamic> json) => JwtModel(
        refresh: json["refresh"],
        access: json["access"],
    );

    Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
    };
}