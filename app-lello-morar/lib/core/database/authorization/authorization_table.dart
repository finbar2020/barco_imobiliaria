import 'package:drift/drift.dart';

@DataClassName("AuthorizationData")
class AuthorizationTable extends Table {
  TextColumn get role => text()();

  @override
  Set<Column> get primaryKey => {role};
}
