import 'package:flutter/material.dart';

class MissionInvoice {
  final String id;
  final String missionId;
  final String? invoiceNumber;
  final double amount;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? validatedAt;
  final DateTime? paidAt;
  final InvoiceStatus status;
  final String? rejectionReason;
  final String? pdfUrl;
  final String? pdfFileName;
  final String? notes;
  final bool isAdvancePayment; // Acompte

  MissionInvoice({
    required this.id,
    required this.missionId,
    this.invoiceNumber,
    required this.amount,
    required this.createdAt,
    this.submittedAt,
    this.validatedAt,
    this.paidAt,
    required this.status,
    this.rejectionReason,
    this.pdfUrl,
    this.pdfFileName,
    this.notes,
    this.isAdvancePayment = false,
  });
}

enum InvoiceStatus {
  draft, // Brouillon (créée mais pas encore soumise)
  submitted, // Soumise
  validated, // Validée
  inPayment, // Mise en paiement
  paid, // Payée
  rejected; // Rejetée

  String get displayName {
    switch (this) {
      case InvoiceStatus.draft:
        return 'Brouillon';
      case InvoiceStatus.submitted:
        return 'Soumise';
      case InvoiceStatus.validated:
        return 'Validée';
      case InvoiceStatus.inPayment:
        return 'Mise en paiement';
      case InvoiceStatus.paid:
        return 'Payée';
      case InvoiceStatus.rejected:
        return 'Rejetée';
    }
  }

  Color get color {
    switch (this) {
      case InvoiceStatus.draft:
        return const Color(0xFF999999);
      case InvoiceStatus.submitted:
        return const Color(0xFF3B82F6);
      case InvoiceStatus.validated:
        return const Color(0xFF10B981);
      case InvoiceStatus.inPayment:
        return const Color(0xFFF59E0B);
      case InvoiceStatus.paid:
        return const Color(0xFF10B981);
      case InvoiceStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }
}

