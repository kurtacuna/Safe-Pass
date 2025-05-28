// To parse this JSON data, do
//
//     final idTypesModel = idTypesModelFromJson(jsonString);

import 'dart:convert';

IdTypesModel idTypesModelFromJson(String str) => IdTypesModel.fromJson(json.decode(str));

String idTypesModelToJson(IdTypesModel data) => json.encode(data.toJson());

class IdTypesModel {
    List<IdType> idTypes;

    IdTypesModel({
        required this.idTypes,
    });

    factory IdTypesModel.fromJson(Map<String, dynamic> json) => IdTypesModel(
        idTypes: List<IdType>.from(json["id_types"].map((x) => IdType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id_types": List<dynamic>.from(idTypes.map((x) => x.toJson())),
    };
}

class IdType {
    String type;
    String code;

    IdType({
        required this.type,
        required this.code,
    });

    factory IdType.fromJson(Map<String, dynamic> json) => IdType(
        type: json["type"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
    };
}
