import 'package:essentials/essentials.dart';
import '../../domain/entity/mailing.dart';

abstract class MailingEvent extends Equatable {
  const MailingEvent();

  @override
  List<Object?> get props => [];
}

class MailingEmptyEvent extends MailingEvent {
  const MailingEmptyEvent();
}

class MailingLoadingEvent extends MailingEvent {
  const MailingLoadingEvent();
}

class MailingSuccessEvent extends MailingEvent {
  final List<Mailing> mailings;

  const MailingSuccessEvent({
    required this.mailings,
  });

  @override
  List<Object?> get props => [mailings];
}

class MailingFailureEvent extends MailingEvent {
  const MailingFailureEvent();
}
