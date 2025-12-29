import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import 'modals/pdf_viewer_with_annotations.dart';

class MissionDocumentsPlansView extends StatefulWidget {
  final String missionId;
  final String missionTitle;

  const MissionDocumentsPlansView({
    super.key,
    required this.missionId,
    required this.missionTitle,
  });

  @override
  State<MissionDocumentsPlansView> createState() => _MissionDocumentsPlansViewState();
}

class _MissionDocumentsPlansViewState extends State<MissionDocumentsPlansView> {
  int _availableCount = 12;
  int _totalCount = 15;
  bool _showMissingForm = false;

  final List<DocumentItem> _documents = [
    DocumentItem(
      name: 'Plan RDC - Version 2',
      type: DocumentType.plan,
      date: DateTime(2024, 1, 15),
      size: '2.3 MB',
      isNew: true,
      version: 'v2.0',
    ),
    DocumentItem(
      name: 'Rapport audit 2023',
      type: DocumentType.report,
      date: DateTime(2023, 12, 10),
      size: '1.8 MB',
      isNew: false,
    ),
    DocumentItem(
      name: 'PV réunion technique',
      type: DocumentType.administrative,
      date: DateTime(2024, 1, 10),
      size: '0.5 MB',
      isNew: false,
    ),
    DocumentItem(
      name: 'Photos site - Zone A',
      type: DocumentType.photo,
      date: DateTime(2024, 1, 12),
      size: '5.2 MB',
      isNew: true,
    ),
  ];

  final List<String> _missingDocuments = [
    'Plan étage 1',
    'Fiche technique équipement',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtres
          // Filtres
          _buildFilters(),
          const SizedBox(height: 16),
          // Documents existants
          _buildSectionTitle('Documents existants'),
          const SizedBox(height: 12),
          ..._documents.map((doc) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDocumentCard(doc),
              )),
          const SizedBox(height: 24),
          // Pièces manquantes
          if (_missingDocuments.isNotEmpty) ...[
            _buildMissingDocumentsSection(),
            const SizedBox(height: 24),
          ],
          // Accès rapide contacts
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Tous', true),
          const SizedBox(width: 8),
          _buildFilterChip('Plans', false),
          const SizedBox(width: 8),
          _buildFilterChip('Rapports', false),
          const SizedBox(width: 8),
          _buildFilterChip('Photos', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return FilterChip(
      label: Text(label),
      selected: isActive,
      onSelected: (selected) {},
      selectedColor: const Color(0xFFFF4D3D),
      labelStyle: TextStyle(
        color: isActive ? Colors.white : const Color(0xFF666666),
        fontSize: 12,
      ),
    );
  }

  Widget _buildDocumentCard(DocumentItem doc) {
    IconData icon;
    Color iconColor;

    switch (doc.type) {
      case DocumentType.plan:
        icon = Icons.description;
        iconColor = const Color(0xFFDC2626);
        break;
      case DocumentType.report:
        icon = Icons.article;
        iconColor = const Color(0xFF3B82F6);
        break;
      case DocumentType.administrative:
        icon = Icons.folder;
        iconColor = const Color(0xFF10B981);
        break;
      case DocumentType.photo:
        icon = Icons.photo;
        iconColor = const Color(0xFFF59E0B);
        break;
    }

    return AppCard(
      onTap: () {
        // Si c'est un PDF (plan ou rapport), ouvrir avec annotations
        if (doc.type == DocumentType.plan || doc.type == DocumentType.report) {
          _openPdfWithAnnotations(context, doc);
        } else {
          // Pour les autres types, télécharger ou ouvrir normalement
        }
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
                        doc.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    if (doc.isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Nouveau',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (doc.version != null) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          doc.version!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatDate(doc.date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${doc.size}',
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
          GestureDetector(
            onTap: () {
              // Télécharger localement
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Téléchargement en cours...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.download_outlined, color: Color(0xFF1E40AF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingDocumentsSection() {
    return AppCard(
      backgroundColor: const Color(0xFFFFF5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Pièces manquantes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._missingDocuments.map((doc) => Padding(
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
            text: 'Signaler un manquant',
            onPressed: () => _showMissingDocumentForm(),
            variant: ButtonVariant.primary,
            fullWidth: true,
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContacts() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Accès rapide aux contacts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildContactItem('Prévéris - Siège', Icons.business, Colors.blue),
          const SizedBox(height: 8),
          _buildContactItem('Client - Contact', Icons.person, Colors.green),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.phone, size: 18),
          onPressed: () {},
          color: const Color(0xFF1E40AF),
        ),
        IconButton(
          icon: const Icon(Icons.email, size: 18),
          onPressed: () {},
          color: const Color(0xFF1E40AF),
        ),
      ],
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
              content: Text('Document manquant signalé. Statut mis à jour.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _openPdfWithAnnotations(BuildContext context, DocumentItem doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfViewerWithAnnotations(
        documentName: doc.name,
        documentId: doc.name, // Utiliser le nom comme ID pour l'exemple
        missionId: widget.missionId,
      ),
    );
  }
}

class DocumentItem {
  final String name;
  final DocumentType type;
  final DateTime date;
  final String size;
  final bool isNew;
  final String? version;

  DocumentItem({
    required this.name,
    required this.type,
    required this.date,
    required this.size,
    required this.isNew,
    this.version,
  });
}

enum DocumentType { plan, report, administrative, photo }

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

