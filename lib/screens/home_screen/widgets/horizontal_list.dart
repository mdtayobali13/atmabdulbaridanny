import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Widget> items;

  const HorizontalList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: items,
      ),
    );
  }
}
