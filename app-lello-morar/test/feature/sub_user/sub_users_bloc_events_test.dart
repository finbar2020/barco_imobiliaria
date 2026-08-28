import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';

import 'sub_user_test_helpers.dart';

void main() {
  test('SubUsersBloc mapeia todos os eventos para os estados', () async {
    final bloc = SubUsersBloc();
    final states = <Type>[];
    final sub = bloc.stream.listen((s) => states.add(s.runtimeType));

    final events = <SubUserEvent>[
      SubUserLoadingEvent(),
      SubUserErrorEvent(error: UnknownFailure('x')),
      SubUserLoadedEvent(subUsers: [owner()], pendingRequests: const []),
      SubUserInviteResidentFailureEvent(subUser: subUser(), failure: UnknownFailure('x')),
      SubUserInviteResidentLoadingEvent(),
      SubUserInviteResidentSuccessEvent(),
      SubUserInviteLoadedEvent(subUser: subUser()),
      SubUserServiceOnEvent(),
      SubUserServiceOffEvent(),
      SubUserFacialLoadingEvent(),
      SubUserFacialLoadedEvent(),
      SubUserFacialErrorEvent(code: '1', message: 'm'),
      SubUserSendInviteErrorEvent(),
      SubUserSendInviteLoadedEvent(),
      UpdateStatusRequestLoadingEvent(),
    ];
    for (final e in events) {
      bloc.add(e);
    }
    bloc.add(UpdateAccessStatusRequestSuccessState(status: 'ok'));
    bloc.add(UpdateAccessStatusRequestErrorState(error: UnknownFailure('x')));
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(states, [
      SubUserLoadingState,
      SubUserErrorState,
      SubUserLoadedState,
      InsertSubUserErrorState,
      SubUserInviteLoadingState,
      SubUserInviteSuccessState,
      SubUserInviteLoadedState,
      CheckServiceOnlineState,
      CheckServiceOfflineState,
      FacialBiometricLoadingState,
      FacialBiometricLoadedState,
      FacialBiometricErrorState,
      SendInviteFailedState,
      SendInviteSuccessState,
      UpdateStatusRequestLoadingState,
      UpdateAccessStatusRequestSuccessState,
      UpdateAccessStatusRequestErrorState,
    ]);
    final facial = FacialBiometricErrorState(code: 'c', message: 'm');
    expect(facial.code, 'c');
    expect(SendInviteSubUserState(subUser: subUser()).subUser.id, 's1');
    expect(SendInviteSubUserErrorState(error: 'e').error, 'e');
    expect(UpdateSubUserAccessStatusRequestErrorEvent(error: null).error, isNull);
    expect(UpdateSubUserAccessStatusRequestSuccessEvent(), isA<SubUserEvent>());
    await sub.cancel();
    await bloc.close();
  });
}
