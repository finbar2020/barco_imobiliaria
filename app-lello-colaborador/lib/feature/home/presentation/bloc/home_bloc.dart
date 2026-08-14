import 'package:colaborador/feature/home/presentation/bloc/home_event.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_state.dart';
import 'package:colaborador/feature/me/domain/entity/condominium.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:shared_features/shared_features.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RegisterFcm registerFcm;
  final SessionBloc sessionBloc;
  final DeviceIdentifierService deviceIdentifierService;

  HomeBloc({
    required this.registerFcm,
    required this.sessionBloc,
    required this.deviceIdentifierService,
  }) : super(const HomeInitialState()) {
    on<HomeLoadEvent>(handleHomeLoadEvent);
  }

  void handleHomeLoadEvent(
    HomeLoadEvent event,
    Emitter emit,
  ) {
    emit(
      HomeLoadedState(
        digitalPoints: event.digitalPoints,
      ),
    );
  }

  void registerFcmToken(List<Condominium> condominiums) async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;

    String? fcmToken = await fcm.getToken();

    String? deviceId = await deviceIdentifierService.getDeviceIdentifier();
    RegisterFcmToken fcmTokenParams = RegisterFcmToken();
    fcmTokenParams.reference = condominiums.map((e) => e.reference).toList();
    fcmTokenParams.type = 'APPDPREP';
    fcmTokenParams.token = fcmToken;
    fcmTokenParams.deviceId = deviceId;

    await registerFcm.call(RegisterFcmTokenParams(fcmToken: fcmTokenParams));
  }
}
