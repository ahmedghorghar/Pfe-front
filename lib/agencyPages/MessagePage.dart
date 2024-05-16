// lib/agencyPages/messagePage.dart

// import 'package:flutter/cupertino.dart';
// import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'chatScreen.dart';

class AgencyChats extends StatefulWidget {
  const AgencyChats({super.key});

  @override
  State<AgencyChats> createState() => _AgencyChatsState();
}

class _AgencyChatsState extends State<AgencyChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#1E9CFF"),
        leading: Image.asset("assets/agencyImages/Menu.png"),
        title: Text(
          "Messages",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Wrap(
          children: List.generate(7, (index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
              },
              child: Card(
                child: ListTile(
                  title: Text("Ashish sharma"),
                  leading: Image.asset("assets/agencyImages/avatar.png"),
                  subtitle: Text("hello , how are you...." ,style: TextStyle(fontSize: 12), ),
                  trailing: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("2" , style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

}
