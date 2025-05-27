import 'dart:convert';

List<VisitorLog> visitorLogsFromJson(String str) =>
    List<VisitorLog>.from(json.decode(str).map((x) => VisitorLog.fromJson(x)));

String visitorLogsToJson(List<VisitorLog> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VisitorLog {
  final int id;
  final String visitorName;
  final String purpose;
  final String checkInTime;
  final String? checkOutTime;
  final String status;

  VisitorLog({
    required this.id,
    required this.visitorName,
    required this.purpose,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
  });

  factory VisitorLog.fromJson(Map<String, dynamic> json) => VisitorLog(
        id: json["id"],
        visitorName: json["visitor_details"]?["full_name"] ?? "Unknown",
        purpose: json["purpose"]?["purpose"] ?? "No Purpose",
        checkInTime: json["check_in"] ?? "",
        checkOutTime: json["check_out"], // nullable
        status: json["status"]?["status"] ?? "Unknown",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_details": {"full_name": visitorName},
        "purpose": {"purpose": purpose},
        "check_in": checkInTime,
        "check_out": checkOutTime,
        "status": {"status": status},
      };
}
