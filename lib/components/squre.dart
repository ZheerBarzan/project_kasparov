import 'package:flutter/material.dart';

class Squre extends StatelessWidget {
  final bool isWhite;
  const Squre({super.key, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? Colors.grey.shade200 : Colors.grey.shade800,
    );
  }
}
