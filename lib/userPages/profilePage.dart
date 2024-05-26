// lib/userPages/profilePage.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/login/login_event.dart';
import 'package:tataguid/components/theme_manager.dart';
import 'package:tataguid/storage/profil_storage.dart';
import 'package:tataguid/userPages/ProfilComponents/about_tataguid_page.dart';
import 'package:tataguid/userPages/ProfilComponents/rate_app_page.dart';
import 'package:tataguid/userPages/ProfilComponents/share_feedback_page.dart';
import 'package:tataguid/userPages/ProfilComponents/user_bookings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showSettings = false;
  String theme = "Light";
  List<String> themes = ['Light', 'Dark'];
  String temperature = "°F";
  List<String> temperatures = ["°F", "°C"];
  String distance = "M";
  List<String> distances = ["M", "KM"];
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => BlocProvider.of<LoginBloc>(context),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profile & Settings",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.08),
                      )),
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    children: [
                      FutureBuilder<String?>(
                        future: ProfileUserStorage.getUserEmail(),
                        builder: (context, emailSnapshot) {
                          if (emailSnapshot.connectionState ==
                              ConnectionState.done) {
                            String? email = emailSnapshot.data;
                            return FutureBuilder<String?>(
                              future:
                                  ProfileUserStorage.getProfileImage(email!),
                              builder: (context, snapshot) {
                                return imageProfile(snapshot);
                              },
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      FutureBuilder<String?>(
                        future: ProfileUserStorage.getUserName(),
                        builder: (context, nameSnapshot) {
                          if (nameSnapshot.connectionState ==
                              ConnectionState.done) {
                            String? name = nameSnapshot.data;
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.05),
                              child: Text(
                                name ?? "Default Name",
                                style: GoogleFonts.lato(
                                  textStyle:
                                      TextStyle(fontSize: screenWidth * 0.06),
                                ),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  ListTile(
                    onTap: () {
                      setState(() {
                        showSettings = !showSettings;
                      });
                    },
                    leading: Icon(Icons.settings),
                    title: Text("Settings",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.keyboard_arrow_down),
                  ),
                  if (showSettings)
                    Container(
                      margin: EdgeInsets.only(left: screenWidth * 0.1),
                      child: Column(
                        children: [
                          settingsOption("Application Theme", theme, themes,
                              (newValue) {
                            setState(() {
                              theme = newValue!;
                              if (theme == "Dark") {
                                context
                                    .read<ThemeManager>()
                                    .setTheme(ThemeMode.dark);
                              } else {
                                context
                                    .read<ThemeManager>()
                                    .setTheme(ThemeMode.light);
                              }
                            });
                          }),
                          settingsOption(
                              "Temperature", temperature, temperatures,
                              (newValue) {
                            setState(() {
                              temperature = newValue!;
                            });
                          }),
                          settingsOption("Distance", distance, distances,
                              (newValue) {
                            setState(() {
                              distance = newValue!;
                            });
                          }),
                        ],
                      ),
                    ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.monetization_on_rounded),
                    title: Text("Restore Purchases",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.star_border_outlined),
                    title: Text("Rate the App",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RateAppPage()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.message_outlined),
                    title: Text("Share Feedback",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShareFeedbackPage()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text("About TataGuid",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutTataGuidPage()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.book_online),
                    title: Text("Your Bookings",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserBookingsPage()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        )),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      BlocProvider.of<LoginBloc>(context).add(LogoutEvent());
                      // Navigate to login screen after logout
                      Navigator.of(context).pushReplacementNamed('/login_ui');
                    },
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

  Widget settingsOption(String title, String currentValue, List<String> options,
      ValueChanged<String?> onChanged) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      title: Text(title),
      trailing: SizedBox(
        width: screenWidth * 0.3,
        child: DropdownButtonFormField<String>(
          value: currentValue,
          icon: Icon(Icons.arrow_drop_down),
          menuMaxHeight: 200,
          items: options.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isDense: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
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
          Text("Choose a Profile Photo", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 20),
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
          ),
        ],
      ),
    );
  }

  Widget imageProfile(AsyncSnapshot<String?> snapshot) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 50.0,
          backgroundImage: snapshot.hasData
              ? NetworkImage(snapshot.data!)
              : AssetImage('assets/Profileimage.png') as ImageProvider,
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => BottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }
}
