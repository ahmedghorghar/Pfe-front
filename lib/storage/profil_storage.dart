// lib/storage/profil_storage.dart

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileStorage {
  // static FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> storeDefaultProfileImage() async {
    // Store the default profile image path
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('default_profile_image_path', 'assets/Profileimage.png');
    print('prefs: $prefs');
  }

  static Future<void> storeProfileImage(String email, String imagePath) async {
    // Store the user's profile image path
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image_path_$email', imagePath);
  }

  static Future<String?> getProfileImage(String email) async {
    // Retrieve the user's profile image path
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image_path_$email');
    if (imagePath == null) {
      // If no profile image is found for this email, return the default image path
      imagePath = prefs.getString('default_profile_image_path');
    }
    return imagePath;
  }

  static Future<void> deleteProfileImage(String email) async {
    // Delete the user's profile image
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('profile_image_path_$email');
  }

  static Future<String?> getUserEmail() async {
    // Retrieve the user's email
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> storeEmail(String email) async {
    // Store the user's email
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
  }

  static Future<void> clearDefaultProfileImage() async {
    // Clear the default profile image path
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('default_profile_image_path');
  }

  static Future<void> storeUserName(String name) async {
    // Store the user's name
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', name);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }
}
