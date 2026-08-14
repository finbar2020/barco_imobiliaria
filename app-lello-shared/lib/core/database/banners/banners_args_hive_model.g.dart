// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_args_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannersArgsHiveModelAdapter extends TypeAdapter<BannersArgsHiveModel> {
  @override
  final int typeId = 0;

  @override
  BannersArgsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannersArgsHiveModel()
      ..bannerId = fields[0] as String
      ..condominiumId = fields[1] as String
      ..partnerId = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, BannersArgsHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.bannerId)
      ..writeByte(1)
      ..write(obj.condominiumId)
      ..writeByte(2)
      ..write(obj.partnerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannersArgsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
