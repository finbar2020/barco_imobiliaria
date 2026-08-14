part of shared_features;

class LogoutImpl extends Logout {
  final AccessTokenRepository repository;
  final pendencyRepository;
  final sessionRepository;

  LogoutImpl(
      {required this.repository,
      required this.pendencyRepository,
      required this.sessionRepository});

  @override
  Future<Try<Nothing>> call() async {
    final result = await this.repository.save(null);
    if (pendencyRepository != null) await this.pendencyRepository.clear();
    await this.sessionRepository.clear();
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    _fcm.deleteToken();
    return result.fold((err) => Rejection(err), (_) => Success(Nothing()));
  }
}
