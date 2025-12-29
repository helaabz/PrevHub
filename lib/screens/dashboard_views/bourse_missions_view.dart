import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import 'mission_detail_screen.dart';
import 'modals/positionnement_modal.dart';

class BourseMissionsView extends StatefulWidget {
  const BourseMissionsView({super.key});

  @override
  State<BourseMissionsView> createState() => _BourseMissionsViewState();
}

class _BourseMissionsViewState extends State<BourseMissionsView> {
  final int _missionCount = 12;
  int _displayedMissionsCount = 3; // Afficher 3 missions initialement
  
  // Filtres sélectionnés
  String? _selectedType;
  String? _selectedZone;
  String? _selectedEcheance;
  String? _selectedComplexite;

  final List<Mission> _missions = [
    Mission(
      id: '1',
      title: 'Audit Incendie - Entrepôt Logistique',
      location: 'Lyon, 69001',
      distance: '2.5 km',
      deadline: DateTime.now().add(const Duration(hours: 36)),
      complexity: 2,
      rate: '450€',
      isUrgent: true,
      candidates: 2,
      type: 'Audit',
    ),
    Mission(
      id: '2',
      title: 'Formation SST - Groupe 12 pers.',
      location: 'Paris, 75001',
      distance: '5.2 km',
      deadline: DateTime.now().add(const Duration(days: 5)),
      complexity: 1,
      rate: '300€',
      isUrgent: false,
      candidates: 0,
      type: 'Formation',
    ),
    Mission(
      id: '3',
      title: 'Inspection Périodique ERP',
      location: 'Marseille, 13001',
      distance: '8.1 km',
      deadline: DateTime.now().add(const Duration(days: 7)),
      complexity: 3,
      rate: '500€',
      isUrgent: false,
      candidates: 5,
      type: 'Inspection',
    ),
     Mission(
      id: '4',
      title: 'Inspection',
      location: 'Marseille, 13001',
      distance: '10 km',
      deadline: DateTime.now().add(const Duration(days: 7)),
      complexity: 3,
      rate: '300€',
      isUrgent: false,
      candidates: 5,
      type: 'Inspection',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _displayedMissionsCount + 1,
              itemBuilder: (context, index) {
                if (index == _displayedMissionsCount) {
                  // Afficher le bouton "Voir plus" seulement s'il reste des missions
                  if (_displayedMissionsCount < _missions.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: AppButton(
                        text: 'Voir plus',
                        onPressed: () {
                          setState(() {
                            _displayedMissionsCount++;
                          });
                        },
                        variant: ButtonVariant.ghost,
                        fullWidth: true,
                        size: ButtonSize.sm,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMissionCard(_missions[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Missions Ouvertes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '($_missionCount)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Type de mission',
              value: _selectedType,
              onTap: () => _showTypeFilter(),
            ),
            const SizedBox(width: 6),
            _buildFilterChip(
              label: 'Zone',
              value: _selectedZone,
              onTap: () => _showZoneFilter(),
            ),
            const SizedBox(width: 6),
            _buildFilterChip(
              label: 'Échéance',
              value: _selectedEcheance,
              onTap: () => _showEcheanceFilter(),
            ),
            const SizedBox(width: 6),
            _buildFilterChip(
              label: 'Complexité',
              value: _selectedComplexite,
              onTap: () => _showComplexiteFilter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    String? value,
    required VoidCallback onTap,
  }) {
    final isSelected = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE63900) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFE63900) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value ?? label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF666666),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  setState(() {
                    if (label == 'Type de mission') _selectedType = null;
                    if (label == 'Zone') _selectedZone = null;
                    if (label == 'Échéance') _selectedEcheance = null;
                    if (label == 'Complexité') _selectedComplexite = null;
                  });
                },
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ] else ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF666666),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type de mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('Audit', () {
              setState(() => _selectedType = 'Audit');
              Navigator.pop(context);
            }),
            _buildFilterOption('Formation', () {
              setState(() => _selectedType = 'Formation');
              Navigator.pop(context);
            }),
            _buildFilterOption('Inspection', () {
              setState(() => _selectedType = 'Inspection');
              Navigator.pop(context);
            }),
            _buildFilterOption('Conseil', () {
              setState(() => _selectedType = 'Conseil');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showZoneFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Zone',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('Lyon', () {
              setState(() => _selectedZone = 'Lyon');
              Navigator.pop(context);
            }),
            _buildFilterOption('Paris', () {
              setState(() => _selectedZone = 'Paris');
              Navigator.pop(context);
            }),
            _buildFilterOption('Marseille', () {
              setState(() => _selectedZone = 'Marseille');
              Navigator.pop(context);
            }),
            _buildFilterOption('Toulouse', () {
              setState(() => _selectedZone = 'Toulouse');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showEcheanceFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Échéance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('Urgent (< 48h)', () {
              setState(() => _selectedEcheance = 'Urgent');
              Navigator.pop(context);
            }),
            _buildFilterOption('Cette semaine', () {
              setState(() => _selectedEcheance = 'Cette semaine');
              Navigator.pop(context);
            }),
            _buildFilterOption('Ce mois', () {
              setState(() => _selectedEcheance = 'Ce mois');
              Navigator.pop(context);
            }),
            _buildFilterOption('Plus tard', () {
              setState(() => _selectedEcheance = 'Plus tard');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showComplexiteFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complexité',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('Simple (★)', () {
              setState(() => _selectedComplexite = 'Simple');
              Navigator.pop(context);
            }),
            _buildFilterOption('Moyenne (★★)', () {
              setState(() => _selectedComplexite = 'Moyenne');
              Navigator.pop(context);
            }),
            _buildFilterOption('Complexe (★★★)', () {
              setState(() => _selectedComplexite = 'Complexe');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, VoidCallback onTap) {
    return ListTile(
      title: Text(label),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildMissionCard(Mission mission) {
    final deadlineDiff = mission.deadline.difference(DateTime.now());
    final isUrgentDeadline = deadlineDiff.inHours < 48;
    final isVeryUrgent = deadlineDiff.inHours < 24;

    Color deadlineColor;
    String deadlineText;
    if (isVeryUrgent) {
      deadlineColor = const Color(0xFFDC2626);
      deadlineText = '${deadlineDiff.inHours}h';
    } else if (isUrgentDeadline) {
      deadlineColor = const Color(0xFFFFA500);
      deadlineText = '${deadlineDiff.inDays}j';
    } else {
      deadlineColor = const Color(0xFF10B981);
      deadlineText = '${deadlineDiff.inDays}j';
    }

    return AppCard(
      onTap: () => _showMissionDetail(mission),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mission.title,
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
                  Text(
                    mission.location,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    mission.distance,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Échéance
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: deadlineColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: deadlineColor),
                    const SizedBox(width: 4),
                    Text(
                      deadlineText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: deadlineColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (mission.candidates > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${mission.candidates} candidat${mission.candidates > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMissionDetail(Mission mission) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MissionDetailScreen(
          missionId: mission.id,
          onPosition: () {
            Navigator.pop(context);
            _showPositionnementModal(mission);
          },
        ),
      ),
    );
  }

  void _showPositionnementModal(Mission mission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PositionnementModal(
        missionId: mission.id,
        missionTitle: mission.title,
        onConfirm: (message, availableTomorrow, canTakePhotos) {
          // Ici, vous pouvez traiter le message et les options
          // Par exemple, les envoyer à une API
          if (message.isNotEmpty) {
            // Message envoyé avec la candidature
          }
          Navigator.pop(context);
          _showSuccessFeedback(mission);
        },
      ),
    );
  }

  void _showSuccessFeedback(Mission mission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4D3D),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Candidature Envoyée!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Votre candidature a bien été reçue. Vous serez notifié de la réponse sous peu.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    mission.location,
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Retour à la liste'),
          ),
          AppButton(
            text: 'Voir ma candidature',
            onPressed: () {
              Navigator.pop(context);
              // Naviguer vers mes candidatures
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

}

class Mission {
  final String id;
  final String title;
  final String location;
  final String distance;
  final DateTime deadline;
  final int complexity; // 1-3
  final String rate;
  final bool isUrgent;
  final int candidates;
  final String type;

  Mission({
    required this.id,
    required this.title,
    required this.location,
    required this.distance,
    required this.deadline,
    required this.complexity,
    required this.rate,
    required this.isUrgent,
    required this.candidates,
    required this.type,
  });
}

