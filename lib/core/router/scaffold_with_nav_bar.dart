import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_vectors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      // The child is the screen for the current branch
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1F2937).withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem("Home", AppVectors.icon_35, 16, 18, navigationShell.currentIndex == 0, () => _goBranch(0)),
            _buildNavItem("Search", AppVectors.icon_36, 18, 18, navigationShell.currentIndex == 1, () => _goBranch(1)),
            _buildNavItem("Planner", AppVectors.icon_37, 22, 22, navigationShell.currentIndex == 2, () => _goBranch(2)),
            _buildNavItem("Trends", AppVectors.icon_38, 22, 17, navigationShell.currentIndex == 3, () => _goBranch(3)),
            _buildNavItem("Profile", AppVectors.icon_39, 16, 16, navigationShell.currentIndex == 4, () => _goBranch(4)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, String iconVector, double iconW, double iconH, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
      ),
    );
  }
}
