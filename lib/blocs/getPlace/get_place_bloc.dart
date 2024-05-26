// lib/blocs/place/place_bloc.dart

// lib/blocs/place/place_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/getPlace/get_place_event.dart';
import 'package:tataguid/blocs/getPlace/get_place_state.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/repository/get_places_repository.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceRepository placeRepository;

  PlaceBloc({required this.placeRepository}) : super(PlaceInitial()) {
    on<FetchPlaces>(_onFetchPlaces);
  }

  void _onFetchPlaces(FetchPlaces event, Emitter<PlaceState> emit) async {
    emit(PlaceLoading());
    try {
      final places = await placeRepository.getAllPlaces();
      emit(PlaceLoaded(places.cast<PlaceModel>()));
    } catch (error) {
      emit(PlaceError('Failed to load places: $error'));
    }
  }
}
