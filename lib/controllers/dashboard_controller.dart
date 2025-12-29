import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/notification.dart';

/// Controller pour gérer le dashboard
class DashboardController extends ChangeNotifier {
  int _activeTab = 0;
  Project? _selectedProject;
  bool _isNotificationsOpen = false;

  int get activeTab => _activeTab;
  Project? get selectedProject => _selectedProject;
  bool get isNotificationsOpen => _isNotificationsOpen;

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  void selectProject(Project project) {
    _selectedProject = project;
    notifyListeners();
  }

  void clearSelectedProject() {
    _selectedProject = null;
    notifyListeners();
  }

  void openNotifications() {
    _isNotificationsOpen = true;
    notifyListeners();
  }

  void closeNotifications() {
    _isNotificationsOpen = false;
    notifyListeners();
  }
}

