import 'dart:convert';

List<VisitorDetails> visitorDetailsFromJson(String str) => List<VisitorDetails>.from(json.decode(str).map((x) => VisitorDetails.fromJson(x)));

String visitorDetailsToJson(List<VisitorDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VisitorDetails {
    String photo;
    String firstName;
    String middleName;
    String lastName;
    String fullName;
    String contactNumber;
    String idType;
    String idNumber;
    String status;
    DateTime registrationDate;

    VisitorDetails({
        required this.photo,
        required this.firstName,
        required this.middleName,
        required this.lastName,
        required this.fullName,
        required this.contactNumber,
        required this.idType,
        required this.idNumber,
        required this.status,
        required this.registrationDate,
    });

    factory VisitorDetails.fromJson(Map<String, dynamic> json) => VisitorDetails(
        photo: json["photo"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        contactNumber: json["contact_number"],
        idType: json["id_type"],
        idNumber: json["id_number"],
        status: json["status"],
        registrationDate: DateTime.parse(json["registration_date"]),
    );

    Map<String, dynamic> toJson() => {
        "photo": photo,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "full_name": fullName,
        "contact_number": contactNumber,
        "id_type": idType,
        "id_number": idNumber,
        "status": status,
        "registration_date": registrationDate.toIso8601String(),
    };
}