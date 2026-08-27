import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/generated/l10n.dart';

/// Exercita o catálogo gerado (`S`) nos dois idiomas empacotados, garantindo
/// que todas as chaves resolvem para texto e que o delegate reconhece os
/// locales suportados.
void main() {
  List<String> allStrings() => [
        S.current.pending_requests,
        S.current.clickTo,
        S.current.approve,
        S.current.or,
        S.current.aRequest,
        S.current.registrationLello,
        S.current.conciergeRegistration,
        S.current.registrationWithoutContract,
        S.current.profileWithTwoDots,
        S.current.approvingSuccessfulUpperCase,
        S.current.updateRequestStatusSuccessMessage,
        S.current.changeOfOwnership,
        S.current.changeOfOwnershipMessage,
        S.current.accessRequestApproveConfirmationMessage,
        S.current.changeAccessRequestStatusToBlockedMessage,
        S.current.blockingSuccessful,
        S.current.updateRequestStatusToBlockSuccessMessage,
        S.current.expirationAccessDate,
        S.current.addResidentDisclaimer,
        S.current.subUserAlreadyRegistered,
        S.current.pendingRequestsCounter(1),
        S.current.pendingRequestsCounter(3),
        S.current.remainingDays(1),
        S.current.remainingDays(5),
      ];

  test('carrega pt_BR e resolve todas as chaves', () async {
    await S.load(const Locale('pt', 'BR'));

    final strings = allStrings();
    expect(strings, everyElement(isNotEmpty));
    expect(S.current.pendingRequestsCounter(2), contains('2'));
    expect(S.current.remainingDays(5), contains('5'));
  });

  test('carrega en e resolve todas as chaves', () async {
    await S.load(const Locale('en'));

    expect(allStrings(), everyElement(isNotEmpty));
  });

  test('delegate reconhece apenas os locales empacotados', () {
    const delegate = S.delegate;
    expect(delegate.isSupported(const Locale('pt', 'BR')), isTrue);
    expect(delegate.isSupported(const Locale('en')), isTrue);
    expect(delegate.isSupported(const Locale('fr')), isFalse);
    expect(delegate.shouldReload(delegate), isFalse);
    expect(delegate.supportedLocales, isNotEmpty);
  });

  testWidgets('S.of e S.maybeOf leem a instância do contexto', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      home: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }),
    ));
    await tester.pumpAndSettle();

    expect(S.of(ctx), isNotNull);
    expect(S.maybeOf(ctx), isNotNull);
    expect(S.of(ctx).approve, isNotEmpty);
  });
}
