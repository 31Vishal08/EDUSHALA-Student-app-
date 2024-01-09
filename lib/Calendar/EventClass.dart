import 'package:flutter/material.dart';

class Events{
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color bgColor;
  final bool isAllDay;
  final int index;
  final String id;

  const Events({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.bgColor = Colors.tealAccent,
    this.isAllDay = true,
    this.index = 0,
    this.id = "hello"
});
}