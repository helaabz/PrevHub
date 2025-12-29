class DocumentAttendu {
  final String name;
  final String type;
  final bool isRequired;
  final bool isDepose;
  final String? status;

  DocumentAttendu({
    required this.name,
    required this.type,
    required this.isRequired,
    required this.isDepose,
    this.status,
  });
}

