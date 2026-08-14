import 'package:drift/drift.dart';

@DataClassName("MeData")
class MeTable extends Table {
  TextColumn get id => text().nullable()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get cpf => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get picture => text()();
  TextColumn get pictureHash => text().nullable()();
  TextColumn get biometricPictureHash => text().nullable()();
  BoolColumn get useFacialBiometric => boolean().nullable()();
  DateTimeColumn get updated => dateTime()();

  @override
  Set<Column> get primaryKey => {email};
}