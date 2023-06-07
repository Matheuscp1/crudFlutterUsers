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
        birthDate = DateTime.parse(json['birthDate']),
        picture = json['picture'],
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        state = json['state'],
        city = json['city'],
        brief = json['brief'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'birthDate': birthDate!.toIso8601String(),
      'picture': picture!,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'state': state,
      'city': city,
      'brief': brief!
    };
  }
}
