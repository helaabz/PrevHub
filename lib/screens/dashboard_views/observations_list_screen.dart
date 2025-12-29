import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../models/observation.dart';
import 'observation_form_screen.dart';
import 'observation_detail_screen.dart';

class ObservationsListScreen extends StatelessWidget {
  final String missionId;
  final String missionTitle;
  final List<Observation> observations;
  final Function(Observation) onObservationAdded;

  const ObservationsListScreen({
    super.key,
    required this.missionId,
    required this.missionTitle,
    required this.observations,
    required this.onObservationAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              missionTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${observations.length} observation${observations.length > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
      body: observations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_off_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune observation',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez votre première observation',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: observations.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildObservationCard(context, observations[index]),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: AppButton(
                    text: 'Ajouter une observation',
                    onPressed: () => _addObservation(context),
                    variant: ButtonVariant.primary,
                    fullWidth: true,
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildObservationCard(BuildContext context, Observation observation) {
    Color priorityColor;
    String priorityLabel;
    switch (observation.priority) {
      case Priority.critique:
        priorityColor = const Color(0xFFDC2626);
        priorityLabel = 'Critique';
        break;
      case Priority.eleve:
        priorityColor = const Color(0xFFF59E0B);
        priorityLabel = 'Élevé';
        break;
      case Priority.moyen:
        priorityColor = const Color(0xFF3B82F6);
        priorityLabel = 'Moyen';
        break;
      case Priority.faible:
        priorityColor = const Color(0xFF10B981);
        priorityLabel = 'Faible';
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObservationDetailScreen(
              observation: observation,
            ),
          ),
        );
      },
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    priorityLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: priorityColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (!observation.isSynced)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 12,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Non synchronisé',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              observation.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF666666)),
                const SizedBox(width: 4),
                Text(
                  observation.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                if (observation.photos > 0) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.photo, size: 14, color: Color(0xFF666666)),
                  const SizedBox(width: 4),
                  Text(
                    '${observation.photos} photo${observation.photos > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${observation.date.day}/${observation.date.month}/${observation.date.year} à ${observation.date.hour.toString().padLeft(2, '0')}:${observation.date.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF999999),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ObservationDetailScreen(
                        observation: observation,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF4D3D)),
                label: const Text(
                  'Voir détail',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF4D3D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addObservation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationFormScreen(
          missionId: missionId,
          onSave: (observation) {
            onObservationAdded(observation);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Observation sauvegardée localement'),
                  ],
                ),
                backgroundColor: Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }
}

