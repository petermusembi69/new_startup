import 'dart:convert';

import 'package:hive/hive.dart';

class UserModel {
  UserModel({
    required this.name,
    required this.count,
  });

  String name;
  CountModel count;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        count: CountModel.fromJson(json["count"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count.toJson(),
      };
}

class CountModel {
  CountModel({
    required this.count,
  });

  int count;

  factory CountModel.fromJson(Map<String, dynamic> json) => CountModel(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel.fromJson(
      Map<String, dynamic>.of(
          json.decode(reader.read() as String) as Map<String, dynamic>),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.write(json.encode(obj.toJson()));
  }
}
