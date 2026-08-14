// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Solicitações Pendentes`
  String get pending_requests {
    return Intl.message(
      'Solicitações Pendentes',
      name: 'pending_requests',
      desc: '',
      args: [],
    );
  }

  /// `Solicitaçôes pendentes ({count})`
  String pendingRequestsCounter(Object count) {
    return Intl.message(
      'Solicitaçôes pendentes ($count)',
      name: 'pendingRequestsCounter',
      desc: '',
      args: [count],
    );
  }

  /// `Clique para`
  String get clickTo {
    return Intl.message('Clique para', name: 'clickTo', desc: '', args: []);
  }

  /// `Aprovar`
  String get approve {
    return Intl.message('Aprovar', name: 'approve', desc: '', args: []);
  }

  /// `ou`
  String get or {
    return Intl.message('ou', name: 'or', desc: '', args: []);
  }

  /// `uma solicitação`
  String get aRequest {
    return Intl.message(
      'uma solicitação',
      name: 'aRequest',
      desc: '',
      args: [],
    );
  }

  /// `CADASTRO`
  String get registrationLello {
    return Intl.message(
      'CADASTRO',
      name: 'registrationLello',
      desc: '',
      args: [],
    );
  }

  /// `CADASTRO PORTARIA`
  String get conciergeRegistration {
    return Intl.message(
      'CADASTRO PORTARIA',
      name: 'conciergeRegistration',
      desc: '',
      args: [],
    );
  }

  /// `CADASTRO SEM CONTRATO`
  String get registrationWithoutContract {
    return Intl.message(
      'CADASTRO SEM CONTRATO',
      name: 'registrationWithoutContract',
      desc: '',
      args: [],
    );
  }

  /// `{howMany, plural, one{1 DIA RESTANTE} other{{howMany} DIAS RESTANTES}}`
  String remainingDays(num howMany) {
    return Intl.plural(
      howMany,
      one: '1 DIA RESTANTE',
      other: '$howMany DIAS RESTANTES',
      name: 'remainingDays',
      desc: '',
      args: [howMany],
    );
  }

  /// `Perfil:`
  String get profileWithTwoDots {
    return Intl.message(
      'Perfil:',
      name: 'profileWithTwoDots',
      desc: '',
      args: [],
    );
  }

  /// `Aprovação efetuada com sucesso!`
  String get approvingSuccessfulUpperCase {
    return Intl.message(
      'Aprovação efetuada com sucesso!',
      name: 'approvingSuccessfulUpperCase',
      desc: '',
      args: [],
    );
  }

  /// `Agora você pode visualizá-lo e editar os dados e permissões.`
  String get updateRequestStatusSuccessMessage {
    return Intl.message(
      'Agora você pode visualizá-lo e editar os dados e permissões.',
      name: 'updateRequestStatusSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `TROCA DE TITULARIDADE`
  String get changeOfOwnership {
    return Intl.message(
      'TROCA DE TITULARIDADE',
      name: 'changeOfOwnership',
      desc: '',
      args: [],
    );
  }

  /// `Ao aprovar, os moradores que ele cadastrou, permanecerão na sua lista de usuários desta unidade.`
  String get changeOfOwnershipMessage {
    return Intl.message(
      'Ao aprovar, os moradores que ele cadastrou, permanecerão na sua lista de usuários desta unidade.',
      name: 'changeOfOwnershipMessage',
      desc: '',
      args: [],
    );
  }

  /// `Ao aprovar, ele entrará na sua lista de usuários desta unidade, onde você poderá editar os dados e permissões.`
  String get accessRequestApproveConfirmationMessage {
    return Intl.message(
      'Ao aprovar, ele entrará na sua lista de usuários desta unidade, onde você poderá editar os dados e permissões.',
      name: 'accessRequestApproveConfirmationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Ao ser bloqueado, todos os moradores cadastrados por ele também terão o acesso suspenso e permanecerão assim até que sejam desbloqueados manualmente.`
  String get changeAccessRequestStatusToBlockedMessage {
    return Intl.message(
      'Ao ser bloqueado, todos os moradores cadastrados por ele também terão o acesso suspenso e permanecerão assim até que sejam desbloqueados manualmente.',
      name: 'changeAccessRequestStatusToBlockedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Bloqueio efetuado som sucesso!`
  String get blockingSuccessful {
    return Intl.message(
      'Bloqueio efetuado som sucesso!',
      name: 'blockingSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Você pode desbloqueá-lo ou excluí-lo a qualquer momento na Minha Unidade, em Moradores.`
  String get updateRequestStatusToBlockSuccessMessage {
    return Intl.message(
      'Você pode desbloqueá-lo ou excluí-lo a qualquer momento na Minha Unidade, em Moradores.',
      name: 'updateRequestStatusToBlockSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Data de expiração de acesso`
  String get expirationAccessDate {
    return Intl.message(
      'Data de expiração de acesso',
      name: 'expirationAccessDate',
      desc: '',
      args: [],
    );
  }

  /// `Atualmente, há {billetByEmailCounter} usuários cadastrados para receber cópias de boletos por e-mail. Você pode adicionar mais {billetByEmailRemaining} usuários, totalizando o limite de 3.`
  String billetByEmailCounterMessage(
    Object billetByEmailCounter,
    Object billetByEmailRemaining,
  ) {
    return Intl.message(
      'Atualmente, há $billetByEmailCounter usuários cadastrados para receber cópias de boletos por e-mail. Você pode adicionar mais $billetByEmailRemaining usuários, totalizando o limite de 3.',
      name: 'billetByEmailCounterMessage',
      desc: '',
      args: [billetByEmailCounter, billetByEmailRemaining],
    );
  }

  /// `Ao adicionar um morador, o proprietário terá a permissão de bloqueá-lo quando quiser.`
  String get addResidentDisclaimer {
    return Intl.message(
      'Ao adicionar um morador, o proprietário terá a permissão de bloqueá-lo quando quiser.',
      name: 'addResidentDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Morador já cadastrado. Pode não estar visível por ter sido incluído pelo proprietário.`
  String get subUserAlreadyRegistered {
    return Intl.message(
      'Morador já cadastrado. Pode não estar visível por ter sido incluído pelo proprietário.',
      name: 'subUserAlreadyRegistered',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
