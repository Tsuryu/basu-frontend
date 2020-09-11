import 'package:flutter/material.dart';

class GestureIcon extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final Color color;

  const GestureIcon({@required this.iconData, this.onTap, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.height * 0.08,
      child: MaterialButton(
        padding: EdgeInsets.all(0.0),
        onPressed: this.onTap == null ? () {} : this.onTap,
        child: Icon(iconData, size: size.height * 0.06, color: this.color),
        shape: CircleBorder(),
      ),
    );
  }
}
