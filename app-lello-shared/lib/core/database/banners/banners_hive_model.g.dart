// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannersHiveAdapter extends TypeAdapter<BannersHive> {
  @override
  final int typeId = 1;

  @override
  BannersHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannersHive()
      ..id = fields[0] as String
      ..condominiumId = fields[1] as String
      ..redirect = fields[2] as String?
      ..redirectType = fields[3] as String?
      ..image = fields[4] as String
      ..urlImage = fields[5] as String?
      ..feature = fields[6] as String?
      ..lastUpdateAt = fields[7] as DateTime?
      ..name = fields[8] as String?
      ..observacao = fields[9] as String?
      ..location = fields[10] as String?
      ..subTitle = fields[11] as String?
      ..typeBanner = fields[12] as String?
      ..projeto = fields[13] as String?
      ..ordem = fields[14] as int?
      ..ativo = fields[15] as String?;
  }

  @override
  void write(BinaryWriter writer, BannersHive obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.condominiumId)
      ..writeByte(2)
      ..write(obj.redirect)
      ..writeByte(3)
      ..write(obj.redirectType)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.urlImage)
      ..writeByte(6)
      ..write(obj.feature)
      ..writeByte(7)
      ..write(obj.lastUpdateAt)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.observacao)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.subTitle)
      ..writeByte(12)
      ..write(obj.typeBanner)
      ..writeByte(13)
      ..write(obj.projeto)
      ..writeByte(14)
      ..write(obj.ordem)
      ..writeByte(15)
      ..write(obj.ativo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannersHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
