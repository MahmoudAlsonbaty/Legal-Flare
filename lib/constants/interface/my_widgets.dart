import 'package:flutter/material.dart';

class UnderlineText extends StatelessWidget {
  const UnderlineText({
    super.key,
    this.distance = 3,
    required this.textWidget,
    this.color = const Color(0xFFA0AAFF),
    this.thickness = 3,
  });
  final double distance;
  final Widget textWidget;
  final Color color;
  final double thickness;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: distance,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: color,
        width: thickness,
      ))),
      child: textWidget,
    );
  }
}

String? dateToString(DateTime? value) {
  if (value == null) {
    return null;
  }
  return "${value.year}/${value.month}/${value.day}";
}
