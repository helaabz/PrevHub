import 'compliance_component.dart';

enum ComplianceLevel {
  critical,
  warning,
  good,
  excellent;

  String get displayName {
    switch (this) {
      case ComplianceLevel.critical:
        return 'Critique';
      case ComplianceLevel.warning:
        return 'Attention';
      case ComplianceLevel.good:
        return 'Bon';
      case ComplianceLevel.excellent:
        return 'Excellent';
    }
  }

  String get emoji {
    switch (this) {
      case ComplianceLevel.critical:
        return '🚨';
      case ComplianceLevel.warning:
        return '⚠️';
      case ComplianceLevel.good:
        return '✓';
      case ComplianceLevel.excellent:
        return '⭐';
    }
  }
}

class EstablishmentStats {
  final double globalScore;
  final ComplianceLevel level;
  final ComplianceComponent installations;
  final ComplianceComponent obligations;
  final ComplianceComponent documents;

  EstablishmentStats({
    required this.globalScore,
    required this.level,
    required this.installations,
    required this.obligations,
    required this.documents,
  });
}

