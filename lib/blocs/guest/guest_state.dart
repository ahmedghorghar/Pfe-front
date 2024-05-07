// frontend/lib/blocs/guest/guest_state.dart

// guest_state.dart

import 'package:equatable/equatable.dart';

abstract class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object> get props => [];
}

class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestLoaded extends GuestState {
  final String guestID;

  const GuestLoaded(this.guestID);

  @override
  List<Object> get props => [guestID];
}

class GuestError extends GuestState {
  final String message;

  const GuestError(this.message);

  @override
  List<Object> get props => [message];
}
