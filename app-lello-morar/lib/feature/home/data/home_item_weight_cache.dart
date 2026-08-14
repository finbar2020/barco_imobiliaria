import 'package:shared_preferences/shared_preferences.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class HomeItemWeightCache {
  static const String _orderKey = 'home_item_order_v2';

  /// Atualiza a ordem LRU colocando o item mais recente no início
  /// LRU: Least Recently Used cache para itens da tela inicial
  static Future<void> updateOrder(HomeItemEnum item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_orderKey) ?? [];
    final itemStr = item.toString().split('.').last;
    final filtered = current.where((e) => e != itemStr).toList();
    filtered.insert(0, itemStr);
    await prefs.setStringList(_orderKey, filtered);
  }

  /// Retorna os 3 itens mais recentes que podem ser exibidos (considerando RBAC)
  /// Se faltar, completa com os defaults na ordem desejada
  static Future<List<HomeItemEnum>> getOrder(
    List<HomeItemEnum> defaultItems,
    SessionBloc sessionBloc,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_orderKey) ?? [];
    final enums = <HomeItemEnum>[];
    // Adiciona os mais recentes do cache, se visíveis
    for (final s in stored) {
      final candidates = HomeItemEnum.values.where(
        (e) => e.toString().split('.').last == s,
      );
      if (candidates.isNotEmpty) {
        final item = candidates.first;
        if (!enums.contains(item) && item.checkVisible(sessionBloc)) {
          enums.add(item);
        }
      }
      if (enums.length == 3) break;
    }
    // Completa com defaults se necessário
    for (final d in defaultItems) {
      if (enums.length == 3) break;
      if (!enums.contains(d) && d.checkVisible(sessionBloc)) {
        enums.add(d);
      }
    }
    return enums;
  }

  /// Para debugr
  static Future<void> clearOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_orderKey);
  }
}
