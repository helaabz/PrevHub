import 'package:flutter/foundation.dart';
import '../models/user_role.dart';
import '../models/sector.dart';

/// Controller pour gérer l'authentification et la navigation
class AuthController extends ChangeNotifier {
  UserRole? _userRole;
  Sector? _userSector;
  AppScreen _currentScreen = AppScreen.landing;

  UserRole? get userRole => _userRole;
  Sector? get userSector => _userSector;
  AppScreen get currentScreen => _currentScreen;

  bool get isAuthenticated => _userRole != null;

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

  void navigateToLanding() {
    _currentScreen = AppScreen.landing;
    notifyListeners();
  }

  void navigateToLogin() {
    _currentScreen = AppScreen.login;
    notifyListeners();
  }

  void navigateToSignupCvSubmission() {
    _currentScreen = AppScreen.signupCvSubmission;
    notifyListeners();
  }
}

enum AppScreen {
  landing,
  login,
  signupCvSubmission,
  dashboard,
}

