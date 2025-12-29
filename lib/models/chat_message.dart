class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderRole; // 'preventionniste', 'siege', 'client'
  final String content;
  final DateTime timestamp;
  final List<ChatAttachment>? attachments;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.content,
    required this.timestamp,
    this.attachments,
    this.isRead = false,
  });
}

class ChatAttachment {
  final String id;
  final String name;
  final String type; // 'image', 'document', 'plan'
  final String url;
  final String? size;

  ChatAttachment({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    this.size,
  });
}

