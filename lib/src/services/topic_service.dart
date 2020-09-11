import 'dart:convert';

import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/topic_model.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:basu/src/services/consumer_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TopicService {
  Future<Topic> find(BuildContext context, String id) async {
    final baseUrl = Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
    final response = await http.get('$baseUrl/queueing/topics/$id');
    final decodedData = json.decode(response.body);

    return Topic.fromJson(decodedData);
  }

  Future<List<Topic>> findAll(BuildContext context) async {
    final baseUrl = Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
    final response = await http.get('$baseUrl/queueing/topics');
    final decodedData = json.decode(response.body);

    final List<Topic> topics = Topic.fromJsonList(decodedData['list']);

    return topics.where((topic) => topic.lastUpdate == 'basu' || topic.lastUpdate == 'guest').toList();
  }

  Future<String> create(BuildContext context, Topic topic, {String baseUrl}) async {
    try {
      if (baseUrl == null) {
        baseUrl = Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
      }
      final Map<String, dynamic> data = topic.toJson();
      removeNullAndEmptyParams(data);
      var header = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "withConsumer": topic.defaultConsumer.toString(),
      };
      final encoding = Encoding.getByName('utf-8');

      final response = await http.post(
        '$baseUrl/queueing/topics',
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
      return "Failed to create the topic";
    }
  }

  Future<bool> delete(BuildContext context, String id) async {
    final baseUrl = Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
    final response = await http.delete('$baseUrl/queueing/topics/$id');

    if (response.statusCode != 200) {
      final decodedData = json.decode(response.body);
      print(decodedData);
      return false;
    }

    return true;
  }

  Future<String> copy(BuildContext context, Topic topic, {String baseUrl}) async {
    String result = await this.create(context, topic, baseUrl: baseUrl);
    if (result != null) {
      return result;
    }

    if (topic.bindings == null) {
      return null;
    }

    for (Binding binding in topic.bindings) {
      final consumer = await ConsumerService().find(context, binding.destination);
      consumer.topicId = topic.id;
      result = await ConsumerService().create(context, consumer, baseUrl: baseUrl);
      if (result != null) {
        break;
      }
    }

    return result;
  }
}
