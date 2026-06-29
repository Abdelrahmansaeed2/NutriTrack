import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/network/api_client.dart';
import 'package:nutri_track/core/widgets/Header.dart';
import 'package:nutri_track/features/dashboard/widgets/settings_list.dart';
import 'package:nutri_track/features/dashboard/widgets/days_tracked_card.dart';
import 'package:nutri_track/features/dashboard/widgets/profile_header.dart';
import 'package:nutri_track/features/dashboard/widgets/statistics_grid.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_state.dart';
import '../services/profile_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileService(ApiClient.instance.dio))..loadProfile(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Header(),
              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProfileError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<ProfileCubit>().loadProfile(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is ProfileLoaded) {
                      final profile = state.profileData;
                      final onboarding = profile['onboarding'] as Map<String, dynamic>? ?? {};
                      final targets = profile['targets'] as Map<String, dynamic>? ?? {};

                      final name = profile['name'] as String? ?? 'User';
                      final bio = profile['bio'] as String? ?? '';
                      final currentWeight = (onboarding['weightKg'] as num?)?.toDouble() ?? 70.0;
                      final targetWeight = (onboarding['targetWeightKg'] as num?)?.toDouble() ?? 70.0;
                      final bmr = (onboarding['bmr'] as num?)?.toInt() ?? 1500;
                      final calorieTarget = (targets['dailyCalories'] as num?)?.toInt() ?? 2000;

                      const daysTracked = 14; 

                      return RefreshIndicator(
                        onRefresh: () => context.read<ProfileCubit>().loadProfile(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            child: Column(
                              children: [
                                ProfileHeader(name: name, bio: bio),
                                const SizedBox(
                                  height: 16,
                                ),
                                const DaysTrackedCard(daysTracked: daysTracked),
                                const SizedBox(
                                  height: 16,
                                ),
                                StatisticsGrid(
                                  currentWeight: currentWeight,
                                  targetWeight: targetWeight,
                                  bmr: bmr,
                                  calorieTarget: calorieTarget,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const SettingsList()
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
