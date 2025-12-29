import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../widgets/app_button.dart';

class PdfViewerWithAnnotations extends StatefulWidget {
  final String documentName;
  final String documentId;
  final String missionId;

  const PdfViewerWithAnnotations({
    super.key,
    required this.documentName,
    required this.documentId,
    required this.missionId,
  });

  @override
  State<PdfViewerWithAnnotations> createState() => _PdfViewerWithAnnotationsState();
}

// Modèle pour les annotations
class Annotation {
  final String id;
  final String tool;
  final String layer;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final DateTime timestamp;

  Annotation({
    required this.id,
    required this.tool,
    required this.layer,
    required this.points,
    required this.color,
    required this.strokeWidth,
    required this.timestamp,
  });
}

class _PdfViewerWithAnnotationsState extends State<PdfViewerWithAnnotations> {
  String _selectedTool = 'crayon';
  bool _toolbarVisible = true;
  String _selectedLayer = 'brouillon';
  int _currentPage = 1;
  int _totalPages = 1;
  PdfViewerController? _pdfViewerController;
  String? _pdfPath;
  bool _isLoading = false;
  
  // Gestion des annotations
  final List<Annotation> _annotations = [];
  List<Offset> _currentPoints = [];
  bool _isDrawing = false;
  
  // Couleurs par outil
  Color get _toolColor {
    switch (_selectedTool) {
      case 'crayon':
        return const Color(0xFF3B82F6);
      case 'rectangle':
        return const Color(0xFFDC2626);
      case 'fleche':
        return const Color(0xFF10B981);
      case 'surligneur':
        return const Color(0xFFFFE66D);
      case 'repere':
        return const Color(0xFFF59E0B);
      case 'note':
        return const Color(0xFF8B5CF6);
      case 'point':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF3B82F6);
    }
  }
  
  double get _strokeWidth {
    switch (_selectedTool) {
      case 'crayon':
        return 2.0;
      case 'surligneur':
        return 15.0;
      case 'point':
        return 8.0;
      default:
        return 3.0;
    }
  }
  
  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadPdfFromAssets();
  }
  
  Future<void> _loadPdfFromAssets() async {
    // Essayer de charger un PDF depuis les assets
    // Si aucun PDF n'est trouvé, on peut en sélectionner un
    setState(() {
      _isLoading = true;
    });
    
    // Pour l'instant, on attend qu'un PDF soit sélectionné
    setState(() {
      _isLoading = false;
    });
  }
  
  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      
      if (result != null && result.files.single.path != null) {
        setState(() {
          _pdfPath = result.files.single.path;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection du PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.documentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (_pdfPath != null)
                            Text(
                              'Page $_currentPage/$_totalPages',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            )
                          else
                            const Text(
                              'Aucun PDF chargé',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (_pdfPath == null)
                          IconButton(
                            icon: const Icon(Icons.upload_file, color: Color(0xFF3B82F6)),
                            onPressed: _pickPdfFile,
                            tooltip: 'Charger un PDF',
                          ),
                        IconButton(
                          icon: Icon(
                            _toolbarVisible ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF666666),
                          ),
                          onPressed: () {
                            setState(() {
                              _toolbarVisible = !_toolbarVisible;
                            });
                          },
                          tooltip: _toolbarVisible ? 'Masquer la toolbar' : 'Afficher la toolbar',
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF999999)),
                          onPressed: () {
                            // Retourner true si des annotations ont été créées
                            Navigator.pop(context, _annotations.isNotEmpty);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Toolbar d'annotation
              if (_toolbarVisible) _buildAnnotationToolbar(),
              // Visualiseur PDF avec annotations
              Expanded(
                child: _buildPDFViewer(),
              ),
              // Barre de navigation
              _buildNavigationBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnnotationToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Outils d'annotation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildToolButton('crayon', Icons.edit, 'Crayon'),
                const SizedBox(width: 8),
                _buildToolButton('rectangle', Icons.crop_free, 'Rectangle'),
                const SizedBox(width: 8),
                _buildToolButton('fleche', Icons.arrow_forward, 'Flèche'),
                const SizedBox(width: 8),
                _buildToolButton('surligneur', Icons.format_color_fill, 'Surligneur'),
                const SizedBox(width: 8),
                _buildToolButton('repere', Icons.tag, 'Repère'),
                const SizedBox(width: 8),
                _buildToolButton('note', Icons.note_add, 'Note'),
                const SizedBox(width: 8),
                _buildToolButton('point', Icons.location_on, 'Point'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Sélection de couche
          Row(
            children: [
              const Text(
                'Couche:',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              const SizedBox(width: 8),
              _buildLayerChip('brouillon', 'Brouillon'),
              const SizedBox(width: 6),
              _buildLayerChip('partage', 'Partagé'),
              const SizedBox(width: 6),
              _buildLayerChip('final', 'Final'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String tool, IconData icon, String label) {
    final isSelected = _selectedTool == tool;
    return GestureDetector(
      onTap: () => setState(() => _selectedTool = tool),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF666666),
            ),
            const SizedBox(width: 6),
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

  Widget _buildLayerChip(String layer, String label) {
    final isSelected = _selectedLayer == layer;
    return GestureDetector(
      onTap: () => setState(() => _selectedLayer = layer),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981).withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildPDFViewer() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_pdfPath == null) {
      return Container(
        color: Colors.grey.shade100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24),
              const Text(
                'Aucun PDF chargé',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cliquez sur l\'icône de chargement pour\nsélectionner un PDF de test',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Charger un PDF',
                onPressed: _pickPdfFile,
                variant: ButtonVariant.primary,
                icon: const Icon(Icons.upload_file, size: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      color: Colors.grey.shade200,
      child: Stack(
        children: [
          // Visualiseur PDF réel
          SfPdfViewer.file(
            File(_pdfPath!),
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _totalPages = details.document.pages.count;
              });
            },
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                _currentPage = details.newPageNumber;
                // Filtrer les annotations pour la page actuelle
              });
            },
          ),
          // Overlay pour les annotations
          Positioned.fill(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _isDrawing = true;
                  _currentPoints = [details.localPosition];
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  if (_currentPoints.isNotEmpty) {
                    final annotation = Annotation(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      tool: _selectedTool,
                      layer: _selectedLayer,
                      points: List.from(_currentPoints),
                      color: _toolColor,
                      strokeWidth: _strokeWidth,
                      timestamp: DateTime.now(),
                    );
                    _annotations.add(annotation);
                    _currentPoints.clear();
                    _isDrawing = false;
                  }
                });
              },
              child: CustomPaint(
                painter: AnnotationPainter(
                  annotations: _annotations,
                  currentPoints: _currentPoints,
                  isDrawing: _isDrawing,
                  currentTool: _selectedTool,
                  currentColor: _toolColor,
                  currentStrokeWidth: _strokeWidth,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Color(0xFF666666)),
            onPressed: _pdfPath != null
                ? () {
                    _pdfViewerController?.zoomLevel = (_pdfViewerController?.zoomLevel ?? 1.0) - 0.25;
                  }
                : null,
            tooltip: 'Zoom -',
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF666666)),
                onPressed: _pdfPath != null && _currentPage > 1
                    ? () {
                        _pdfViewerController?.previousPage();
                      }
                    : null,
              ),
              Text(
                _pdfPath != null ? '$_currentPage / $_totalPages' : '- / -',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF666666)),
                onPressed: _pdfPath != null && _currentPage < _totalPages
                    ? () {
                        _pdfViewerController?.nextPage();
                      }
                    : null,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Color(0xFF666666)),
            onPressed: _pdfPath != null
                ? () {
                    _pdfViewerController?.zoomLevel = (_pdfViewerController?.zoomLevel ?? 1.0) + 0.25;
                  }
                : null,
            tooltip: 'Zoom +',
          ),
        ],
      ),
    );
  }
}

// CustomPainter pour dessiner les annotations
class AnnotationPainter extends CustomPainter {
  final List<Annotation> annotations;
  final List<Offset> currentPoints;
  final bool isDrawing;
  final String currentTool;
  final Color currentColor;
  final double currentStrokeWidth;

  AnnotationPainter({
    required this.annotations,
    required this.currentPoints,
    required this.isDrawing,
    required this.currentTool,
    required this.currentColor,
    required this.currentStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner les annotations existantes
    for (final annotation in annotations) {
      _drawAnnotation(canvas, annotation);
    }

    // Dessiner le trait en cours
    if (isDrawing && currentPoints.length > 1) {
      final paint = Paint()
        ..color = currentColor
        ..strokeWidth = currentStrokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (currentTool == 'surligneur') {
        paint.blendMode = BlendMode.multiply;
        paint.color = currentColor.withOpacity(0.3);
      }

      if (currentTool == 'crayon' || currentTool == 'surligneur') {
        // Dessiner une ligne libre
        final path = Path();
        path.moveTo(currentPoints[0].dx, currentPoints[0].dy);
        for (int i = 1; i < currentPoints.length; i++) {
          path.lineTo(currentPoints[i].dx, currentPoints[i].dy);
        }
        canvas.drawPath(path, paint);
      } else if (currentTool == 'rectangle' && currentPoints.length >= 2) {
        // Dessiner un rectangle
        final rect = Rect.fromPoints(currentPoints[0], currentPoints.last);
        canvas.drawRect(rect, paint);
      } else if (currentTool == 'point' && currentPoints.isNotEmpty) {
        // Dessiner un point
        canvas.drawCircle(currentPoints[0], currentStrokeWidth / 2, paint..style = PaintingStyle.fill);
      }
    }
  }

  void _drawAnnotation(Canvas canvas, Annotation annotation) {
    final paint = Paint()
      ..color = annotation.color
      ..strokeWidth = annotation.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (annotation.tool == 'surligneur') {
      paint.blendMode = BlendMode.multiply;
      paint.color = annotation.color.withOpacity(0.3);
    }

    if (annotation.points.isEmpty) return;

    switch (annotation.tool) {
      case 'crayon':
      case 'surligneur':
        // Ligne libre
        final path = Path();
        path.moveTo(annotation.points[0].dx, annotation.points[0].dy);
        for (int i = 1; i < annotation.points.length; i++) {
          path.lineTo(annotation.points[i].dx, annotation.points[i].dy);
        }
        canvas.drawPath(path, paint);
        break;

      case 'rectangle':
        if (annotation.points.length >= 2) {
          final rect = Rect.fromPoints(annotation.points[0], annotation.points.last);
          canvas.drawRect(rect, paint);
        }
        break;

      case 'fleche':
        if (annotation.points.length >= 2) {
          // Dessiner une flèche
          final start = annotation.points[0];
          final end = annotation.points.last;
          canvas.drawLine(start, end, paint);
          // Dessiner la pointe de la flèche
          _drawArrowHead(canvas, start, end, paint);
        }
        break;

      case 'point':
        canvas.drawCircle(
          annotation.points[0],
          annotation.strokeWidth / 2,
          paint..style = PaintingStyle.fill,
        );
        break;

      case 'repere':
        if (annotation.points.isNotEmpty) {
          // Dessiner un repère numéroté
          final point = annotation.points[0];
          canvas.drawCircle(point, 12, paint..style = PaintingStyle.fill);
          final textPainter = TextPainter(
            text: TextSpan(
              text: '#',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(point.dx - textPainter.width / 2, point.dy - textPainter.height / 2),
          );
        }
        break;
    }
  }

  void _drawArrowHead(Canvas canvas, Offset start, Offset end, Paint paint) {
    final angle = (end - start).direction;
    final arrowLength = 15.0;
    final arrowAngle = 0.5;

    final path = Path();
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowLength * math.cos(angle - arrowAngle),
      end.dy - arrowLength * math.sin(angle - arrowAngle),
    );
    path.lineTo(
      end.dx - arrowLength * math.cos(angle + arrowAngle),
      end.dy - arrowLength * math.sin(angle + arrowAngle),
    );
    path.close();
    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(AnnotationPainter oldDelegate) {
    return oldDelegate.annotations != annotations ||
        oldDelegate.currentPoints != currentPoints ||
        oldDelegate.isDrawing != isDrawing ||
        oldDelegate.currentTool != currentTool;
  }
}

