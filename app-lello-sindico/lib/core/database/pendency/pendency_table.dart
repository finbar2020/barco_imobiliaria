import 'package:drift/drift.dart';

@DataClassName("PendencyData")
class PendencyTable extends Table {
  TextColumn get condominiumId => text()();
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  TextColumn get message => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get type => text()();
  TextColumn get senderId => text()();
  TextColumn get senderName => text().nullable()();
  TextColumn get senderPicture => text().nullable()();
  TextColumn get module => text().nullable()();

  @override
  Set<Column> get primaryKey => {condominiumId, id};
}
