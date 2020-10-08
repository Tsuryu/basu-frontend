import 'package:basu/src/providers/configuration_provider.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HealthService {
  Future<bool> healthcheck(BuildContext context) async {
    final baseUrl = Provider.of<ConfigurationProvider>(context).environment.baseUrl;
    final url = '$baseUrl/queueing/health';
    try {
      final response = await http.get(url);

      return response.statusCode == 200;
    } catch (e) {
      throw new Exception([e, Exception(url)]);
    }
  }
}
