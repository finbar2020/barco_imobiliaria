import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/repository/home_repository.dart';
import 'package:morar/feature/home/domain/use_cases/post_terms/post_terms.dart';

class PostTermsImpl extends PostTerms {
  final HomeRepository repository;

  PostTermsImpl({required this.repository});

  @override
  Future<Try<String>> call(PostTermsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.postTerms(params.unitId);
  }

  Failure? _validate(PostTermsParams param) {
    if (param.unitId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
