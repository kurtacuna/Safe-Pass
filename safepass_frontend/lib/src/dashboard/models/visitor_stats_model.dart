class VisitorStats {
  final int totalVisitors;
  final int checkedIn;
  final int checkedOut;
  final int newRegistrants;

  VisitorStats({
    required this.totalVisitors,
    required this.checkedIn,
    required this.checkedOut,
    required this.newRegistrants,
  });

  factory VisitorStats.fromJson(Map<String, dynamic> json) {
    return VisitorStats(
      totalVisitors: json['total_visitors'] ?? 0,
      checkedIn: json['checked_in'] ?? 0,
      checkedOut: json['checked_out'] ?? 0,
      newRegistrants: json['new_registrants'] ?? 0,
    );
  }
} 