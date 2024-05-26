// lib/agencyPages/homePage.dart

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_event.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_state.dart';
import 'package:tataguid/models/booking.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:tataguid/storage/profil_storage.dart';

class AgencyHome extends StatefulWidget {
  const AgencyHome({super.key});

  @override
  State<AgencyHome> createState() => _AgencyHomeState();
}

class _AgencyHomeState extends State<AgencyHome> {
  final userName = ProfileUserStorage.getUserName();
  final userEmail = ProfileUserStorage.getUserEmail();

  @override
  void initState() {
    super.initState();
    _fetchAgencyBookings();
  }

  void _fetchAgencyBookings() async {
    String? agencyId = await TokenStorage.getAgencyId();
    if (agencyId != null) {
      BlocProvider.of<BookingBloc>(context).add(FetchAgencyBookings(agencyId));
    }
  }

  Future<String?> _getProfileImage(String? email) async {
    if (email == null) return null;
    return await ProfileUserStorage.getProfileImage(email);
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          } else if (state is BookingsLoaded) {
            return Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: state.bookings.length,
                      itemBuilder: (context, index) {
                        final booking = state.bookings[index];
                        return FutureBuilder<String?>(
                          future: _getProfileImage(booking.userEmail),
                          builder: (context, snapshot) {
                            String? profileImage = snapshot.data;
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: profileImage != null
                                          ? NetworkImage(profileImage)
                                          : AssetImage(
                                                  "assets/Profileimage.png")
                                              as ImageProvider,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking.userName ??
                                                booking.userEmail ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            booking.placeName ?? "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            booking.bookingDate?.toString() ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    color: Colors.grey[200],
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          booking.title ?? "",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          booking.price != null
                                              ? '\$${booking.price!.toStringAsFixed(2)}'
                                              : 'Price not available',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          booking.price != null
                                              ? '\$${booking.price!.toStringAsFixed(2)}'
                                              : 'Price not available',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No bookings available'));
          }
        },
      ),
    );
  }
}
