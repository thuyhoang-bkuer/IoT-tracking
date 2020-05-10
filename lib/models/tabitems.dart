
import 'package:flutter/material.dart';

class AnimatedItem {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final IconData iconData;
  final double iconSize;
  final Color color;
  final Widget screen;

  AnimatedItem({
    this.text,
    this.iconData,
    this.color,
    this.screen,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 16,
    this.iconSize = 24,
  });
}