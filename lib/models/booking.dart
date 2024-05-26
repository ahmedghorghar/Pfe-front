/* // lib/models/booking.dart

class BookingModel {
  String? id;
  String? userId;
  String? placeId;
  String? agencyId;
  DateTime? bookingDate;
  String? status;
  String? notes;

  BookingModel({
    this.id,
    this.userId,
    this.placeId,
    this.agencyId,
    this.bookingDate,
    this.status,
    this.notes,
  });

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['bookingId'] ?? json['_id'];  // Handle both possible keys
    userId = json['userId'];
    placeId = json['placeId'];
    agencyId = json['agencyId'];
    bookingDate = json['visitDate'] != null ? DateTime.parse(json['visitDate']) : null;
    status = json['status'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['placeId'] = placeId;
    data['agencyId'] = agencyId;
    data['visitDate'] = bookingDate?.toIso8601String();
    data['status'] = status;
    data['notes'] = notes;
    return data;
  }
}
 */

// lib/models/booking.dart
class BookingModel {
  late final String id;
  late final String userId;
  late final String userName;
  late final String userEmail;
  late final String placeId;
  late final String placeName; // Ensure this field is present
  late final String title;
  late final String agencyId;
  late final DateTime bookingDate;
  late final double price; // This field will be used for price.
  late final String notes;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.placeId,
    required this.placeName, // Ensure this field is initialized
    required this.title,
    required this.agencyId,
    required this.bookingDate,
    required this.price,
    required this.notes,
  });

BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['bookingId'] ?? json['_id'] ?? '';
    userId = json['userId'] ?? '';
    userName = json['userName'] ?? '';
    userEmail = json['userEmail'] ?? '';
    placeId = json['placeId'] ?? '';
    placeName = json['placeName'] ?? ''; // Ensure this field is parsed
    title = json['title'] ?? '';
    agencyId = json['agencyId'] ?? '';
    bookingDate = (json['visitDate'] != null
        ? DateTime.parse(json['visitDate'])
        : null)!;
    price = json['price']?.toDouble();
    notes = json['notes'] ?? '';
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['placeId'] = placeId;
    data['placeName'] = placeName; // Ensure this field is included in JSON
    data['title'] = title;
    data['agencyId'] = agencyId;
    data['visitDate'] = bookingDate.toIso8601String();
    data['price'] = price;
    data['notes'] = notes;
    return data;
  }
}
