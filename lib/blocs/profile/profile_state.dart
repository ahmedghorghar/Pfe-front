// lib/blocs/profil/profile_state.dart

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String imageUrl;

  const ProfileSuccess({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure({required this.error});

  @override
  List<Object> get props => [error];
}
