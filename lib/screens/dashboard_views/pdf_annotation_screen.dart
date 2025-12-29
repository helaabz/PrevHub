import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import '../../widgets/app_button.dart';

/// Point d'annotation sur le PDF
class PdfAnnotationPoint {
  final double x;
  final double y;
  final int pageIndex;
  
  PdfAnnotationPoint({
    required this.x,
    required this.y,
    required this.pageIndex,
  });
  
  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'pageIndex': pageIndex,
  };
}

class PdfAnnotationScreen extends StatefulWidget {
  final String pdfPath;
  final Function(PdfAnnotationPoint?)? onPointSelected;
  
  const PdfAnnotationScreen({
    super.key,
    required this.pdfPath,
    this.onPointSelected,
  });

  @override
  State<PdfAnnotationScreen> createState() => _PdfAnnotationScreenState();
}

class _PdfAnnotationScreenState extends State<PdfAnnotationScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey _pdfViewerKey = GlobalKey();
  final List<PdfAnnotationPoint> _annotationPoints = [];
  PdfAnnotationPoint? _selectedPoint;
  bool _isPointMode = true; // Mode point activé par défaut
  Offset? _pointerDownPosition;
  bool _isScrolling = false;
  int _currentPageNumber = 1;
  double _scrollOffset = 0.0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context, _selectedPoint),
        ),
        title: const Text(
          'Repérage sur plan PDF',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        actions: [
          // Bouton pour activer/désactiver le mode point
          IconButton(
            icon: Icon(
              _isPointMode ? Icons.edit_location_alt : Icons.edit_location_alt_outlined,
              color: _isPointMode ? const Color(0xFFE63900) : const Color(0xFF666666),
            ),
            onPressed: () {
              setState(() {
                _isPointMode = !_isPointMode;
              });
            },
            tooltip: _isPointMode ? 'Désactiver le mode point' : 'Activer le mode point',
          ),
          // Bouton pour supprimer le point sélectionné
          if (_selectedPoint != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Color(0xFFDC2626)),
              onPressed: () {
                setState(() {
                  _annotationPoints.remove(_selectedPoint);
                  _selectedPoint = null;
                });
              },
              tooltip: 'Supprimer le point',
            ),
        ],
      ),
      body: Stack(
        children: [
          // Visualiseur PDF avec scroll activé
          GestureDetector(
            onTapDown: _isPointMode ? (details) {
              // Utiliser un timer pour distinguer tap vs scroll
              Future.delayed(const Duration(milliseconds: 150), () {
                if (mounted && !_isScrolling) {
                  _handleTap(details.localPosition);
                }
              });
            } : null,
            onPanStart: _isPointMode ? (details) {
              _isScrolling = true;
            } : null,
            onPanEnd: _isPointMode ? (details) {
              Future.delayed(const Duration(milliseconds: 100), () {
                _isScrolling = false;
              });
            } : null,
            behavior: HitTestBehavior.translucent,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  setState(() {
                    _scrollOffset = notification.metrics.pixels;
                    _currentPageNumber = _pdfViewerController.pageNumber;
                  });
                }
                return false;
              },
              child: SfPdfViewer.file(
                File(widget.pdfPath),
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                enableDoubleTapZooming: true,
                enableTextSelection: false,
                scrollDirection: PdfScrollDirection.vertical,
                onPageChanged: (details) {
                  setState(() {
                    _currentPageNumber = details.newPageNumber;
                  });
                },
                onDocumentLoadFailed: (details) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors du chargement du PDF: ${details.error}'),
                      backgroundColor: const Color(0xFFDC2626),
                    ),
                  );
                },
              ),
            ),
          ),
          // Overlay pour afficher les points d'annotation
          if (_annotationPoints.isNotEmpty)
            ..._annotationPoints.map((point) => _buildAnnotationPoint(point)),
          // Instructions en bas
          if (_isPointMode)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE63900).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Appuyez sur le plan pour placer un point',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
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
          children: [
            Expanded(
              child: AppButton(
                text: 'Annuler',
                onPressed: () => Navigator.pop(context),
                variant: ButtonVariant.outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: _selectedPoint != null ? 'Confirmer' : 'Sélectionner un point',
                onPressed: _selectedPoint != null
                    ? () => Navigator.pop(context, _selectedPoint)
                    : null,
                variant: ButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleTap(Offset position) {
    if (!_isPointMode) return;
    
    // Obtenir le numéro de page actuel depuis le contrôleur
    final currentPage = _pdfViewerController.pageNumber;
    
    // Obtenir la position relative à la page visible
    // On stocke la position relative à la page (y relatif au début de la page visible)
    final RenderBox? renderBox = _pdfViewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    // Calculer la position relative à la page
    // Pour une page, on suppose que chaque page a une hauteur d'environ 800 pixels (à ajuster selon votre PDF)
    // La position y relative à la page = position.y - (scrollOffset % hauteurPage)
    const double estimatedPageHeight = 800.0; // Hauteur estimée d'une page
    final double pageRelativeY = position.dy + _scrollOffset;
    final double pageRelativeX = position.dx;
    
    final point = PdfAnnotationPoint(
      x: pageRelativeX,
      y: pageRelativeY,
      pageIndex: currentPage > 0 ? currentPage - 1 : 0, // Les pages commencent à 1
    );
    
    setState(() {
      _annotationPoints.add(point);
      _selectedPoint = point;
    });
    
    // Afficher la vue de confirmation après le pointage
    _showPointDetailsModal(point);
  }
  
  void _showPointDetailsModal(PdfAnnotationPoint point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PointDetailsModal(
        point: point,
        onConfirm: () {
          Navigator.pop(context); // Fermer la modale
          // Le point est déjà sélectionné, l'utilisateur peut confirmer depuis le bouton en bas
        },
        onCancel: () {
          setState(() {
            _annotationPoints.remove(point);
            if (_selectedPoint == point) {
              _selectedPoint = _annotationPoints.isNotEmpty ? _annotationPoints.last : null;
            }
          });
          Navigator.pop(context); // Fermer la modale
        },
        onModify: () {
          Navigator.pop(context); // Fermer la modale
          // L'utilisateur peut déplacer le point ou en placer un nouveau
          setState(() {
            _annotationPoints.remove(point);
            if (_selectedPoint == point) {
              _selectedPoint = null;
            }
          });
        },
      ),
    );
  }
  
  Widget _buildAnnotationPoint(PdfAnnotationPoint point) {
    final isSelected = _selectedPoint == point;
    
    // Vérifier si le point est sur la page actuellement visible
    final pointPageNumber = point.pageIndex + 1;
    if (pointPageNumber != _currentPageNumber) {
      // Le point n'est pas sur la page visible, ne pas l'afficher
      return const SizedBox.shrink();
    }
    
    // Calculer la position d'affichage en fonction du scroll
    const double estimatedPageHeight = 800.0; // Hauteur estimée d'une page
    final double displayY = point.y - _scrollOffset;
    final double displayX = point.x;
    
    // Vérifier si le point est visible à l'écran
    final screenHeight = MediaQuery.of(context).size.height;
    if (displayY < -50 || displayY > screenHeight + 50) {
      return const SizedBox.shrink();
    }
    
    return Positioned(
      left: displayX - 12,
      top: displayY - 12,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPoint = point;
          });
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE63900) : const Color(0xFFDC2626),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}

/// Modale pour afficher les détails du point après le pointage
class _PointDetailsModal extends StatelessWidget {
  final PdfAnnotationPoint point;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onModify;

  const _PointDetailsModal({
    required this.point,
    required this.onConfirm,
    required this.onCancel,
    required this.onModify,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE63900).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFFE63900),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Point placé',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Vérifiez les informations du point',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        icon: Icons.description,
                        label: 'Page',
                        value: 'Page ${point.pageIndex + 1}',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.my_location,
                        label: 'Position X',
                        value: '${point.x.toStringAsFixed(0)} px',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.my_location,
                        label: 'Position Y',
                        value: '${point.y.toStringAsFixed(0)} px',
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63900).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE63900).withOpacity(0.2),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFFE63900),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Le point a été placé sur le plan. Vous pouvez le modifier ou le confirmer.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Actions
              Container(
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  children: [
                    AppButton(
                      text: 'Confirmer ce point',
                      onPressed: onConfirm,
                      variant: ButtonVariant.primary,
                      fullWidth: true,
                      icon: const Icon(Icons.check, size: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Modifier',
                            onPressed: onModify,
                            variant: ButtonVariant.outline,
                            icon: const Icon(Icons.edit, size: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: 'Supprimer',
                            onPressed: onCancel,
                            variant: ButtonVariant.outline,
                            icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFDC2626)),
                          ),
                        ),
                      ],
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF666666)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

