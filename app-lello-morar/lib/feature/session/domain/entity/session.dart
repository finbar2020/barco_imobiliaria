import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/me/domain/entity/me.dart';

class Session {
  Me? me;

  Unity? _unity;
  Condominium? _condominium;

  Unity? get unity {
    _unity = _unity ?? me?.condominiums?.first.blocks?.first.units?.first;
    return _unity;
  }

  Condominium? get condominium {
    _condominium = _condominium ?? me?.condominiums?.first;
    return _condominium;
  }

  String? get tokenName {
    if (condominium?.id == null || unity?.id == null) return null;
    return (condominium!.reference! + unity!.title!);
  }

  set unity(Unity? u) {
    _unity = u;
  }

  set condominium(Condominium? c) {
    _condominium = c;
  }

  Session();
}
