import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/user_role.dart';
import '../models/sector.dart';
import '../services/project_service.dart';

/// Controller pour gérer les projets/établissements
class ProjectController extends ChangeNotifier {
  final ProjectService _projectService;
  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;

  ProjectController({ProjectService? projectService})
      : _projectService = projectService ?? ProjectService();

  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  bool get isLoading => _isLoading;

  /// Charge les projets selon le rôle et le secteur de l'utilisateur
  Future<void> loadProjects(UserRole userRole, Sector? userSector) async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = _projectService.getProjectsForUser(userRole, userSector);
    } catch (e) {
      debugPrint('Error loading projects: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProject(Project project) {
    _selectedProject = project;
    notifyListeners();
  }

  void clearSelectedProject() {
    _selectedProject = null;
    notifyListeners();
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}

