import 'package:basu/src/models/environment_model.dart';
import 'package:flutter/material.dart';

class ConfigurationProvider with ChangeNotifier {
  Environment _environment;

  Environment get environment => this._environment;

  set environment(Environment value) {
    this._environment = value;
    notifyListeners();
  }
}
