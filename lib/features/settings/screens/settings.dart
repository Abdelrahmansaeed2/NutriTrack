import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';
import 'package:nutri_track/features/settings/widgets/logout_button.dart';
import 'package:nutri_track/features/settings/widgets/section_header.dart';
import 'package:nutri_track/features/settings/widgets/settings_list_item.dart';
import 'package:nutri_track/features/settings/widgets/settings_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/user.jpg'),
            ),
          ),
          title: const Text(
            'NutriTrack AI',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBrandColor,
                fontSize: 36),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black87,
                    size: 28,
                  ),
                  Positioned(
                    right: 2,
                    top: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SettingsHeader(),
              SizedBox(height: 32),
              // ACCOUNT SECTION
              SectionHeader(title: 'ACCOUNT'),
              SizedBox(height: 16),
              SettingsListItem(
                icon: Icons.person,
                title: 'Edit Profile',
                subtitle: 'Update your personal details',
                onTap: () {},
              ),
              SizedBox(height: 24),
              // INTEGRATIONS SECTION
              SectionHeader(title: 'INTEGRATIONS'),
              SizedBox(height: 16),
              SettingsListItem(
                icon: Icons.health_and_safety,
                title: 'Sync with Health Apps',
                subtitle: 'Apple Health, Google Fit',
                onTap: () {},
              ),
              SizedBox(height: 24),
              // PREFERENCES SECTION
              SectionHeader(title: 'PREFERENCES'),
              SizedBox(height: 16),
              SettingsListItem(
                icon: Icons.dark_mode,
                title: 'Dark Theme',
                subtitle: 'Switch between light and dark',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeThumbColor: AppTheme.primaryBrandColor,
                ),
                onTap: () {},
              ),
              SettingsListItem(
                icon: Icons.notifications_active,
                title: 'Notifications',
                subtitle: 'Manage alerts and reminders',
                onTap: () {},
              ),
              SizedBox(height: 32),
              LogoutButton()
            ]),
          ),
        ),
      ),
    );
  }
}
