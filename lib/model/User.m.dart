class User {
  User(
      {this.id,
      this.brief,
      this.city,
      this.birthDate,
      this.email,
      this.firstName,
      this.lastName,
      this.picture,
      this.state});

  String? id;
  DateTime? birthDate = DateTime.now();
  String? picture;
  String? email;
  String? firstName;
  String? lastName;
  String? state;
  String? city;
  String? brief;
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        birthDate = DateTime.parse(json['birthDate'] ?? '2028-11-11'),
        picture = json['picture'] ?? 'Vazio',
        email = json['email'] ?? 'Vazio',
        firstName = json['firstName'] ?? 'Vazio',
        lastName = json['lastName'] ?? 'Vazio',
        state = json['state'] ?? 'CE',
        city = json['city'] ?? '',
        brief = json['brief'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'birthDate': birthDate?.toIso8601String(),
      'picture': picture,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'state': state,
      'city': city,
      'brief': brief
    };
  }
}
