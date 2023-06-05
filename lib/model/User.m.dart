class User {
  User({required this.title});

  User.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']);

  String title;
  DateTime dateTime = DateTime.now();

  Map<String, dynamic> toJson() {
    return {'title': title, 'datetime': dateTime.toIso8601String()};
  }
}