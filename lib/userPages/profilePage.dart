import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tataguid/blocs/profile/profile_bloc.dart';
import 'package:tataguid/blocs/profile/profile_event.dart';
import 'package:tataguid/blocs/profile/profile_state.dart';
import 'package:tataguid/repository/profil_repo.dart';
import 'package:tataguid/storage/profil_storage.dart';
import 'package:tataguid/storage/token_storage.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  XFile? _imageFile;
  bool showscrollWidget = false;
  bool status = false;
  String theme = "Light";
  List<String> themes = ['Light', 'Dark'];
  String? temperature = "°F";
  List<String> temperatures = ["°F", "°C"];
  String? distance = "M";
  List<String> distances = ["M", "KM"];

  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(profileRepository: ProfileRepository());
    
  }

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _profileBloc,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profile & Settings",
                      style: GoogleFonts.afacad(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: sW * 0.08),
                      )),
                  SizedBox(height: sH * 0.04),
                  Row(
                    children: [
                      FutureBuilder<String?>(
                        future: ProfileStorage.getUserEmail(),
                        builder: (context, emailSnapshot) {
                          if (emailSnapshot.connectionState ==
                              ConnectionState.done) {
                            String? email = emailSnapshot.data;
                            return FutureBuilder<String?>(
                              future: ProfileStorage.getProfileImage(email!),
                              builder: (context, snapshot) {
                                return imageProfile(snapshot);
                              },
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      Text("Mrabet Lassade",
                          style: GoogleFonts.afacad(
                            textStyle: TextStyle(fontSize: sW * 0.06),
                          )),
                    ],
                  ),
                  SizedBox(height: sH * 0.04),
                  ListTile(
                    onTap: () {
                      setState(() {
                        showscrollWidget = !showscrollWidget;
                      });
                    },
                    leading: Icon(Icons.settings),
                    title: Text("Settings",
                        style: GoogleFonts.afacad(
                          textStyle: TextStyle(
                              fontSize: sW * 0.05, fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.keyboard_arrow_down),
                  ),
                  if (showscrollWidget)
                    Container(
                      margin: EdgeInsets.only(left: sW * 0.1),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Application Theme"),
                            trailing: SizedBox(
                              width: sW * 0.3,
                              child: DropdownButtonFormField<String>(
                                value: theme,
                                icon: Icon(Icons.arrow_drop_down),
                                menuMaxHeight: 200,
                                items: themes.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                isDense: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (String? newValue) {},
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text("Temperature"),
                            trailing: SizedBox(
                              width: sW * 0.3,
                              child: DropdownButtonFormField<String>(
                                value: temperature,
                                icon: Icon(Icons.arrow_drop_down),
                                menuMaxHeight: 200,
                                items: temperatures.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                isDense: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (String? newvalue) {
                                  setState(() {
                                    temperature = newvalue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text("Distance"),
                            trailing: SizedBox(
                              width: sW * 0.3,
                              child: DropdownButtonFormField<String>(
                                value: distance,
                                icon: Icon(Icons.arrow_drop_down),
                                menuMaxHeight: 200,
                                items: distances.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                isDense: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (String? newvalue) {
                                  setState(() {
                                    distance = newvalue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.monetization_on_rounded),
                    title: Text("Restore purchases",
                        style: GoogleFonts.afacad(
                          textStyle: TextStyle(
                              fontSize: sW * 0.05, fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.star_border_outlined),
                    title: Text("Rate the App",
                        style: GoogleFonts.afacad(
                          textStyle: TextStyle(
                              fontSize: sW * 0.05, fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.message_outlined),
                    title: Text("Share feedback",
                        style: GoogleFonts.afacad(
                          textStyle: TextStyle(
                              fontSize: sW * 0.05, fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  Widget BottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text("Choose a Profile photo", style: TextStyle(fontSize: 20.0)),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget imageProfile(AsyncSnapshot<String?> snapshot) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: snapshot.data != null
              ? FileImage(File(snapshot.data!)) as ImageProvider<Object>?
              : AssetImage('assets/Profileimage.png'),
        ),
        Positioned(
          bottom: 1.0,
          right: 30.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => BottomSheet()),
              );
            },
            child: Icon(Icons.camera_alt, color: Colors.teal, size: 28.0),
          ),
        ),
      ],
    );
  }

  void takePhoto(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      String? token = await TokenStorage.getToken();
      String? email = await ProfileStorage.getUserEmail();
      if (token != null && email != null) {
        await uploadProfilePhoto(File(pickedFile.path), token, email);
      } else {
        print('token or email is null: $token, $email');
      }
    }
  }

  Future<void> uploadProfilePhoto(
      File imageFile, String token, String email) async {
    // Clear the old profile image path
    await ProfileStorage.deleteProfileImage(email);

    // Store the new profile image path
    await ProfileStorage.storeProfileImage(email, imageFile.path);

    // Add the UploadProfileImage event to the ProfileBloc
    context.read<ProfileBloc>().add(
          UploadProfileImage(imageFile: imageFile, token: token, email: email),
        );
  }
}
