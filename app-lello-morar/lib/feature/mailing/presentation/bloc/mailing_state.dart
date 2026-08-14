import 'package:essentials/essentials.dart';
import '../../domain/entity/mailing.dart';

abstract class MailingState extends Equatable {
  const MailingState();

  @override
  List<Object?> get props => [];
}

class MailingInitialState extends MailingState {
  const MailingInitialState();
}

class MailingLoadingState extends MailingState {
  const MailingLoadingState();
}

class MailingSuccessState extends MailingState {
  final List<Mailing> mailings;

  const MailingSuccessState({
    required this.mailings,
  });

  @override
  List<Object?> get props => [mailings];
}

class MailingFailureState extends MailingState {
  const MailingFailureState();
}
