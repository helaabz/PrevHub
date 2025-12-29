import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../widgets/app_button.dart';

class PurchaseOrderScreen extends StatefulWidget {
  final String purchaseOrderId;
  final String purchaseOrderDate;
  final String? fileUrl;

  const PurchaseOrderScreen({
    super.key,
    required this.purchaseOrderId,
    required this.purchaseOrderDate,
    this.fileUrl,
  });

  @override
  State<PurchaseOrderScreen> createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
  PdfViewerController? _pdfViewerController;
  String? _pdfPath;
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Remplacer par le chargement réel du PDF depuis l'URL ou le stockage
      // Pour l'instant, on charge un PDF depuis les assets
      // En production, vous devrez télécharger le PDF depuis widget.fileUrl
      
      // Exemple avec un fichier local (à remplacer par le vrai chargement)
      // _pdfPath = widget.fileUrl ?? 'assets/pdfs/sample.pdf';
      
      // Pour la démo, on simule un chargement
      await Future.delayed(const Duration(milliseconds: 500));
      
      // En production, utilisez quelque chose comme :
      // if (widget.fileUrl != null) {
      //   final file = await downloadFile(widget.fileUrl!);
      //   _pdfPath = file.path;
      // } else {
      //   _pdfPath = 'assets/pdfs/default_purchase_order.pdf';
      // }
      
      // Pour la démo, on utilise le PDF existant dans les assets
      // En production, remplacez par le chargement depuis widget.fileUrl
      _pdfPath = 'assets/pdfs/Appli Prev\'hub workflow préventionniste.pdf';
      
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement du PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pdfViewerController?.dispose();
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
            const Text(
              'Bon de commande',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              widget.purchaseOrderId,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Color(0xFF666666)),
            onPressed: _downloadPdf,
            tooltip: 'Télécharger',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF666666)),
            onPressed: _sharePdf,
            tooltip: 'Partager',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre d'information
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFFFF4D3D),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Généré le ${widget.purchaseOrderDate}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      if (_totalPages > 1)
                        Text(
                          'Page $_currentPage sur $_totalPages',
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
          ),
          // Viewer PDF
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF4D3D),
                    ),
                  )
                : _pdfPath != null
                    ? SfPdfViewer.asset(
                        _pdfPath!,
                        controller: _pdfViewerController,
                        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                          setState(() {
                            _totalPages = details.document.pages.count;
                            _currentPage = 1;
                          });
                        },
                        onPageChanged: (PdfPageChangedDetails details) {
                          setState(() {
                            _currentPage = details.newPageNumber;
                          });
                        },
                        enableDoubleTapZooming: true,
                        enableTextSelection: true,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Color(0xFF999999),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Document introuvable',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Le bon de commande n\'a pas pu être chargé.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              text: 'Réessayer',
                              onPressed: _loadPdf,
                              variant: ButtonVariant.outline,
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _downloadPdf() {
    // TODO: Implémenter le téléchargement réel du PDF
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Téléchargement du bon de commande ${widget.purchaseOrderId}'),
        backgroundColor: const Color(0xFF10B981),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _sharePdf() {
    // TODO: Implémenter le partage du PDF
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de partage à venir'),
        backgroundColor: Color(0xFF666666),
      ),
    );
  }
}

