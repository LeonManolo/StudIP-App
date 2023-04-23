class OutgoingMessage {
  final String subject;
  final String message;
  final List<String> recipients;

  OutgoingMessage(
      {required this.subject, required this.message, required this.recipients});
}
