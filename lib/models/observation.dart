class Observation {
  final String id;
  final String missionId;
  final String description;
  final Priority priority;
  final String location;
  final int photos;
  final bool isSynced;
  final DateTime date;

  Observation({
    required this.id,
    required this.missionId,
    required this.description,
    required this.priority,
    required this.location,
    required this.photos,
    required this.isSynced,
    required this.date,
  });
}

enum Priority { critique, eleve, moyen, faible }

