import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _darkTheme = false;
  bool _customTheme = false;

  ThemeData _currentTheme;

  bool get darkTheme => this._darkTheme;
  bool get customTheme => this._customTheme;
  ThemeData get currentTheme => this._currentTheme;

  ThemeChanger(int theme) {
    switch (theme) {
      case 1: // light
        _darkTheme = false;
        _customTheme = false;
        _currentTheme = ThemeData.light().copyWith(
          accentColor: Colors.pink,
        );
        break;
      case 2: // light
        _darkTheme = true;
        _customTheme = false;
        _currentTheme = ThemeData.dark().copyWith(
          iconTheme: IconThemeData(
            color: Colors.blueGrey[300],
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.blueGrey[300],
            ),
            bodyText2: TextStyle(
              color: Colors.blueGrey[300],
            ),
            button: TextStyle(
              color: Colors.blueGrey[300],
            ),
            headline1: TextStyle(
              color: Colors.blueGrey[300],
            ),
            headline2: TextStyle(
              color: Colors.blueGrey[300],
            ),
            headline3: TextStyle(
              color: Colors.blueGrey[300],
            ),
            headline4: TextStyle(
              color: Colors.blueGrey[300],
            ),
            headline5: TextStyle(
              color: Colors.blueGrey[300],
            ),
            headline6: TextStyle(
              color: Colors.blueGrey[300],
            ),
            // tile subtitle
            caption: TextStyle(
              color: Colors.blueGrey[300],
            ),
            overline: TextStyle(
              color: Colors.blueGrey[300],
            ),
            // tile title
            subtitle1: TextStyle(
              color: Colors.blueGrey[300],
            ),
          ),
          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(
              color: Colors.blueGrey[300],
            ),
            contentTextStyle: TextStyle(
              color: Colors.blueGrey[300],
            ),
          ),
          accentColor: Colors.blueGrey[300],
          backgroundColor: Colors.blueGrey[800],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueGrey[700],
          ),
        );
        break;
      case 3: // light
        _darkTheme = false;
        _customTheme = true;
        break;
      default:
        _darkTheme = false;
        _customTheme = false;
        _currentTheme = ThemeData.light();
    }
  }

  set darkTheme(bool value) {
    this._customTheme = false;
    this._darkTheme = value;
    if (value) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light().copyWith(
        accentColor: Colors.pink,
      );
    }
    notifyListeners();
  }

  set customTheme(bool value) {
    this._customTheme = value;
    this._darkTheme = false;
    if (value) {
      _currentTheme = ThemeData.dark().copyWith(
        accentColor: Color(0xff48A0EB),
        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: Color(0xff16202B),
        textTheme: TextTheme(
            // bodyText1: TextStyle(color: Colors.white),
            ),
        // appTheme.textTheme.bodyText1.color: Colors.white,
      );
    } else {
      _currentTheme = ThemeData.light();
    }
    notifyListeners();
  }
}
