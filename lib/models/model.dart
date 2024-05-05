// lib/models/model.dart

class Profil {
  String? id;
  String? email;
  String? password;
  String? name;
  String? language;
  String? country;
  String? type;
  String? agencyName;
  String? location;
  String? description;
  String? token;

  Profil(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.language,
      this.country,
      this.type,
      this.agencyName,
      this.location,
      this.description,
      this.token});

  Profil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    language = json['language'];
    country = json['country'];
    type = json['type'];
    agencyName = json['agencyName'];
    location = json['location'];
    description = json['description'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    data['language'] = this.language;
    data['country'] = this.country;
    data['type'] = this.type;
    data['agencyName'] = this.agencyName;
    data['location'] = this.location;
    data['description'] = this.description;
    data['token'] = this.token;
    return data;
  }
}
