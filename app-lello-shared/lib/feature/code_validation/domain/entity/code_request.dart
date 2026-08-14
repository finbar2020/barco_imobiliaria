part of shared_features;

class CodeRequest {
  String? id;
  CodeValidationSource source;
  CodeValidationOrigin origin;
  String value;
  String token;
  String? cpf;
  String? appSignature;

  CodeRequest({
    this.id,
    required this.source,
    required this.origin,
    required this.value,
    required this.token,
    this.cpf,
    this.appSignature,
  });

  String getWarningMessage(BuildContext context) {
    //getString(context, "next");
    if (origin == CodeValidationOrigin.changeNumber) {
      return "Alguns números podem ser bloqueados automaticamente pelo seu celular, e você não conseguirá receber o SMS.";
    } else
      return source == CodeValidationSource.email
          ? "Verifique se o email está em sua caixa de spam/arquivo morto/lixo eletrônico."
          : "Alguns números podem ser bloqueados automaticamente pelo seu celular, e você não conseguirá receber o SMS. Se for o caso, tente receber o código por email.";
  }
}
