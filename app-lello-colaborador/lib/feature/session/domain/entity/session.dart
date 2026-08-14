import 'package:colaborador/feature/me/domain/entity/condominium.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:shared_features/shared_features.dart';

class Session extends SharedSession {
  Me me;
  Condominium condominium;

  Session({
    required this.me,
    required this.condominium,
  });

  @override
  String get condominiumId => condominium.id;

  @override
  String get condominiumReference => condominium.reference;

  @override
  String get unitId => "";

  @override
  String get userId => me.id;

  Position? _position;
  void setLastPosition(Position p) {
    if (lastPosition == null) {
      _position = p;
      return;
    } else if (p.accuracy < _position!.accuracy) {
      _position = p;
      return;
    }
  }

  //only if position is more recent than 1 minute
  Position? get lastPosition => _position?.timestamp != null &&
          DateTime.now().difference(_position!.timestamp).inMinutes < 1
      ? _position
      : null;
}
