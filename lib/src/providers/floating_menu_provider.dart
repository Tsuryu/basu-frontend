import 'package:flutter/material.dart';

class FloatingMenuProvider with ChangeNotifier {
  bool _show = true;

  bool get show => this._show;

  set show(bool show) {
    this._show = show;
    notifyListeners();
  }
}
