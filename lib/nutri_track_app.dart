import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/routing/app_router.dart';
import 'package:nutri_track/core/routing/routes.dart';
import 'package:nutri_track/core/theme/app_theme.dart';
import 'package:nutri_track/features/settings/cubits/theme_cubit.dart';

class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'NutriTrack AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          initialRoute: Routes.onBoardingScreen,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
