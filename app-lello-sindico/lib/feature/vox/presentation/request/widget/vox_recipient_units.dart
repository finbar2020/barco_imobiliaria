import 'package:lello/feature/resident/controller/residents_controller.dart';

/// Unidade agrupada com seus moradores, derivada do `ResidentsController` (a API
/// retorna a mesma unidade repetida por morador). Compartilhada entre a tela de
/// seleção de destinatários e o resumo no passo de dados.
class VoxUnit {
  final String key;
  final String label;

  /// Id da unidade — é o que vai no fio (`recipient_list`/`unity_id`), não o
  /// rótulo. A seleção guarda este id como valor do `recipientListMap`.
  final String? id;

  final List<String> residents = [];

  VoxUnit(this.key, this.label, this.id);

  String get residentsText => residents.join("\n");
}

/// Agrupa os moradores por unidade. A chave (`group|title`) casa com o que é
/// guardado em `recipientListMap`.
List<VoxUnit> voxGroupUnits(ResidentsController controller) {
  final map = <String, VoxUnit>{};
  for (final resident in controller.residents) {
    final unit = resident.unit;
    if (unit == null) continue;
    final key = "${unit.group ?? ''}|${unit.title ?? ''}";
    final label = [unit.group, unit.title]
        .where((e) => (e ?? '').isNotEmpty)
        .join(' - ');
    final entry = map.putIfAbsent(key, () => VoxUnit(key, label, unit.id));
    final name = resident.name;
    if (name != null && name.isNotEmpty) entry.residents.add(name);
  }
  return map.values.toList();
}
