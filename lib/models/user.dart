import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String name;
    String email;
    bool isOnline;
    String uid;

    User({
        required this.name,
        required this.email,
        required this.isOnline,
        required this.uid,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        isOnline: json["isOnline"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "isOnline": isOnline,
        "uid": uid,
    };
}
