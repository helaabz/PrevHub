import '../models/team_member.dart';
import '../constants/app_constants.dart';

/// Service pour gérer les membres de l'équipe
class TeamService {
  /// Récupère tous les membres de l'équipe
  List<TeamMember> getTeamMembers() {
    return AppConstants.mockTeam;
  }

  /// Récupère un membre par son ID
  TeamMember? getTeamMemberById(int id) {
    try {
      return AppConstants.mockTeam.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}

