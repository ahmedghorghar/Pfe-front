/*  // lib/blocs/booking/booking_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_event.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_state.dart';
import 'package:tataguid/repository/booking_repository.dart';



class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<FetchBookings>(_onFetchBookings);
    on<AddBooking>(_onAddBooking);
    on<UpdateBooking>(_onUpdateBooking);
    on<DeleteBooking>(_onDeleteBooking);
  }

  void _onFetchBookings(
      FetchBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.fetchBookings();
      emit(BookingsLoaded(bookings));
    } catch (error) {
      emit(BookingError('Failed to load bookings: $error'));
    }
  }

  void _onAddBooking(AddBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final newBooking = await bookingRepository.addBooking(event.booking);
      emit(BookingAdded(newBooking));
    } catch (error) {
      emit(BookingError('Failed to add booking: $error'));
    }
  }

  void _onUpdateBooking(
      UpdateBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final updatedBooking = await bookingRepository.updateBooking(event.booking);
      emit(BookingUpdated(updatedBooking));
    } catch (error) {
      emit(BookingError('Failed to update booking: $error'));
    }
  }

  void _onDeleteBooking(
      DeleteBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      await bookingRepository.deleteBooking(event.bookingId);
      emit(BookingDeleted(event.bookingId));
    } catch (error) {
      emit(BookingError('Failed to delete booking: $error'));
    }
  }
}  */