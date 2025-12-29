import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';

enum AvailabilityStatus {
  available,
  unavailable,
  limited,
}

class DisponibilitesView extends StatefulWidget {
  const DisponibilitesView({super.key});

  @override
  State<DisponibilitesView> createState() => _DisponibilitesViewState();
}

class _DisponibilitesViewState extends State<DisponibilitesView> {
  AvailabilityStatus _currentStatus = AvailabilityStatus.available;
  DateTime? _unavailableUntilDate;
  final TextEditingController _limitedCommentController = TextEditingController();

  @override
  void dispose() {
    _limitedCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          // Statut actuel
          _buildCurrentStatusCard(),
          const SizedBox(height: 32),
          const Text(
            'Modifier mon statut',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          // Option Disponible
          _buildStatusOption(
            title: 'Disponible',
            description: 'Je suis prêt à recevoir des missions immédiatement.',
            icon: Icons.check_circle,
            iconColor: const Color(0xFF10B981),
            isSelected: _currentStatus == AvailabilityStatus.available,
            onTap: () {
              setState(() {
                _currentStatus = AvailabilityStatus.available;
                _unavailableUntilDate = null;
                _limitedCommentController.clear();
              });
            },
          ),
          const SizedBox(height: 12),
          // Option Disponibilité limitée
          _buildStatusOption(
            title: 'Disponibilité limitée',
            description: 'Je suis disponible uniquement sur certains créneaux.',
            icon: Icons.schedule,
            iconColor: const Color(0xFFFFA500),
            isSelected: _currentStatus == AvailabilityStatus.limited,
            onTap: () {
              setState(() {
                _currentStatus = AvailabilityStatus.limited;
                _unavailableUntilDate = null;
              });
            },
          ),
          // Afficher le champ de commentaire si Disponibilité limitée est sélectionné
          if (_currentStatus == AvailabilityStatus.limited) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                controller: _limitedCommentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Indiquez votre motif ou commentaire (ex: disponibilité uniquement le matin, jours spécifiques, etc.)',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF4D3D),
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Option Indisponible
          _buildStatusOption(
            title: 'Indisponible',
            description: 'Je ne suis pas joignable pour le moment.',
            icon: Icons.remove_circle,
            iconColor: const Color(0xFFEF4444),
            isSelected: _currentStatus == AvailabilityStatus.unavailable,
            onTap: () => _showUnavailableDatePicker(),
          ),
          // Afficher la date si Indisponible est sélectionné
          if (_currentStatus == AvailabilityStatus.unavailable &&
              _unavailableUntilDate != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Jusqu\'au ${_formatDate(_unavailableUntilDate!)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          // Info box
          _buildInfoBox(),
          const SizedBox(height: 24),
          // Bouton Enregistrer
          AppButton(
            text: 'Enregistrer',
            onPressed: () {
              _saveStatus();
            },
            variant: ButtonVariant.primary,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard() {
    String statusText;
    String statusSubtext;
    Color statusColor;

    switch (_currentStatus) {
      case AvailabilityStatus.available:
        statusText = 'Disponible';
        statusSubtext = 'Prêt à recevoir des missions';
        statusColor = const Color(0xFF10B981);
        break;
      case AvailabilityStatus.unavailable:
        statusText = 'Indisponible';
        statusSubtext = 'Ne recevra pas de nouvelles missions';
        statusColor = const Color(0xFFEF4444);
        break;
      case AvailabilityStatus.limited:
        statusText = 'Disponibilité limitée';
        statusSubtext = 'Disponible sur certains créneaux';
        statusColor = const Color(0xFFFFA500);
        break;
    }

    return AppCard(
      backgroundColor: Colors.white,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusSubtext,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4D3D),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFE8DC).withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF4D3D)
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF4D3D).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icône circulaire à gauche
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D3D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? const Color(0xFF666666)
                          : const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFF3B82F6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Votre statut influence directement l\'attribution des missions. Pensez à le tenir à jour pour maintenir un bon score de fiabilité.',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1A1A1A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showUnavailableDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _unavailableUntilDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFFF4D3D),
                onPrimary: Colors.white,
                onSurface: Color(0xFF1A1A1A),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _currentStatus = AvailabilityStatus.unavailable;
        _unavailableUntilDate = picked;
        _limitedCommentController.clear();
      });
    } else {
      // Si l'utilisateur annule, on peut quand même sélectionner Indisponible sans date
      setState(() {
        _currentStatus = AvailabilityStatus.unavailable;
        _limitedCommentController.clear();
      });
    }
  }

  void _saveStatus() {
    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Votre statut a été mis à jour'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // Ici, vous pouvez ajouter la logique pour sauvegarder le statut
    // Par exemple, appeler une API ou sauvegarder localement
  }

  String _formatDate(DateTime date) {
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
