import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import 'mission_documents_plans_view.dart';
import 'mission_contacts_view.dart';
import 'mission_avancement_view.dart';
import 'mission_exchanges_view.dart';
import 'mission_invoicing_view.dart';

class MissionDetailScreen extends StatefulWidget {
  final String missionId;
  final VoidCallback? onPosition;
  final bool isAssigned;

  const MissionDetailScreen({
    super.key,
    required this.missionId,
    this.onPosition,
    this.isAssigned = false,
  });

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  final List<_MissionFile> _livrableFiles = [
    _MissionFile(
      name: 'Rapport_principal_v1.pdf',
      size: '2.3 MB',
      date: DateTime(2024, 3, 14),
      status: 'Brouillon',
    ),
    _MissionFile(
      name: 'Annexes_site.zip',
      size: '8.5 MB',
      date: DateTime(2024, 3, 14),
      status: 'Brouillon',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 8 onglets si mission assignée (avec Avancement, Échanges et Facturation), 7 sinon
    final tabCount = widget.isAssigned ? 8 : 7;
    _tabController = TabController(length: tabCount, vsync: this);
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
              'Mission #${widget.missionId}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFF4D3D),
          unselectedLabelColor: const Color(0xFF999999),
          indicatorColor: const Color(0xFFFF4D3D),
          isScrollable: true,
          tabs: [
            const Tab(text: 'Contexte'),
            const Tab(text: 'Contraintes & Délais'),
            const Tab(text: 'Documents disponibles'),
            const Tab(text: 'Livrables'),
            if (widget.isAssigned) const Tab(text: 'Avancement'),
            const Tab(text: 'Échanges'),
            if (widget.isAssigned) const Tab(text: 'Facturation'),
            const Tab(text: 'Contacts'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Mission summary card (affichée uniquement dans l'onglet "Contexte")
          if (_tabController.index == 0)
            Padding(
              padding: const EdgeInsets.all(16),
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
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContexteTab(), // Contexte
                _buildContraintesDelaisTab(),
                _buildDocumentsPlansTab(),
                _buildLivrablesTab(),
                if (widget.isAssigned) _buildAvancementTab(), // Avancement (seulement si assignée)
                _buildExchangesTab(), // Échanges
                if (widget.isAssigned) _buildInvoicingTab(), // Facturation (seulement si assignée)
                _buildContactsTab(),
              ],
            ),
          ),
          // CTA Button (seulement sur l'onglet Contexte)
          if (_tabController.index == 0)
            if (!widget.isAssigned && widget.onPosition != null)
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
          // CTA soumission livrables
          if (_tabController.index == 3 && _livrableFiles.isNotEmpty)
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
                text: 'SOUMETTRE POUR VALIDATION',
                onPressed: _showSubmitLivrablesModal,
                variant: ButtonVariant.primary,
                fullWidth: true,
                icon: const Icon(Icons.send, size: 18, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    // TODO: Refresh mission data from backend
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isRefreshing = false;
    });
  }

  Widget _buildContexteTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
         
        ],
      ),
      ),
    );
  }

  Widget _buildContraintesDelaisTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }

  Widget _buildLivrablesTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dépôt des livrables',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _buildUploadDropZone(),
          const SizedBox(height: 24),
          const Text(
            'Fichiers déposés',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          ..._livrableFiles.map((fichier) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFileCard(fichier),
              )),
          const SizedBox(height: 24),
          _buildValidationChecklist(),
        ],
      ),
      ),
    );
  }

  Widget _buildUploadDropZone() {
    return GestureDetector(
      onTap: _addFile,
      child: Container(
        constraints: const BoxConstraints(minHeight: 180),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3B82F6),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload, size: 40, color: Color(0xFF3B82F6)),
            const SizedBox(height: 10),
            const Text(
              'Déposez vos fichiers ici',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            AppButton(
              text: '📎 Ajouter un fichier',
              onPressed: _addFile,
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Formats acceptés : PDF, DOCX, XLSX, JPG, PNG • Max. 50 Mo par fichier',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF999999),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard(_MissionFile fichier) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.description, color: Color(0xFF3B82F6), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fichier.name,
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
                      fichier.size,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${_formatFileDate(fichier.date)}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fichier.status,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined, size: 18),
            onPressed: () {},
            color: const Color(0xFF3B82F6),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () {
              setState(() {
                _livrableFiles.remove(fichier);
              });
            },
            color: const Color(0xFFDC2626),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationChecklist() {
    return AppCard(
      backgroundColor: const Color(0xFF10B981).withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text(
                'Vérification avant envoi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckItem('Taille OK', true),
          _buildCheckItem('Format OK', true),
          _buildCheckItem('Nom conforme', true),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool isOk) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isOk ? const Color(0xFF10B981) : const Color(0xFF999999),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isOk ? const Color(0xFF1A1A1A) : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'xlsx', 'jpg', 'png'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final sizeBytes = file.size;
        final sizeMB = (sizeBytes / (1024 * 1024)).toStringAsFixed(1);
        setState(() {
          _livrableFiles.add(
            _MissionFile(
              name: file.name,
              size: '$sizeMB MB',
              date: DateTime.now(),
              status: 'Brouillon',
            ),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du dépôt du fichier : $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  void _showSubmitLivrablesModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Soumettre pour validation ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Les fichiers suivants seront soumis :'),
            const SizedBox(height: 12),
            ..._livrableFiles.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${f.name}',
                    style: const TextStyle(fontSize: 12),
                  ),
                )),
            const SizedBox(height: 12),
            const Text(
              '⚠️ Vous ne pourrez plus modifier les fichiers après soumission.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFF59E0B),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          AppButton(
            text: 'Confirmer',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livrables soumis avec succès'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  String _formatFileDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDocumentsPlansTab() {
    if (widget.isAssigned) {
      return MissionDocumentsPlansView(
        missionId: widget.missionId,
        missionTitle: 'Mission #${widget.missionId}',
      );
    }
    return _ReadOnlyDocumentsPlansView(
      missionId: widget.missionId,
      missionTitle: 'Mission #${widget.missionId}',
    );
  }

  Widget _buildContactsTab() {
    if (widget.isAssigned) {
      return MissionContactsView(
        missionId: widget.missionId,
      );
    }
    return _ReadOnlyContactsView(
      missionId: widget.missionId,
    );
  }

  Widget _buildAvancementTab() {
    return MissionAvancementView(
      missionId: widget.missionId,
    );
  }

  Widget _buildExchangesTab() {
    return MissionExchangesView(
      missionId: widget.missionId,
      isAssigned: widget.isAssigned,
    );
  }

  Widget _buildInvoicingTab() {
    return MissionInvoicingView(
      missionId: widget.missionId,
      isAssigned: widget.isAssigned,
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
          widget.onPosition?.call();
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

class _MissionFile {
  final String name;
  final String size;
  final DateTime date;
  final String status;

  _MissionFile({
    required this.name,
    required this.size,
    required this.date,
    required this.status,
  });
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

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh documents
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh contacts
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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

