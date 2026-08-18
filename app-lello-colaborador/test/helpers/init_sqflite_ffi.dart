import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool _sqfliteInitialized = false;

void initSqfliteForTests() {
  if (_sqfliteInitialized) return;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  _sqfliteInitialized = true;
}
