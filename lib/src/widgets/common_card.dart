import 'package:basu/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final Function callback;

  const CommonCard({@required this.child, this.callback});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.005),
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            color: appTheme.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: callback,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              width: double.infinity,
              height: size.height * 0.1,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
