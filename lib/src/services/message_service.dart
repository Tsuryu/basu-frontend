import 'dart:convert';

import 'package:basu/src/models/message_model.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;

class MessageService {
  Future<String> create(BuildContext context, String id, Message message) async {
    try {
      final baseUrl = provider.Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
      final header = {'Content-Type': 'application/json', "Accept": "application/json"};
      final encoding = Encoding.getByName('utf-8');

      final response = await http.post(
        '$baseUrl/queueing/topics/$id/messages',
        body: json.encode(message.toJson()),
        headers: header,
        encoding: encoding,
      );

      if (response.statusCode == 201) {
        return null;
      }

      return json.decode(response.body)["result"];
    } catch (e) {
      print(e);
      return "Failed to send message";
    }
  }
}
