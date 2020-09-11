// To parse this JSON data, do
//
//     final consumerStats = consumerStatsFromJson(jsonString);

import 'dart:convert';

List<ConsumerStats> consumerStatsFromJson(String str) =>
    List<ConsumerStats>.from(json.decode(str).map((x) => ConsumerStats.fromJson(x)));

String consumerStatsToJson(List<ConsumerStats> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConsumerStats {
  ConsumerStats({
    this.id,
    this.total,
    this.ready,
    this.acknowledged,
    this.unacknowledged,
    this.requestAmount,
    this.published,
  });

  String id;
  int total;
  int ready;
  int acknowledged;
  int unacknowledged;
  int requestAmount;
  int published;

  factory ConsumerStats.fromJson(Map<String, dynamic> json) => ConsumerStats(
        id: json["id"],
        total: json["total"],
        ready: json["ready"],
        acknowledged: json["acknowledged"],
        unacknowledged: json["unacknowledged"],
        requestAmount: json["requestAmount"],
        published: json["published"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total": total,
        "ready": ready,
        "acknowledged": acknowledged,
        "unacknowledged": unacknowledged,
        "requestAmount": requestAmount,
        "published": published,
      };
}
