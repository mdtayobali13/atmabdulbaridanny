import 'package:flutter/material.dart';

class BannerAvatar extends StatelessWidget {
  final IconData icon;
  final String label;

  const BannerAvatar({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white24,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
