import 'sector.dart';
import 'establishment_stats.dart';

enum ProjectStatus {
  active,
  pending,
  urgent;

  String get displayName {
    switch (this) {
      case ProjectStatus.active:
        return 'ACTIVE';
      case ProjectStatus.pending:
        return 'PENDING';
      case ProjectStatus.urgent:
        return 'URGENT';
    }
  }
}

class Project {
  final String id;
  final String name;
  final String type;
  final Sector sector;
  final String address;
  final ProjectStatus status;
  final double progress;
  final String lastUpdate;
  final String? nextDeadline;
  final EstablishmentStats? stats;

  Project({
    required this.id,
    required this.name,
    required this.type,
    required this.sector,
    required this.address,
    required this.status,
    required this.progress,
    required this.lastUpdate,
    this.nextDeadline,
    this.stats,
  });
}

