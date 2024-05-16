// lib/ui/post_contacts.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tataguid/agencyPages/FormPage.dart';
import 'package:tataguid/agencyPages/MessagePage.dart';
import 'package:tataguid/agencyPages/homePage.dart';

import '../agencyPages/ProfilePage.dart';
import '../userPages/profilePage.dart';

class AgencyPanelScreen extends StatefulWidget {
  @override
  State<AgencyPanelScreen> createState() => _AgencyPanelScreenState();
}

class _AgencyPanelScreenState extends State<AgencyPanelScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      // Wrap with LayoutBuilder for responsive adjustments
      builder: (context, constraints) {
        // Calculate responsive padding based on screen width
        final double responsivePadding =
            constraints.maxWidth < 600 ? 15.0 : 30.0;

        return Scaffold(
          bottomNavigationBar: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsivePadding, // Apply responsive padding
                vertical: 20.0,
              ),
              child: GNav(
                rippleColor: Colors.grey,
                hoverColor: Colors.grey,
                haptic: true,
                // tabBorderRadius: 15,
                curve: Curves.linear,
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800,
                gap: 8,
                onTabChange: (index) {
                  setState(() => _selectedIndex = index);
                },
                padding: const EdgeInsets.all(16),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Bookings',
                  ),
                  GButton(
                    icon: Icons.message_outlined,
                    text: 'Messages',
                  ),
                  GButton(
                    icon: Icons.account_circle_outlined,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
          ),
          body: IndexedStack(
            // Use IndexedStack for content based on selected index
            index: _selectedIndex,
            children: const [
              // Replace these with your content widgets for each tab
              AgencyHome(),
              AgencyChats(),
              AgencyProfile(),
              Profilepage(), // Remove toggleTheme here
            ],
          ),
         floatingActionButton: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminForm(),));
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]),
            child: Image.asset("assets/agencyImages/upload.png"),
           ),
          ),
        );
      },
    );
  }
}
