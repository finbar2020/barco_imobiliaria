import 'package:drift/drift.dart';
import 'package:morar/core/database/authorization/authorization_table.dart';
import 'package:morar/core/database/lello_database.dart';

part 'authorization_dao.g.dart';

@DriftAccessor(tables: [AuthorizationTable])
class AuthorizationDao extends DatabaseAccessor<LelloDatabase>
    with _$AuthorizationDaoMixin {
  final LelloDatabase database;
  AuthorizationDao(this.database) : super(database);

  Future<AuthorizationData> get() =>
      select(database.authorizationTable).getSingle();
  Future<int> clear() => delete(database.authorizationTable).go();
  Future<void> insert(Insertable<AuthorizationData> data) =>
      into(database.authorizationTable).insert(data, mode: InsertMode.replace);
}
