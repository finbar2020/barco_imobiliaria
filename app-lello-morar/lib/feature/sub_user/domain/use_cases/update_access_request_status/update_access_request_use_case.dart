import 'package:essentials/base/use_case.dart';

abstract class UpdateAccessRequestUseCase
    extends UseCase<bool, UpdateAccessRequestStatusParams> {}

class UpdateAccessRequestStatusParams {
  final int id;
  final String status;
  final DateTime? expiresAt;

  UpdateAccessRequestStatusParams({
    required this.id,
    required this.status,
    this.expiresAt,
  });
}
