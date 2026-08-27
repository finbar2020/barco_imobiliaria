import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/access_control/data/model/access_control_service_seventh_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_event.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';

import 'access_control_test_helpers.dart';

void main() {
  group('igualdade (Equatable) dos eventos', () {
    test('eventos com os mesmos dados são iguais', () {
      final g = gest();
      final a = auth();
      expect(const AccessControlLoadingEvent(), const AccessControlLoadingEvent());
      expect(const AccessControlFailureEvent().props, isEmpty);
      expect(const AccessControlOnBoardingEvent(), const AccessControlOnBoardingEvent());
      expect(
        AccessControlLoadedEvent(visitants: [g], providers: const []),
        AccessControlLoadedEvent(visitants: [g], providers: const []),
      );
      expect(
        EditVisitantEvent(visitant: g, providers: const [], model: a, visitants: const []).props,
        [g, a, const [], const []],
      );
      expect(
        const SaveVisitantLoadedEvent(visitants: [], providers: [], useFacial: true, isVisitant: false, link: 'l').props,
        [const [], const [], true, false, 'l', false, false, false],
      );
      expect(
        SaveVisitantFailureEvent(visitants: const [], providers: const [], visitant: g, model: a, failureInvite: true).props,
        [const [], const [], g, a, true, false],
      );
      expect(
        DeleteVisitantEvent(visitants: const [], providers: const [], visitant: g).props,
        [const [], const [], g],
      );
      expect(
        DeleteFailureVisitEvent(visitants: const [], providers: const [], visitant: g, model: a).props,
        [const [], const [], g, a],
      );
      expect(
        SearchingVisitantEvent(visitants: [g], providers: const []),
        SearchingVisitantEvent(visitants: [g], providers: const []),
      );
      expect(
        SearchingProviderEvent(visitants: const [], providers: [g]),
        SearchingProviderEvent(visitants: const [], providers: [g]),
      );
      expect(
        SearchingProviderEvent(visitants: const [], providers: [g]),
        isNot(SearchingProviderEvent(visitants: const [], providers: const [])),
      );
    });

    test('estados com os mesmos dados são iguais', () {
      final g = gest();
      final a = auth();
      expect(
        DeleteVisitantState(visitants: const [], providers: const [], visitant: g),
        DeleteVisitantState(visitants: const [], providers: const [], visitant: g),
      );
      expect(const DeleteVisitState(isVisitant: true).props, [true]);
      expect(
        DeleteFailureVisitState(visitants: const [], providers: const [], visitant: g, model: a),
        DeleteFailureVisitState(visitants: const [], providers: const [], visitant: g, model: a),
      );
      expect(
        const SearchingVisitantState(visitants: [], providers: []),
        isNot(const SearchingProviderState(visitants: [], providers: [])),
      );
    });
  });

  group('AccessControlServiceSeventhModel', () {
    test('converte de/para json e entidade', () {
      final model = AccessControlServiceSeventhModel.fromJson({'condominium_active': true});
      expect(model.condominiumActive, isTrue);
      expect(model.toJson(), {'condominium_active': true});
      expect(AccessControlServiceSeventhModel.fromJson({}).condominiumActive, isFalse);

      final entity = model.toEntity();
      expect(entity.condominiumActive, isTrue);
      expect(AccessControlServiceSeventhModel.fromEntity(entity)!.condominiumActive, isTrue);
      expect(AccessControlServiceSeventhModel.fromEntity(null), isNull);
      expect(AccessControlServiceSeventh().condominiumActive, isFalse);
    });
  });
}
