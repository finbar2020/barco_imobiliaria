part of shared_features;

class ClearDataImpl extends ClearData {
  ClearDataImpl();

  @override
  Future<Try<Nothing>> call() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return Success(Nothing());
  }
}
