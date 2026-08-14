import 'package:essentials/essentials.dart';

class SubUserRole extends Equatable {
  final String? role;
  final String? description;
  final bool? enabled;

  const SubUserRole({
    this.role,
    this.description,
    this.enabled,
  });

  SubUserRole copyWith({
    String? role,
    String? description,
    bool? enabled,
  }) {
    return SubUserRole(
      role: role ?? this.role,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  String toString() =>
      'SubUserRole(role: $role, description: $description), { enabled: $enabled }';

  @override
  List<Object?> get props => [role, description, enabled];
}
