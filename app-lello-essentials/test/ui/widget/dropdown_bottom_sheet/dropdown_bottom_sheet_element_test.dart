import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_element.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guarda texto e valor tipado e permite alteração', () {
    final elemento = DropdownBottomSheetElement<int>(text: 'Um', value: 1);
    expect(elemento.text, 'Um');
    expect(elemento.value, 1);

    elemento
      ..text = 'Dois'
      ..value = 2;
    expect(elemento.text, 'Dois');
    expect(elemento.value, 2);

    final generico = DropdownBottomSheetElement(text: 'x', value: null);
    expect(generico.value, isNull);
  });
}
