import 'package:basu/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicText extends StatelessWidget {
  final List<InlineSpan> children;

  const DynamicText({@required this.children});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return RichText(
      text: TextSpan(
        style: appTheme.textTheme.bodyText1,
        children: this.children,
      ),
    );
  }
}
