import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 48, color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              'Manage your account, preferences, and connections.')
        ]);
  }
}
