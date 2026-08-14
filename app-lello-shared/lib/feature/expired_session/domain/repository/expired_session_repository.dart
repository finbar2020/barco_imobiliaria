part of shared_features;

abstract class ExpiredSessionRepository {
  Future<Try<Nothing>> clear();
}
