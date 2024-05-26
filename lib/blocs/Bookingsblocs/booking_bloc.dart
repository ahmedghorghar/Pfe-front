// lib/blocs/booking/booking_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_event.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_state.dart';
import 'package:tataguid/repository/booking_repository.dart';
import 'package:tataguid/storage/token_storage.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<FetchBookings>(_onFetchBookings);
    on<FetchUserBookings>(_onFetchUserBookings);
    on<AddBooking>(_onAddBooking);
    on<UpdateBooking>(_onUpdateBooking);
    on<DeleteBooking>(_onDeleteBooking);
    on<FetchAgencyBookings>(_onFetchAgencyBookings);
  }

  void _onFetchAgencyBookings(
      FetchAgencyBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings =
          await bookingRepository.fetchAgencyBookings(event.agencyId);
      emit(BookingsLoaded(bookings));
    } catch (error) {
      emit(BookingError('Failed to load agency bookings: $error'));
    }
  }

  void _onFetchBookings(FetchBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.fetchBookings();
      emit(BookingsLoaded(bookings));
    } catch (error) {
      emit(BookingError('Failed to load bookings: $error'));
    }
  }

  void _onFetchUserBookings(
      FetchUserBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.fetchUserBookings();
      emit(BookingsLoaded(bookings));
    } catch (error) {
      emit(BookingError('Failed to load user bookings: $error'));
    }
  }

  void _onAddBooking(AddBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final userId = await TokenStorage.getAgencyId(); // Changed to non-nullable
      final newBooking = await bookingRepository.addBooking(event.booking, userId!);
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
}
