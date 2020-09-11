import 'package:basu/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicCard extends StatelessWidget {
  final Widget child;
  final String title;
  final Color color;
  final Widget footer;

  const BasicCard({@required this.child, this.title, this.color, this.footer});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      margin: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03, top: size.height * 0.02),
      padding: this.footer != null
          ? EdgeInsets.only(top: size.height * 0.02)
          : EdgeInsets.symmetric(vertical: size.height * 0.02),
      decoration: BoxDecoration(
        color: this.color != null ? this.color : appTheme.accentColor.withOpacity(0.1),
        // borderRadius: this.footer != null
        //     ? BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))
        //     : BorderRadius.all(Radius.circular(15.0)),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Column(
        children: [
          if (this.title != null)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: size.height * 0.01),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Text(this.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.04)),
                margin: EdgeInsets.only(bottom: size.height * 0.01),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: this.child,
          ),
          this.footer != null
              ? Container(
                  width: double.infinity,
                  child: this.footer,
                )
              : Container()
        ],
      ),
    );
  }
}
