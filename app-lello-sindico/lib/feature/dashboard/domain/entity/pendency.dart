
class Pendency {
  String? id;
  DateTime? date;
  String? title;
  String? message;
  DateTime? visualizedAt;
  String? status;
  String? reference;
  String? iconType;
  String? identifier;
  String? idSender;
  String? type;
  bool? read;

  Pendency(
      {this.id,
      this.date,
      this.title,
      this.message,
      this.visualizedAt,
      this.status,
      this.reference,
      this.iconType,
      this.identifier,
      this.idSender,
      this.type,
      this.read});
}
