import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../models/chat_message.dart';
import '../../models/mission_email.dart';
import '../../models/mission_visio.dart';

class MissionExchangesView extends StatefulWidget {
  final String missionId;
  final bool isAssigned;

  const MissionExchangesView({
    super.key,
    required this.missionId,
    this.isAssigned = false,
  });

  @override
  State<MissionExchangesView> createState() => _MissionExchangesViewState();
}

class _MissionExchangesViewState extends State<MissionExchangesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _chatMessageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  Future<void> _refreshData() async {
    // TODO: Refresh exchanges data from backend
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Mock data
  final List<ChatMessage> _chatMessages = [
    ChatMessage(
      id: '1',
      senderId: 'siege1',
      senderName: 'Marie Dupont',
      senderRole: 'siege',
      content: 'Bonjour, avez-vous des questions sur la mission ?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    ChatMessage(
      id: '2',
      senderId: 'prev1',
      senderName: 'Vous',
      senderRole: 'preventionniste',
      content: 'Oui, j\'aimerais savoir si je peux accéder au site le week-end.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      senderId: 'siege1',
      senderName: 'Marie Dupont',
      senderRole: 'siege',
      content: 'Oui, c\'est possible. Je vous envoie les autorisations.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      isRead: true,
      attachments: [
        ChatAttachment(
          id: 'att1',
          name: 'Autorisation_accès.pdf',
          type: 'document',
          url: '',
          size: '125 KB',
        ),
      ],
    ),
  ];

  final List<MissionEmail> _emails = [
    MissionEmail(
      id: '1',
      recipients: ['marie.dupont@preveris.fr'],
      subject: 'Question sur les équipements requis',
      body: 'Bonjour, j\'aimerais confirmer la liste des EPI nécessaires...',
      sentAt: DateTime.now().subtract(const Duration(days: 2)),
      status: EmailStatus.sent,
      contextMissionId: 'mission1',
    ),
    MissionEmail(
      id: '2',
      recipients: ['j.martin@client.fr'],
      subject: 'Rapport d\'avancement - Mission #123',
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      status: EmailStatus.sent,
      attachments: [
        EmailAttachment(
          id: 'att1',
          name: 'Rapport_avancement.pdf',
          type: 'report',
          url: '',
          size: '2.3 MB',
        ),
      ],
      contextMissionId: 'mission1',
    ),
  ];

  final List<MissionVisio> _visios = [
    MissionVisio(
      id: '1',
      missionId: 'mission1',
      participants: [
        VisioParticipant(
          id: 'p1',
          name: 'Marie Dupont',
          role: 'siege',
          email: 'marie.dupont@preveris.fr',
        ),
        VisioParticipant(
          id: 'p2',
          name: 'Vous',
          role: 'preventionniste',
        ),
      ],
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
      status: VisioStatus.scheduled,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatMessageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFFF4D3D),
            unselectedLabelColor: const Color(0xFF999999),
            indicatorColor: const Color(0xFFFF4D3D),
            tabs: const [
              Tab(text: 'Chat'),
              Tab(text: 'Visio'),
              Tab(text: 'Emails'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildChatTab(),
              _buildVisioTab(),
              _buildEmailsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              controller: _chatScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              final message = _chatMessages[index];
              final isMe = message.senderRole == 'preventionniste';
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe) ...[
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: _getSenderColor(message.senderRole)
                            .withOpacity(0.2),
                        child: Icon(
                          _getSenderIcon(message.senderRole),
                          size: 16,
                          color: _getSenderColor(message.senderRole),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFFFF4D3D)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isMe)
                                  Text(
                                    message.senderName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isMe
                                          ? Colors.white
                                          : const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                if (!isMe) const SizedBox(height: 4),
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isMe
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                if (message.attachments != null &&
                                    message.attachments!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  ...message.attachments!.map((att) =>
                                      _buildAttachmentChip(att, isMe)),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(message.timestamp),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFFFF4D3D).withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          size: 16,
                          color: Color(0xFFFF4D3D),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: Color(0xFF666666)),
                onPressed: _attachFile,
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Color(0xFF666666)),
                onPressed: _attachPhoto,
              ),
              Expanded(
                child: TextField(
                  controller: _chatMessageController,
                  decoration: InputDecoration(
                    hintText: 'Tapez votre message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF4D3D),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFFFF4D3D)),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisioTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isAssigned)
            AppButton(
              text: 'Lancer une visio',
              onPressed: _showStartVisioModal,
              variant: ButtonVariant.primary,
              fullWidth: true,
              icon: const Icon(Icons.videocam, size: 18, color: Colors.white),
            ),
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
                      'Vous devez être assigné à la mission pour lancer une visio.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          const Text(
            'Visios planifiées',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          if (_visios.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.videocam_outlined,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune visio planifiée',
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
            ..._visios.map((visio) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.videocam,
                                color: Color(0xFF3B82F6),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatDate(visio.scheduledAt),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${visio.participants.length} participant(s)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
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
                                color: _getVisioStatusColor(visio.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                visio.status.displayName,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getVisioStatusColor(visio.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (visio.status == VisioStatus.scheduled &&
                            widget.isAssigned) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Rejoindre',
                                  onPressed: () => _joinVisio(visio),
                                  variant: ButtonVariant.primary,
                                  size: ButtonSize.sm,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppButton(
                                  text: 'Annuler',
                                  onPressed: () => _cancelVisio(visio),
                                  variant: ButtonVariant.outline,
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

  Widget _buildEmailsTab() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isAssigned)
                  AppButton(
                    text: 'Nouvel email',
                    onPressed: _showComposeEmailModal,
                    variant: ButtonVariant.primary,
                    fullWidth: true,
                    icon: const Icon(Icons.email, size: 18, color: Colors.white),
                  ),
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
                            'Vous devez être assigné à la mission pour envoyer des emails.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Emails envoyés',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                if (_emails.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun email envoyé',
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
                  ..._emails.map((email) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          onTap: () => _showEmailDetails(email),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.email,
                                      color: Color(0xFF3B82F6),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          email.subject,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1A1A1A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          email.recipients.join(', '),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF666666),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                      color: _getEmailStatusColor(email.status)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      email.status.displayName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: _getEmailStatusColor(email.status),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDateTime(email.sentAt),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (email.attachments.isNotEmpty) ...[
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.attach_file,
                                      size: 12,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${email.attachments.length} pièce(s) jointe(s)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
              ],
            ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentChip(ChatAttachment att, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMe
            ? Colors.white.withOpacity(0.2)
            : const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getAttachmentIcon(att.type),
            size: 14,
            color: isMe ? Colors.white : const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 4),
          Text(
            att.name,
            style: TextStyle(
              fontSize: 11,
              color: isMe ? Colors.white : const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAttachmentIcon(String type) {
    switch (type) {
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      case 'plan':
        return Icons.map;
      default:
        return Icons.attach_file;
    }
  }

  IconData _getSenderIcon(String role) {
    switch (role) {
      case 'siege':
        return Icons.business;
      case 'client':
        return Icons.person;
      default:
        return Icons.person;
    }
  }

  Color _getSenderColor(String role) {
    switch (role) {
      case 'siege':
        return Colors.blue;
      case 'client':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getVisioStatusColor(VisioStatus status) {
    switch (status) {
      case VisioStatus.scheduled:
        return const Color(0xFF3B82F6);
      case VisioStatus.inProgress:
        return const Color(0xFF10B981);
      case VisioStatus.completed:
        return const Color(0xFF666666);
      case VisioStatus.cancelled:
        return const Color(0xFFDC2626);
    }
  }

  Color _getEmailStatusColor(EmailStatus status) {
    switch (status) {
      case EmailStatus.sent:
        return const Color(0xFF10B981);
      case EmailStatus.failed:
        return const Color(0xFFDC2626);
      case EmailStatus.pending:
        return const Color(0xFFF59E0B);
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hier à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return _formatDate(dateTime);
    }
  }

  Future<void> _attachFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'xlsx', 'jpg', 'png'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        // TODO: Handle file attachment
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fichier sélectionné: ${result.files.first.name}'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<void> _attachPhoto() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // TODO: Handle photo attachment
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo capturée'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  void _sendMessage() {
    if (_chatMessageController.text.trim().isEmpty) return;

    setState(() {
      _chatMessages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'prev1',
          senderName: 'Vous',
          senderRole: 'preventionniste',
          content: _chatMessageController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
      _chatMessageController.clear();
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showStartVisioModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StartVisioModal(
        missionId: widget.missionId,
        onStart: (participants) {
          Navigator.pop(context);
          // TODO: Start visio
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Visio lancée avec succès'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  void _joinVisio(MissionVisio visio) {
    // TODO: Join visio
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion à la visio...'),
        backgroundColor: Color(0xFF3B82F6),
      ),
    );
  }

  void _cancelVisio(MissionVisio visio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la visio ?'),
        content: const Text('Êtes-vous sûr de vouloir annuler cette visio ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          AppButton(
            text: 'Oui, annuler',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Cancel visio
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Visio annulée'),
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

  void _showComposeEmailModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ComposeEmailModal(
        missionId: widget.missionId,
        onSend: (recipients, subject, body, attachments) {
          Navigator.pop(context);
          // TODO: Send email
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email envoyé avec succès'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  void _showEmailDetails(MissionEmail email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(email.subject),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('À: ${email.recipients.join(', ')}'),
              const SizedBox(height: 8),
              Text('Envoyé le: ${_formatDateTime(email.sentAt)}'),
              const SizedBox(height: 8),
              Text('Statut: ${email.status.displayName}'),
              if (email.body != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(email.body!),
              ],
              if (email.attachments.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Pièces jointes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...email.attachments.map((att) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file, size: 16),
                          const SizedBox(width: 4),
                          Text(att.name),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// Modal pour lancer une visio
class _StartVisioModal extends StatefulWidget {
  final String missionId;
  final Function(List<VisioParticipant>) onStart;

  const _StartVisioModal({
    required this.missionId,
    required this.onStart,
  });

  @override
  State<_StartVisioModal> createState() => _StartVisioModalState();
}

class _StartVisioModalState extends State<_StartVisioModal> {
  final List<VisioParticipant> _availableParticipants = [
    VisioParticipant(
      id: 'p1',
      name: 'Marie Dupont',
      role: 'siege',
      email: 'marie.dupont@preveris.fr',
    ),
    VisioParticipant(
      id: 'p2',
      name: 'Jean Martin',
      role: 'client',
      email: 'j.martin@client.fr',
    ),
  ];

  final Set<String> _selectedParticipantIds = {};
  bool _isScheduled = false;
  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
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
                      'Lancer une visio',
                      style: TextStyle(
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
                      // Toggle pour planifier ou lancer maintenant
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isScheduled = false;
                                    _scheduledDate = null;
                                    _scheduledTime = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: !_isScheduled ? const Color(0xFFFF4D3D) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Lancer maintenant',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: !_isScheduled ? Colors.white : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isScheduled = true;
                                    _scheduledDate = DateTime.now();
                                    _scheduledTime = TimeOfDay.now();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _isScheduled ? const Color(0xFFFF4D3D) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Planifier',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _isScheduled ? Colors.white : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Section planification
                      if (_isScheduled) ...[
                        const Text(
                          'Date et heure',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _selectDate,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFFFF4D3D),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _scheduledDate != null
                                              ? _formatDateForVisio(_scheduledDate!)
                                              : 'Sélectionner la date',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _scheduledDate != null
                                                ? const Color(0xFF1A1A1A)
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: _selectTime,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Color(0xFFFF4D3D),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _scheduledTime != null
                                              ? _scheduledTime!.format(context)
                                              : 'Sélectionner l\'heure',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _scheduledTime != null
                                                ? const Color(0xFF1A1A1A)
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                      const Text(
                        'Sélectionnez les participants',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._availableParticipants.map((participant) {
                        final isSelected =
                            _selectedParticipantIds.contains(participant.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedParticipantIds.add(participant.id);
                                } else {
                                  _selectedParticipantIds.remove(participant.id);
                                }
                              });
                            },
                            title: Text(participant.name),
                            subtitle: Text(participant.role),
                            activeColor: const Color(0xFFFF4D3D),
                          ),
                        );
                      }),
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
                child: AppButton(
                  text: _isScheduled ? 'Planifier la visio' : 'Lancer la visio',
                  onPressed: _selectedParticipantIds.isEmpty ||
                          (_isScheduled && (_scheduledDate == null || _scheduledTime == null))
                      ? null
                      : () {
                          final selected = _availableParticipants
                              .where((p) =>
                                  _selectedParticipantIds.contains(p.id))
                              .toList();
                          widget.onStart(selected);
                        },
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                  icon: Icon(
                    _isScheduled ? Icons.schedule : Icons.videocam,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner la date',
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFFF4D3D),
                onPrimary: Colors.white,
                onSurface: Color(0xFF1A1A1A),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _scheduledDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _scheduledTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFFF4D3D),
                onPrimary: Colors.white,
                onSurface: Color(0xFF1A1A1A),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _scheduledTime = picked;
      });
    }
  }

  String _formatDateForVisio(DateTime date) {
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// Modal pour composer un email
class _ComposeEmailModal extends StatefulWidget {
  final String missionId;
  final Function(List<String>, String, String?, List<EmailAttachment>) onSend;

  const _ComposeEmailModal({
    required this.missionId,
    required this.onSend,
  });

  @override
  State<_ComposeEmailModal> createState() => _ComposeEmailModalState();
}

class _ComposeEmailModalState extends State<_ComposeEmailModal> {
  final TextEditingController _recipientsController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final List<EmailAttachment> _attachments = [];

  final List<String> _availableRecipients = [
    'marie.dupont@preveris.fr (Siège)',
    'j.martin@client.fr (Client)',
    'architecte@example.fr (Architecte)',
  ];

  @override
  void dispose() {
    _recipientsController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
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
                    const Text(
                      'Nouvel email',
                      style: TextStyle(
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
                        'Destinataires',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _recipientsController,
                        decoration: InputDecoration(
                          hintText: 'Sélectionnez ou tapez les emails...',
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
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _availableRecipients.map((recipient) {
                          return ActionChip(
                            label: Text(recipient.split(' ')[0]),
                            onPressed: () {
                              final current = _recipientsController.text;
                              if (current.isEmpty) {
                                _recipientsController.text = recipient.split(' ')[0];
                              } else {
                                _recipientsController.text = '$current, ${recipient.split(' ')[0]}';
                              }
                            },
                            backgroundColor: Colors.grey.shade100,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Objet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          hintText: 'Objet de l\'email',
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
                      const Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _bodyController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: 'Tapez votre message...',
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
                      Row(
                        children: [
                          const Text(
                            'Pièces jointes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _addAttachment,
                            icon: const Icon(Icons.attach_file, size: 18),
                            label: const Text('Ajouter'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                      if (_attachments.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ..._attachments.map((att) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: AppCard(
                                child: Row(
                                  children: [
                                    const Icon(Icons.attach_file, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(att.name),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _attachments.remove(att);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
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
                                'Contexte: Mission #${widget.missionId}',
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
                child: AppButton(
                  text: 'Envoyer',
                  onPressed: _recipientsController.text.isEmpty ||
                          _subjectController.text.isEmpty
                      ? null
                      : () {
                          final recipients = _recipientsController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                          widget.onSend(
                            recipients,
                            _subjectController.text,
                            _bodyController.text.isEmpty
                                ? null
                                : _bodyController.text,
                            _attachments,
                          );
                        },
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                  icon: const Icon(Icons.send, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'xlsx', 'jpg', 'png'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _attachments.add(
            EmailAttachment(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: file.name,
              type: 'document',
              url: file.path ?? '',
              size: file.size != null
                  ? '${(file.size! / (1024 * 1024)).toStringAsFixed(1)} MB'
                  : '0 MB',
            ),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }
}

