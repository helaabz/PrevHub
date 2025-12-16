import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../models/sector.dart';
import '../../models/project.dart';
import '../../widgets/project_card.dart';
import '../../constants/app_constants.dart';

class ProjectsView extends StatelessWidget {
  final UserRole userRole;
  final Sector? userSector;
  final Function(Project) onProjectTap;

  const ProjectsView({
    super.key,
    required this.userRole,
    this.userSector,
    required this.onProjectTap,
  });

  List<Project> get _establishments {
    if (userRole == UserRole.client) {
      final mainEst = userSector == Sector.restaurant
          ? AppConstants.mockEstablishments[0]
          : AppConstants.mockEstablishments[1];
      return [mainEst];
    }
    return AppConstants.mockEstablishments;
  }

  @override
  Widget build(BuildContext context) {
    final establishments = _establishments;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tous les dossiers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          ...establishments.map((est) => GestureDetector(
                onTap: () => onProjectTap(est),
                child: ProjectCard(project: est),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

