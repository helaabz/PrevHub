import '../models/project.dart';
import '../models/user_role.dart';
import '../models/sector.dart';
import '../constants/app_constants.dart';

/// Service pour gérer les opérations sur les projets
class ProjectService {
  /// Récupère les projets selon le rôle et le secteur de l'utilisateur
  List<Project> getProjectsForUser(UserRole userRole, Sector? userSector) {
    if (userRole == UserRole.client) {
      // Pour un client, retourner uniquement son établissement principal
      if (userSector == Sector.restaurant) {
        return [AppConstants.mockEstablishments[0]];
      } else {
        return [AppConstants.mockEstablishments[1]];
      }
    } else if (userRole == UserRole.manager) {
      // Pour un manager, retourner tous les établissements
      return AppConstants.mockEstablishments;
    } else {
      // Pour un prestataire, retourner tous les établissements
      return AppConstants.mockEstablishments;
    }
  }

  /// Récupère un projet par son ID
  Project? getProjectById(String id) {
    try {
      return AppConstants.mockEstablishments.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Récupère tous les projets
  List<Project> getAllProjects() {
    return AppConstants.mockEstablishments;
  }
}

