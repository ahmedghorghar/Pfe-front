// lib/models/booking.dart

class BookingModel {
  String? id;
  String? userId;
  String? serviceId;
  DateTime? bookingDate;
  double? price;
  String? status;
  String? notes;

  BookingModel({
    this.id,
    this.userId,
    this.serviceId,
    this.bookingDate,
    this.price,
    this.status,
    this.notes,
  });

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    serviceId = json['serviceId'];
    bookingDate = json['bookingDate'] != null ? DateTime.parse(json['bookingDate']) : null;
    price = json['price'];
    status = json['status'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['serviceId'] = serviceId;
    data['bookingDate'] = bookingDate?.toIso8601String();
    data['price'] = price;
    data['status'] = status;
    data['notes'] = notes;
    return data;
  }
}
