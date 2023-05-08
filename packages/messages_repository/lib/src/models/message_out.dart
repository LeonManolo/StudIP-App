class OutgoingMessage {

  OutgoingMessage(
      {required this.subject, required this.message, required this.recipients,});
  final String subject;
  final String message;
  final List<String> recipients;
}
