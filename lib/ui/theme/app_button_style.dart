import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static final  ButtonStyle linkButton = ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.blue),
        textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
  );
}
