
import 'dart:convert';
import 'dart:io';

String readFixture(String name) => File("test/fixture/$name.json").readAsStringSync();
Map<String, dynamic> fixture(String name) => jsonDecode(readFixture(name));
