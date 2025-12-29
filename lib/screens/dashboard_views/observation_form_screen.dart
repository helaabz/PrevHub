import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../models/observation.dart';
import '../../services/pdf_service.dart';
import 'pdf_annotation_screen.dart';

class ObservationFormScreen extends StatefulWidget {
  final String missionId;
  final Function(Observation) onSave;

  const ObservationFormScreen({
    super.key,
    required this.missionId,
    required this.onSave,
  });

  @override
  State<ObservationFormScreen> createState() => _ObservationFormScreenState();
}

class _ObservationFormScreenState extends State<ObservationFormScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Priority? _selectedPriority;
  String _selectedLocationMethod = 'zone';
  final List<String> _photos = [];
  bool _isRecording = false;
  
  // Valeurs des dropdowns
  String? _selectedZone;
  String? _selectedNiveau;
  final TextEditingController _localController = TextEditingController();
  
  // Options pour les dropdowns
  final List<String> _zones = ['Hall d\'entrée', 'Zone A', 'Zone B', 'Zone C', 'Zone D'];
  final List<String> _niveaux = ['RDC', '-1', '+1', '+2', '+3'];
  
  // Service PDF
  final PdfService _pdfService = PdfService();
  String? _pdfPath;
  PdfAnnotationPoint? _selectedPdfPoint;
  bool _isLoadingPdf = false;

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
        title: const Text(
          'Nouvelle observation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Observation
                  _buildSectionTitle('Observation'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Décrivez l\'observation...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                        onPressed: () {
                          setState(() => _isRecording = !_isRecording);
                        },
                        color: _isRecording ? const Color(0xFFDC2626) : const Color(0xFF666666),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Suggestions
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSuggestionChip('Équipement non conforme...'),
                        const SizedBox(width: 8),
                        _buildSuggestionChip('Absence de signalétique...'),
                        const SizedBox(width: 8),
                        _buildSuggestionChip('Sortie obstruée...'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Section Priorité
                  _buildSectionTitle('Priorité'),
                  const SizedBox(height: 12),
                  _buildPriorityButtons(),
                  const SizedBox(height: 24),
                  // Section Localisation
                  _buildSectionTitle('Localisation'),
                  const SizedBox(height: 12),
                  _buildLocationTabs(),
                  const SizedBox(height: 16),
                  _buildLocationContent(),
                  const SizedBox(height: 24),
                  // Section Photos
                  _buildSectionTitle('Photos'),
                  const SizedBox(height: 12),
                  _buildPhotoGallery(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Bouton sauvegarder
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
              text: 'Sauvegarder l\'observation',
              onPressed: _selectedPriority != null ? _saveObservation : null,
              variant: ButtonVariant.primary,
              fullWidth: true,
              icon: const Icon(Icons.save, size: 18, color: Colors.white),
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

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _descriptionController.text = text;
      },
      backgroundColor: Colors.grey.shade100,
      labelStyle: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildPriorityButtons() {
    return Column(
      children: [
        _buildPriorityButton(
          Priority.critique,
          'CRITIQUE',
          'Action immédiate requise',
          const Color(0xFFDC2626),
          Icons.error,
        ),
        const SizedBox(height: 8),
        _buildPriorityButton(
          Priority.eleve,
          'ÉLEVÉ',
          'Correction sous 48h',
          const Color(0xFFF97316),
          Icons.warning,
        ),
        const SizedBox(height: 8),
        _buildPriorityButton(
          Priority.moyen,
          'MOYEN',
          'Correction sous 15 jours',
          const Color(0xFFEAB308),
          Icons.info,
        ),
        const SizedBox(height: 8),
        _buildPriorityButton(
          Priority.faible,
          'FAIBLE',
          'Amélioration recommandée',
          const Color(0xFF22C55E),
          Icons.check_circle,
        ),
      ],
    );
  }

  Widget _buildPriorityButton(
    Priority priority,
    String label,
    String description,
    Color color,
    IconData icon,
  ) {
    final isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = priority),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : const Color(0xFF1A1A1A),
                    ),
                  ),
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
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF10B981)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTabs() {
    return Row(
      children: [
        Expanded(
          child: _buildLocationTab('zone', 'Zone/Niveau', Icons.layers),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildLocationTab('plan', 'Sur plan PDF', Icons.description),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildLocationTab('photo', 'Sur photo', Icons.photo),
        ),
      ],
    );
  }

  Widget _buildLocationTab(String method, String label, IconData icon) {
    final isSelected = _selectedLocationMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedLocationMethod = method),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF666666), size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationContent() {
    switch (_selectedLocationMethod) {
      case 'zone':
        return _buildZoneLocation();
      case 'plan':
        return _buildPlanLocation();
      case 'photo':
        return _buildPhotoLocation();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildZoneLocation() {
    return AppCard(
      child: Column(
        children: [
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Rechercher une zone...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            items: _zones,
            selectedItem: _selectedZone,
            onChanged: (value) {
              setState(() {
                _selectedZone = value;
              });
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Zone',
                hintText: 'Sélectionner une zone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Rechercher un niveau...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            items: _niveaux,
            selectedItem: _selectedNiveau,
            onChanged: (value) {
              setState(() {
                _selectedNiveau = value;
              });
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Niveau',
                hintText: 'Sélectionner un niveau',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _localController,
            decoration: InputDecoration(
              labelText: 'Local (optionnel)',
              hintText: 'Ex: Bureau 203',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanLocation() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Repérage sur plan PDF',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoadingPdf)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE63900),
                ),
              ),
            )
          else if (_selectedPdfPoint != null)
            Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE63900).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE63900),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 48, color: Color(0xFFE63900)),
                  const SizedBox(height: 8),
                  const Text(
                    'Point sélectionné sur le plan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE63900),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Page ${_selectedPdfPoint!.pageIndex + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Modifier le point',
                    onPressed: () => _openPdfAnnotation(),
                    variant: ButtonVariant.outline,
                    size: ButtonSize.sm,
                  ),
                ],
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.description, size: 48, color: Color(0xFF999999)),
                    const SizedBox(height: 8),
                    const Text(
                      'Visualiseur PDF avec outils de marquage',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '📍 Point • 🔲 Zone • ➤ Chemin',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Ouvrir le plan PDF',
                      onPressed: () => _openPdfAnnotation(),
                      variant: ButtonVariant.primary,
                      size: ButtonSize.sm,
                      icon: const Icon(Icons.open_in_new, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Future<void> _openPdfAnnotation() async {
    setState(() {
      _isLoadingPdf = true;
    });
    
    try {
      // Récupérer le PDF depuis le backend
      final pdfPath = await _pdfService.fetchPlanPdf(widget.missionId);
      
      if (pdfPath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de charger le PDF. Veuillez réessayer plus tard.'),
              backgroundColor: Color(0xFFDC2626),
            ),
          );
        }
        setState(() {
          _isLoadingPdf = false;
        });
        return;
      }
      
      setState(() {
        _pdfPath = pdfPath;
        _isLoadingPdf = false;
      });
      
      // Ouvrir l'écran d'annotation
      if (mounted) {
        final result = await Navigator.push<PdfAnnotationPoint?>(
          context,
          MaterialPageRoute(
            builder: (context) => PdfAnnotationScreen(
              pdfPath: pdfPath,
            ),
          ),
        );
        
        if (result != null) {
          setState(() {
            _selectedPdfPoint = result;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement du PDF: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
      setState(() {
        _isLoadingPdf = false;
      });
    }
  }

  Widget _buildPhotoLocation() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Marquer sur photo du plan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo, size: 48, color: Color(0xFF999999)),
                  const SizedBox(height: 8),
                  AppButton(
                    text: 'Prendre une photo du plan',
                    onPressed: () {},
                    variant: ButtonVariant.outline,
                    icon: const Icon(Icons.camera_alt, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery() {
    return Column(
      children: [
        if (_photos.isEmpty)
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF999999)),
                  const SizedBox(height: 8),
                  AppButton(
                    text: '+ Ajouter une photo',
                    onPressed: () => _addPhoto(),
                    variant: ButtonVariant.primary,
                    size: ButtonSize.sm,
                    icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._photos.map((photo) => _buildPhotoThumbnail(photo)),
              GestureDetector(
                onTap: () => _addPhoto(),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.add, color: Color(0xFF666666)),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String photo) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.photo, size: 32, color: Color(0xFF999999)),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _photos.remove(photo)),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _addPhoto() {
    // Simuler l'ajout d'une photo
    setState(() {
      _photos.add('photo_${_photos.length + 1}');
    });
  }

  void _saveObservation() {
    // Construire la localisation à partir des sélections
    String location = '';
    if (_selectedZone != null) {
      location = _selectedZone!;
    }
    if (_selectedNiveau != null) {
      location += location.isNotEmpty ? ' - $_selectedNiveau' : _selectedNiveau!;
    }
    if (_localController.text.isNotEmpty) {
      location += location.isNotEmpty ? ' - ${_localController.text}' : _localController.text;
    }
    if (location.isEmpty) {
      location = 'Non spécifiée';
    }

    final observation = Observation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      missionId: widget.missionId,
      description: _descriptionController.text,
      priority: _selectedPriority!,
      location: location,
      photos: _photos.length,
      isSynced: false,
      date: DateTime.now(),
    );

    widget.onSave(observation);
    Navigator.pop(context);
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
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _localController.dispose();
    super.dispose();
  }
}

