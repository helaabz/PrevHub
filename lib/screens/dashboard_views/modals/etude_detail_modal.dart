import 'package:flutter/material.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../mission_documents_view.dart';
import '../mission_documents_plans_view.dart';
import '../mission_contacts_view.dart';
import '../mission_avancement_view.dart';

class EtudeDetailModal extends StatefulWidget {
  final String etudeId;
  final String etudeTitle;
  final String currentStatus;

  const EtudeDetailModal({
    super.key,
    required this.etudeId,
    required this.etudeTitle,
    required this.currentStatus,
  });

  @override
  State<EtudeDetailModal> createState() => _EtudeDetailModalState();
}

class _EtudeDetailModalState extends State<EtudeDetailModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.etudeTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.etudeId,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFF999999),
                    ),
                  ],
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFFFF4D3D),
                unselectedLabelColor: const Color(0xFF999999),
                indicatorColor: const Color(0xFFFF4D3D),
                tabs: const [
                  Tab(text: 'E1 - Préparation'),
                  Tab(text: 'E2 - Plans & Annotations'),
                  Tab(text: 'E3 - Avancement'),
                ],
              ),
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPreparationTab(), // E1 - Préparation
                    _buildPlansAnnotationsTab(), // E2 - Plans & Annotations
                    _buildAvancementTab(), // E3 - Avancement
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // E1) Préparation (commune)
  Widget _buildPreparationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Documents existants
          const Text(
            'Documents existants',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildDocumentsSection(),
          const SizedBox(height: 24),
          // Section Contacts
          const Text(
            'Contacts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildContactsSection(),
          const SizedBox(height: 24),
          // Section Consignes et attendus
          const Text(
            'Consignes et attendus',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildConsignesSection(),
          const SizedBox(height: 24),
          // Section Pièces manquantes
          _buildMissingDocumentsSection(),
          const SizedBox(height: 24),
          // Section Historique des échanges
          const Text(
            'Historique des échanges',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildHistorySection(),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    final documents = [
      {'name': 'Plan RDC - Version 2', 'type': 'Plan', 'date': '15/01/2024', 'size': '2.3 MB'},
      {'name': 'Rapport audit 2023', 'type': 'Rapport', 'date': '10/12/2023', 'size': '1.8 MB'},
      {'name': 'PV réunion technique', 'type': 'PV', 'date': '10/01/2024', 'size': '0.5 MB'},
      {'name': 'Dossier administratif', 'type': 'Dossier', 'date': '05/01/2024', 'size': '3.2 MB'},
    ];

    return Column(
      children: documents.map((doc) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppCard(
          onTap: () {
            // Télécharger ou ouvrir le document
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ouverture de ${doc['name']}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          doc['type'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${doc['date']} • ${doc['size']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.download_outlined, color: Color(0xFF3B82F6)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildContactsSection() {
    final contacts = [
      {
        'organization': 'Prévéris - Siège',
        'name': 'Marie Dupont',
        'role': 'Responsable mission',
        'email': 'marie.dupont@preveris.fr',
        'phone': '+33 1 23 45 67 89',
        'icon': Icons.business,
        'color': Colors.blue,
      },
      {
        'organization': 'Client',
        'name': 'Jean Martin',
        'role': 'Directeur technique',
        'email': 'j.martin@client.fr',
        'phone': '+33 6 12 34 56 78',
        'icon': Icons.person,
        'color': Colors.green,
      },
      {
        'organization': 'Architecte',
        'name': 'Sophie Bernard',
        'role': 'Architecte DPLG',
        'email': 's.bernard@archi.fr',
        'phone': '+33 6 98 76 54 32',
        'icon': Icons.architecture,
        'color': Colors.orange,
      },
    ];

    return Column(
      children: contacts.map((contact) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (contact['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      contact['icon'] as IconData,
                      color: contact['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact['organization'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact['name'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Text(
                          contact['role'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Appeler',
                      onPressed: () {},
                      variant: ButtonVariant.outline,
                      size: ButtonSize.sm,
                      icon: const Icon(Icons.phone, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      text: 'Email',
                      onPressed: () {},
                      variant: ButtonVariant.outline,
                      size: ButtonSize.sm,
                      icon: const Icon(Icons.email, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildConsignesSection() {
    final consignes = [
      'Respecter les horaires d\'intervention (8h-17h)',
      'Utiliser les EPI obligatoires sur site',
      'Documenter toutes les observations avec photos',
      'Respecter la confidentialité des informations client',
      'Rapport à déposer dans un délai de 15 jours après intervention',
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exigences de l\'étude',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          ...consignes.map((consigne) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, size: 20, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    consigne,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMissingDocumentsSection() {
    final missingDocs = [
      'Plan étage 1',
      'Fiche technique équipement',
    ];

    if (missingDocs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pièces manquantes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          backgroundColor: const Color(0xFFFFF5F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Documents requis non disponibles',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...missingDocs.map((doc) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Color(0xFFEF4444)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doc,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              AppButton(
                text: 'Signaler un document manquant',
                onPressed: () => _showMissingDocumentForm(),
                variant: ButtonVariant.primary,
                fullWidth: true,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMissingDocumentForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MissingDocumentForm(
        onSubmit: (type, urgency, comment) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document manquant signalé. Statut mis à jour en "En attente d\'éléments".'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistorySection() {
    final exchanges = [
      {
        'date': '17/03/2024 14:30',
        'author': 'Marie Dupont',
        'message': 'Bonjour, pouvez-vous confirmer la date d\'intervention ?',
        'attachments': 0,
      },
      {
        'date': '17/03/2024 15:45',
        'author': 'Vous',
        'message': 'Oui, je confirme pour le 20/03/2024 à 9h.',
        'attachments': 1,
      },
      {
        'date': '18/03/2024 10:15',
        'author': 'Jean Martin',
        'message': 'Merci pour la confirmation. Les documents sont disponibles.',
        'attachments': 2,
      },
    ];

    return Column(
      children: exchanges.map((exchange) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    exchange['author'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    exchange['date'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                exchange['message'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
              if (exchange['attachments'] as int > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_file, size: 16, color: Color(0xFF666666)),
                    const SizedBox(width: 4),
                    Text(
                      '${exchange['attachments']} pièce(s) jointe(s)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      )).toList(),
    );
  }

  // E2) Consultation et annotation des plans PDF
  Widget _buildPlansAnnotationsTab() {
    return MissionDocumentsPlansView(
      missionId: widget.etudeId,
      missionTitle: widget.etudeTitle,
    );
  }

  // E3) Suivi d'avancement
  Widget _buildAvancementTab() {
    return MissionAvancementView(
      missionId: widget.etudeId,
    );
  }
}

class _MissingDocumentForm extends StatefulWidget {
  final Function(String, String, String) onSubmit;

  const _MissingDocumentForm({required this.onSubmit});

  @override
  State<_MissingDocumentForm> createState() => _MissingDocumentFormState();
}

class _MissingDocumentFormState extends State<_MissingDocumentForm> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _selectedUrgency = 'moyenne';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
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
                      'Signaler un document manquant',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Type de document',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _typeController,
                        decoration: InputDecoration(
                          hintText: 'Ex: Plan étage, Fiche technique...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Urgence',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildUrgencyOption('faible', 'Faible', Colors.green),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildUrgencyOption('moyenne', 'Moyenne', Colors.orange),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildUrgencyOption('haute', 'Haute', Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Commentaire (optionnel)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Ajoutez des précisions...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: AppButton(
                  text: 'Confirmer',
                  onPressed: () {
                    widget.onSubmit(
                      _typeController.text,
                      _selectedUrgency,
                      _commentController.text,
                    );
                  },
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUrgencyOption(String value, String label, Color color) {
    final isSelected = _selectedUrgency == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedUrgency = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? color : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }
}

