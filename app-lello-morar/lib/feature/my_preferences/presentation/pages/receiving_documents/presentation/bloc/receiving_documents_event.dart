import 'package:essentials/essentials.dart';

import '../../../../../domain/entities/access_data_entity.dart';
import '../../../../../model/zero_paper_preference_item_model.dart';

abstract class ReceivingDocumentsEvent extends Equatable {
  const ReceivingDocumentsEvent();

  @override
  List<Object?> get props => [];
}

class ReceivingDocumentsLoadingEvent extends ReceivingDocumentsEvent {
  const ReceivingDocumentsLoadingEvent();
}

class ReceivingDocumentsLoadedEvent extends ReceivingDocumentsEvent {
  final List<ZeroPaperItemModel> preferences;
  final bool hasChanges;
  final bool hasSavedChanges;
  final AccessData accessData;

  const ReceivingDocumentsLoadedEvent({
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

class ReceivingDocumentsFailureEvent extends ReceivingDocumentsEvent {
  final String error;

  const ReceivingDocumentsFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
