import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space.dart';
import 'package:lello/feature/space/domain/use_case/list_space_type/list_space_type.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';
import 'package:lello/feature/space/registration/domain/use_case/register_space/register_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/update_space/update_space.dart';
import 'package:lello/feature/space/registration/domain/use_case/upload_space_file/upload_space_file.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_event.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';

class SpaceRegistrationBlocImpl extends SpaceRegistrationBloc {
  static final stepOrder = [
    SpaceRegistrationStep.data,
    SpaceRegistrationStep.rules,
    SpaceRegistrationStep.usage,
    SpaceRegistrationStep.charges,
    SpaceRegistrationStep.confirmation,
    SpaceRegistrationStep.registration,
  ];

  final SessionBloc sessionBloc;
  final RegisterSpace registerSpace;
  final ListAccounts listAccounts;
  final ListSpaceType listSpaceType;
  final UploadSpaceFile uploadSpaceFile;
  final ListSpace listSpaces;
  final UpdateSpace updateSpace;

  var isUpdating = false;
  var didSetup = false;

  var changedStep = false;

  StreamSubscription? _subscription;
  Space? _pendingSpace;
  Space? _pendingSetup;

  SpaceRegistrationBlocImpl(
      {required this.sessionBloc,
      required this.registerSpace,
      required this.uploadSpaceFile,
      required this.listAccounts,
      required this.listSpaces,
      required this.listSpaceType,
      required this.updateSpace})
      : super(SpaceRegistrationIdleState(
            Space(), null, [], stepOrder.first, [], [])) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<SpaceRegistrationState> mapEventToState(
      SpaceRegistrationEvent event) async* {
    if (event is SpaceRegistrationChangeStepEvent)
      yield SpaceRegistrationIdleState(state.data, state.condominium,
          state.accounts, event.step, state.spaces, state.spaceTypes);
    if (event is SpaceRegistrationRegisterEvent) yield* _mapRegister(event);
    if (event is SpaceRegistrationSetupEvent) yield* _mapSetup(event);
  }

  Stream<SpaceRegistrationState> _mapSetup(
      SpaceRegistrationSetupEvent event) async* {
    final condominium = event.condominium;
    final data = isUpdating ? event.space : state.data;
    final step = isUpdating ? SpaceRegistrationStep.confirmation : state.step;
    final accounts = state.accounts;
    final spaces = state.spaces;
    final spaceTypes = state.spaceTypes;

    yield SpaceRegistrationLoadingState(
        data, condominium, accounts, step!, spaces, spaceTypes);
    final requests = [
      listAccounts.call(ListAccountsParms(
          condominiumId: condominium.id, origin: DataOrigin.remote)),
      listSpaces.call(ListSpaceParam(
          condominiumId: condominium.id, origin: DataOrigin.remote)),
      listSpaceType.call(ListSpaceTypeParam(condominiumId: condominium.id))
    ];
    final result = await Future.wait(requests);
    final accountResult = result[0];
    final spaceResult = result[1];
    final spaceTypeResult = result[2];

    if (accountResult is Success ||
        spaceResult is Success ||
        spaceTypeResult is Success) {
      final accountRes = !(accountResult is Rejection<List<Account>>)
          ? accountResult.getOrElse(() => []) as List<Account>
          : accounts;
      List<Space> spaceRes = !(spaceResult is Rejection<List<Space>>)
          ? spaceResult.getOrElse(() => []) as List<Space>
          : spaces;
      final spaceTypeRes = !(spaceTypeResult is Rejection<List<SpaceType>>)
          ? spaceTypeResult.getOrElse(() => []) as List<SpaceType>
          : spaceTypes;
      final space = data.name != null
          ? spaceRes.firstWhere((element) => element.name == data.name)
          : data;
      yield SpaceRegistrationIdleState(
          space, condominium, accountRes, step, spaceRes, spaceTypeRes);
    } else {
      Failure? err;
      if (accountResult is Rejection<List<Account>>) err = accountResult.get();
      if (spaceResult is Rejection<List<Space>>) err = spaceResult.get();
      if (spaceTypeResult is Rejection<List<SpaceType>>)
        err = spaceTypeResult.get();

      yield SpaceRegistrationLoadFailedState(
          data, condominium, accounts, step, spaces, spaceTypes, err);
    }
  }

  Stream<SpaceRegistrationState> _mapRegister(
      SpaceRegistrationRegisterEvent event) async* {
    final condominium = event.condominium;
    final data = state.data;
    final step = state.step;
    final accounts = state.accounts;
    final spaces = state.spaces;
    final spaceTypes = state.spaceTypes;

    yield SpaceRegistrationRegisteringState(
        data, condominium, accounts, step!, spaces, spaceTypes);

    if (isUpdating) {
      final result = await updateSpace
          .call(UpdateSpaceParam(condominiumId: condominium.id, space: data));
      yield result.fold(
          (err) => SpaceRegistrationRegisterFailedState(
              data, condominium, accounts, step, spaces, spaceTypes, err),
          (res) {
        data.id = res.id;
        return SpaceRegistrationRegisteredState(
            res, condominium, accounts, step, spaces, spaceTypes);
      });
    } else {
      final result = await registerSpace
          .call(RegisterSpaceParam(condominiumId: condominium.id, space: data));
      yield result.fold(
          (err) => SpaceRegistrationRegisterFailedState(
              data, condominium, accounts, step, spaces, spaceTypes, err),
          (res) {
        data.id = res.id;
        return SpaceRegistrationRegisteredState(
            res, condominium, accounts, step, spaces, spaceTypes);
      });
    }

    yield* _sendFile(data, condominium, accounts, step, spaces, spaceTypes);
  }

  Stream<SpaceRegistrationState> _sendFile(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes) async* {
    if (data.pendingPicture != null) {
      yield* _upload(condominium, data, accounts, spaces, spaceTypes, step,
          data.pendingPicture!, true);
    }
    if (state is SpaceRegistrationUploadFailedState) return;
    if (data.pendingFile != null) {
      yield* _upload(condominium, data, accounts, spaces, spaceTypes, step,
          data.pendingFile!, false);
    }

    if (state is SpaceRegistrationUploadFailedState) return;
  }

  Stream<SpaceRegistrationState> _upload(
      Condominium condominium,
      Space data,
      List<Account> accounts,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      SpaceRegistrationStep step,
      File file,
      bool uploadingPicture) async* {
    final progressController = StreamController<double>();
    yield SpaceRegistrationUploadingState(data, condominium, accounts, step,
        spaces, spaceTypes, progressController.stream, file);
    final result = await uploadSpaceFile.call(UploadSpaceFileParam(
        spaceId: data.id!,
        file: file,
        progress: progressController,
        condominiumId: condominium.id));
    yield result.fold(
        (err) => SpaceRegistrationUploadFailedState(
            data, condominium, accounts, step, spaces, spaceTypes, err), (res) {
      if (uploadingPicture) {
        data.pictureUrl = res;
        data.pendingPicture = null;
      } else {
        data.pendingFile = null;
        data.fileUrl = res;
      }
      return SpaceRegistrationUploadedState(
          data, condominium, accounts, step, spaces, spaceTypes, res);
    });
    progressController.close();
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (state.condominium == null && condominium != null) {
        if (_pendingSetup != null) {
          setup(_pendingSetup!);
        } else if (!didSetup) {
          add(SpaceRegistrationSetupEvent(
              condominium: condominium, space: state.data));
        }
      }
      if (_pendingSpace != null) {
        beginRegister(_pendingSpace!);
      }
    }
  }

  @override
  void beginRegister(Space space) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(SpaceRegistrationRegisterEvent(
            condominium: condominium, space: space));
      }
      _pendingSpace = null;
    } else {
      _pendingSpace = space;
    }
  }

  @override
  void nextStep() {
    final step = state.step ?? stepOrder.first;
    final index = stepOrder.indexOf(step);
    if (index < stepOrder.length - 1) {
      goToStep(stepOrder[index + 1]);
    }
    changedStep = true;
  }

  @override
  bool previousStep() {
    if (isUpdating && !changedStep) return true;

    final step = state.step ?? stepOrder.first;
    final index = stepOrder.indexOf(step);
    if (index > 0) {
      goToStep(stepOrder[index - 1]);
      return false;
    }
    return true;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  void goToStep(SpaceRegistrationStep step) {
    add(SpaceRegistrationChangeStepEvent(step: step));
  }

  @override
  void setup(Space space) {
    isUpdating = true;
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        didSetup = true;
        add(SpaceRegistrationSetupEvent(
            condominium: condominium, space: space));
      }
      _pendingSetup = null;
    } else {
      _pendingSetup = space;
    }
  }
}
