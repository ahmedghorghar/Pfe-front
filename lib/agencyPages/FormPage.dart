// lib/agencyPages/FormPage.dart

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/uploadBloc/upload_bloc.dart';
import 'package:tataguid/models/upload.model.dart';
import 'package:tataguid/blocs/uploadBloc/upload_event.dart';
import 'package:tataguid/repository/upload_repository.dart';
import 'package:image_picker/image_picker.dart';

class AdminForm extends StatefulWidget {
  const AdminForm({super.key});

  @override
  State<AdminForm> createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  TextEditingController title = TextEditingController();
  List<File> images = [];
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController check_In = TextEditingController();
  TextEditingController check_Out = TextEditingController();
  TextEditingController hotel_name = TextEditingController();
  TextEditingController room_type = TextEditingController();
  PageController pageController = PageController();
  GlobalKey<FormState> formKey = GlobalKey();
  late final UploadBloc _uploadBloc;

  @override
  void initState() {
    super.initState();
    _uploadBloc = UploadBloc(uploadRepository: UploadRepository());
  }

  Future<List<XFile>> pickImages() async {
    List<XFile>? pickedFiles;
    try {
      pickedFiles = await ImagePicker().pickMultiImage(
        imageQuality: 80, // Adjust the image quality as needed
      );
    } catch (e) {
      print('Error while picking images: $e');
    }
    return pickedFiles ?? [];
  }
/* 
  void _handleImageSelection() async {
    List<XFile> selectedImages = await pickImages();
    if (selectedImages.isNotEmpty) {
      // Handle the selected images (e.g., display them, upload them, etc.)
      setState(() {
        // Update your UI with the selected images
      });
    } else {
      // User canceled image selection or no images were selected
      // Handle accordingly (e.g., show a message)
    }
  } */

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Form(
            key: formKey,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        "Add new Package",
                        style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        height: 1,
                        width: screenWidth,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tittle"),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          TextFormField(
                            controller: title,
                            decoration: InputDecoration(
                                hintText: "Enter the title",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Attach Documents"),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          DottedBorder(
                            color: HexColor("#551656"),
                            dashPattern: [10],
                            strokeWidth: 4,
                            child: GestureDetector(
                             // onTap: _handleImageSelection,
                              child: Container(
                                width: screenWidth,
                                height: screenHeight * 0.35,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/agencyImages/upload.png",
                                      width: screenWidth * 0.17,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),
                                    Text(
                                      'Click to pick images',
                                      style: TextStyle(
                                        color: HexColor("#2996E4"),
                                        fontSize: screenWidth * 0.07,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {}/* _handleImageSelection */,
                                      child: Text('Pick Images'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),

                      // first next Button hello
                      Container(
                        width: screenWidth,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(HexColor("#1E9CFF")),
                          ),
                          onPressed: () async {
                           /*  // Get the list of image file paths
                            List<XFile> selectedImages = await pickImages();

                            // Check if both images and title are not empty
                            if (selectedImages.isNotEmpty &&
                                title.text.isNotEmpty) {
                              List<String> imagePaths = selectedImages
                                  .map((file) => file.path)
                                  .toList();

                              // Create the upload model
                              final uploadModel = UploadModel(
                                placeName: title.text,
                                photos: imagePaths,
                                // Add logic to handle the remaining properties
                              );

                              // Add the upload data event to the bloc
                              _uploadBloc.add(UploadData(
                                agencyId: '', // Provide agency ID here
                                token: '', // Provide token here
                                uploadModel: uploadModel,
                              ));

                              // Navigate to the next page
                              pageController.animateToPage(
                                1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                            } else {
                              // Handle when no images are selected or title is empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please select at least one image and provide a title'),
                                ),
                              );
                            } */
                            /*  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please select at least one image and provide a title'),
                             ),); */
                              pageController.animateToPage(
                                1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.05),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              pageController.animateToPage(0,
                                  duration: Duration(microseconds: 200),
                                  curve: Curves.ease);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                            )),

                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Starting Point",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: start,
                              decoration: InputDecoration(
                                  hintText: "Enter the Starting Point",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Destination",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: end,
                              decoration: InputDecoration(
                                  hintText: "Enter the Destination",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: price,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money_outlined),
                                  hintText: "100",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Duration",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Text(
                              "Form",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.03),
                            ),
                            TextFormField(
                              controller: from,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money_outlined),
                                  hintText: "05/07/2024",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Text(
                              "To",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.03),
                            ),
                            TextFormField(
                              controller: to,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money_outlined),
                                  hintText: "05/08/2024",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: description,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  hintText:
                                      "Enter Something about trip and Ai will elaborate",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            Container(
                              width: screenWidth,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              HexColor("#0B4EFA"))),
                                  onPressed: () {},
                                  child: Text(
                                    "Generate Using AI",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        // hello
                        Container(
                          width: screenWidth,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    HexColor("#1E9CFF"))),
                            onPressed: () {
                              pageController.animateToPage(2,
                                  duration: Duration(microseconds: 200),
                                  curve: Curves.ease);
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Next",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              pageController.animateToPage(1,
                                  duration: Duration(microseconds: 200),
                                  curve: Curves.ease);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                            )),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Accommodation Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hotel Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: hotel_name,
                              decoration: InputDecoration(
                                  hintText: "Enter the Hotel Name",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: location,
                              decoration: InputDecoration(
                                  hintText: "Enter the location",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Room Type",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: room_type,
                              decoration: InputDecoration(
                                  hintText: "Room Type",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check In Time",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: check_In,
                              decoration: InputDecoration(
                                  hintText: "Enter the Check",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check Out Time",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            TextFormField(
                              controller: check_Out,
                              decoration: InputDecoration(
                                  hintText: "Enter the Check out Time",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),

                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        // hello
                        Container(
                          width: screenWidth,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    HexColor("#1E9CFF"))),
                            onPressed: () {
                              pageController.animateToPage(2,
                                  duration: Duration(microseconds: 200),
                                  curve: Curves.ease);
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
