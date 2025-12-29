import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../models/observation.dart';
import 'observation_form_screen.dart';
import 'observations_list_screen.dart';

class AuditTerrainView extends StatefulWidget {
  const AuditTerrainView({super.key});

  @override
  State<AuditTerrainView> createState() => _AuditTerrainViewState();
}

class _AuditTerrainViewState extends State<AuditTerrainView> {
  final Map<String, List<Observation>> _observationsByMission = {
    'mission-1': [
      Observation(
        id: '1',
        missionId: 'mission-1',
        description: 'Équipement de sécurité incendie non conforme - Absence de signalétique',
        priority: Priority.critique,
        location: 'Hall d\'entrée - RDC',
        photos: 2,
        isSynced: false,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Observation(
        id: '2',
        missionId: 'mission-1',
        description: 'Sortie de secours partiellement obstruée',
        priority: Priority.eleve,
        location: 'Zone A - Niveau +1',
        photos: 1,
        isSynced: true,
        date: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
    'mission-2': [],
  };

  final List<Map<String, dynamic>> _missions = [
    {
      'id': 'mission-1',
      'title': 'Audit Sécurité Incendie - Site B',
      'location': 'Lyon, 69001',
      'date': '20 Jan 2024',
      'status': 'Acceptée',
      'statusColor': const Color(0xFF10B981),
    },
    {
      'id': 'mission-2',
      'title': 'Coordination SPS - Chantier Lyon',
      'location': 'Lyon, 69002',
      'date': '25 Jan 2024',
      'status': 'Planifiée',
      'statusColor': const Color(0xFF3B82F6),
    },
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audit terrain',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gérez vos audits terrain et inspections.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 24),
          // Liste des missions
          ..._missions.map((mission) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMissionCard(mission),
              )),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    final missionId = mission['id'] as String;
    final observations = _observationsByMission[missionId] ?? [];
    final observationCount = observations.length;
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF666666)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            mission['location'] as String,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF666666)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            mission['date'] as String,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AppButton(
                text: 'Observation',
                onPressed: () => _addObservation(missionId),
                size: ButtonSize.sm,
                variant: ButtonVariant.primary,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ],
          ),
          if (observationCount > 0) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF666666)),
                    const SizedBox(width: 8),
                    Text(
                      '$observationCount observation${observationCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showObservationsList(missionId, mission['title'] as String),
                  icon: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF4D3D)),
                  label: const Text(
                    'Voir toutes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF4D3D),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildObservationPreview(Observation observation) {
    Color priorityColor;
    switch (observation.priority) {
      case Priority.critique:
        priorityColor = const Color(0xFFDC2626);
        break;
      case Priority.eleve:
        priorityColor = const Color(0xFFF59E0B);
        break;
      case Priority.moyen:
        priorityColor = const Color(0xFF3B82F6);
        break;
      case Priority.faible:
        priorityColor = const Color(0xFF10B981);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  observation.description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      observation.location,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (observation.photos > 0) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.photo, size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${observation.photos} photo${observation.photos > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!observation.isSynced)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                size: 16,
                color: Color(0xFFF59E0B),
              ),
            ),
        ],
      ),
    );
  }

  void _showObservationsList(String missionId, String missionTitle) {
    final observations = _observationsByMission[missionId] ?? [];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationsListScreen(
          missionId: missionId,
          missionTitle: missionTitle,
          observations: observations,
          onObservationAdded: (Observation observation) {
            setState(() {
              if (!_observationsByMission.containsKey(missionId)) {
                _observationsByMission[missionId] = [];
              }
              _observationsByMission[missionId]!.insert(0, observation);
            });
          },
        ),
      ),
    );
  }

  void _addObservation(String missionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationFormScreen(
          missionId: missionId,
          onSave: (observation) {
            setState(() {
              if (!_observationsByMission.containsKey(missionId)) {
                _observationsByMission[missionId] = [];
              }
              _observationsByMission[missionId]!.insert(0, observation);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Observation sauvegardée localement'),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

}
