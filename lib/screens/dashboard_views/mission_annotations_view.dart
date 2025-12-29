import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';

class MissionAnnotationsView extends StatefulWidget {
  final String missionId;

  const MissionAnnotationsView({
    super.key,
    required this.missionId,
  });

  @override
  State<MissionAnnotationsView> createState() => _MissionAnnotationsViewState();
}

class _MissionAnnotationsViewState extends State<MissionAnnotationsView> {
  String _selectedTool = 'crayon';
  bool _toolbarVisible = true;
  String _selectedLayer = 'brouillon';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar d'annotation
        if (_toolbarVisible) _buildAnnotationToolbar(),
        // Visualiseur PDF
        Expanded(
          child: _buildPDFViewer(),
        ),
        // Barre de navigation
        _buildNavigationBar(),
      ],
    );
  }

  Widget _buildAnnotationToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sélection de couche
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLayerButton('brouillon', 'Mes annotations', Icons.edit),
              _buildLayerButton('partage', 'Partagées', Icons.share),
              _buildLayerButton('finales', 'Finales', Icons.lock),
            ],
          ),
          const SizedBox(height: 12),
          // Outils d'annotation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildToolButton('crayon', Icons.edit, 'Crayon'),
                _buildToolButton('rectangle', Icons.crop_free, 'Rectangle'),
                _buildToolButton('fleche', Icons.arrow_forward, 'Flèche'),
                _buildToolButton('surligneur', Icons.highlight, 'Surligneur'),
                _buildToolButton('repere', Icons.tag, 'Repère'),
                _buildToolButton('note', Icons.comment, 'Note'),
                _buildToolButton('point', Icons.location_on, 'Point'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerButton(String layer, String label, IconData icon) {
    final isSelected = _selectedLayer == layer;
    return GestureDetector(
      onTap: () => setState(() => _selectedLayer = layer),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF666666)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(String tool, IconData icon, String label) {
    final isSelected = _selectedTool == tool;
    return GestureDetector(
      onTap: () => setState(() => _selectedTool = tool),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : const Color(0xFF666666)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? Colors.white : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFViewer() {
    return Container(
      color: Colors.grey.shade100,
      child: Stack(
        children: [
          // Aperçu PDF (simulé)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.picture_as_pdf, size: 64, color: Color(0xFFDC2626)),
                const SizedBox(height: 16),
                const Text(
                  'Visualiseur PDF',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pinch-to-zoom activé',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Page 3/12',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Miniatures sur le côté (swipe vertical)
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    height: 40,
                    decoration: BoxDecoration(
                      color: index == 2 ? const Color(0xFF3B82F6).withOpacity(0.2) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: index == 2 ? const Color(0xFF3B82F6) : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          color: index == 2 ? const Color(0xFF3B82F6) : const Color(0xFF666666),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {},
          ),
          Expanded(
            child: Center(
              child: Text(
                'Page 3 sur 12',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(_toolbarVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _toolbarVisible = !_toolbarVisible),
          ),
        ],
      ),
    );
  }
}

