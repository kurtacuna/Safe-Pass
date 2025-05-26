import 'dart:convert';

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
        visitorName: json["visitor_name"],
        purpose: json["purpose"],
        checkInTime: json["check_in_time"],
        checkOutTime: json["check_out_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_name": visitorName,
        "purpose": purpose,
        "check_in_time": checkInTime,
        "check_out_time": checkOutTime,
        "status": status,
      };
}

List<VisitorLog> visitorLogsFromJson(String str) =>
    List<VisitorLog>.from(json.decode(str).map((x) => VisitorLog.fromJson(x)));

String visitorLogsToJson(List<VisitorLog> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))); 