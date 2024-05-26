// lib/userPages/TourPages.dart

import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_event.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_state.dart'; // Import the booking state
import 'package:tataguid/models/booking.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:tataguid/utils/deep_link_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class TourPage extends StatefulWidget {
  final PlaceModel place;
  final bool showBookingButton;

  const TourPage({Key? key, required this.place, this.showBookingButton = true})
      : super(key: key);

  @override
  _TourPageState createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  bool isLiked = false;
  bool isLoading = false;
  late ConfettiController _confettiController;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _fetchAgencyPhoneNumber();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _fetchAgencyPhoneNumber() async {
    // Fetch the phone number from the PlaceModel
    setState(() {
      phoneNumber = widget.place.phoneNumber;
    });
  }

  void _callAgency() async {
    if (phoneNumber != null) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber!);
      if (await canLaunch(phoneUri.toString())) {
        await launch(phoneUri.toString());
      } else {
        _showSnackBar('Could not launch phone dialer');
      }
    } else {
      _showSnackBar('Phone number not available');
    }
  }

  void _bookNow() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Ensure the visitDate string format is consistent and correct
      final dateRangeString = widget.place.visitDate
          .replaceAll('from the ', '')
          .replaceAll(' to the ', ' to ');

      final dateRange = dateRangeString.split(' to ');

      // Check if the dateRange list has exactly two elements
      if (dateRange.length != 2) {
        throw FormatException('Invalid date range format');
      }

      // Assuming date format is "dd/MM/yyyy"
      final dateFormat = DateFormat('dd/MM/yyyy');
      DateTime visitStartDate = dateFormat.parse(dateRange[0]);
      DateTime visitEndDate = dateFormat.parse(dateRange[1]);

      String? agencyId = await TokenStorage.getAgencyId();
      String? userId = await TokenStorage.getToken();

      if (agencyId != null && userId != null) {
        final booking = BookingModel(
          id: widget.place.id,
          userId: userId,
          userName: "John Doe",
          userEmail: "john@example.com",
          placeName: widget.place.placeName,
          title: widget.place.title,
          price: widget.place.price,
          placeId: widget.place.id,
          agencyId: agencyId,
          bookingDate: visitStartDate, // or visitEndDate as per your logic
          notes: "Notes for the booking",
        );

        BlocProvider.of<BookingBloc>(context).add(AddBooking(booking));
      } else {
        _showSnackBar("Unable to get user or agency information");
      }
    } catch (e) {
      print("Error occurred during booking process: $e");
      _showSnackBar("An error occurred while booking: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked) {
      _confettiController.play();
    }
  }

  void _sharePlace() async {
    final deepLink = generateDeepLink(widget.place);
    final RenderBox box = context.findRenderObject() as RenderBox;
    final String text = """
🌟 Check out this amazing place: ${widget.place.title}\n\n$deepLink 🌟

📍 **Location**: ${widget.place.placeName}
🗓️ **Visit Date**: ${widget.place.visitDate}
⏳ **Duration**: ${widget.place.duration}
🏨 **Hotel**: ${widget.place.hotelName}
🔑 **Check-in/out**: ${widget.place.checkInOut}
♿ **Accessibility**: ${widget.place.accessibility}

💰 **Price**: \$${widget.place.price}

📝 **Description**: 
${widget.place.description ?? 'No Description Available'}

🖼️ **Images**: 
${widget.place.photos.join(', ')}

Don't miss out on this wonderful opportunity!
    """;

    await Share.share(
      text,
      subject: widget.place.title,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: HexColor("#F5F5F5"),
      body: SafeArea(
        child: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingAdded) {
              _showSnackBar("Booking created successfully");
            } else if (state is BookingError) {
              _showSnackBar(state.message ?? "An error occurred while booking");
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildImage(
                      widget.place.photos.isNotEmpty
                          ? widget.place.photos.first
                          : 'https://via.placeholder.com/400x200',
                      double.infinity,
                      250,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.place.title,
                            style: GoogleFonts.lato(
                              fontSize: sw * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: sh * 0.02),
                          buildInfoRow(Icons.place, widget.place.placeName, sh),
                          buildInfoRow(
                              Icons.map, widget.place.startEndPoint, sh),
                          buildInfoRow(
                              Icons.date_range, widget.place.visitDate, sh),
                          buildInfoRow(Icons.attach_money,
                              '\$${widget.place.price}', sh),
                          buildInfoRow(Icons.timer, widget.place.duration, sh),
                          buildInfoRow(Icons.hotel, widget.place.hotelName, sh),
                          buildInfoRow(
                              Icons.access_time, widget.place.checkInOut, sh),
                          buildInfoRow(
                              Icons.accessible, widget.place.accessibility, sh),
                          SizedBox(height: sh * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildActionButton(
                                  Icons.call_split, "Directions", sw, sh, () {
                                // Add your directions functionality here
                              }),
                              buildActionButton(
                                  Icons.call, "Call", sw, sh, _callAgency),
                            ],
                          ),
                          SizedBox(height: sh * 0.04),
                          Text(
                            "Images",
                            style: GoogleFonts.lato(
                              fontSize: sw * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: sh * 0.01),
                          CarouselSlider(
                            items: widget.place.photos.map((photo) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      _buildImage(photo, sw * 0.8, sh * 0.25),
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              viewportFraction: 0.8,
                              height: sh * 0.25,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              enlargeCenterPage: true,
                            ),
                          ),
                          SizedBox(height: sh * 0.03),
                          Text(
                            "Description",
                            style: GoogleFonts.lato(
                              fontSize: sw * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: sh * 0.01),
                          Text(
                            widget.place.description ??
                                'No Description Available',
                            style: GoogleFonts.lato(
                              fontSize: sw * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.1),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                  color: Colors.white,
                  iconSize: sw * 0.07,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(Icons.favorite,
                          color: isLiked ? Colors.pink : Colors.white),
                      iconSize: sw * 0.07,
                    ),
                    IconButton(
                      onPressed: _sharePlace,
                      icon: Icon(Icons.share, color: Colors.white),
                      iconSize: sw * 0.07,
                    ),
                  ],
                ),
              ),
              if (widget.showBookingButton)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _bookNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Book Now",
                            style: GoogleFonts.lato(
                              fontSize: sw * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text, double sh) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sh * 0.005),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(IconData icon, String label, double sw, double sh,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        elevation: 5,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(sw * 0.4, sh * 0.06),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _buildImage(String url, double width, double height) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } else {
      return Image.file(
        File(url),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
