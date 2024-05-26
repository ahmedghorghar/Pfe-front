// lib/userPages/favorites_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tataguid/models/place_model.dart';

class FavoritesPage extends StatelessWidget {
  final List<PlaceModel> favoritePlaces;

  FavoritesPage({required this.favoritePlaces});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.deepPurple,
      ),
      body: favoritePlaces.isEmpty
          ? Center(child: Text('No favorites yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favoritePlaces.length,
              itemBuilder: (context, index) {
                final place = favoritePlaces[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: _buildImage(
                          place.photos.isNotEmpty
                              ? place.photos.first
                              : 'https://via.placeholder.com/400x200',
                          double.infinity, // width
                          150, // height
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.title ?? 'No Title',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              place.placeName ?? 'No Place Name',
                              style: TextStyle(
                                fontSize: 16,
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
                                        backgroundColor:
                                            Colors.deepPurple.shade100,
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.grey[700]),
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
                                    size: 16, color: Colors.grey[700]),
                                SizedBox(width: 4),
                                Text(
                                  '\$${place.price.toStringAsFixed(2)}',
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
                );
              },
            ),
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
          return Icon(Icons.error);
        },
      );
    } else {
      return Image.file(
        File(url),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    }
  }
}
