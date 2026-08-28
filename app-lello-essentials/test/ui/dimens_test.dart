import 'package:essentials/ui/dimens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('espaçamentos seguem a escala documentada', () {
    expect(Dimens.spacingXSmall, 4.0);
    expect(Dimens.spacingSmall, 8.0);
    expect(Dimens.spacing, 16.0);
    expect(Dimens.spacingMedium, 24.0);
    expect(Dimens.spacingLarge, 32.0);
    expect(Dimens.spacingXLarge, 64.0);
  });

  test('escala é crescente e múltipla de 4', () {
    final escala = [
      Dimens.spacingXSmall,
      Dimens.spacingSmall,
      Dimens.spacing,
      Dimens.spacingMedium,
      Dimens.spacingLarge,
      Dimens.spacingXLarge,
    ];
    for (var i = 1; i < escala.length; i++) {
      expect(escala[i], greaterThan(escala[i - 1]));
      expect(escala[i] % 4, 0);
    }
  });

  test('dimensões da home', () {
    expect(Dimens.homeAppBarHeight, 135.0);
    expect(Dimens.homeBalanceHeightCollapsed, 85.0);

    /// Corrigido: o comentário agora diz "Tamanho: 44.7" (o valor não mudou).
    expect(Dimens.homeMenuIconSize, 44.7);
  });
}
