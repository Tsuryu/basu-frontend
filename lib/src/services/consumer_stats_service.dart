import 'dart:convert';

import 'package:basu/src/models/consumer_stats_model.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ConsumerStatsService {
  Future<List<ConsumerStats>> findAll(BuildContext context) async {
    final baseUrl = Provider.of<ConfigurationProvider>(context, listen: false).environment.baseUrl;
    final response = await http.get('$baseUrl/queueing/stats');
    final decodedData = json.decode(response.body);

    final List<ConsumerStats> consumerStatsList = consumerStatsFromJson(json.encode(decodedData['list']));

    return consumerStatsList;
  }
}
