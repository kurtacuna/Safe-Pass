import 'dart:convert';

VisitorSearchModel visitorSearchModelFromJson(String str) => VisitorSearchModel.fromJson(json.decode(str));

String visitorSearchModelToJson(VisitorSearchModel data) => json.encode(data.toJson());

class VisitorSearchModel {
  final List<VisitorSearchResult> results;

  VisitorSearchModel({
    required this.results,
  });

  factory VisitorSearchModel.fromJson(Map<String, dynamic> json) => VisitorSearchModel(
    results: List<VisitorSearchResult>.from(json["results"].map((x) => VisitorSearchResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class VisitorSearchResult {
  final String id;
  final String idNumber;
  final String fullName;
  final String? lastVisitDate;
  final String? visitPurpose;

  VisitorSearchResult({
    required this.id,
    required this.idNumber,
    required this.fullName,
    this.lastVisitDate,
    this.visitPurpose,
  });

  factory VisitorSearchResult.fromJson(Map<String, dynamic> json) => VisitorSearchResult(
    id: json["id"],
    idNumber: json["id_number"],
    fullName: json["full_name"],
    lastVisitDate: json["last_visit_date"],
    visitPurpose: json["visit_purpose"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_number": idNumber,
    "full_name": fullName,
    "last_visit_date": lastVisitDate,
    "visit_purpose": visitPurpose,
  };

  @override
  String toString() => "$idNumber ($fullName)";
} 