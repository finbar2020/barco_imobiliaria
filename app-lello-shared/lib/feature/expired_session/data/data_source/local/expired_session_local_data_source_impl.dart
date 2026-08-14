part of shared_features;

class ExpiredSessionLocalDataSourceImpl extends ExpiredSessionLocalDataSource {
  final Future<Try<Nothing>> Function() resetDb;

  ExpiredSessionLocalDataSourceImpl({required this.resetDb});

  @override
  Future<void> clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await resetDb();
  }
}
