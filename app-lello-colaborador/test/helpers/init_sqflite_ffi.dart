import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool _sqfliteInitialized = false;

/// Inicializa o sqflite para testes.
///
/// Cada arquivo de teste roda em um processo próprio, mas todos apontariam
/// para a mesma pasta de bancos — e o sqlite trava ("database is locked")
/// quando dois processos abrem o mesmo arquivo. Por isso cada processo recebe
/// uma pasta temporária exclusiva.
void initSqfliteForTests() {
  if (_sqfliteInitialized) return;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  databaseFactory.setDatabasesPath(
    Directory.systemTemp.createTempSync('colaborador_db').path,
  );
  _sqfliteInitialized = true;
}
