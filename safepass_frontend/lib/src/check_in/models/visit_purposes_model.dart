// To parse this JSON data, do
//
//     final visitPurposesModel = visitPurposesModelFromJson(jsonString);

import 'dart:convert';

VisitPurposesModel visitPurposesModelFromJson(String str) => VisitPurposesModel.fromJson(json.decode(str));

String visitPurposesModelToJson(VisitPurposesModel data) => json.encode(data.toJson());

class VisitPurposesModel {
    final List<Purpose> purposes;

    VisitPurposesModel({
        required this.purposes,
    });

    factory VisitPurposesModel.fromJson(Map<String, dynamic> json) => VisitPurposesModel(
        purposes: List<Purpose>.from(json["purposes"].map((x) => Purpose.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "purposes": List<dynamic>.from(purposes.map((x) => x.toJson())),
    };
}

class Purpose {
    final int id;
    final String purpose;

    Purpose({
        required this.id,
        required this.purpose,
    });

    factory Purpose.fromJson(Map<String, dynamic> json) => Purpose(
        id: json["id"],
        purpose: json["purpose"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "purpose": purpose,
    };
}
