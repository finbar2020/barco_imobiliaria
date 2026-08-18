import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc_impl.dart';
import 'package:lello/feature/home/presentation/bloc/home_state.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
	HomeBloc bloc;

	setUp(() {
		bloc = HomeBlocImpl();
	});

	group('showCondominiumSelector', () {
		test('Should emit new state with expected showCondominiumSelector attribute', () async {
			bloc.showCondominiumSelector();
			expect(bloc, emitsInOrder([
				IsAnd<HomeState>((it) => it.showCondominumSelector == false), //default state
				IsAnd<HomeState>((it) => it.showCondominumSelector == true)
			]));
		});
	});

	group('collapseCondominiumSelector', () {
		test('Should emit new state with expected showCondominiumSelector attribute', () async {
			bloc.collapseCondominiumSelector();
			expect(bloc, emitsInOrder([
				IsAnd<HomeState>((it) => it.showCondominumSelector == false)
			]));
		});
	});
}