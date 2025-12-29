class MissionEmail {
  final String id;
  final List<String> recipients;
  final String subject;
  final String? body;
  final DateTime sentAt;
  final EmailStatus status;
  final List<EmailAttachment> attachments;
  final String? contextMissionId;
  final String? contextProjectId;

  MissionEmail({
    required this.id,
    required this.recipients,
    required this.subject,
    this.body,
    required this.sentAt,
    required this.status,
    this.attachments = const [],
    this.contextMissionId,
    this.contextProjectId,
  });
}

enum EmailStatus {
  sent,
  failed,
  pending;

  String get displayName {
    switch (this) {
      case EmailStatus.sent:
        return 'Envoyé';
      case EmailStatus.failed:
        return 'Échec';
      case EmailStatus.pending:
        return 'En attente';
    }
  }
}

class EmailAttachment {
  final String id;
  final String name;
  final String type; // 'document', 'plan', 'report', etc.
  final String url;
  final String size;

  EmailAttachment({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.size,
  });
}

