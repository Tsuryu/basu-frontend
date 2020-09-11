// To parse this JSON data, do
//
//     final topic = topicFromJson(jsonString);

import 'dart:convert';

List<Topic> topicFromJson(String str) => List<Topic>.from(json.decode(str).map((x) => Topic.fromJson(x)));

String topicToJson(List<Topic> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Topic {
  Topic({
    this.type,
    this.durability,
    this.autoDelete,
    this.internal,
    this.lastUpdate,
    this.vhost,
    this.bindings,
    this.id,
    this.pushConfiguration,
    this.defaultConsumer,
  });

  String type;
  bool durability;
  bool autoDelete;
  bool internal;
  String lastUpdate;
  String vhost;
  List<Binding> bindings;
  String id;
  PushConfiguration pushConfiguration;
  bool defaultConsumer = false;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        type: json["type"],
        durability: json["durability"],
        autoDelete: json["autoDelete"],
        internal: json["internal"],
        lastUpdate: json["lastUpdate"],
        vhost: json["vhost"],
        bindings:
            json["bindings"] == null ? null : List<Binding>.from(json["bindings"].map((x) => Binding.fromJson(x))),
        id: json["id"],
        pushConfiguration: PushConfiguration.fromJson(json["pushConfiguration"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "durability": durability,
        "autoDelete": autoDelete,
        "internal": internal,
        "lastUpdate": lastUpdateValues.reverse[lastUpdate],
        "vhost": vhostValues.reverse[vhost],
        "bindings": bindings == null ? null : List<dynamic>.from(bindings.map((x) => x.toJson())),
        "id": id,
        "pushConfiguration": pushConfiguration.toJson(),
      };

  static List<Topic> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return null;

    List<Topic> items = List();
    for (var item in jsonList) {
      final topic = Topic.fromJson(item);
      items.add(topic);
    }
    return items;
  }
}

class Binding {
  Binding({
    this.destination,
  });

  String destination;

  factory Binding.fromJson(Map<String, dynamic> json) => Binding(
        destination: json["destination"],
      );

  Map<String, dynamic> toJson() => {
        "destination": destination,
      };
}

enum LastUpdate { RMQ_INTERNAL, GUEST }

final lastUpdateValues = EnumValues({"guest": LastUpdate.GUEST, "rmq-internal": LastUpdate.RMQ_INTERNAL});

class PushConfiguration {
  PushConfiguration({
    this.attempsLimit,
    this.urls,
  });

  int attempsLimit;
  List<String> urls;

  factory PushConfiguration.fromJson(Map<String, dynamic> json) => PushConfiguration(
        attempsLimit: json["attempsLimit"] == null ? null : json["attempsLimit"],
        urls: json["urls"] == null ? null : List<String>.from(json["urls"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "attempsLimit": attempsLimit == null ? null : attempsLimit,
        "urls": urls == null ? null : List<dynamic>.from(urls.map((x) => x)),
      };
}

enum Vhost { EMPTY }

final vhostValues = EnumValues({"/": Vhost.EMPTY});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

// To parse this JSON data, do
//
//     final topic = topicFromJson(jsonString);

// import 'dart:convert';

// List<Topic> topicFromJson(String str) => List<Topic>.from(json.decode(str).map((x) => Topic.fromJson(x)));

// String topicToJson(List<Topic> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Topic {
//   Topic({
//     this.type,
//     this.durability,
//     this.autoDelete,
//     this.internal,
//     this.lastUpdate,
//     this.vhost,
//     this.id,
//     this.pushConfiguration,
//   });

//   String type;
//   bool durability;
//   bool autoDelete;
//   bool internal;
//   String lastUpdate;
//   String vhost;
//   String id;
//   PushConfiguration pushConfiguration;

//   factory Topic.fromJson(Map<String, dynamic> json) => Topic(
//         type: json["type"],
//         durability: json["durability"],
//         autoDelete: json["autoDelete"],
//         internal: json["internal"],
//         lastUpdate: json["lastUpdate"],
//         vhost: json["vhost"],
//         id: json["id"],
//         pushConfiguration: PushConfiguration.fromJson(json["pushConfiguration"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "type": type,
//         "durability": durability,
//         "autoDelete": autoDelete,
//         "internal": internal,
//         "lastUpdate": lastUpdate,
//         "vhost": vhost,
//         "id": id,
//         "pushConfiguration": pushConfiguration?.toJson(),
//       };

//   static List<Topic> fromJsonList(List<dynamic> jsonList) {
//     if (jsonList == null) return null;

//     List<Topic> items = List();
//     for (var item in jsonList) {
//       final topic = Topic.fromJson(item);
//       items.add(topic);
//     }
//     return items;
//   }
// }

// class PushConfiguration {
//   PushConfiguration({
//     this.attempsLimit,
//     this.urls,
//   });

//   int attempsLimit;
//   List<String> urls;

//   factory PushConfiguration.fromJson(Map<String, dynamic> json) => PushConfiguration(
//         attempsLimit: json["attempsLimit"] == null ? null : json["attempsLimit"],
//         urls: json["urls"] == null ? null : List<String>.from(json["urls"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "attempsLimit": attempsLimit == null ? null : attempsLimit,
//         "urls": urls == null ? null : List<dynamic>.from(urls.map((x) => x)),
//       };
// }
