import 'package:basu/src/models/topic_model.dart';
import 'package:flutter/material.dart';

class TopicProvider with ChangeNotifier {
  Topic _topic;

  Topic get topic => this._topic;

  set topic(Topic value) {
    this._topic = value;
    notifyListeners();
  }
}
