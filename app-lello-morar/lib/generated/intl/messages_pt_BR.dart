// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_BR';

  static String m0(billetByEmailCounter, billetByEmailRemaining) =>
      "Atualmente, há ${billetByEmailCounter} usuários cadastrados para receber cópias de boletos por e-mail. Você pode adicionar mais ${billetByEmailRemaining} usuários, totalizando o limite de 3.";

  static String m1(count) => "Solicitaçôes pendentes (${count})";

  static String m2(howMany) =>
      "${Intl.plural(howMany, one: '1 DIA RESTANTE', other: '${howMany} DIAS RESTANTES')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aRequest": MessageLookupByLibrary.simpleMessage("uma solicitação"),
    "accessRequestApproveConfirmationMessage": MessageLookupByLibrary.simpleMessage(
      "Ao aprovar, ele entrará na sua lista de usuários desta unidade, onde você poderá editar os dados e permissões.",
    ),
    "addResidentDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Ao adicionar um morador, o proprietário terá a permissão de bloqueá-lo quando quiser.",
    ),
    "approve": MessageLookupByLibrary.simpleMessage("Aprovar"),
    "approvingSuccessfulUpperCase": MessageLookupByLibrary.simpleMessage(
      "Aprovação efetuada com sucesso!",
    ),
    "billetByEmailCounterMessage": m0,
    "blockingSuccessful": MessageLookupByLibrary.simpleMessage(
      "Bloqueio efetuado som sucesso!",
    ),
    "changeAccessRequestStatusToBlockedMessage":
        MessageLookupByLibrary.simpleMessage(
          "Ao ser bloqueado, todos os moradores cadastrados por ele também terão o acesso suspenso e permanecerão assim até que sejam desbloqueados manualmente.",
        ),
    "changeOfOwnership": MessageLookupByLibrary.simpleMessage(
      "TROCA DE TITULARIDADE",
    ),
    "changeOfOwnershipMessage": MessageLookupByLibrary.simpleMessage(
      "Ao aprovar, os moradores que ele cadastrou, permanecerão na sua lista de usuários desta unidade.",
    ),
    "clickTo": MessageLookupByLibrary.simpleMessage("Clique para"),
    "conciergeRegistration": MessageLookupByLibrary.simpleMessage(
      "CADASTRO PORTARIA",
    ),
    "expirationAccessDate": MessageLookupByLibrary.simpleMessage(
      "Data de expiração de acesso",
    ),
    "or": MessageLookupByLibrary.simpleMessage("ou"),
    "pendingRequestsCounter": m1,
    "pending_requests": MessageLookupByLibrary.simpleMessage(
      "Solicitações Pendentes",
    ),
    "profileWithTwoDots": MessageLookupByLibrary.simpleMessage("Perfil:"),
    "registrationLello": MessageLookupByLibrary.simpleMessage("CADASTRO"),
    "registrationWithoutContract": MessageLookupByLibrary.simpleMessage(
      "CADASTRO SEM CONTRATO",
    ),
    "remainingDays": m2,
    "subUserAlreadyRegistered": MessageLookupByLibrary.simpleMessage(
      "Morador já cadastrado. Pode não estar visível por ter sido incluído pelo proprietário.",
    ),
    "updateRequestStatusSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Agora você pode visualizá-lo e editar os dados e permissões.",
    ),
    "updateRequestStatusToBlockSuccessMessage":
        MessageLookupByLibrary.simpleMessage(
          "Você pode desbloqueá-lo ou excluí-lo a qualquer momento na Minha Unidade, em Moradores.",
        ),
  };
}
