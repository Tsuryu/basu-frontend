import 'package:basu/src/models/consumer_model.dart';
import 'package:flutter/material.dart';

class ConsumerProvider with ChangeNotifier {
  Consumer _consumer;

  Consumer get consumer => this._consumer;

  set consumer(Consumer value) {
    this._consumer = value;
    notifyListeners();
  }
}
