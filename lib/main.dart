
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/tracking/cubit/calorie_cubit.dart';
import 'features/daily dashboard/screens/daily_dashboard_screen.dart';
//import 'features/presentation/pages/food_detail_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CalorieCubit>(
          create: (_) => CalorieCubit(),
        ),
        // Add other global or feature-specific cubits here
      ],
      child: const NutriTrackApp(),
    ),
  );
}

class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const  DailyDashboardScreen(),

    );
  }
}
