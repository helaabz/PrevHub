import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../models/mission_invoice.dart';

class MissionInvoicingView extends StatefulWidget {
  final String missionId;
  final bool isAssigned;

  const MissionInvoicingView({
    super.key,
    required this.missionId,
    this.isAssigned = false,
  });

  @override
  State<MissionInvoicingView> createState() => _MissionInvoicingViewState();
}

class _MissionInvoicingViewState extends State<MissionInvoicingView> {
  // Mock data
  final List<MissionInvoice> _invoices = [
    MissionInvoice(
      id: '1',
      missionId: 'mission1',
      invoiceNumber: 'FAC-2024-001',
      amount: 2250.00,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      submittedAt: DateTime.now().subtract(const Duration(days: 8)),
      validatedAt: DateTime.now().subtract(const Duration(days: 5)),
      status: InvoiceStatus.inPayment,
      pdfFileName: 'Facture_FAC-2024-001.pdf',
      isAdvancePayment: false,
    ),
    MissionInvoice(
      id: '2',
      missionId: 'mission1',
      invoiceNumber: 'FAC-2024-002',
      amount: 1125.00,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: InvoiceStatus.submitted,
      pdfFileName: 'Facture_FAC-2024-002.pdf',
      isAdvancePayment: true,
    ),
  ];

  Future<void> _refreshData() async {
    // TODO: Refresh invoices from backend
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isAssigned) ...[
            AppButton(
              text: 'Nouvelle facture',
              onPressed: _showCreateInvoiceModal,
              variant: ButtonVariant.primary,
              fullWidth: true,
              icon: const Icon(Icons.receipt, size: 18, color: Colors.white),
            ),
            const SizedBox(height: 24),
          ],
          if (!widget.isAssigned)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFF59E0B)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vous devez être assigné à la mission pour créer une facture.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.isAssigned) const SizedBox(height: 24),
          const Text(
            'Factures',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          if (_invoices.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune facture',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._invoices.map((invoice) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () => _showInvoiceDetails(invoice),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: invoice.status.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.receipt,
                                color: invoice.status.color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        invoice.invoiceNumber ?? 'Brouillon',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      if (invoice.isAdvancePayment) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF3B82F6)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Acompte',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF3B82F6),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_formatAmount(invoice.amount)} €',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: invoice.status.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                invoice.status.displayName,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: invoice.status.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Créée le ${_formatDate(invoice.createdAt)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (invoice.submittedAt != null) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.send_outlined,
                                size: 12,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Soumise le ${_formatDate(invoice.submittedAt!)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (invoice.status == InvoiceStatus.rejected &&
                            invoice.rejectionReason != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFDC2626).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 16,
                                  color: Color(0xFFDC2626),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Motif: ${invoice.rejectionReason}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFDC2626),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (invoice.status == InvoiceStatus.draft &&
                            widget.isAssigned) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Modifier',
                                  onPressed: () => _editInvoice(invoice),
                                  variant: ButtonVariant.outline,
                                  size: ButtonSize.sm,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppButton(
                                  text: 'Soumettre',
                                  onPressed: () => _submitInvoice(invoice),
                                  variant: ButtonVariant.primary,
                                  size: ButtonSize.sm,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
        ],
      ),
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateInvoiceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateInvoiceModal(
        missionId: widget.missionId,
        onCreate: (amount, isAdvancePayment, pdfFile, notes) {
          Navigator.pop(context);
          // TODO: Create invoice
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Facture créée avec succès'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  void _editInvoice(MissionInvoice invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateInvoiceModal(
        missionId: widget.missionId,
        invoice: invoice,
        onCreate: (amount, isAdvancePayment, pdfFile, notes) {
          Navigator.pop(context);
          // TODO: Update invoice
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Facture modifiée avec succès'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  void _submitInvoice(MissionInvoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Soumettre la facture ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Facture: ${invoice.invoiceNumber ?? "Brouillon"}'),
            const SizedBox(height: 8),
            Text('Montant: ${_formatAmount(invoice.amount)} €'),
            const SizedBox(height: 12),
            const Text(
              'La facture sera envoyée au siège pour validation. Vous ne pourrez plus la modifier après soumission.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          AppButton(
            text: 'Soumettre',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Submit invoice
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Facture soumise avec succès'),
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

  void _showInvoiceDetails(MissionInvoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(invoice.invoiceNumber ?? 'Facture'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Montant', '${_formatAmount(invoice.amount)} €'),
              _buildDetailRow('Statut', invoice.status.displayName),
              if (invoice.isAdvancePayment)
                _buildDetailRow('Type', 'Acompte'),
              if (invoice.createdAt != null)
                _buildDetailRow(
                    'Créée le', _formatDate(invoice.createdAt)),
              if (invoice.submittedAt != null)
                _buildDetailRow(
                    'Soumise le', _formatDate(invoice.submittedAt!)),
              if (invoice.validatedAt != null)
                _buildDetailRow(
                    'Validée le', _formatDate(invoice.validatedAt!)),
              if (invoice.paidAt != null)
                _buildDetailRow('Payée le', _formatDate(invoice.paidAt!)),
              if (invoice.pdfFileName != null)
                _buildDetailRow('Fichier PDF', invoice.pdfFileName!),
              if (invoice.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Motif de rejet:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invoice.rejectionReason!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
              if (invoice.notes != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Notes', invoice.notes!),
              ],
            ],
          ),
        ),
        actions: [
          if (invoice.pdfFileName != null)
            TextButton.icon(
              onPressed: () {
                // TODO: Open PDF
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ouverture du PDF...'),
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Voir le PDF'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modal pour créer/modifier une facture
class _CreateInvoiceModal extends StatefulWidget {
  final String missionId;
  final MissionInvoice? invoice;
  final Function(double, bool, String?, String?) onCreate;

  const _CreateInvoiceModal({
    required this.missionId,
    this.invoice,
    required this.onCreate,
  });

  @override
  State<_CreateInvoiceModal> createState() => _CreateInvoiceModalState();
}

class _CreateInvoiceModalState extends State<_CreateInvoiceModal> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isAdvancePayment = false;
  String? _pdfFileName;
  String? _pdfFilePath;

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      _amountController.text = widget.invoice!.amount.toStringAsFixed(2);
      _notesController.text = widget.invoice!.notes ?? '';
      _isAdvancePayment = widget.invoice!.isAdvancePayment;
      _pdfFileName = widget.invoice!.pdfFileName;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
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
                    Text(
                      widget.invoice == null
                          ? 'Nouvelle facture'
                          : 'Modifier la facture',
                      style: const TextStyle(
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
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Montant (€)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixText: '€ ',
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
                              color: Color(0xFFFF4D3D),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _isAdvancePayment,
                        onChanged: (value) {
                          setState(() {
                            _isAdvancePayment = value ?? false;
                          });
                        },
                        title: const Text('Acompte'),
                        subtitle: const Text(
                          'Cocher si cette facture est un acompte',
                          style: TextStyle(fontSize: 12),
                        ),
                        activeColor: const Color(0xFFFF4D3D),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Facture PDF',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_pdfFileName != null)
                        AppCard(
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf,
                                  color: Color(0xFFDC2626)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _pdfFileName!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _pdfFileName = null;
                                    _pdfFilePath = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      else
                        AppButton(
                          text: '📎 Téléverser le PDF',
                          onPressed: _uploadPDF,
                          variant: ButtonVariant.outline,
                          fullWidth: true,
                          icon: const Icon(Icons.upload_file,
                              size: 18, color: Color(0xFFFF4D3D)),
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        'Vous pouvez téléverser un PDF de facture généré via votre outil externe, ou le générer directement depuis l\'application.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Notes (optionnel)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Ajoutez des notes ou commentaires...',
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
                              color: Color(0xFFFF4D3D),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Mission: #${widget.missionId}',
                                style: const TextStyle(
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
                child: Row(
                  children: [
                    if (widget.invoice == null)
                      Expanded(
                        child: AppButton(
                          text: 'Enregistrer comme brouillon',
                          onPressed: _saveAsDraft,
                          variant: ButtonVariant.outline,
                        ),
                      ),
                    if (widget.invoice == null) const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        text: widget.invoice == null
                            ? 'Créer et soumettre'
                            : 'Enregistrer',
                        onPressed: _validateAndCreate,
                        variant: ButtonVariant.primary,
                      ),
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

  Future<void> _uploadPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _pdfFileName = file.name;
          _pdfFilePath = file.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du téléversement: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  void _saveAsDraft() {
    final amount = double.tryParse(_amountController.text.replaceAll(' ', ''));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un montant valide'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    widget.onCreate(amount, _isAdvancePayment, _pdfFilePath, _notesController.text.isEmpty ? null : _notesController.text);
  }

  void _validateAndCreate() {
    final amount = double.tryParse(_amountController.text.replaceAll(' ', ''));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un montant valide'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    if (_pdfFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez téléverser un PDF de facture'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    widget.onCreate(amount, _isAdvancePayment, _pdfFilePath, _notesController.text.isEmpty ? null : _notesController.text);
  }
}

