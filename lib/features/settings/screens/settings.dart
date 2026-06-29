import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/routing/routes.dart';
import 'package:nutri_track/core/widgets/Header.dart';
import 'package:nutri_track/features/settings/widgets/logout_button.dart';
import 'package:nutri_track/features/settings/widgets/section_header.dart';
import 'package:nutri_track/features/settings/widgets/settings_list_item.dart';
import 'package:nutri_track/features/settings/widgets/settings_header.dart';
import '../cubits/settings_cubit.dart';
import '../cubits/settings_state.dart';
import '../services/settings_service.dart';
import '../cubits/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(SettingsService()),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.onBoardingScreen,
              (route) => false,
            );
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SettingsLoading;

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const Header(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SettingsHeader(),
                              const SizedBox(height: 32),
                              // ACCOUNT SECTION
                              const SectionHeader(title: 'ACCOUNT'),
                              const SizedBox(height: 16),
                              SettingsListItem(
                                icon: Icons.person,
                                title: 'Edit Profile',
                                subtitle: 'Update your personal details',
                                onTap: () {},
                              ),
                              const SizedBox(height: 24),
                              // PREFERENCES SECTION
                              const SectionHeader(title: 'PREFERENCES'),
                              const SizedBox(height: 16),
                              BlocBuilder<ThemeCubit, ThemeMode>(
                                builder: (context, themeMode) {
                                  final isDark = themeMode == ThemeMode.dark;
                                  return SettingsListItem(
                                    icon: Icons.dark_mode,
                                    title: 'Dark Theme',
                                    subtitle: 'Switch between light and dark',
                                    trailing: Switch(
                                      value: isDark,
                                      onChanged: (value) {
                                        context.read<ThemeCubit>().toggleTheme(value);
                                      },
                                      activeColor: const Color(0xFF1DB574),
                                    ),
                                    onTap: () {
                                      context.read<ThemeCubit>().toggleTheme(!isDark);
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 32),
                              isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : LogoutButton(
                                      onTap: () {
                                        context.read<SettingsCubit>().logout();
                                      },
                                    ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
