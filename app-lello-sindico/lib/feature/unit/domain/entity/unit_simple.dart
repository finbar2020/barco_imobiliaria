// ignore_for_file: public_member_api_docs, sort_constructors_first
class UnitSimple {
  final String id;
  final String? notificationContext;
  final String title;

  UnitSimple({
    required this.id,
    this.notificationContext,
    required this.title,
  });

  UnitSimple copyWith({
    String? id,
    String? notificationContext,
    String? title,
  }) {
    return UnitSimple(
      id: id ?? this.id,
      notificationContext: notificationContext ?? this.notificationContext,
      title: title ?? this.title,
    );
  }

  @override
  bool operator ==(covariant UnitSimple other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.notificationContext == notificationContext &&
        other.title == title;
  }

  @override
  int get hashCode =>
      id.hashCode ^ notificationContext.hashCode ^ title.hashCode;
}
