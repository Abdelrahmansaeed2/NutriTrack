import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 48, color: Colors.black),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black54),
              'Manage your account, preferences, and connections.')
        ]);
  }
}
