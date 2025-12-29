class MissionVisio {
  final String id;
  final String missionId;
  final List<VisioParticipant> participants;
  final DateTime scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final VisioStatus status;
  final String? meetingUrl;

  MissionVisio({
    required this.id,
    required this.missionId,
    required this.participants,
    required this.scheduledAt,
    this.startedAt,
    this.endedAt,
    required this.status,
    this.meetingUrl,
  });
}

class VisioParticipant {
  final String id;
  final String name;
  final String role; // 'preventionniste', 'siege', 'client', 'architecte'
  final String? email;
  final bool isAuthorized;

  VisioParticipant({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.isAuthorized = true,
  });
}

enum VisioStatus {
  scheduled,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case VisioStatus.scheduled:
        return 'Planifiée';
      case VisioStatus.inProgress:
        return 'En cours';
      case VisioStatus.completed:
        return 'Terminée';
      case VisioStatus.cancelled:
        return 'Annulée';
    }
  }
}

