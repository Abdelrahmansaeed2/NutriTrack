import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/user_profile_cubit.dart';
import '../cubits/user_profile_state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit()..loadProfile(),
      child: const UserProfileView(),
    );
  }
}

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Stack(
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
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF006C49), width: 1.5),
                              image: const DecorationImage(
                                image: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder for demo
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "NutriTrack AI",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF006C49),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: Center(
                              child: SvgPicture.string(
                                AppVectors.icon_41, // Notification/Alerts Icon Placeholder
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(Color(0xFF3C4A42), BlendMode.srcIn),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBA1A1A),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFF8F9FF), width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocBuilder<UserProfileCubit, UserProfileState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Profile Header Section
                              Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: const Color(0xFFFFFFFF), width: 4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF1F2937).withValues(alpha: 0.10),
                                                  offset: const Offset(0, 8),
                                                  blurRadius: 24,
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF006C49),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFF000000).withValues(alpha: 0.10),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 4,
                                                  ),
                                                  BoxShadow(
                                                    color: const Color(0xFF000000).withValues(alpha: 0.10),
                                                    offset: const Offset(0, 4),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: SvgPicture.string(
                                                  AppVectors.icon_62, // Pencil/Edit icon fallback
                                                  width: 16,
                                                  height: 16,
                                                  colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      state.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF121C2A),
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.bio,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF3C4A42),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              
                              // Stats Grid
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildHalfStatCard(
                                      value: state.badgesEarned.toString(),
                                      title: "Badges Earned",
                                      iconBg: const Color(0xFFFF7A73),
                                      iconColor: const Color(0xFF79000E),
                                      iconStr: AppVectors.icon_62, // Fallback icon
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildHalfStatCard(
                                      value: state.recipesCreated.toString(),
                                      title: "Healthy Recipes Created",
                                      iconBg: const Color(0xFFD8E2FF),
                                      iconColor: const Color(0xFF001A42),
                                      iconStr: AppVectors.icon_63, // Fallback icon
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildFullWidthStatCard(state.daysTracked),
                              const SizedBox(height: 32),
                              
                              // Action Buttons
                              _buildActionButton(
                                title: "Account Settings",
                                leadingIconStr: AppVectors.icon_40, // Setting fallback
                              ),
                              const SizedBox(height: 16),
                              _buildActionButton(
                                title: "Support & FAQ",
                                leadingIconStr: AppVectors.icon_62, // General help fallback
                              ),
                              const SizedBox(height: 48), // Bottom padding
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfStatCard({
    required String value,
    required String title,
    required Color iconBg,
    required Color iconColor,
    required String iconStr,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD9E3F6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.string(
                iconStr,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF121C2A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3C4A42),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthStatCard(int days) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD9E3F6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
          // Decoration glow requested via box shadow
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.05),
            offset: const Offset(0, 0),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.string(
                AppVectors.icon_62,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(Color(0xFF006C49), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              const Text(
                "Total Days Tracked",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C4A42),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                days.toString(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF006C49),
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "DAYS",
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFD9E3F6),
              borderRadius: BorderRadius.circular(9999),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.85, // Dummy progress
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF006C49),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String title, required String leadingIconStr}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9E3F6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.string(
            leadingIconStr,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Color(0xFF6C7A71), BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF121C2A),
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded, // Best for simple right chevron
            color: const Color(0xFFBBCABF),
            size: 24,
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
