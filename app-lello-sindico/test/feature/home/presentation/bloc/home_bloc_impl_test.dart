import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/home/presentation/bloc/home_state.dart';

void main() {
  test('HomeViewState props', () {
    const a = HomeViewState(showCondominumSelector: false);
    const b = HomeViewState(showCondominumSelector: true);
    expect(a.showCondominumSelector, false);
    expect(b.showCondominumSelector, true);
    expect(a, isNot(equals(b)));
  });
}
