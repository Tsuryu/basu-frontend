import 'package:basu/src/providers/configuration_provider.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gesture_icon.dart';

class PlainTitleHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<GestureIcon> buttons;

  const PlainTitleHeader({@required this.title, this.subtitle = "", this.buttons = const []});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final environment = Provider.of<ConfigurationProvider>(context).environment;
    String composedTitle = this.title;
    if (environment != null) {
      composedTitle += " (${environment.name})";
    }

    return Container(
      height: size.height * 0.15,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(composedTitle, style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
              SizedBox(height: size.height * 0.01),
              Text(this.subtitle, style: TextStyle(fontSize: size.height * 0.025)),
            ],
          ),
          Spacer(),
          Container(child: Row(children: this.buttons, mainAxisAlignment: MainAxisAlignment.end)),
        ],
      ),
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50.0),
        ),
      ),
    );
  }
}
