part of shared_features;

abstract class GetDados2fa extends UseCase<CodeData, CodeDataParam> {}

class CodeDataParam {
  String cpf;
    int? idEmpresa;

  CodeDataParam({
    required this.cpf,
    this.idEmpresa,
  });
}
