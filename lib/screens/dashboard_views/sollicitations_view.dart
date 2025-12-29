import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';

class SollicitationsView extends StatefulWidget {
  const SollicitationsView({super.key});

  @override
  State<SollicitationsView> createState() => _SollicitationsViewState();
}

class _SollicitationsViewState extends State<SollicitationsView> {
  final List<Solicitation> _solicitations = [
    Solicitation(
      id: '1',
      title: 'Audit Sécurité Incendie - Site Industriel',
      client: 'Groupe Industriel ABC',
      deadline: DateTime.now().add(const Duration(hours: 2, minutes: 15)),
      urgency: UrgencyLevel.high,
      location: 'Lyon, 69001',
      rate: '450€ / jour',
      isEligible: true,
    ),
    Solicitation(
      id: '2',
      title: 'Formation SST - Groupe 15 personnes',
      client: 'Entreprise XYZ',
      deadline: DateTime.now().add(const Duration(hours: 5, minutes: 30)),
      urgency: UrgencyLevel.medium,
      location: 'Paris, 75001',
      rate: '300€ / jour',
      isEligible: true,
    ),
    Solicitation(
      id: '3',
      title: 'Inspection Périodique ERP',
      client: 'Centre Commercial DEF',
      deadline: DateTime.now().add(const Duration(hours: 12)),
      urgency: UrgencyLevel.low,
      location: 'Marseille, 13001',
      rate: '400€ / jour',
      isEligible: false,
      eligibilityIssue: 'Documents manquants',
    ),
  ];

  Timer? _timer;
  String? _refusingSolicitationId;
  final Map<String, TextEditingController> _refusalControllers = {};

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    // Initialiser les contrôleurs pour chaque sollicitation
    for (var solicitation in _solicitations) {
      _refusalControllers[solicitation.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _refusalControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Simuler un refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Offre de Mission',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${_solicitations.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._solicitations.map((solicitation) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSolicitationCard(solicitation),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSolicitationCard(Solicitation solicitation) {
    final timeRemaining = solicitation.deadline.difference(DateTime.now());
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    final seconds = timeRemaining.inSeconds % 60;
    final isExpired = timeRemaining.isNegative;
    final progress = isExpired
        ? 0.0
        : (timeRemaining.inSeconds / solicitation.initialDuration.inSeconds).clamp(0.0, 1.0);

    Color urgencyColor;
    switch (solicitation.urgency) {
      case UrgencyLevel.high:
        urgencyColor = const Color(0xFFDC2626);
        break;
      case UrgencyLevel.medium:
        urgencyColor = const Color(0xFFFFA500);
        break;
      case UrgencyLevel.low:
        urgencyColor = const Color(0xFF3B82F6);
        break;
    }

    return AppCard(
      backgroundColor: solicitation.urgency == UrgencyLevel.high && !isExpired
          ? const Color(0xFFFFF5F5)
          : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec urgence
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: urgencyColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Réponse attendue dans :',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: urgencyColor,
                    ),
                  ),
                ),
                Text(
                  isExpired
                      ? 'EXPIRÉ'
                      : '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: urgencyColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(urgencyColor),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 12),
          // Titre et client
          Text(
            solicitation.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            solicitation.client,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 10),
          // Infos
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF666666)),
              const SizedBox(width: 4),
              Text(
                solicitation.location,
                style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.euro, size: 14, color: Color(0xFF666666)),
              const SizedBox(width: 4),
              Text(
                solicitation.rate,
                style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
              ),
            ],
          ),
          // Blocage éligibilité
          if (!solicitation.isEligible) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      solicitation.eligibilityIssue ?? 'Non éligible',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Naviguer vers profil
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      minimumSize: MaterialStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Mettre à jour',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Boutons d'action
          if (solicitation.isEligible && !isExpired)
            _refusingSolicitationId == solicitation.id
                ? _buildRefusalForm(solicitation)
                : Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'ACCEPTER',
                          onPressed: () => _handleAccept(solicitation),
                          variant: ButtonVariant.primary,
                          size: ButtonSize.sm,
                          icon: const Icon(Icons.check, size: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          text: 'REFUSER',
                          onPressed: () => _handleRefuse(solicitation),
                          variant: ButtonVariant.outline,
                          size: ButtonSize.sm,
                          icon: const Icon(Icons.close, size: 16, color: Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  )
          else if (isExpired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Temps de réponse expiré',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleAccept(Solicitation solicitation) {
    // Accepter directement sans afficher le modal de mission
    _showSuccessDialog();
  }

  void _handleRefuse(Solicitation solicitation) {
    setState(() {
      _refusingSolicitationId = solicitation.id;
    });
  }

  void _cancelRefusal() {
    setState(() {
      if (_refusingSolicitationId != null) {
        _refusalControllers[_refusingSolicitationId]?.clear();
      }
      _refusingSolicitationId = null;
    });
  }

  void _confirmRefusal(Solicitation solicitation) {
    final motif = _refusalControllers[solicitation.id]?.text.trim() ?? '';
    if (motif.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un motif de refus'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() {
      _refusingSolicitationId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sollicitation refusée'),
        backgroundColor: Color(0xFF6B7280),
      ),
    );
  }

  Widget _buildRefusalForm(Solicitation solicitation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Motif de refus',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _refusalControllers[solicitation.id],
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Saisissez le motif de votre refus...',
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
                color: Color(0xFFDC2626),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Annuler',
                onPressed: _cancelRefusal,
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                text: 'Confirmer',
                onPressed: () => _confirmRefusal(solicitation),
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
                icon: const Icon(Icons.close, size: 16, color: Color(0xFFDC2626)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sollicitation acceptée',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vous recevrez une confirmation sous peu.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class Solicitation {
  final String id;
  final String title;
  final String client;
  final DateTime deadline;
  final UrgencyLevel urgency;
  final String location;
  final String rate;
  final bool isEligible;
  final String? eligibilityIssue;
  late final Duration initialDuration;

  Solicitation({
    required this.id,
    required this.title,
    required this.client,
    required this.deadline,
    required this.urgency,
    required this.location,
    required this.rate,
    required this.isEligible,
    this.eligibilityIssue,
  }) {
    // Calculer la durée initiale (par exemple, 4h pour high, 8h pour medium, 24h pour low)
    switch (urgency) {
      case UrgencyLevel.high:
        initialDuration = const Duration(hours: 4);
        break;
      case UrgencyLevel.medium:
        initialDuration = const Duration(hours: 8);
        break;
      case UrgencyLevel.low:
        initialDuration = const Duration(hours: 24);
        break;
    }
  }
}

enum UrgencyLevel { low, medium, high }

