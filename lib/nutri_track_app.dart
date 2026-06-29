import 'package:flutter/material.dart';
import 'package:nutri_track/core/routing/app_router.dart';
import 'package:nutri_track/core/routing/routes.dart';
import 'package:nutri_track/core/theme/app_theme.dart';

import 'package:nutri_track/features/on_boarding/ui/screens/on_boarding_screen.dart';

class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.onBoardingScreen, //////////
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}

// Future<void> checkedUserLoggedIn() async {
//   String? userToken = await SharedPrefHelper.getString(SharedPrefKeys.token);
//   isUserLoggedIn = userToken != null && userToken.isNotEmpty;
// }
