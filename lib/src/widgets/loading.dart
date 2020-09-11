import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.height * 0.2,
        height: size.height * 0.2,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
