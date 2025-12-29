import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/project_controller.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_cv_submission_screen.dart';
import 'screens/dashboard_screen.dart';
import 'models/user_role.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => ProjectController()),
      ],
      child: MaterialApp(
        title: "Prev'Hub",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
        ],
        locale: const Locale('fr', 'FR'),
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        switch (authController.currentScreen) {
          case AppScreen.landing:
            return LandingScreen(
              onStart: () => authController.navigateToSignupCvSubmission(),
              onLogin: () => authController.navigateToLogin(),
            );
          case AppScreen.login:
            return LoginScreen(
              onLogin: () {
                // Rediriger directement vers le dashboard
                authController.setUserRole(UserRole.provider, null);
              },
              onBack: () => authController.navigateToLanding(),
              onSignUp: () => authController.navigateToSignupCvSubmission(),
            );
          case AppScreen.signupCvSubmission:
            return SignupCvSubmissionScreen(
              onBack: () => authController.navigateToLogin(),
            );
          case AppScreen.dashboard:
            return DashboardScreen(
              userRole: authController.userRole!,
              userSector: authController.userSector,
              onLogout: () => authController.logout(),
            );
          default:
            return LandingScreen(
              onStart: () => authController.navigateToSignupCvSubmission(),
              onLogin: () => authController.navigateToLogin(),
            );
        }
      },
    );
  }
}
