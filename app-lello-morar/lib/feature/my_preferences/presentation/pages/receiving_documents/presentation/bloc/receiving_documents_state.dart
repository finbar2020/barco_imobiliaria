import 'package:essentials/essentials.dart';

import '../../../../../domain/entities/access_data_entity.dart';
import '../../../../../model/zero_paper_preference_item_model.dart';

abstract class ReceivingDocumentsState extends Equatable {
  const ReceivingDocumentsState();

  @override
  List<Object?> get props => [];
}

class ReceivingDocumentsInitialState extends ReceivingDocumentsState {
  const ReceivingDocumentsInitialState();
}

class ReceivingDocumentsLoadingState extends ReceivingDocumentsState {
  const ReceivingDocumentsLoadingState();
}

class ReceivingDocumentsLoadedState extends ReceivingDocumentsState {
  final List<ZeroPaperItemModel> preferences;
  final AccessData accessData;
  final bool hasChanges;
  final bool hasSavedChanges;

  const ReceivingDocumentsLoadedState({
    required this.hasChanges,
    required this.preferences,
    required this.hasSavedChanges,
    required this.accessData,
  });

  @override
  List<Object?> get props => [
        preferences,
        hasChanges,
        hasSavedChanges,
        accessData,
      ];
}

class ReceivingDocumentsFailureState extends ReceivingDocumentsState {
  final String error;

  const ReceivingDocumentsFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
