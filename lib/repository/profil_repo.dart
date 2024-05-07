// lib/ripository/profile_repo.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
// import 'package:path/path.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:tataguid/storage/profil_storage.dart';

class ProfileRepository {
  static const String baseUrl = 'http://172.16.27.195:8080/profile'; // Replace with your backend URL

 Future<String> uploadProfileImage(
    File imageFile, String token, String email) async {
  try {
    final url = Uri.parse('$baseUrl/add/image/$email');
    final request = http.MultipartRequest('PATCH', url);
    request.headers['authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath(
      'img',
      imageFile.path,
      contentType: MediaType('image', 'jpg'),
    ));

    final response = await request.send();
//    print('Response status code: ${response.statusCode}');

    final responseData = await response.stream.bytesToString();
    // print('Response data: $responseData');

    if (response.statusCode == 200) {
      final parsedData = json.decode(responseData);
      final imgUrl = parsedData['data']['img'];
      // print('Image URL: $imgUrl');
      return imgUrl;
    } else {
      await ProfileStorage.storeEmail(email);
      throw Exception('Failed to upload profile image');
    }
  } catch (error) {
    await ProfileStorage.storeEmail(email);
    throw error;
  }
}
}