// lib/agencyPages/homePage.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

class AgencyHome extends StatefulWidget {
  const AgencyHome({super.key});

  @override
  State<AgencyHome> createState() => _AgencyHomeState();
}

class _AgencyHomeState extends State<AgencyHome> {
  int _isSelectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#1E9CFF"),
        leading: Image.asset("assets/agencyImages/Menu.png"),
        title: Text(
          "Bookings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: HexColor("#D9D9D9"),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton(0, "Planners", screenWidth * 0.3), // Adjust width as needed
                _buildTabButton(1, "Travelers", screenWidth * 0.3), // Adjust width as needed
                _buildTabButton(2, "Reviewers", screenWidth * 0.3), // Adjust width as needed
              ],
            ),
          ),
          Expanded(
            child: PageStorage(
              bucket: bucket,
              child: _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildTabButton(int index, String title, double buttonWidth) {
  return Flexible(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: buttonWidth),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            _isSelectedIndex == index ? HexColor("#1E9CFF") : HexColor("#D9D9D9"),
          ),
        ),
        onPressed: () {
          setState(() {
            _isSelectedIndex = index;
          });
        },
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16, // Adjust the font size as needed
            color: _isSelectedIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildPage() {
    switch (_isSelectedIndex) {
      case 0:
        return PlannerPage();
      case 1:
        return TravelersPage();
      case 2:
        return ReviewersPage();
      default:
        return Container(); // Return an empty container for unexpected cases
    }
  }

  Widget PlannerPage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        children: List.generate(5, (index) {
          return Card(
            child: ExpansionTile(
              title: Text("Ashish sharma"),
              leading: Image.asset("assets/agencyImages/avatar.png"),
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey,
                  width: 300,
                  child: Text("I am a Planner"),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget TravelersPage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        children: List.generate(5, (index) {
          return Card(
            child: ExpansionTile(
              title: Text("Ashish sharma"),
              leading: Image.asset("assets/agencyImages/avatar.png"),
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey,
                  width: 300,
                  child: Text("I am a Travelers"),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget ReviewersPage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Wrap(
          children: List.generate(12, (index) {
            return Card(
              child: ExpansionTile(
                title: Text("Ashish sharma"),
                leading: Image.asset("assets/agencyImages/avatar.png"),
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.grey,
                    width: 300,
                    child: Text("I am a Reviewers"),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
