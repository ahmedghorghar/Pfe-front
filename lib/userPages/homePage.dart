// lib/userPages/homePage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tataguid/blocs/getPlace/get_place_bloc.dart';
import 'package:tataguid/blocs/getPlace/get_place_event.dart';
import 'package:tataguid/blocs/getPlace/get_place_state.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/userPages/PlaceSearchDelegate.dart';
import 'package:tataguid/userPages/TourPages.dart';

class UserHome extends StatefulWidget {
  final Set<String> favorites;
  final Function(PlaceModel) onFavoriteToggle;

  UserHome({required this.favorites, required this.onFavoriteToggle});

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _showFavoriteAnimation() {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        right: 20,
        child: FadeTransition(
          opacity: _animationController,
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 100,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    _animationController.forward(from: 0.0).then((value) {
      Future.delayed(Duration(seconds: 1), () {
        overlayEntry.remove();
      });
    });
  }

  List<PlaceModel> getPlacesFromState(PlaceState state) {
    if (state is PlaceLoaded) {
      return state.places;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Places',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 28),
            onPressed: () {
              final currentState = BlocProvider.of<PlaceBloc>(context).state;
              final places = getPlacesFromState(currentState);

              showSearch(
                context: context,
                delegate: PlaceSearchDelegate(
                  places: places,
                  favorites: widget.favorites,
                  onFavoriteToggle: widget.onFavoriteToggle,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<PlaceBloc, PlaceState>(
            builder: (context, state) {
              if (state is PlaceInitial) {
                context
                    .read<PlaceBloc>()
                    .add(FetchPlaces('agencyId', 'userToken'));
                return buildShimmerList();
              } else if (state is PlaceLoading) {
                return buildShimmerList();
              } else if (state is PlaceLoaded) {
                final filteredPlaces = state.places
                    .where((place) =>
                        place.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        place.placeName
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        place.price.toString().contains(_searchQuery))
                    .toList();

                if (filteredPlaces.isEmpty) {
                  return Center(
                    child: Text('No results found'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<PlaceBloc>()
                        .add(FetchPlaces('agencyId', 'userToken'));
                    await Future.delayed(Duration(seconds: 1));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];
                      final isFavorite = widget.favorites.contains(place.id);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TourPage(
                                place: place,
                                showBookingButton: true,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                          child: _buildImage(
                                            place.photos.isNotEmpty
                                                ? place.photos.first
                                                : 'https://via.placeholder.com/400x200',
                                            double.infinity, // width
                                            200, // height
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: IconButton(
                                            icon: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? Colors.red
                                                  : Colors.white,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              widget.onFavoriteToggle(place);
                                              if (!isFavorite) {
                                                _showFavoriteAnimation();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            place.title ?? 'No Title',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            place.placeName ?? 'No Place Name',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            children: place.tags
                                                .map((tag) => Chip(
                                                      label: Text(tag),
                                                      backgroundColor: Colors
                                                          .deepPurple.shade100,
                                                    ))
                                                .toList(),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time,
                                                  size: 16,
                                                  color: Colors.grey[700]),
                                              SizedBox(width: 4),
                                              Text(
                                                place.duration ?? 'No Duration',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.monetization_on,
                                                  size: 16,
                                                  color: Colors.grey[700]),
                                              SizedBox(width: 4),
                                              Text(
                                                '\dt${place.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is PlaceError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text('Unexpected state'));
              }
            },
          ),
          Positioned(
            top: 10.0,
            left: 20.0,
            right: 20.0,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search places...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 6, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: 150,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 100,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: List.generate(
                            3,
                            (index) => Chip(
                                  label: Container(
                                    height: 14,
                                    width: 50,
                                    color: Colors.grey[300],
                                  ),
                                )),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey[300]),
                          SizedBox(width: 4),
                          Container(
                            height: 14,
                            width: 80,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.monetization_on,
                              size: 16, color: Colors.grey[300]),
                          SizedBox(width: 4),
                          Container(
                            height: 14,
                            width: 80,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String url, double width, double height) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 40),
              Text("Network Error", style: TextStyle(color: Colors.red)),
            ],
          );
        },
      );
    } else {
      return Image.file(
        File(url),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 40),
              Text("File Error", style: TextStyle(color: Colors.red)),
            ],
          );
        },
      );
    }
  }
}
