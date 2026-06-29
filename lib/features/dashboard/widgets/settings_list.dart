import 'package:flutter/material.dart';
import 'package:nutri_track/features/dashboard/widgets/settings_list_item.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsListItem(
          icon: Icons.settings,
          title: 'Account Settings',
          onTap: () {
            // Navigate to account settings
          },
        ),
        SettingsListItem(
          icon: Icons.help,
          title: 'Support & FAQ',
          onTap: () {
            // Navigate to support
          },
        ),
      ],
    );
  }
}
