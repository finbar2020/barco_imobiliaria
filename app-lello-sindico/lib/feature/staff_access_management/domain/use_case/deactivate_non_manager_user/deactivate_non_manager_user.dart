import 'package:essentials/essentials.dart';

abstract class DeactivateNonManagerUserCase
    extends UseCase<void, DeactivateNonManagerUserParam> {}

class DeactivateNonManagerUserParam {
  final String condominiumId;
  final String userId;
  final bool isActive;
  DeactivateNonManagerUserParam({
    required this.condominiumId,
    required this.userId,
    required this.isActive,
  });
}
