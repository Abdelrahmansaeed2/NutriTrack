import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/tracking/cubits/calorie_cubit.dart';

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
      home: const Scaffold(
        body: Center(
          child: Text(
            'NutriTrack AI Architecture Core Initialized',
            style: TextStyle(color: Colors.pink, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
