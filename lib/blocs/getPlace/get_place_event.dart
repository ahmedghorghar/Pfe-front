// lib/blocs/place/place_event.dart
// lib/blocs/place/place_event.dart

import 'package:equatable/equatable.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class FetchPlaces extends PlaceEvent {
  const FetchPlaces(String agencyId, String userToken);

  @override
  List<Object> get props => [];
}


