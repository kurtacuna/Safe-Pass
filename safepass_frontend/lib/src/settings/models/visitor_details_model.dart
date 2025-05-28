// To parse this JSON data, do
//
//     final visitorsModel = visitorsModelFromJson(jsonString);

import 'dart:convert';

VisitorsModel visitorsModelFromJson(String str) => VisitorsModel.fromJson(json.decode(str));

String visitorsModelToJson(VisitorsModel data) => json.encode(data.toJson());

class VisitorsModel {
    List<Visitor> visitors;

    VisitorsModel({
        required this.visitors,
    });

    factory VisitorsModel.fromJson(Map<String, dynamic> json) => VisitorsModel(
        visitors: List<Visitor>.from(json["visitors"].map((x) => Visitor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "visitors": List<dynamic>.from(visitors.map((x) => x.toJson())),
    };
}

class Visitor {
    int id;
    IdType idType;
    String photo;
    String firstName;
    String middleName;
    String lastName;
    String fullName;
    String contactNumber;
    String idNumber;
    String status;
    DateTime registrationDate;

    Visitor({
        required this.id,
        required this.idType,
        required this.photo,
        required this.firstName,
        required this.middleName,
        required this.lastName,
        required this.fullName,
        required this.contactNumber,
        required this.idNumber,
        required this.status,
        required this.registrationDate,
    });

    factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
        id: json["id"],
        idType: IdType.fromJson(json["id_type"]),
        photo: json["photo"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        contactNumber: json["contact_number"],
        idNumber: json["id_number"],
        status: json["status"],
        registrationDate: DateTime.parse(json["registration_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_type": idType.toJson(),
        "photo": photo,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "full_name": fullName,
        "contact_number": contactNumber,
        "id_number": idNumber,
        "status": status,
        "registration_date": registrationDate.toIso8601String(),
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
