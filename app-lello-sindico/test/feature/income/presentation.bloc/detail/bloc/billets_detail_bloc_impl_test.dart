import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/income/domain/use_case/get_billets.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_detail_bloc.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_detail_state.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_details_bloc_impl.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  BilletsDetailBloc bloc;
  GetBillets getBillets;

  setUp(() {
    getBillets = GetBilletsMock();
    bloc = BilletsDetailBlocImpl(getBillets: getBillets);
  });

  group("beginLoad", () {
    test("Should call get billets use case", () async {
      bloc.beginLoad(Unit(), DateTime.now());

      await expectLater(
          bloc,
          emitsInOrder([
            isA<BilletsDetailLoadingState>(), //default state
            isA<BilletsDetailLoadingState>(), //default state
          ]));

      verify(getBillets.call(any));
    });

    test("Should call get billets", () async {
      bloc.beginLoad(Unit(), DateTime.now());

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsDetailLoadingState>(),
            isA<BilletsDetailLoadingState>(),
          ]));
    });

    test("Should emit loaded when get billets succeed", () async {
      Billet billet = Billet();
      when(getBillets.call(any)).thenAnswer((_) async => Success(billet));

      bloc.beginLoad(Unit(), DateTime.now());

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsDetailLoadingState>(),
            isA<BilletsDetailLoadingState>(),
            IsAnd<BilletsDetailLoadedState>((state) => state.billet == billet),
          ]));
    });

    test("Should emit loaded when get billets failure", () async {
      when(getBillets.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      bloc.beginLoad(Unit(), DateTime.now());

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsDetailLoadingState>(),
            isA<BilletsDetailLoadingState>(),
            isA<BilletsDetailLoadFailedState>(),
          ]));
    });
  });
}

class GetBilletsMock extends Mock implements GetBillets {}
