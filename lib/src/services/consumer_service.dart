import 'dart:convert';

import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/consumer_model.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;

class ConsumerService {
  Future<List<Consumer>> findAll(BuildContext context) async {
    final baseUrl = provider.Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
    final response = await http.get('$baseUrl/queueing/consumers');
    final decodedData = json.decode(response.body);

    final List<Consumer> consumers = Consumer.fromJsonList(decodedData['list']);

    return consumers;
    // return consumers.where((consumer) => !consumer.id.endsWith("_default")).toList();
  }

  Future<bool> delete(BuildContext context, String id) async {
    final baseUrl = provider.Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
    final response = await http.delete('$baseUrl/queueing/topics/topics/consumers/$id');

    if (response.statusCode != 200) {
      final decodedData = json.decode(response.body);
      print(decodedData);
      return false;
    }

    return true;
  }

  Future<String> create(BuildContext context, Consumer consumer, {String baseUrl}) async {
    try {
      if (baseUrl == null) {
        baseUrl = provider.Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
      }
      final Map<String, dynamic> data = consumer.toJson();
      removeNullAndEmptyParams(data);
      final header = {'Content-Type': 'application/json', "Accept": "application/json"};
      final encoding = Encoding.getByName('utf-8');

      final response = await http.post(
        '$baseUrl/queueing/topics/${consumer.topicId}/consumers',
        body: json.encode(data),
        headers: header,
        encoding: encoding,
      );

      if (response.statusCode == 201) {
        return null;
      }

      return json.decode(response.body)["result"];
    } catch (e) {
      print(e);
      return "Failed to create the consumer";
    }
  }

  Future<Consumer> find(BuildContext context, String id) async {
    final baseUrl = provider.Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
    final response = await http.get('$baseUrl/queueing/consumers/$id');
    final decodedData = json.decode(response.body);

    return Consumer.fromJson(decodedData);
  }
}
