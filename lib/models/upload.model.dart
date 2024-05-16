// lib/models/upload.dart



class UploadModel {
  String? placeName;
  List<String>? photos;
  String? visitDate;
  String? price;
  String? description;
  String? duration;
  String? tags;
  String? accessibility;

  UploadModel(
      {this.placeName,
      this.photos,
      this.visitDate,
      this.price,
      this.description,
      this.duration,
      this.tags,
      this.accessibility});

  UploadModel.fromJson(Map<String, dynamic> json) {
    placeName = json['placeName'];
    photos = List<String>.from(json['photos']);
    visitDate = json['visitDate'];
    price = json['price'];
    description = json['description'];
    duration = json['duration'];
    tags = json['tags'];
    accessibility = json['accessibility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['placeName'] = this.placeName;
    data['photos'] = this.photos;
    data['visitDate'] = this.visitDate;
    data['price'] = this.price;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['tags'] = this.tags;
    data['accessibility'] = this.accessibility;
    return data;
  }
}
