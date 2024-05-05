// lib/blocs/profil/profile_event.dart

import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UploadProfileImage extends ProfileEvent {
  final File imageFile;
  final String token;
  final String email;

  const UploadProfileImage({
    required this.imageFile,
    required this.token,
    required this.email,
  });

  @override
  List<Object> get props => [imageFile, token, email];
}
