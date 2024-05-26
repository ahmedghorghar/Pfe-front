// lib/agencyPages/general_information_page.dart

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GeneralInformationPage extends StatelessWidget {
  const GeneralInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#1E9CFF"),
        title: Text(
          "General Information",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Agency Name",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.045),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter agency name",
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Location",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.045),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter agency location",
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Contact Information",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.045),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter contact information",
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Description",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.045),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write a brief description",
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Save the information
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
