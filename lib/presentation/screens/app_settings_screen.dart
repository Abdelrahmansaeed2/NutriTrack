import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/settings_cubit.dart';
import '../cubits/settings_state.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: const AppSettingsView(),
    );
  }
}

class AppSettingsView extends StatelessWidget {
  const AppSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) => previous.authState != current.authState,
          listener: (context, state) {
            if (state.authState == AuthenticationState.unauthenticated) {
              // In a real app, use GoRouter or Navigator to route to Login/Splash
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully.')),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    // Header - TopAppBar
                    Container(
                      color: const Color(0xFFF8F9FF),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "NutriTrack AI",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF006C49),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Main Content Canvas
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Main Header
                              const Text(
                                "Settings",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF121C2A),
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Manage your account, preferences, and connections.",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3C4A42),
                                ),
                              ),
                              const SizedBox(height: 32),
                              
                              // Section: Account
                              _buildListGroup(
                                title: "ACCOUNT",
                                children: [
                                  _buildListItem(
                                    title: "Edit Profile",
                                    subtitle: "Update your personal details",
                                    leadingIconStr: AppVectors.icon_62, // Fallback icon
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              
                              // Section: Integrations
                              _buildListGroup(
                                title: "INTEGRATIONS",
                                children: [
                                  _buildListItem(
                                    title: "Sync with Health Apps",
                                    subtitle: "Apple Health, Google Fit",
                                    leadingIconStr: AppVectors.icon_63, // Fallback icon
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              
                              // Section: Preferences
                              _buildListGroup(
                                title: "PREFERENCES",
                                children: [
                                  _buildToggleItem(
                                    title: "Dark Theme",
                                    subtitle: "Switch between light and dark",
                                    leadingIconStr: AppVectors.icon_64, // Fallback icon
                                    isActive: state.isDarkTheme,
                                    onToggle: (val) => context.read<SettingsCubit>().toggleDarkTheme(val),
                                  ),
                                  const Divider(height: 1, color: Color(0xFFD9E3F6)),
                                  _buildListItem(
                                    title: "Notifications",
                                    subtitle: "Manage alerts and reminders",
                                    leadingIconStr: AppVectors.icon_41, // Bell fallback
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              
                              // Logout Button
                              GestureDetector(
                                onTap: () => context.read<SettingsCubit>().logout(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.string(
                                        AppVectors.icon_62, // Logout fallback
                                        width: 20,
                                        height: 20,
                                        colorFilter: const ColorFilter.mode(Color(0xFF93000A), BlendMode.srcIn),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF93000A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48), // Bottom padding
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildListGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6C7A71),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1F2937).withValues(alpha: 0.05),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem({
    required String title,
    required String subtitle,
    required String leadingIconStr,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.string(
                leadingIconStr,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF121C2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFBBCABF),
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required String leadingIconStr,
    required bool isActive,
    required ValueChanged<bool> onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.string(
                leadingIconStr,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF121C2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ],
            ),
          ),
          // Custom Animated Toggle matching Traceability Table
          GestureDetector(
            onTap: () => onToggle(!isActive),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 50,
              height: 28,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: isActive ? const Color(0xFF006C49) : const Color(0xFFD9E3F6),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFFD1D5DB),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, String iconVector, double iconW, double iconH, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            iconVector,
            width: iconW,
            height: iconH,
            colorFilter: ColorFilter.mode(
              isActive ? const Color(0xFF00422B) : const Color(0xFF3C4A42),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF00422B) : const Color(0xFF3C4A42),
            ),
          ),
        ],
      ),
    );
  }
}
