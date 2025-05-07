class VisitorLog {
  final String name;
  final String checkIn;
  final String checkOut;
  final String purpose;
  final String status;

  VisitorLog({
    required this.name,
    required this.checkIn,
    required this.checkOut,
    required this.purpose,
    required this.status,
  });

  factory VisitorLog.fromMap(Map<String, dynamic> map) {
    return VisitorLog(
      name: map['name'] ?? '',
      checkIn: map['checkIn'] ?? '',
      checkOut: map['checkOut'] ?? '',
      purpose: map['purpose'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'purpose': purpose,
      'status': status,
    };
  }
}
