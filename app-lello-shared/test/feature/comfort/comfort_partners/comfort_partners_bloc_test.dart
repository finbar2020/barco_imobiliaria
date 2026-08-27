import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';

import 'comfort_partners_test_support.dart';

void main() {
  group('ComfortPartnersBloc', () {
    late ComfortPartnersBloc bloc;

    setUp(() => bloc = ComfortPartnersBloc());
    tearDown(() => bloc.close());

    test('começa vazio', () {
      expect(bloc.state, const EmptyComfortPartnersState());
    });

    test('emite a sequência de estados de cada evento', () async {
      final partner = buildPartner('P1');
      final request = buildCouponRequest();
      final purchase = buildPurchase();
      final config = [yourCondoConfig('cleaning')];

      final states = <ComfortPartnersState>[];
      final sub = bloc.stream.listen(states.add);

      bloc
        ..add(const LoadingComfortPartnersEvent())
        ..add(const ErrorComfortPartnersEvent(
            errorMessageKey: 'erro', errorCode: '500', errorDescription: 'd'))
        ..add(LoadedComfortPartnersEvent(
          comfortPartnerCategoryIsFilter: true,
          comfortPartnersIsRandomic: false,
          categoriesToYourCondo: config,
          isFailedCondoPartners: true,
          isSuccessYourCondoPartners: true,
          partnerFocus: partner,
        ))
        ..add(LoadedComfortPartnerDetailsEvent(
            selectedPartner: partner,
            couponRequest: request,
            requestPurchase: purchase,
            error: 'e'))
        ..add(SuccessComfortPartnerCupomEvent(
            selectedPartner: partner, couponRequest: request))
        ..add(LoadedComfortPartnerRequestErrorEvent(
            selectedPartner: partner, error: 'erro_req'))
        ..add(SuccessComfortPartnersEvent(selectedPartner: partner))
        ..add(const SuccessReviewSentEvent())
        ..add(const EmptyComfortPartnersEvent());
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [
        const LoadingComfortPartnersState(),
        const ErrorComfortPartnersState(
            errorMessageKey: 'erro', errorCode: '500', errorDescription: 'd'),
        LoadedComfortPartnersState(
          comfortPartnerCategoryIsFilter: true,
          // Defeito: o bloc copia `isFailedCondoPartners` para
          // `comfortPartnersIsRandomic` em vez do valor do evento.
          comfortPartnersIsRandomic: true,
          categoriesToYourCondo: config,
          isFailedCondoPartners: true,
          isSuccessYourCondoPartners: true,
          partnerFocus: partner,
        ),
        LoadedComfortPartnerDetailsState(
            selectedPartner: partner,
            couponRequest: request,
            requestPurchase: purchase,
            error: 'e'),
        // Defeito: `SuccessComfortPartnerCupomEvent` estende
        // `LoadedComfortPartnerDetailsEvent`, então casa com os DOIS handlers
        // e o bloc emite um `LoadedComfortPartnerDetailsState` intermediário
        // antes do `SuccessComfortPartnerCupomState`.
        LoadedComfortPartnerDetailsState(
            selectedPartner: partner, couponRequest: request),
        SuccessComfortPartnerCupomState(
            selectedPartner: partner, couponRequest: request),
        LoadedComfortPartnerDetailsState(
            selectedPartner: partner, error: 'erro_req'),
        SuccessComfortPartnersState(selectedPartner: partner),
        const SuccessReviewSentState(),
        const EmptyComfortPartnersState(),
      ]);
    });

    /// Defeito: `LoadedComfortPartnersEvent.flushbarMessage` não é repassado
    /// ao `LoadedComfortPartnersState` pelo handler do bloc (a tela de
    /// favoritos nunca recebe a mensagem de erro do "desfavoritar").
    test('flushbarMessage do evento é descartado pelo handler', () async {
      bloc.add(const LoadedComfortPartnersEvent(
        flushbarMessage: 'mensagem',
        comfortPartnerCategoryIsFilter: true,
        comfortPartnersIsRandomic: false,
        categoriesToYourCondo: [],
      ));
      await Future<void>.delayed(Duration.zero);
      final state = bloc.state as LoadedComfortPartnersState;
      expect(state.flushbarMessage, isNull);
    });

    test('estados com os mesmos dados são iguais (Equatable)', () {
      final partner = buildPartner('P1');
      expect(
        SuccessComfortPartnersState(selectedPartner: partner),
        SuccessComfortPartnersState(selectedPartner: partner),
      );
      expect(
        const LoadedComfortPartnersState(
            comfortPartnerCategoryIsFilter: true,
            comfortPartnersIsRandomic: false,
            categoriesToYourCondo: []),
        isNot(const LoadedComfortPartnersState(
            comfortPartnerCategoryIsFilter: false,
            comfortPartnersIsRandomic: false,
            categoriesToYourCondo: [])),
      );
      expect(
        const ErrorComfortPartnersState(
                errorMessageKey: 'a', errorCode: null, errorDescription: null)
            .props,
        ['a', null, null],
      );
      expect(const LoadedComfortState().props, isEmpty);
      expect(const EmptyComfortPartnersEvent().props, isEmpty);
      expect(SuccessComfortPartnersEvent(selectedPartner: partner).props,
          [partner]);
      expect(
        const ErrorComfortPartnersEvent(
                errorMessageKey: 'k', errorCode: 'c', errorDescription: 'd')
            .props,
        ['k', 'd', 'c'],
      );
      expect(
        LoadedComfortPartnerDetailsEvent(selectedPartner: partner).props,
        [partner, null, null, null],
      );
      expect(
        const LoadedComfortPartnersEvent(
                comfortPartnerCategoryIsFilter: true,
                comfortPartnersIsRandomic: true,
                categoriesToYourCondo: [])
            .props
            .length,
        7,
      );
    });
  });

  group('ComfortPartnerCouponsBloc', () {
    late ComfortPartnerCouponsBloc bloc;

    setUp(() => bloc = ComfortPartnerCouponsBloc());
    tearDown(() => bloc.close());

    test('começa vazio e percorre carregando, carregado e erro', () async {
      expect(bloc.state, const EmptyCouponsState());
      final coupons = [buildCoupon('C1')];
      final states = <ComfortPartnerCouponsState>[];
      final sub = bloc.stream.listen(states.add);

      bloc
        ..add(const LoadingCouponsEvent(partnerId: 'P1', condominiumId: 'C1'))
        ..add(LoadedCouponsEvent(coupons: coupons))
        ..add(const CouponsErrorEvent(
            errorMessageKey: 'erro', errorCode: '500', errorDescription: 'd'));
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [
        const LoadingCouponsState(),
        LoadedCouponsState(coupons: coupons),
        const CouponsErrorState(
            errorMessageKey: 'erro', errorCode: '500', errorDescription: 'd'),
      ]);
      expect(bloc.state, isA<CouponsErrorState>());
    });

    /// Defeito: `EmptyCouponsEvent` existe mas o bloc não registra handler
    /// para ele — `add` lança `StateError` em vez de voltar ao estado vazio.
    test('EmptyCouponsEvent não tem handler registrado', () {
      expect(() => bloc.add(const EmptyCouponsEvent()), throwsStateError);
    });

    test('props dos eventos e estados', () {
      expect(const EmptyCouponsEvent().props, isEmpty);
      expect(
          const LoadingCouponsEvent(partnerId: 'P1', condominiumId: 'C1')
              .props,
          ['P1', 'C1']);
      expect(const LoadedCouponsEvent(coupons: []).props, [[]]);
      expect(const CouponsErrorEvent(errorMessageKey: 'k').props,
          ['k', null, null]);
      expect(const EmptyCouponsState().props, isEmpty);
      expect(const LoadingCouponsState().props, isEmpty);
      expect(const LoadedCouponsState(coupons: []).props, [[]]);
      expect(const CouponsErrorState(errorMessageKey: 'k').props,
          ['k', null, null]);
    });
  });

  test('ComfortPageOriginEnum expõe todas as origens', () {
    expect(ComfortPageOriginEnum.values, hasLength(16));
    expect(ComfortPageOriginEnum.test.name, 'test');
  });
}
