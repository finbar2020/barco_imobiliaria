import 'package:lello/core/database/chat_contact/chat_contact_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'chat_contact_dao.g.dart';

@DriftAccessor(tables: [ChatContactTable])
class ChatContactDao extends DatabaseAccessor<LelloDatabase>
    with _$ChatContactDaoMixin {
  final LelloDatabase database;
  ChatContactDao(this.database) : super(database);

  Future<List<ChatContactData>> list(String condominiumId) =>
      (select(database.chatContactTable)
            ..where((tbl) => tbl.condominiumId.equals(condominiumId)))
          .get();

  Future<void> insert(List<Insertable<ChatContactData>> data) => batch((b) =>
      b.insertAll(database.chatContactTable, data, mode: InsertMode.replace));
  Future<int> clear() => delete(database.chatContactTable).go();
}
