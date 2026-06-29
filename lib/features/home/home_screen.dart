


import 'package:flutter/material.dart';
import 'package:nutri_track/features/analytics/screens/analytics_dashboard.dart';
import 'package:nutri_track/features/daily%20dashboard/screens/daily_dashboard_screen.dart';
import 'package:nutri_track/features/dashboard/screens/dashboard.dart';
import 'package:nutri_track/features/foodSearch/screens/food_search_screen.dart';
import 'package:nutri_track/features/settings/screens/settings.dart';
import 'package:nutri_track/features/weeklyMealPlanner/screens/weekly_planner_screen.dart';

import '../grocery/screens/grocery_list_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DailyDashboardScreen(),           
    const FoodSearchScreen(),          
    const _PlannerTab(),               
    const AnalyticsDashboardScreen(),  
    const _ProfileTab(),            
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1DB574),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlannerTab extends StatefulWidget {
  const _PlannerTab();

  @override
  State<_PlannerTab> createState() => _PlannerTabState();
}

class _PlannerTabState extends State<_PlannerTab> {
  int _plannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _plannerIndex,
            children: const [
              WeeklyPlannerScreen(),
              GroceryListScreen(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _plannerIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _plannerIndex == 0
                          ? const Color(0xFF1DB574)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Weekly Plan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _plannerIndex == 0
                            ? Colors.white
                            : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _plannerIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _plannerIndex == 1
                          ? const Color(0xFF1DB574)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Grocery List',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _plannerIndex == 1
                            ? Colors.white
                            : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  int _profileIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _profileIndex,
            children: const [
              DashboardScreen(), 
              SettingsScreen(),  
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _profileIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _profileIndex == 0
                          ? const Color(0xFF1DB574)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _profileIndex == 0 ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _profileIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _profileIndex == 1
                          ? const Color(0xFF1DB574)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _profileIndex == 1 ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label screen\ncoming soon',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}