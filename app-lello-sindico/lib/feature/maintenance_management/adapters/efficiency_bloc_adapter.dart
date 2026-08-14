import '../domain/entity/efficiency_entity.dart';
import '../presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';

extension EfficiencyItemEntityToBlocAdapter on EfficiencyItemEntity {
  EfficiencyItem toBlocItem({String? subtitle, String avatarColor = '#2F80ED'}) {
    return EfficiencyItem(
      id: id,
      title: name,
      subtitle: subtitle,
      completed: done,
      pending: notStarted,
      inProgress: draft,
      avatarColor: avatarColor,
    );
  }
}

extension EfficiencyResponseEntityToBlocAdapter on EfficiencyResponseEntity {
  List<EfficiencyItem> toBlocItems({String avatarColor = '#2F80ED'}) {
    return efficiencyResponse.map((item) => item.toBlocItem(avatarColor: avatarColor)).toList();
  }
}
