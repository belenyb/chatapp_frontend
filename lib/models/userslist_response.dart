import 'dart:convert';
import 'user.dart';

UsersListResponse usersListFromJson(String str) => UsersListResponse.fromJson(json.decode(str));

String usersListToJson(UsersListResponse data) => json.encode(data.toJson());

class UsersListResponse {
    bool ok;
    List<User> users;

    UsersListResponse({
        required this.ok,
        required this.users,
    });

    factory UsersListResponse.fromJson(Map<String, dynamic> json) => UsersListResponse(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}
