part of shared_features;

class ExpiredSessionBloc extends Bloc<ExpiredSessionEvent, ExpiredSessionState> {
  final ClearData clearDataUseCase;
  final Logout logOutUseCase;
  final VoidCallback emptySessionState;

  ExpiredSessionBloc({
    required this.clearDataUseCase,
    required this.logOutUseCase,
    required this.emptySessionState,
  }) : super(const ExpiredSessionEmptyState()) {
    on<ExpiredSessionLogOutEvent>(_mapLogOut);
  }

  void beginLogOut(ExpiredSessionArguments? args) {
    add(ExpiredSessionLogOutEvent(args));
  }

  Future<void> _mapLogOut(
    ExpiredSessionLogOutEvent event,
    Emitter<ExpiredSessionState> emit,
  ) async {
    emit(const ExpiredSessionLogOutLoadingState());

    await logOutUseCase.call();
    await clearDataUseCase.call();

    setEmptySessionState();

    final args = event.args;
    await FirebaseCrashlytics.instance
        .log("CPF session: ${args?.cpf ?? "N/A"}");
    await FirebaseCrashlytics.instance
        .log("Token: ${args?.accessToken ?? "N/A"}");
    await FirebaseCrashlytics.instance
        .log("Refresh: ${args?.refreshToken ?? "N/A"}");
    await FirebaseCrashlytics.instance
        .log("Failure: ${args?.failure ?? "N/A"}");
    await FirebaseCrashlytics.instance.recordError(
      Exception("sessao_expirada_new"),
      StackTrace.current,
      reason: args?.reason ?? "empty",
      information: args?.information ?? [],
    );

    emit(const ExpiredSessionLogOutLoadedState());
  }

  void setEmptySessionState() {
    emptySessionState();
  }
}
