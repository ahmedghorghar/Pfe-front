// lib/blocs/profil/profile_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tataguid/repository/profil_repo.dart';
import 'package:tataguid/blocs/profile/profile_event.dart';
import 'package:tataguid/blocs/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<UploadProfileImage>(_onUploadProfileImage);
  }
 void _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final imageUrl = await profileRepository.uploadProfileImage(
        event.imageFile,
        event.token,
        event.email
      );  
      emit(ProfileSuccess(imageUrl: imageUrl));
    } catch (error) {
      emit(ProfileFailure(error: error.toString()));
    }
  }
}

