import 'package:essentials/functional/try.dart';
import '../entity/submit_form_entity.dart';
import '../repository/maintenance_management_repository.dart';

class SubmitFormUseCase {
  final MaintenanceManagementRepository repository;

  SubmitFormUseCase(this.repository);

  Future<Try<SubmitFormResponseEntity>> call(
      SubmitFormRequestEntity request) async {
    return await repository.submitForm(request);
  }
}
