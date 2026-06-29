import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';
import 'package:nutri_track/features/dashboard/widgets/settings_list.dart';
import 'package:nutri_track/features/dashboard/widgets/days_tracked_card.dart';
import 'package:nutri_track/features/dashboard/widgets/profile_header.dart';
import 'package:nutri_track/features/dashboard/widgets/statistics_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                ProfileHeader(),
                SizedBox(
                  height: 16,
                ),
                DaysTrackedCard(),
                SizedBox(
                  height: 16,
                ),
                StatisticsGrid(),
                SizedBox(
                  height: 16,
                ),
                SettingsList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
