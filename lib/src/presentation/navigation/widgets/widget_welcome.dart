import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class WidgetWelcome extends StatelessWidget {
  const WidgetWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome to boilerplate!', 
      ),
    );
  }
}
