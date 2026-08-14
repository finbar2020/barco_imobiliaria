import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/payment_pendency_list_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/payment_pendency_list_bloc_impl.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/payment_pendency_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';
import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  ListPayment listPayment;
  SessionBloc sessionBloc;
  PaymentPendencyListBloc bloc;
  final session = Session()..selectedCondominium = Condominium(id: "1");
  setUp(() {
    listPayment = ListPaymentMock();
    sessionBloc = SessionBlocMock();
    bloc = PaymentPendencyListBlocImpl(
        listPayment: listPayment, sessionBloc: sessionBloc);
  });

  group('on session change', () {
    test('Should begin loading when session is loaded', () async {
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = PaymentPendencyListBlocImpl(
          listPayment: listPayment, sessionBloc: sessionBloc);

      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            isA<PaymentPendencyLoadingState>()
          ]));
    });

    test(
        'Should emit failure state when session is loaded and list pendency fails',
        () async {
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listPayment.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc = PaymentPendencyListBlocImpl(
          listPayment: listPayment, sessionBloc: sessionBloc);

      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            isA<PaymentPendencyLoadingState>(),
            isA<PaymentPendencyLoadFailedState>()
          ]));
    });

    test(
        'Should emit loaded state when session is loaded and list pendency succeeds',
        () async {
      List<Payment> data = [];
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listPayment.call(any)).thenAnswer((_) async => Success(data));
      bloc = PaymentPendencyListBlocImpl(
          listPayment: listPayment, sessionBloc: sessionBloc);

      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            isA<PaymentPendencyLoadingState>(),
            IsAnd<PaymentPendencyLoadedState>((it) => it.data == data)
          ]));
    });

    test('Should not start loading when session is not loaded', () async {
      whenListen(sessionBloc, Stream.fromIterable([SessionLoadingState(null)]));
      bloc = PaymentPendencyListBlocImpl(
          listPayment: listPayment, sessionBloc: sessionBloc);

      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
          ]));
    });
  });

  group('beginFilter', () {
    test('Should emit failure state when list pendency fails', () async {
      when(listPayment.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final filter = PaymentListFilter();
      bloc.beginFilter(filter);
      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            IsAnd<PaymentPendencyLoadingState>((it) => it.filter == filter),
            isA<PaymentPendencyLoadFailedState>()
          ]));
    });

    test('Should emit loaded state when list pendency succeeds', () async {
      List<Payment> data = [];
      when(listPayment.call(any)).thenAnswer((_) async => Success(data));
      final filter = PaymentListFilter();
      bloc.beginFilter(filter);
      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            IsAnd<PaymentPendencyLoadingState>((it) => it.filter == filter),
            IsAnd<PaymentPendencyLoadedState>(
                (it) => it.filter == filter && it.data == data)
          ]));
    });
  });

  group('beginRefresh', () {
    test('Should emit anything while state is loading', () async {
      when(listPayment.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
          ]));
    });

    void updateStateToLoaded() async {
      when(listPayment.call(any)).thenAnswer((_) async => Success([]));
      bloc.beginLoadNextPage();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            isA<PaymentPendencyPagingState>(),
            isA<PaymentPendencyLoadedState>()
          ]));
    }

    test(
        'Should emit failure state when session is loaded and list pendency fails',
        () async {
      await updateStateToLoaded();

      when(listPayment.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadedState>(), //default state
            isA<PaymentPendencyLoadingState>(),
            isA<PaymentPendencyLoadFailedState>()
          ]));
    });

    test(
        'Should emit loaded state when session is loaded and list pendency succeeds',
        () async {
      await updateStateToLoaded();

      List<Payment> data = [];
      when(listPayment.call(any)).thenAnswer((_) async => Success(data));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadedState>(), //default state
            isA<PaymentPendencyLoadingState>(),
            IsAnd<PaymentPendencyLoadedState>((it) => it.data == data)
          ]));
    });
  });

  group('beginLoadNextPage', () {
    test('Should emit failure state when list pendency fails', () async {
      when(listPayment.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoadNextPage();
      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            isA<PaymentPendencyPagingState>(),
            isA<PaymentPendencyLoadFailedState>()
          ]));
    });

    test('Should emit loaded state when list pendency succeeds', () async {
      List<Payment> data = [];
      when(listPayment.call(any)).thenAnswer((_) async => Success(data));
      bloc.beginLoadNextPage();
      expect(
          bloc,
          emitsInOrder([
            isA<PaymentPendencyLoadingState>(), //default state
            isA<PaymentPendencyPagingState>(),
            isA<PaymentPendencyLoadedState>()
          ]));
    });
  });
}

class ListPaymentMock extends Mock implements ListPayment {}
