import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';

abstract class MailingRepository {
  Future<Try<Paginator>> getMailings(String unityId, {bool showAll = false});

  Future<Try<Uint8List?>> getPicture(String hash);
}
