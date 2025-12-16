import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/landing_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/dashboard_screen.dart';
import 'models/user_role.dart';
import 'models/sector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: "Prev'Hub",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AppNavigator(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  UserRole? _userRole;
  Sector? _userSector;
  AppScreen _currentScreen = AppScreen.landing;

  UserRole? get userRole => _userRole;
  Sector? get userSector => _userSector;
  AppScreen get currentScreen => _currentScreen;

  void setUserRole(UserRole role, Sector? sector) {
    _userRole = role;
    _userSector = sector;
    _currentScreen = AppScreen.dashboard;
    notifyListeners();
  }

  void logout() {
    _userRole = null;
    _userSector = null;
    _currentScreen = AppScreen.landing;
    notifyListeners();
  }

  void navigateToRoleSelection() {
    _currentScreen = AppScreen.roleSelection;
    notifyListeners();
  }

  void navigateToLanding() {
    _currentScreen = AppScreen.landing;
    notifyListeners();
  }
}

enum AppScreen {
  landing,
  roleSelection,
  dashboard,
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        switch (appState.currentScreen) {
          case AppScreen.landing:
            return LandingScreen(
              onStart: () => appState.navigateToRoleSelection(),
            );
          case AppScreen.roleSelection:
            return RoleSelectionScreen(
              onBack: () => appState.navigateToLanding(),
              onComplete: (role, sector) => appState.setUserRole(role, sector),
            );
          case AppScreen.dashboard:
            return DashboardScreen(
              userRole: appState.userRole!,
              userSector: appState.userSector,
              onLogout: () => appState.logout(),
            );
        }
      },
    );
  }
}
