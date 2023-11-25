import 'package:flutter/material.dart';

class Styles {
  static const textStyle = TextStyle();
  static const queueCurrentIndexStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const TextStyle subtitleStyle = TextStyle(fontSize: 12);
  static const TextStyle albumStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle miniplayerTitle =
      TextStyle(fontWeight: FontWeight.bold);
  static const borderRadius = BorderRadius.all(Radius.circular(5));

  static TextStyle smallSubtitleStyle(ThemeData theme) {
    return TextStyle(color: theme.disabledColor, fontWeight: FontWeight.w200);
  }

  static TextStyle results(ThemeData theme) {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  static TextStyle categoryLabelStyle(ThemeData theme) {
    return const TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  }

  static TextStyle queuePrevIndexStyle(ThemeData theme) {
    return TextStyle(color: theme.disabledColor);
  }
}
