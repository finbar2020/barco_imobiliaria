part of shared_features;

class CodeData {
  List<CodeDataContact> emailContacts;
  List<CodeDataContact> smsContacts;
  bool registered;

  CodeData(
      {required this.emailContacts,
      required this.smsContacts,
      required this.registered});

  // String getWarningMessage(BuildContext context) {
  //   //getString(context, "next");
  //   if (origin == CodeValidationOrigin.changeNumber) {
  //     return "Alguns números podem ser bloqueados automaticamente pelo seu celular, e você não conseguirá receber o SMS.";
  //   } else
  //     return source == CodeValidationSource.email
  //         ? "Verifique se o email está em sua caixa de spam/arquivo morto/lixo eletrônico."
  //         : "Alguns números podem ser bloqueados automaticamente pelo seu celular, e você não conseguirá receber o SMS. Se for o caso, tente receber o código por email.";
  // }
}
