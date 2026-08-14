import 'package:essentials/essentials.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';

abstract class BilletsState extends Equatable {
  final List<Billet> billets;
  final int allItems;
  final Billet? billet;

  const BilletsState({
    this.billets = const [],
    this.allItems = 0,
    this.billet,
  });

  @override
  List<Object?> get props => [billets, allItems, billet];
}

class BilletsInitialState extends BilletsState {
  const BilletsInitialState();
}

class BilletsLoadingState extends BilletsState {
  const BilletsLoadingState({Billet? billet}) : super(billet: billet);
}

class BilletsLoadedState extends BilletsState {
  final List<Billet> billets;
  final int allBillets;

  const BilletsLoadedState({required this.billets, required this.allBillets})
      : super();

  @override
  List<Object?> get props => [billets, allBillets];
}

class BilletsShowInfoState extends BilletsState {
  final Billet billet;
  final String? pdf;
  final String? fileName;

  const BilletsShowInfoState({
    required this.billet,
    this.pdf,
    this.fileName,
  }) : super();

  @override
  List<Object?> get props => [billet, pdf, fileName];
}

class BilletsFailureState extends BilletsState {
  final String errorMessageKey;
  final Billet? billet;

  const BilletsFailureState({required this.errorMessageKey, this.billet})
      : super();

  @override
  List<Object?> get props => [errorMessageKey, billet];
}
