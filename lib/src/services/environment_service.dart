import 'package:basu/src/models/environment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EnvironmentService {
  Future<String> create(Environment environment) async {
    try {
      List<Environment> environments;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString = prefs.getString('environments');
      if (jsonString != null) {
        environments = Environment.fromJsonList(json.decode(prefs.getString('environments')));
      } else {
        environments = List<Environment>();
      }

      environments.add(environment);
      await prefs.setString("environments", json.encode(environments));

      return null;
    } catch (e) {
      return "Failed to add environment";
    }
  }

  Future<List<Environment>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString("environments");

    return jsonString != null ? Environment.fromJsonList(json.decode(jsonString)) : List<Environment>();
  }

  Future<String> delete(String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Environment> environments = Environment.fromJsonList(json.decode(prefs.getString('environments')));

      await prefs.setString(
          "environments", json.encode(environments.where((environment) => environment.name != name).toList()));

      return null;
    } catch (e) {
      return "Failed to delete environment";
    }
  }

  Future<String> setDefault(Environment env) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (env == null) {
        await prefs.remove("environment");
      } else {
        await prefs.setString("environment", json.encode(env));
      }

      return null;
    } catch (e) {
      return "Failed to set environment";
    }
  }

  Future<Environment> getDefault() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final jsonString = prefs.getString("environment");
      if (jsonString == null) {
        return null;
      }

      return Environment.fromJson(json.decode(jsonString));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
