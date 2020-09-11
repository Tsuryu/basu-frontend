// To parse this JSON data, do
//
//     final environment = environmentFromJson(jsonString);

import 'dart:convert';

List<Environment> environmentFromJson(String str) =>
    List<Environment>.from(json.decode(str).map((x) => Environment.fromJson(x)));

String environmentToJson(List<Environment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Environment {
  Environment({
    this.name,
    this.baseUrl,
  });

  String name;
  String baseUrl;

  factory Environment.fromJson(Map<String, dynamic> json) => Environment(
        name: json["name"],
        baseUrl: json["base_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "base_url": baseUrl,
      };

  static List<Environment> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return null;

    List<Environment> items = List();
    for (var item in jsonList) {
      final environment = Environment.fromJson(item);
      items.add(environment);
    }
    return items;
  }
}
