import 'package:flutter/material.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../mission_documents_view.dart';
import '../mission_documents_plans_view.dart';
import '../mission_contacts_view.dart';

class MissionDetailModal extends StatefulWidget {
  final String missionId;
  final VoidCallback onPosition;

  const MissionDetailModal({
    super.key,
    required this.missionId,
    required this.onPosition,
  });

  @override
  State<MissionDetailModal> createState() => _MissionDetailModalState();
}

class _MissionDetailModalState extends State<MissionDetailModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to show/hide CTA button
    });
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
                          const Text(
                            'Mission #12345 - Audit Sécur...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                        
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
              // Mission summary card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 48, color: Color(0xFF999999)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'PME Industrielle - Métallurgie',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF666666)),
                          const SizedBox(width: 4),
                          const Text(
                            'Lyon, 69001',
                            style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF666666)),
                          const SizedBox(width: 4),
                          const Text(
                            '15-20 Jan 2024',
                            style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '450€ / jour',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4D3D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFFFF4D3D),
                unselectedLabelColor: const Color(0xFF999999),
                indicatorColor: const Color(0xFFFF4D3D),
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Contexte'),
                  Tab(text: 'Documents & Plans'),
                  Tab(text: 'Contraintes & Délais'),
                  Tab(text: 'Livrables'),
                  Tab(text: 'Contacts'),
                ],
              ),
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildContexteTab(), // Contexte
                    _buildDocumentsPlansTab(),
                    _buildContraintesDelaisTab(),
                    _buildLivrablesTab(),
                    _buildContactsTab(),
                  ],
                ),
              ),
              // CTA Button (seulement sur l'onglet Contexte)
              if (_tabController.index == 0)
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
                    text: 'Je me positionne',
                    onPressed: () => _showPositionModal(),
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

  Widget _buildContexteTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contexte de la mission',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Audit complet de sécurité incendie pour un site industriel de métallurgie. Le client souhaite une évaluation approfondie de ses installations et de ses procédures.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Objectifs principaux',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildObjectiveItem('Vérification de la conformité réglementaire'),
          _buildObjectiveItem('Évaluation des risques incendie'),
          _buildObjectiveItem('Recommandations d\'amélioration'),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ENJEU MAJEUR CLIENT',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContraintesDelaisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contraintes & Spécificités',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Color(0xFF3B82F6)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Zone à accès réglementé. Équipements de protection individuelle requis.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Délais & Planning',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20, color: Color(0xFF3B82F6)),
                    const SizedBox(width: 8),
                    const Text(
                      'Période d\'intervention',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Du 15 au 20 janvier 2024',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Horaires : 8h - 17h',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Color(0xFF666666)),
                    const SizedBox(width: 4),
                    const Text(
                      'Durée estimée : 5 jours',
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Équipements Requis (EPI)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildEPIIcon(Icons.construction, 'Casque'),
              const SizedBox(width: 12),
              _buildEPIIcon(Icons.shopping_bag, 'Chaussures'),
              const SizedBox(width: 12),
              _buildEPIIcon(Icons.visibility, 'Gilet'),
              const SizedBox(width: 12),
              _buildEPIIcon(Icons.hearing, 'Protection'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLivrablesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Livrables attendus',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildDeliverableItem(
            'Rapport d\'audit complet',
            'Document PDF détaillé avec toutes les observations et recommandations',
            Icons.description,
            Colors.blue,
            true,
          ),
          _buildDeliverableItem(
            'Plan d\'action priorisé',
            'Liste des actions correctives classées par priorité',
            Icons.checklist,
            Colors.orange,
            true,
          ),
          _buildDeliverableItem(
            'Photos des non-conformités',
            'Documentation photographique des points critiques identifiés',
            Icons.photo_library,
            Colors.green,
            true,
          ),
          _buildDeliverableItem(
            'Fiche de conformité réglementaire',
            'Tableau récapitulatif de la conformité aux normes en vigueur',
            Icons.verified,
            Colors.purple,
            false,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 20, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Délai de livraison',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tous les livrables doivent être remis dans un délai de 15 jours après la fin de l\'intervention.',
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
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverableItem(
    String title,
    String description,
    IconData icon,
    Color color,
    bool required,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: required ? color.withOpacity(0.3) : Colors.grey.shade200,
          width: required ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    if (required)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'OBLIGATOIRE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsPlansTab() {
    return _ReadOnlyDocumentsPlansView(
      missionId: widget.missionId,
      missionTitle: 'Mission #${widget.missionId}',
    );
  }

  Widget _buildContactsTab() {
    return _ReadOnlyContactsView(
      missionId: widget.missionId,
    );
  }

  Widget _buildObjectiveItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
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
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildEPIIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 24, color: const Color(0xFF666666)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  void _showPositionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PositionModal(
        missionId: widget.missionId,
        onConfirm: (message) {
          Navigator.pop(context);
          widget.onPosition();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Votre positionnement a été envoyé avec succès'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }
}

class _PositionModal extends StatefulWidget {
  final String missionId;
  final Function(String) onConfirm;

  const _PositionModal({
    required this.missionId,
    required this.onConfirm,
  });

  @override
  State<_PositionModal> createState() => _PositionModalState();
}

class _PositionModalState extends State<_PositionModal> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

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
                    const Text(
                      'Je me positionne',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
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
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Message (optionnel)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Vous pouvez indiquer votre disponibilité, vos contraintes ou poser des questions.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _messageController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Ex: Disponible à partir du 20 janvier. Question sur les équipements requis...',
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
                              color: Color(0xFFE63900),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // CTA Button
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
                  text: 'Confirmer mon positionnement',
                  onPressed: () => widget.onConfirm(_messageController.text.trim()),
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                  icon: const Icon(Icons.check, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Version en lecture seule de MissionDocumentsPlansView
class _ReadOnlyDocumentsPlansView extends StatelessWidget {
  final String missionId;
  final String missionTitle;

  const _ReadOnlyDocumentsPlansView({
    required this.missionId,
    required this.missionTitle,
  });

  @override
  Widget build(BuildContext context) {
    final documents = [
      {'name': 'Plan RDC - Version 2', 'type': 'Plan', 'date': '15/01/2024', 'size': '2.3 MB'},
      {'name': 'Rapport audit 2023', 'type': 'Rapport', 'date': '10/12/2023', 'size': '1.8 MB'},
      {'name': 'PV réunion technique', 'type': 'PV', 'date': '10/01/2024', 'size': '0.5 MB'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            missionTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Documents et plans (consultation uniquement)',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 24),
          ...documents.map((doc) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              // Pas de onTap - lecture seule
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
                  const Icon(Icons.visibility_outlined, color: Color(0xFF999999)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// Version en lecture seule de MissionContactsView
class _ReadOnlyContactsView extends StatelessWidget {
  final String missionId;

  const _ReadOnlyContactsView({
    required this.missionId,
  });

  @override
  Widget build(BuildContext context) {
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
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contacts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          ...contacts.map((contact) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              // Pas de boutons d'action - lecture seule
              child: Row(
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
                        const SizedBox(height: 4),
                        Text(
                          contact['phone'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Text(
                          contact['email'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

