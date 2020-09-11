import 'dart:collection';
import 'dart:convert';

class Message {
  Message({
    this.headers,
    this.data,
  });

  Message.build() {
    this.data = Map<String, dynamic>();
    this.headers = Map<String, dynamic>();
  }

  Map<String, dynamic> headers = Map<String, dynamic>();
  Map<String, dynamic> data = Map<String, dynamic>();

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        headers: json["headers"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers,
        "data": data,
      };
}
