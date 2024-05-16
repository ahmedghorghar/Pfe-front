// lib/blocs/booking/booking_event.dart

import 'package:equatable/equatable.dart';
import 'package:tataguid/models/booking.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class FetchBookings extends BookingEvent {
  const FetchBookings();
}

class AddBooking extends BookingEvent {
  final BookingModel booking;

  const AddBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}

class UpdateBooking extends BookingEvent {
  final BookingModel booking;

  const UpdateBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}

class DeleteBooking extends BookingEvent {
  final String bookingId;

  const DeleteBooking(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
