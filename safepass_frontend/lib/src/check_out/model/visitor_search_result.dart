import 'dart:convert';

VisitorSearchModel visitorSearchModelFromJson(String str) {
  print('DEBUG: Converting JSON string to VisitorSearchModel:');
  print('Raw JSON: $str');
  final json = jsonDecode(str);
  print('Decoded JSON: $json');
  return VisitorSearchModel.fromJson(json);
}

String visitorSearchModelToJson(VisitorSearchModel data) => json.encode(data.toJson());

class VisitorSearchModel {
  final List<VisitorSearchResult> results;

  VisitorSearchModel({
    required this.results,
  });

  factory VisitorSearchModel.fromJson(Map<String, dynamic> json) {
    print('DEBUG: Creating VisitorSearchModel from JSON:');
    print('Input JSON: $json');
    final results = List<VisitorSearchResult>.from(
      json["results"].map((x) {
        print('DEBUG: Creating VisitorSearchResult from: $x');
        return VisitorSearchResult.fromJson(x);
      })
    );
    print('DEBUG: Created ${results.length} VisitorSearchResults');
    return VisitorSearchModel(results: results);
  }

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class VisitorSearchResult {
  final String id;
  final String idNumber;
  final String fullName;
  final String displayString;
  final String? visitPurpose;

  VisitorSearchResult({
    required this.id,
    required this.idNumber,
    required this.fullName,
    required this.displayString,
    this.visitPurpose,
  });

  factory VisitorSearchResult.fromJson(Map<String, dynamic> json) {
    print('DEBUG: Creating VisitorSearchResult from JSON:');
    print('Input JSON: $json');
    final result = VisitorSearchResult(
      id: json["id"] ?? '',
      idNumber: json["id_number"] ?? '',
      fullName: json["full_name"] ?? '',
      displayString: json["display_string"] ?? '',
      visitPurpose: json["visit_purpose"],
    );
    print('DEBUG: Created VisitorSearchResult:');
    print('ID: ${result.id}');
    print('ID Number: ${result.idNumber}');
    print('Full Name: ${result.fullName}');
    print('Display String: ${result.displayString}');
    print('Visit Purpose: ${result.visitPurpose}');
    return result;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_number": idNumber,
    "full_name": fullName,
    "display_string": displayString,
    "visit_purpose": visitPurpose,
  };

  @override
  String toString() => displayString;
} 