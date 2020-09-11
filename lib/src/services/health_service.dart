import 'package:basu/src/providers/configuration_provider.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HealthService {
  Future<bool> healthcheck(BuildContext context) async {
    try {
      final baseUrl = Provider.of<ConfigurationProvider>(context).environment.baseUrl;
      final response = await http.get('$baseUrl/queueing/health');

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
