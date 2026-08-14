// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_documents_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedDocumentsHiveAdapter extends TypeAdapter<CachedDocumentsHive> {
  @override
  final int typeId = 2;

  @override
  CachedDocumentsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedDocumentsHive()
      ..key = fields[0] as String
      ..documentsJson = fields[1] as String
      ..lastFetchedAt = fields[2] as int
      ..lastErrorAt = fields[3] as int?;
  }

  @override
  void write(BinaryWriter writer, CachedDocumentsHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.documentsJson)
      ..writeByte(2)
      ..write(obj.lastFetchedAt)
      ..writeByte(3)
      ..write(obj.lastErrorAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedDocumentsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
