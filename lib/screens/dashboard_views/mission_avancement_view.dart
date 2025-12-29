import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';

class MissionAvancementView extends StatefulWidget {
  final String missionId;

  const MissionAvancementView({
    super.key,
    required this.missionId,
  });

  @override
  State<MissionAvancementView> createState() => _MissionAvancementViewState();
}

class _MissionAvancementViewState extends State<MissionAvancementView> {
  String _currentStatus = 'en_cours';
  int _progress = 45;
  bool _showStatusModal = false;

  final List<TimelineItem> _timeline = [
    TimelineItem(
      date: '15/03',
      title: 'Mission acceptée',
      isCompleted: true,
      icon: Icons.check_circle,
    ),
    TimelineItem(
      date: '16/03',
      title: 'Préparation documentaire',
      isCompleted: true,
      icon: Icons.folder,
    ),
    TimelineItem(
      date: '17/03',
      title: 'En cours - Analyse des plans',
      isCompleted: true,
      isCurrent: true,
      icon: Icons.analytics,
    ),
    TimelineItem(
      date: null,
      title: 'Rapport à déposer',
      isCompleted: false,
      icon: Icons.description,
    ),
    TimelineItem(
      date: null,
      title: 'Validation siège',
      isCompleted: false,
      icon: Icons.verified,
    ),
    TimelineItem(
      date: null,
      title: 'Clôturé',
      isCompleted: false,
      icon: Icons.done_all,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte de statut actuel
          _buildStatusCard(),
          const SizedBox(height: 24),
          // Barre de progression globale
          _buildProgressSection(),
          const SizedBox(height: 24),
          // Timeline
          _buildSectionTitle('Timeline'),
          const SizedBox(height: 16),
          _buildTimeline(),
          const SizedBox(height: 24),
          // Indicateurs de progression
          _buildProgressIndicators(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Statut actuel',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              AppButton(
                text: 'Changer de statut',
                onPressed: () => _showChangeStatusModal(),
                size: ButtonSize.sm,
                variant: ButtonVariant.outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Color(0xFFF59E0B),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'En cours',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Depuis le 17/03/2024 • 2 jours',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progression globale',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '$_progress%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E40AF)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: _timeline.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == _timeline.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.isCompleted
                        ? (item.isCurrent ? const Color(0xFFF59E0B) : const Color(0xFF10B981))
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isCompleted ? Colors.white : const Color(0xFF999999),
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: item.isCompleted ? const Color(0xFF10B981) : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.date != null)
                      Text(
                        item.date!,
                        style: TextStyle(
                          fontSize: 12,
                          color: item.isCompleted ? const Color(0xFF666666) : const Color(0xFF999999),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: item.isCurrent ? FontWeight.w600 : FontWeight.normal,
                        color: item.isCompleted ? const Color(0xFF1A1A1A) : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildProgressIndicators() {
    return Column(
      children: [
        _buildProgressIndicator('Documents consultés', 80, Colors.blue),
        const SizedBox(height: 12),
        _buildProgressIndicator('Plans annotés', 60, Colors.orange),
        const SizedBox(height: 12),
        _buildProgressIndicator('Rapport rédigé', 30, Colors.purple),
      ],
    );
  }

  Widget _buildProgressIndicator(String label, int progress, Color color) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$progress%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  void _showChangeStatusModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChangeStatusModal(
        currentStatus: _currentStatus,
        onStatusChanged: (newStatus) {
          setState(() {
            _currentStatus = newStatus;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Statut mis à jour. Notification envoyée au siège.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }
}

class TimelineItem {
  final String? date;
  final String title;
  final bool isCompleted;
  final bool isCurrent;
  final IconData icon;

  TimelineItem({
    this.date,
    required this.title,
    required this.isCompleted,
    this.isCurrent = false,
    required this.icon,
  });
}

class _ChangeStatusModal extends StatefulWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;

  const _ChangeStatusModal({
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  State<_ChangeStatusModal> createState() => _ChangeStatusModalState();
}

class _ChangeStatusModalState extends State<_ChangeStatusModal> {
  String? _selectedStatus;
  final TextEditingController _commentController = TextEditingController();

  final List<StatusOption> _statuses = [
    StatusOption('a_demarrer', 'À démarrer', Icons.play_circle_outline, Colors.green, 'Mission prête à commencer'),
    StatusOption('en_cours', 'En cours', Icons.analytics, Colors.orange, 'Travail en cours sur la mission'),
    StatusOption('en_attente', 'En attente d\'éléments', Icons.pause_circle_outline, Colors.amber, 'En attente de documents ou informations'),
    StatusOption('rapport_depose', 'Rapport déposé', Icons.upload_file, Colors.blue, 'Rapport soumis pour validation'),
    StatusOption('corrections', 'Corrections demandées', Icons.edit, Colors.purple, 'Des corrections sont nécessaires'),
    StatusOption('resoumis', 'Rapport resoumis', Icons.refresh, Colors.brown, 'Rapport corrigé et resoumis'),
    StatusOption('valide', 'Validé / Clôturé', Icons.check_circle, Colors.green, 'Mission terminée et validée'),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Changer de statut',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: _statuses.map((status) => _buildStatusOption(status)).toList(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Commentaire (optionnel)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Confirmer le changement',
                      onPressed: _selectedStatus != null
                          ? () => widget.onStatusChanged(_selectedStatus!)
                          : null,
                      variant: ButtonVariant.primary,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(StatusOption status) {
    final isSelected = _selectedStatus == status.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? status.color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? status.color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: status.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(status.icon, color: status.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF10B981)),
          ],
        ),
      ),
    );
  }
}

class StatusOption {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String description;

  StatusOption(this.id, this.label, this.icon, this.color, this.description);
}

