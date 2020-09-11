// To parse this JSON data, do
//
//     final consumer = consumerFromJson(jsonString);

import 'dart:convert';

List<Consumer> consumerFromJson(String str) => List<Consumer>.from(json.decode(str).map((x) => Consumer.fromJson(x)));

String consumerToJson(List<Consumer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Consumer {
  Consumer({
    this.type,
    this.durable,
    this.exclusive,
    this.autoDelete,
    this.state,
    this.vhost,
    this.id,
    this.pushConfiguration,
    this.topicId,
  });

  String type;
  bool durable;
  bool exclusive;
  bool autoDelete;
  String state;
  String vhost;
  String id;
  PushConfiguration pushConfiguration;
  String topicId;

  factory Consumer.fromJson(Map<String, dynamic> json) => Consumer(
        type: json["type"],
        durable: json["durable"],
        exclusive: json["exclusive"],
        autoDelete: json["autoDelete"],
        state: json["state"],
        vhost: json["vhost"],
        id: json["id"],
        pushConfiguration: PushConfiguration.fromJson(json["pushConfiguration"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "durable": durable,
        "exclusive": exclusive,
        "autoDelete": autoDelete,
        "state": state,
        "vhost": vhost,
        "id": id,
        "pushConfiguration": pushConfiguration?.toJson(),
      };

  static List<Consumer> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return null;

    List<Consumer> items = List();
    for (var item in jsonList) {
      final consumer = Consumer.fromJson(item);
      items.add(consumer);
    }
    return items;
  }
}

class PushConfiguration {
  PushConfiguration({
    this.urls,
    this.attempsLimit,
  });

  List<String> urls;
  int attempsLimit;

  factory PushConfiguration.fromJson(Map<String, dynamic> json) => PushConfiguration(
        urls: json["urls"] == null ? null : List<String>.from(json["urls"].map((x) => x)),
        attempsLimit: json["attempsLimit"] == null ? null : json["attempsLimit"],
      );

  Map<String, dynamic> toJson() => {
        "urls": urls == null ? null : List<dynamic>.from(urls.map((x) => x)),
        "attempsLimit": attempsLimit == null ? null : attempsLimit,
      };
}
