import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Divider(
            color: Color(0xFF2954F1),
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF2954F1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFF2954F1),
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
        ),
      ],
    );
  }
}
