class ResetScheduleEventEntity {
  final bool success;
  final String? message;

  const ResetScheduleEventEntity({
    required this.success,
    this.message,
  });

  factory ResetScheduleEventEntity.fromJson(Map<String, dynamic> json) {
    return ResetScheduleEventEntity(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResetScheduleEventEntity &&
        other.success == success &&
        other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;

  @override
  String toString() {
    return 'ResetScheduleEventEntity(success: $success, message: $message)';
  }
}
