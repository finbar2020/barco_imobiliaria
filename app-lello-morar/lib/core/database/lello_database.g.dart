// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lello_database.dart';

// ignore_for_file: type=lint
class $MeTableTable extends MeTable with TableInfo<$MeTableTable, MeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
      'cpf', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pictureMeta =
      const VerificationMeta('picture');
  @override
  late final GeneratedColumn<String> picture = GeneratedColumn<String>(
      'picture', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pictureHashMeta =
      const VerificationMeta('pictureHash');
  @override
  late final GeneratedColumn<String> pictureHash = GeneratedColumn<String>(
      'picture_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _biometricPictureHashMeta =
      const VerificationMeta('biometricPictureHash');
  @override
  late final GeneratedColumn<String> biometricPictureHash =
      GeneratedColumn<String>('biometric_picture_hash', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _useFacialBiometricMeta =
      const VerificationMeta('useFacialBiometric');
  @override
  late final GeneratedColumn<bool> useFacialBiometric = GeneratedColumn<bool>(
      'use_facial_biometric', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("use_facial_biometric" IN (0, 1))'));
  static const VerificationMeta _updatedMeta =
      const VerificationMeta('updated');
  @override
  late final GeneratedColumn<DateTime> updated = GeneratedColumn<DateTime>(
      'updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        cpf,
        phone,
        picture,
        pictureHash,
        biometricPictureHash,
        useFacialBiometric,
        updated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'me_table';
  @override
  VerificationContext validateIntegrity(Insertable<MeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('cpf')) {
      context.handle(
          _cpfMeta, cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta,
          picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta));
    } else if (isInserting) {
      context.missing(_pictureMeta);
    }
    if (data.containsKey('picture_hash')) {
      context.handle(
          _pictureHashMeta,
          pictureHash.isAcceptableOrUnknown(
              data['picture_hash']!, _pictureHashMeta));
    }
    if (data.containsKey('biometric_picture_hash')) {
      context.handle(
          _biometricPictureHashMeta,
          biometricPictureHash.isAcceptableOrUnknown(
              data['biometric_picture_hash']!, _biometricPictureHashMeta));
    }
    if (data.containsKey('use_facial_biometric')) {
      context.handle(
          _useFacialBiometricMeta,
          useFacialBiometric.isAcceptableOrUnknown(
              data['use_facial_biometric']!, _useFacialBiometricMeta));
    }
    if (data.containsKey('updated')) {
      context.handle(_updatedMeta,
          updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta));
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {email};
  @override
  MeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      picture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture'])!,
      pictureHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture_hash']),
      biometricPictureHash: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}biometric_picture_hash']),
      useFacialBiometric: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}use_facial_biometric']),
      updated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated'])!,
    );
  }

  @override
  $MeTableTable createAlias(String alias) {
    return $MeTableTable(attachedDatabase, alias);
  }
}

class MeData extends DataClass implements Insertable<MeData> {
  final String? id;
  final String name;
  final String email;
  final String? cpf;
  final String? phone;
  final String picture;
  final String? pictureHash;
  final String? biometricPictureHash;
  final bool? useFacialBiometric;
  final DateTime updated;
  const MeData(
      {this.id,
      required this.name,
      required this.email,
      this.cpf,
      this.phone,
      required this.picture,
      this.pictureHash,
      this.biometricPictureHash,
      this.useFacialBiometric,
      required this.updated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || cpf != null) {
      map['cpf'] = Variable<String>(cpf);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['picture'] = Variable<String>(picture);
    if (!nullToAbsent || pictureHash != null) {
      map['picture_hash'] = Variable<String>(pictureHash);
    }
    if (!nullToAbsent || biometricPictureHash != null) {
      map['biometric_picture_hash'] = Variable<String>(biometricPictureHash);
    }
    if (!nullToAbsent || useFacialBiometric != null) {
      map['use_facial_biometric'] = Variable<bool>(useFacialBiometric);
    }
    map['updated'] = Variable<DateTime>(updated);
    return map;
  }

  MeTableCompanion toCompanion(bool nullToAbsent) {
    return MeTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: Value(name),
      email: Value(email),
      cpf: cpf == null && nullToAbsent ? const Value.absent() : Value(cpf),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      picture: Value(picture),
      pictureHash: pictureHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pictureHash),
      biometricPictureHash: biometricPictureHash == null && nullToAbsent
          ? const Value.absent()
          : Value(biometricPictureHash),
      useFacialBiometric: useFacialBiometric == null && nullToAbsent
          ? const Value.absent()
          : Value(useFacialBiometric),
      updated: Value(updated),
    );
  }

  factory MeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeData(
      id: serializer.fromJson<String?>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      cpf: serializer.fromJson<String?>(json['cpf']),
      phone: serializer.fromJson<String?>(json['phone']),
      picture: serializer.fromJson<String>(json['picture']),
      pictureHash: serializer.fromJson<String?>(json['pictureHash']),
      biometricPictureHash:
          serializer.fromJson<String?>(json['biometricPictureHash']),
      useFacialBiometric:
          serializer.fromJson<bool?>(json['useFacialBiometric']),
      updated: serializer.fromJson<DateTime>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'cpf': serializer.toJson<String?>(cpf),
      'phone': serializer.toJson<String?>(phone),
      'picture': serializer.toJson<String>(picture),
      'pictureHash': serializer.toJson<String?>(pictureHash),
      'biometricPictureHash': serializer.toJson<String?>(biometricPictureHash),
      'useFacialBiometric': serializer.toJson<bool?>(useFacialBiometric),
      'updated': serializer.toJson<DateTime>(updated),
    };
  }

  MeData copyWith(
          {Value<String?> id = const Value.absent(),
          String? name,
          String? email,
          Value<String?> cpf = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          String? picture,
          Value<String?> pictureHash = const Value.absent(),
          Value<String?> biometricPictureHash = const Value.absent(),
          Value<bool?> useFacialBiometric = const Value.absent(),
          DateTime? updated}) =>
      MeData(
        id: id.present ? id.value : this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        cpf: cpf.present ? cpf.value : this.cpf,
        phone: phone.present ? phone.value : this.phone,
        picture: picture ?? this.picture,
        pictureHash: pictureHash.present ? pictureHash.value : this.pictureHash,
        biometricPictureHash: biometricPictureHash.present
            ? biometricPictureHash.value
            : this.biometricPictureHash,
        useFacialBiometric: useFacialBiometric.present
            ? useFacialBiometric.value
            : this.useFacialBiometric,
        updated: updated ?? this.updated,
      );
  MeData copyWithCompanion(MeTableCompanion data) {
    return MeData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      phone: data.phone.present ? data.phone.value : this.phone,
      picture: data.picture.present ? data.picture.value : this.picture,
      pictureHash:
          data.pictureHash.present ? data.pictureHash.value : this.pictureHash,
      biometricPictureHash: data.biometricPictureHash.present
          ? data.biometricPictureHash.value
          : this.biometricPictureHash,
      useFacialBiometric: data.useFacialBiometric.present
          ? data.useFacialBiometric.value
          : this.useFacialBiometric,
      updated: data.updated.present ? data.updated.value : this.updated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('cpf: $cpf, ')
          ..write('phone: $phone, ')
          ..write('picture: $picture, ')
          ..write('pictureHash: $pictureHash, ')
          ..write('biometricPictureHash: $biometricPictureHash, ')
          ..write('useFacialBiometric: $useFacialBiometric, ')
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, cpf, phone, picture,
      pictureHash, biometricPictureHash, useFacialBiometric, updated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.cpf == this.cpf &&
          other.phone == this.phone &&
          other.picture == this.picture &&
          other.pictureHash == this.pictureHash &&
          other.biometricPictureHash == this.biometricPictureHash &&
          other.useFacialBiometric == this.useFacialBiometric &&
          other.updated == this.updated);
}

class MeTableCompanion extends UpdateCompanion<MeData> {
  final Value<String?> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> cpf;
  final Value<String?> phone;
  final Value<String> picture;
  final Value<String?> pictureHash;
  final Value<String?> biometricPictureHash;
  final Value<bool?> useFacialBiometric;
  final Value<DateTime> updated;
  final Value<int> rowid;
  const MeTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.cpf = const Value.absent(),
    this.phone = const Value.absent(),
    this.picture = const Value.absent(),
    this.pictureHash = const Value.absent(),
    this.biometricPictureHash = const Value.absent(),
    this.useFacialBiometric = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    this.cpf = const Value.absent(),
    this.phone = const Value.absent(),
    required String picture,
    this.pictureHash = const Value.absent(),
    this.biometricPictureHash = const Value.absent(),
    this.useFacialBiometric = const Value.absent(),
    required DateTime updated,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        email = Value(email),
        picture = Value(picture),
        updated = Value(updated);
  static Insertable<MeData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? cpf,
    Expression<String>? phone,
    Expression<String>? picture,
    Expression<String>? pictureHash,
    Expression<String>? biometricPictureHash,
    Expression<bool>? useFacialBiometric,
    Expression<DateTime>? updated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (cpf != null) 'cpf': cpf,
      if (phone != null) 'phone': phone,
      if (picture != null) 'picture': picture,
      if (pictureHash != null) 'picture_hash': pictureHash,
      if (biometricPictureHash != null)
        'biometric_picture_hash': biometricPictureHash,
      if (useFacialBiometric != null)
        'use_facial_biometric': useFacialBiometric,
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeTableCompanion copyWith(
      {Value<String?>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String?>? cpf,
      Value<String?>? phone,
      Value<String>? picture,
      Value<String?>? pictureHash,
      Value<String?>? biometricPictureHash,
      Value<bool?>? useFacialBiometric,
      Value<DateTime>? updated,
      Value<int>? rowid}) {
    return MeTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      picture: picture ?? this.picture,
      pictureHash: pictureHash ?? this.pictureHash,
      biometricPictureHash: biometricPictureHash ?? this.biometricPictureHash,
      useFacialBiometric: useFacialBiometric ?? this.useFacialBiometric,
      updated: updated ?? this.updated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String>(picture.value);
    }
    if (pictureHash.present) {
      map['picture_hash'] = Variable<String>(pictureHash.value);
    }
    if (biometricPictureHash.present) {
      map['biometric_picture_hash'] =
          Variable<String>(biometricPictureHash.value);
    }
    if (useFacialBiometric.present) {
      map['use_facial_biometric'] = Variable<bool>(useFacialBiometric.value);
    }
    if (updated.present) {
      map['updated'] = Variable<DateTime>(updated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('cpf: $cpf, ')
          ..write('phone: $phone, ')
          ..write('picture: $picture, ')
          ..write('pictureHash: $pictureHash, ')
          ..write('biometricPictureHash: $biometricPictureHash, ')
          ..write('useFacialBiometric: $useFacialBiometric, ')
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CondominiumTableTable extends CondominiumTable
    with TableInfo<$CondominiumTableTable, CondominiumData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CondominiumTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _regulationUrlMeta =
      const VerificationMeta('regulationUrl');
  @override
  late final GeneratedColumn<String> regulationUrl = GeneratedColumn<String>(
      'regulation_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _active_managerMeta =
      const VerificationMeta('active_manager');
  @override
  late final GeneratedColumn<bool> active_manager = GeneratedColumn<bool>(
      'active_manager', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("active_manager" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, reference, name, address, regulationUrl, active_manager];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condominium_table';
  @override
  VerificationContext validateIntegrity(Insertable<CondominiumData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('regulation_url')) {
      context.handle(
          _regulationUrlMeta,
          regulationUrl.isAcceptableOrUnknown(
              data['regulation_url']!, _regulationUrlMeta));
    } else if (isInserting) {
      context.missing(_regulationUrlMeta);
    }
    if (data.containsKey('active_manager')) {
      context.handle(
          _active_managerMeta,
          active_manager.isAcceptableOrUnknown(
              data['active_manager']!, _active_managerMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CondominiumData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CondominiumData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      regulationUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}regulation_url'])!,
      active_manager: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active_manager']),
    );
  }

  @override
  $CondominiumTableTable createAlias(String alias) {
    return $CondominiumTableTable(attachedDatabase, alias);
  }
}

class CondominiumData extends DataClass implements Insertable<CondominiumData> {
  final String id;
  final String? reference;
  final String? name;
  final String? address;
  final String regulationUrl;
  final bool? active_manager;
  const CondominiumData(
      {required this.id,
      this.reference,
      this.name,
      this.address,
      required this.regulationUrl,
      this.active_manager});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['regulation_url'] = Variable<String>(regulationUrl);
    if (!nullToAbsent || active_manager != null) {
      map['active_manager'] = Variable<bool>(active_manager);
    }
    return map;
  }

  CondominiumTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumTableCompanion(
      id: Value(id),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      regulationUrl: Value(regulationUrl),
      active_manager: active_manager == null && nullToAbsent
          ? const Value.absent()
          : Value(active_manager),
    );
  }

  factory CondominiumData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumData(
      id: serializer.fromJson<String>(json['id']),
      reference: serializer.fromJson<String?>(json['reference']),
      name: serializer.fromJson<String?>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      regulationUrl: serializer.fromJson<String>(json['regulationUrl']),
      active_manager: serializer.fromJson<bool?>(json['active_manager']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reference': serializer.toJson<String?>(reference),
      'name': serializer.toJson<String?>(name),
      'address': serializer.toJson<String?>(address),
      'regulationUrl': serializer.toJson<String>(regulationUrl),
      'active_manager': serializer.toJson<bool?>(active_manager),
    };
  }

  CondominiumData copyWith(
          {String? id,
          Value<String?> reference = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> address = const Value.absent(),
          String? regulationUrl,
          Value<bool?> active_manager = const Value.absent()}) =>
      CondominiumData(
        id: id ?? this.id,
        reference: reference.present ? reference.value : this.reference,
        name: name.present ? name.value : this.name,
        address: address.present ? address.value : this.address,
        regulationUrl: regulationUrl ?? this.regulationUrl,
        active_manager:
            active_manager.present ? active_manager.value : this.active_manager,
      );
  CondominiumData copyWithCompanion(CondominiumTableCompanion data) {
    return CondominiumData(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      regulationUrl: data.regulationUrl.present
          ? data.regulationUrl.value
          : this.regulationUrl,
      active_manager: data.active_manager.present
          ? data.active_manager.value
          : this.active_manager,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumData(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('regulationUrl: $regulationUrl, ')
          ..write('active_manager: $active_manager')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, reference, name, address, regulationUrl, active_manager);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumData &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.name == this.name &&
          other.address == this.address &&
          other.regulationUrl == this.regulationUrl &&
          other.active_manager == this.active_manager);
}

class CondominiumTableCompanion extends UpdateCompanion<CondominiumData> {
  final Value<String> id;
  final Value<String?> reference;
  final Value<String?> name;
  final Value<String?> address;
  final Value<String> regulationUrl;
  final Value<bool?> active_manager;
  final Value<int> rowid;
  const CondominiumTableCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.regulationUrl = const Value.absent(),
    this.active_manager = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumTableCompanion.insert({
    required String id,
    this.reference = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    required String regulationUrl,
    this.active_manager = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        regulationUrl = Value(regulationUrl);
  static Insertable<CondominiumData> custom({
    Expression<String>? id,
    Expression<String>? reference,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? regulationUrl,
    Expression<bool>? active_manager,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (regulationUrl != null) 'regulation_url': regulationUrl,
      if (active_manager != null) 'active_manager': active_manager,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? reference,
      Value<String?>? name,
      Value<String?>? address,
      Value<String>? regulationUrl,
      Value<bool?>? active_manager,
      Value<int>? rowid}) {
    return CondominiumTableCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      name: name ?? this.name,
      address: address ?? this.address,
      regulationUrl: regulationUrl ?? this.regulationUrl,
      active_manager: active_manager ?? this.active_manager,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (regulationUrl.present) {
      map['regulation_url'] = Variable<String>(regulationUrl.value);
    }
    if (active_manager.present) {
      map['active_manager'] = Variable<bool>(active_manager.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumTableCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('regulationUrl: $regulationUrl, ')
          ..write('active_manager: $active_manager, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BlockTableTable extends BlockTable
    with TableInfo<$BlockTableTable, BlockData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, condominiumId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'block_table';
  @override
  VerificationContext validateIntegrity(Insertable<BlockData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
    );
  }

  @override
  $BlockTableTable createAlias(String alias) {
    return $BlockTableTable(attachedDatabase, alias);
  }
}

class BlockData extends DataClass implements Insertable<BlockData> {
  final String id;
  final String condominiumId;
  final String? name;
  const BlockData({required this.id, required this.condominiumId, this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['condominium_id'] = Variable<String>(condominiumId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  BlockTableCompanion toCompanion(bool nullToAbsent) {
    return BlockTableCompanion(
      id: Value(id),
      condominiumId: Value(condominiumId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory BlockData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockData(
      id: serializer.fromJson<String>(json['id']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'name': serializer.toJson<String?>(name),
    };
  }

  BlockData copyWith(
          {String? id,
          String? condominiumId,
          Value<String?> name = const Value.absent()}) =>
      BlockData(
        id: id ?? this.id,
        condominiumId: condominiumId ?? this.condominiumId,
        name: name.present ? name.value : this.name,
      );
  BlockData copyWithCompanion(BlockTableCompanion data) {
    return BlockData(
      id: data.id.present ? data.id.value : this.id,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockData(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, condominiumId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockData &&
          other.id == this.id &&
          other.condominiumId == this.condominiumId &&
          other.name == this.name);
}

class BlockTableCompanion extends UpdateCompanion<BlockData> {
  final Value<String> id;
  final Value<String> condominiumId;
  final Value<String?> name;
  final Value<int> rowid;
  const BlockTableCompanion({
    this.id = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BlockTableCompanion.insert({
    required String id,
    required String condominiumId,
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        condominiumId = Value(condominiumId);
  static Insertable<BlockData> custom({
    Expression<String>? id,
    Expression<String>? condominiumId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BlockTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? condominiumId,
      Value<String?>? name,
      Value<int>? rowid}) {
    return BlockTableCompanion(
      id: id ?? this.id,
      condominiumId: condominiumId ?? this.condominiumId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockTableCompanion(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitTableTable extends UnitTable
    with TableInfo<$UnitTableTable, UnitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationContextMeta =
      const VerificationMeta('notificationContext');
  @override
  late final GeneratedColumn<String> notificationContext =
      GeneratedColumn<String>('notification_context', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(""));
  static const VerificationMeta _blockIdMeta =
      const VerificationMeta('blockId');
  @override
  late final GeneratedColumn<String> blockId = GeneratedColumn<String>(
      'block_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rentedMeta = const VerificationMeta('rented');
  @override
  late final GeneratedColumn<bool> rented = GeneratedColumn<bool>(
      'rented', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("rented" IN (0, 1))'));
  static const VerificationMeta _compliantMeta =
      const VerificationMeta('compliant');
  @override
  late final GeneratedColumn<bool> compliant = GeneratedColumn<bool>(
      'compliant', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("compliant" IN (0, 1))'));
  static const VerificationMeta _agreementMeta =
      const VerificationMeta('agreement');
  @override
  late final GeneratedColumn<bool> agreement = GeneratedColumn<bool>(
      'agreement', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("agreement" IN (0, 1))'));
  static const VerificationMeta _termHomeToGoMeta =
      const VerificationMeta('termHomeToGo');
  @override
  late final GeneratedColumn<bool> termHomeToGo = GeneratedColumn<bool>(
      'term_home_to_go', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("term_home_to_go" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        notificationContext,
        blockId,
        title,
        rented,
        compliant,
        agreement,
        termHomeToGo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_table';
  @override
  VerificationContext validateIntegrity(Insertable<UnitData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('notification_context')) {
      context.handle(
          _notificationContextMeta,
          notificationContext.isAcceptableOrUnknown(
              data['notification_context']!, _notificationContextMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(_blockIdMeta,
          blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta));
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('rented')) {
      context.handle(_rentedMeta,
          rented.isAcceptableOrUnknown(data['rented']!, _rentedMeta));
    }
    if (data.containsKey('compliant')) {
      context.handle(_compliantMeta,
          compliant.isAcceptableOrUnknown(data['compliant']!, _compliantMeta));
    }
    if (data.containsKey('agreement')) {
      context.handle(_agreementMeta,
          agreement.isAcceptableOrUnknown(data['agreement']!, _agreementMeta));
    }
    if (data.containsKey('term_home_to_go')) {
      context.handle(
          _termHomeToGoMeta,
          termHomeToGo.isAcceptableOrUnknown(
              data['term_home_to_go']!, _termHomeToGoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      notificationContext: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_context'])!,
      blockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}block_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      rented: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rented']),
      compliant: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}compliant']),
      agreement: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}agreement']),
      termHomeToGo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}term_home_to_go']),
    );
  }

  @override
  $UnitTableTable createAlias(String alias) {
    return $UnitTableTable(attachedDatabase, alias);
  }
}

class UnitData extends DataClass implements Insertable<UnitData> {
  final String id;
  final String notificationContext;
  final String blockId;
  final String? title;
  final bool? rented;
  final bool? compliant;
  final bool? agreement;
  final bool? termHomeToGo;
  const UnitData(
      {required this.id,
      required this.notificationContext,
      required this.blockId,
      this.title,
      this.rented,
      this.compliant,
      this.agreement,
      this.termHomeToGo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['notification_context'] = Variable<String>(notificationContext);
    map['block_id'] = Variable<String>(blockId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || rented != null) {
      map['rented'] = Variable<bool>(rented);
    }
    if (!nullToAbsent || compliant != null) {
      map['compliant'] = Variable<bool>(compliant);
    }
    if (!nullToAbsent || agreement != null) {
      map['agreement'] = Variable<bool>(agreement);
    }
    if (!nullToAbsent || termHomeToGo != null) {
      map['term_home_to_go'] = Variable<bool>(termHomeToGo);
    }
    return map;
  }

  UnitTableCompanion toCompanion(bool nullToAbsent) {
    return UnitTableCompanion(
      id: Value(id),
      notificationContext: Value(notificationContext),
      blockId: Value(blockId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      rented:
          rented == null && nullToAbsent ? const Value.absent() : Value(rented),
      compliant: compliant == null && nullToAbsent
          ? const Value.absent()
          : Value(compliant),
      agreement: agreement == null && nullToAbsent
          ? const Value.absent()
          : Value(agreement),
      termHomeToGo: termHomeToGo == null && nullToAbsent
          ? const Value.absent()
          : Value(termHomeToGo),
    );
  }

  factory UnitData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitData(
      id: serializer.fromJson<String>(json['id']),
      notificationContext:
          serializer.fromJson<String>(json['notificationContext']),
      blockId: serializer.fromJson<String>(json['blockId']),
      title: serializer.fromJson<String?>(json['title']),
      rented: serializer.fromJson<bool?>(json['rented']),
      compliant: serializer.fromJson<bool?>(json['compliant']),
      agreement: serializer.fromJson<bool?>(json['agreement']),
      termHomeToGo: serializer.fromJson<bool?>(json['termHomeToGo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'notificationContext': serializer.toJson<String>(notificationContext),
      'blockId': serializer.toJson<String>(blockId),
      'title': serializer.toJson<String?>(title),
      'rented': serializer.toJson<bool?>(rented),
      'compliant': serializer.toJson<bool?>(compliant),
      'agreement': serializer.toJson<bool?>(agreement),
      'termHomeToGo': serializer.toJson<bool?>(termHomeToGo),
    };
  }

  UnitData copyWith(
          {String? id,
          String? notificationContext,
          String? blockId,
          Value<String?> title = const Value.absent(),
          Value<bool?> rented = const Value.absent(),
          Value<bool?> compliant = const Value.absent(),
          Value<bool?> agreement = const Value.absent(),
          Value<bool?> termHomeToGo = const Value.absent()}) =>
      UnitData(
        id: id ?? this.id,
        notificationContext: notificationContext ?? this.notificationContext,
        blockId: blockId ?? this.blockId,
        title: title.present ? title.value : this.title,
        rented: rented.present ? rented.value : this.rented,
        compliant: compliant.present ? compliant.value : this.compliant,
        agreement: agreement.present ? agreement.value : this.agreement,
        termHomeToGo:
            termHomeToGo.present ? termHomeToGo.value : this.termHomeToGo,
      );
  UnitData copyWithCompanion(UnitTableCompanion data) {
    return UnitData(
      id: data.id.present ? data.id.value : this.id,
      notificationContext: data.notificationContext.present
          ? data.notificationContext.value
          : this.notificationContext,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      title: data.title.present ? data.title.value : this.title,
      rented: data.rented.present ? data.rented.value : this.rented,
      compliant: data.compliant.present ? data.compliant.value : this.compliant,
      agreement: data.agreement.present ? data.agreement.value : this.agreement,
      termHomeToGo: data.termHomeToGo.present
          ? data.termHomeToGo.value
          : this.termHomeToGo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitData(')
          ..write('id: $id, ')
          ..write('notificationContext: $notificationContext, ')
          ..write('blockId: $blockId, ')
          ..write('title: $title, ')
          ..write('rented: $rented, ')
          ..write('compliant: $compliant, ')
          ..write('agreement: $agreement, ')
          ..write('termHomeToGo: $termHomeToGo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, notificationContext, blockId, title,
      rented, compliant, agreement, termHomeToGo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitData &&
          other.id == this.id &&
          other.notificationContext == this.notificationContext &&
          other.blockId == this.blockId &&
          other.title == this.title &&
          other.rented == this.rented &&
          other.compliant == this.compliant &&
          other.agreement == this.agreement &&
          other.termHomeToGo == this.termHomeToGo);
}

class UnitTableCompanion extends UpdateCompanion<UnitData> {
  final Value<String> id;
  final Value<String> notificationContext;
  final Value<String> blockId;
  final Value<String?> title;
  final Value<bool?> rented;
  final Value<bool?> compliant;
  final Value<bool?> agreement;
  final Value<bool?> termHomeToGo;
  final Value<int> rowid;
  const UnitTableCompanion({
    this.id = const Value.absent(),
    this.notificationContext = const Value.absent(),
    this.blockId = const Value.absent(),
    this.title = const Value.absent(),
    this.rented = const Value.absent(),
    this.compliant = const Value.absent(),
    this.agreement = const Value.absent(),
    this.termHomeToGo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitTableCompanion.insert({
    required String id,
    this.notificationContext = const Value.absent(),
    required String blockId,
    this.title = const Value.absent(),
    this.rented = const Value.absent(),
    this.compliant = const Value.absent(),
    this.agreement = const Value.absent(),
    this.termHomeToGo = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        blockId = Value(blockId);
  static Insertable<UnitData> custom({
    Expression<String>? id,
    Expression<String>? notificationContext,
    Expression<String>? blockId,
    Expression<String>? title,
    Expression<bool>? rented,
    Expression<bool>? compliant,
    Expression<bool>? agreement,
    Expression<bool>? termHomeToGo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notificationContext != null)
        'notification_context': notificationContext,
      if (blockId != null) 'block_id': blockId,
      if (title != null) 'title': title,
      if (rented != null) 'rented': rented,
      if (compliant != null) 'compliant': compliant,
      if (agreement != null) 'agreement': agreement,
      if (termHomeToGo != null) 'term_home_to_go': termHomeToGo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? notificationContext,
      Value<String>? blockId,
      Value<String?>? title,
      Value<bool?>? rented,
      Value<bool?>? compliant,
      Value<bool?>? agreement,
      Value<bool?>? termHomeToGo,
      Value<int>? rowid}) {
    return UnitTableCompanion(
      id: id ?? this.id,
      notificationContext: notificationContext ?? this.notificationContext,
      blockId: blockId ?? this.blockId,
      title: title ?? this.title,
      rented: rented ?? this.rented,
      compliant: compliant ?? this.compliant,
      agreement: agreement ?? this.agreement,
      termHomeToGo: termHomeToGo ?? this.termHomeToGo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (notificationContext.present) {
      map['notification_context'] = Variable<String>(notificationContext.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<String>(blockId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rented.present) {
      map['rented'] = Variable<bool>(rented.value);
    }
    if (compliant.present) {
      map['compliant'] = Variable<bool>(compliant.value);
    }
    if (agreement.present) {
      map['agreement'] = Variable<bool>(agreement.value);
    }
    if (termHomeToGo.present) {
      map['term_home_to_go'] = Variable<bool>(termHomeToGo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitTableCompanion(')
          ..write('id: $id, ')
          ..write('notificationContext: $notificationContext, ')
          ..write('blockId: $blockId, ')
          ..write('title: $title, ')
          ..write('rented: $rented, ')
          ..write('compliant: $compliant, ')
          ..write('agreement: $agreement, ')
          ..write('termHomeToGo: $termHomeToGo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthorizationTableTable extends AuthorizationTable
    with TableInfo<$AuthorizationTableTable, AuthorizationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthorizationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'authorization_table';
  @override
  VerificationContext validateIntegrity(Insertable<AuthorizationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {role};
  @override
  AuthorizationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthorizationData(
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
    );
  }

  @override
  $AuthorizationTableTable createAlias(String alias) {
    return $AuthorizationTableTable(attachedDatabase, alias);
  }
}

class AuthorizationData extends DataClass
    implements Insertable<AuthorizationData> {
  final String role;
  const AuthorizationData({required this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['role'] = Variable<String>(role);
    return map;
  }

  AuthorizationTableCompanion toCompanion(bool nullToAbsent) {
    return AuthorizationTableCompanion(
      role: Value(role),
    );
  }

  factory AuthorizationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthorizationData(
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'role': serializer.toJson<String>(role),
    };
  }

  AuthorizationData copyWith({String? role}) => AuthorizationData(
        role: role ?? this.role,
      );
  AuthorizationData copyWithCompanion(AuthorizationTableCompanion data) {
    return AuthorizationData(
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthorizationData(')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => role.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthorizationData && other.role == this.role);
}

class AuthorizationTableCompanion extends UpdateCompanion<AuthorizationData> {
  final Value<String> role;
  final Value<int> rowid;
  const AuthorizationTableCompanion({
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthorizationTableCompanion.insert({
    required String role,
    this.rowid = const Value.absent(),
  }) : role = Value(role);
  static Insertable<AuthorizationData> custom({
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthorizationTableCompanion copyWith(
      {Value<String>? role, Value<int>? rowid}) {
    return AuthorizationTableCompanion(
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthorizationTableCompanion(')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LayoutTableTable extends LayoutTable
    with TableInfo<$LayoutTableTable, LayoutData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayoutTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _condoIdMeta =
      const VerificationMeta('condoId');
  @override
  late final GeneratedColumn<String> condoId = GeneratedColumn<String>(
      'condo_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codMeta = const VerificationMeta('cod');
  @override
  late final GeneratedColumn<String> cod = GeneratedColumn<String>(
      'cod', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _primaryMeta =
      const VerificationMeta('primary');
  @override
  late final GeneratedColumn<String> primary = GeneratedColumn<String>(
      'primary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _secondaryMeta =
      const VerificationMeta('secondary');
  @override
  late final GeneratedColumn<String> secondary = GeneratedColumn<String>(
      'secondary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, condoId, cod, name, reference, primary, secondary, logoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layout_table';
  @override
  VerificationContext validateIntegrity(Insertable<LayoutData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('condo_id')) {
      context.handle(_condoIdMeta,
          condoId.isAcceptableOrUnknown(data['condo_id']!, _condoIdMeta));
    } else if (isInserting) {
      context.missing(_condoIdMeta);
    }
    if (data.containsKey('cod')) {
      context.handle(
          _codMeta, cod.isAcceptableOrUnknown(data['cod']!, _codMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('primary')) {
      context.handle(_primaryMeta,
          primary.isAcceptableOrUnknown(data['primary']!, _primaryMeta));
    }
    if (data.containsKey('secondary')) {
      context.handle(_secondaryMeta,
          secondary.isAcceptableOrUnknown(data['secondary']!, _secondaryMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LayoutData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayoutData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      condoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condo_id'])!,
      cod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cod']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      primary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}primary']),
      secondary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}secondary']),
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
    );
  }

  @override
  $LayoutTableTable createAlias(String alias) {
    return $LayoutTableTable(attachedDatabase, alias);
  }
}

class LayoutData extends DataClass implements Insertable<LayoutData> {
  final String id;
  final String condoId;
  final String? cod;
  final String? name;
  final String? reference;
  final String? primary;
  final String? secondary;
  final String? logoPath;
  const LayoutData(
      {required this.id,
      required this.condoId,
      this.cod,
      this.name,
      this.reference,
      this.primary,
      this.secondary,
      this.logoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['condo_id'] = Variable<String>(condoId);
    if (!nullToAbsent || cod != null) {
      map['cod'] = Variable<String>(cod);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || primary != null) {
      map['primary'] = Variable<String>(primary);
    }
    if (!nullToAbsent || secondary != null) {
      map['secondary'] = Variable<String>(secondary);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    return map;
  }

  LayoutTableCompanion toCompanion(bool nullToAbsent) {
    return LayoutTableCompanion(
      id: Value(id),
      condoId: Value(condoId),
      cod: cod == null && nullToAbsent ? const Value.absent() : Value(cod),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      primary: primary == null && nullToAbsent
          ? const Value.absent()
          : Value(primary),
      secondary: secondary == null && nullToAbsent
          ? const Value.absent()
          : Value(secondary),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
    );
  }

  factory LayoutData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayoutData(
      id: serializer.fromJson<String>(json['id']),
      condoId: serializer.fromJson<String>(json['condoId']),
      cod: serializer.fromJson<String?>(json['cod']),
      name: serializer.fromJson<String?>(json['name']),
      reference: serializer.fromJson<String?>(json['reference']),
      primary: serializer.fromJson<String?>(json['primary']),
      secondary: serializer.fromJson<String?>(json['secondary']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'condoId': serializer.toJson<String>(condoId),
      'cod': serializer.toJson<String?>(cod),
      'name': serializer.toJson<String?>(name),
      'reference': serializer.toJson<String?>(reference),
      'primary': serializer.toJson<String?>(primary),
      'secondary': serializer.toJson<String?>(secondary),
      'logoPath': serializer.toJson<String?>(logoPath),
    };
  }

  LayoutData copyWith(
          {String? id,
          String? condoId,
          Value<String?> cod = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> reference = const Value.absent(),
          Value<String?> primary = const Value.absent(),
          Value<String?> secondary = const Value.absent(),
          Value<String?> logoPath = const Value.absent()}) =>
      LayoutData(
        id: id ?? this.id,
        condoId: condoId ?? this.condoId,
        cod: cod.present ? cod.value : this.cod,
        name: name.present ? name.value : this.name,
        reference: reference.present ? reference.value : this.reference,
        primary: primary.present ? primary.value : this.primary,
        secondary: secondary.present ? secondary.value : this.secondary,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
      );
  LayoutData copyWithCompanion(LayoutTableCompanion data) {
    return LayoutData(
      id: data.id.present ? data.id.value : this.id,
      condoId: data.condoId.present ? data.condoId.value : this.condoId,
      cod: data.cod.present ? data.cod.value : this.cod,
      name: data.name.present ? data.name.value : this.name,
      reference: data.reference.present ? data.reference.value : this.reference,
      primary: data.primary.present ? data.primary.value : this.primary,
      secondary: data.secondary.present ? data.secondary.value : this.secondary,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayoutData(')
          ..write('id: $id, ')
          ..write('condoId: $condoId, ')
          ..write('cod: $cod, ')
          ..write('name: $name, ')
          ..write('reference: $reference, ')
          ..write('primary: $primary, ')
          ..write('secondary: $secondary, ')
          ..write('logoPath: $logoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, condoId, cod, name, reference, primary, secondary, logoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayoutData &&
          other.id == this.id &&
          other.condoId == this.condoId &&
          other.cod == this.cod &&
          other.name == this.name &&
          other.reference == this.reference &&
          other.primary == this.primary &&
          other.secondary == this.secondary &&
          other.logoPath == this.logoPath);
}

class LayoutTableCompanion extends UpdateCompanion<LayoutData> {
  final Value<String> id;
  final Value<String> condoId;
  final Value<String?> cod;
  final Value<String?> name;
  final Value<String?> reference;
  final Value<String?> primary;
  final Value<String?> secondary;
  final Value<String?> logoPath;
  final Value<int> rowid;
  const LayoutTableCompanion({
    this.id = const Value.absent(),
    this.condoId = const Value.absent(),
    this.cod = const Value.absent(),
    this.name = const Value.absent(),
    this.reference = const Value.absent(),
    this.primary = const Value.absent(),
    this.secondary = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LayoutTableCompanion.insert({
    required String id,
    required String condoId,
    this.cod = const Value.absent(),
    this.name = const Value.absent(),
    this.reference = const Value.absent(),
    this.primary = const Value.absent(),
    this.secondary = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        condoId = Value(condoId);
  static Insertable<LayoutData> custom({
    Expression<String>? id,
    Expression<String>? condoId,
    Expression<String>? cod,
    Expression<String>? name,
    Expression<String>? reference,
    Expression<String>? primary,
    Expression<String>? secondary,
    Expression<String>? logoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (condoId != null) 'condo_id': condoId,
      if (cod != null) 'cod': cod,
      if (name != null) 'name': name,
      if (reference != null) 'reference': reference,
      if (primary != null) 'primary': primary,
      if (secondary != null) 'secondary': secondary,
      if (logoPath != null) 'logo_path': logoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LayoutTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? condoId,
      Value<String?>? cod,
      Value<String?>? name,
      Value<String?>? reference,
      Value<String?>? primary,
      Value<String?>? secondary,
      Value<String?>? logoPath,
      Value<int>? rowid}) {
    return LayoutTableCompanion(
      id: id ?? this.id,
      condoId: condoId ?? this.condoId,
      cod: cod ?? this.cod,
      name: name ?? this.name,
      reference: reference ?? this.reference,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      logoPath: logoPath ?? this.logoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (condoId.present) {
      map['condo_id'] = Variable<String>(condoId.value);
    }
    if (cod.present) {
      map['cod'] = Variable<String>(cod.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (primary.present) {
      map['primary'] = Variable<String>(primary.value);
    }
    if (secondary.present) {
      map['secondary'] = Variable<String>(secondary.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayoutTableCompanion(')
          ..write('id: $id, ')
          ..write('condoId: $condoId, ')
          ..write('cod: $cod, ')
          ..write('name: $name, ')
          ..write('reference: $reference, ')
          ..write('primary: $primary, ')
          ..write('secondary: $secondary, ')
          ..write('logoPath: $logoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedDocumentsTableTable extends CachedDocumentsTable
    with TableInfo<$CachedDocumentsTableTable, CachedDocumentsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDocumentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentTypeMeta =
      const VerificationMeta('documentType');
  @override
  late final GeneratedColumn<String> documentType = GeneratedColumn<String>(
      'document_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentsJsonMeta =
      const VerificationMeta('documentsJson');
  @override
  late final GeneratedColumn<String> documentsJson = GeneratedColumn<String>(
      'documents_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastFetchedAtMeta =
      const VerificationMeta('lastFetchedAt');
  @override
  late final GeneratedColumn<int> lastFetchedAt = GeneratedColumn<int>(
      'last_fetched_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastErrorAtMeta =
      const VerificationMeta('lastErrorAt');
  @override
  late final GeneratedColumn<int> lastErrorAt = GeneratedColumn<int>(
      'last_error_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        condominiumId,
        unitId,
        documentType,
        documentsJson,
        lastFetchedAt,
        lastErrorAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_documents_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CachedDocumentsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('document_type')) {
      context.handle(
          _documentTypeMeta,
          documentType.isAcceptableOrUnknown(
              data['document_type']!, _documentTypeMeta));
    } else if (isInserting) {
      context.missing(_documentTypeMeta);
    }
    if (data.containsKey('documents_json')) {
      context.handle(
          _documentsJsonMeta,
          documentsJson.isAcceptableOrUnknown(
              data['documents_json']!, _documentsJsonMeta));
    } else if (isInserting) {
      context.missing(_documentsJsonMeta);
    }
    if (data.containsKey('last_fetched_at')) {
      context.handle(
          _lastFetchedAtMeta,
          lastFetchedAt.isAcceptableOrUnknown(
              data['last_fetched_at']!, _lastFetchedAtMeta));
    } else if (isInserting) {
      context.missing(_lastFetchedAtMeta);
    }
    if (data.containsKey('last_error_at')) {
      context.handle(
          _lastErrorAtMeta,
          lastErrorAt.isAcceptableOrUnknown(
              data['last_error_at']!, _lastErrorAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, unitId, documentType};
  @override
  CachedDocumentsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDocumentsData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id'])!,
      documentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_type'])!,
      documentsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}documents_json'])!,
      lastFetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_fetched_at'])!,
      lastErrorAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_error_at']),
    );
  }

  @override
  $CachedDocumentsTableTable createAlias(String alias) {
    return $CachedDocumentsTableTable(attachedDatabase, alias);
  }
}

class CachedDocumentsData extends DataClass
    implements Insertable<CachedDocumentsData> {
  final String condominiumId;
  final String unitId;
  final String documentType;
  final String documentsJson;
  final int lastFetchedAt;
  final int? lastErrorAt;
  const CachedDocumentsData(
      {required this.condominiumId,
      required this.unitId,
      required this.documentType,
      required this.documentsJson,
      required this.lastFetchedAt,
      this.lastErrorAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['unit_id'] = Variable<String>(unitId);
    map['document_type'] = Variable<String>(documentType);
    map['documents_json'] = Variable<String>(documentsJson);
    map['last_fetched_at'] = Variable<int>(lastFetchedAt);
    if (!nullToAbsent || lastErrorAt != null) {
      map['last_error_at'] = Variable<int>(lastErrorAt);
    }
    return map;
  }

  CachedDocumentsTableCompanion toCompanion(bool nullToAbsent) {
    return CachedDocumentsTableCompanion(
      condominiumId: Value(condominiumId),
      unitId: Value(unitId),
      documentType: Value(documentType),
      documentsJson: Value(documentsJson),
      lastFetchedAt: Value(lastFetchedAt),
      lastErrorAt: lastErrorAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorAt),
    );
  }

  factory CachedDocumentsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDocumentsData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      unitId: serializer.fromJson<String>(json['unitId']),
      documentType: serializer.fromJson<String>(json['documentType']),
      documentsJson: serializer.fromJson<String>(json['documentsJson']),
      lastFetchedAt: serializer.fromJson<int>(json['lastFetchedAt']),
      lastErrorAt: serializer.fromJson<int?>(json['lastErrorAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'unitId': serializer.toJson<String>(unitId),
      'documentType': serializer.toJson<String>(documentType),
      'documentsJson': serializer.toJson<String>(documentsJson),
      'lastFetchedAt': serializer.toJson<int>(lastFetchedAt),
      'lastErrorAt': serializer.toJson<int?>(lastErrorAt),
    };
  }

  CachedDocumentsData copyWith(
          {String? condominiumId,
          String? unitId,
          String? documentType,
          String? documentsJson,
          int? lastFetchedAt,
          Value<int?> lastErrorAt = const Value.absent()}) =>
      CachedDocumentsData(
        condominiumId: condominiumId ?? this.condominiumId,
        unitId: unitId ?? this.unitId,
        documentType: documentType ?? this.documentType,
        documentsJson: documentsJson ?? this.documentsJson,
        lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
        lastErrorAt: lastErrorAt.present ? lastErrorAt.value : this.lastErrorAt,
      );
  CachedDocumentsData copyWithCompanion(CachedDocumentsTableCompanion data) {
    return CachedDocumentsData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      documentsJson: data.documentsJson.present
          ? data.documentsJson.value
          : this.documentsJson,
      lastFetchedAt: data.lastFetchedAt.present
          ? data.lastFetchedAt.value
          : this.lastFetchedAt,
      lastErrorAt:
          data.lastErrorAt.present ? data.lastErrorAt.value : this.lastErrorAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDocumentsData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('unitId: $unitId, ')
          ..write('documentType: $documentType, ')
          ..write('documentsJson: $documentsJson, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('lastErrorAt: $lastErrorAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, unitId, documentType,
      documentsJson, lastFetchedAt, lastErrorAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDocumentsData &&
          other.condominiumId == this.condominiumId &&
          other.unitId == this.unitId &&
          other.documentType == this.documentType &&
          other.documentsJson == this.documentsJson &&
          other.lastFetchedAt == this.lastFetchedAt &&
          other.lastErrorAt == this.lastErrorAt);
}

class CachedDocumentsTableCompanion
    extends UpdateCompanion<CachedDocumentsData> {
  final Value<String> condominiumId;
  final Value<String> unitId;
  final Value<String> documentType;
  final Value<String> documentsJson;
  final Value<int> lastFetchedAt;
  final Value<int?> lastErrorAt;
  final Value<int> rowid;
  const CachedDocumentsTableCompanion({
    this.condominiumId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.documentType = const Value.absent(),
    this.documentsJson = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.lastErrorAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDocumentsTableCompanion.insert({
    required String condominiumId,
    required String unitId,
    required String documentType,
    required String documentsJson,
    required int lastFetchedAt,
    this.lastErrorAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        unitId = Value(unitId),
        documentType = Value(documentType),
        documentsJson = Value(documentsJson),
        lastFetchedAt = Value(lastFetchedAt);
  static Insertable<CachedDocumentsData> custom({
    Expression<String>? condominiumId,
    Expression<String>? unitId,
    Expression<String>? documentType,
    Expression<String>? documentsJson,
    Expression<int>? lastFetchedAt,
    Expression<int>? lastErrorAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (unitId != null) 'unit_id': unitId,
      if (documentType != null) 'document_type': documentType,
      if (documentsJson != null) 'documents_json': documentsJson,
      if (lastFetchedAt != null) 'last_fetched_at': lastFetchedAt,
      if (lastErrorAt != null) 'last_error_at': lastErrorAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDocumentsTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<String>? unitId,
      Value<String>? documentType,
      Value<String>? documentsJson,
      Value<int>? lastFetchedAt,
      Value<int?>? lastErrorAt,
      Value<int>? rowid}) {
    return CachedDocumentsTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      unitId: unitId ?? this.unitId,
      documentType: documentType ?? this.documentType,
      documentsJson: documentsJson ?? this.documentsJson,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      lastErrorAt: lastErrorAt ?? this.lastErrorAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<String>(documentType.value);
    }
    if (documentsJson.present) {
      map['documents_json'] = Variable<String>(documentsJson.value);
    }
    if (lastFetchedAt.present) {
      map['last_fetched_at'] = Variable<int>(lastFetchedAt.value);
    }
    if (lastErrorAt.present) {
      map['last_error_at'] = Variable<int>(lastErrorAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDocumentsTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('unitId: $unitId, ')
          ..write('documentType: $documentType, ')
          ..write('documentsJson: $documentsJson, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('lastErrorAt: $lastErrorAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LelloDatabase extends GeneratedDatabase {
  _$LelloDatabase(QueryExecutor e) : super(e);
  $LelloDatabaseManager get managers => $LelloDatabaseManager(this);
  late final $MeTableTable meTable = $MeTableTable(this);
  late final $CondominiumTableTable condominiumTable =
      $CondominiumTableTable(this);
  late final $BlockTableTable blockTable = $BlockTableTable(this);
  late final $UnitTableTable unitTable = $UnitTableTable(this);
  late final $AuthorizationTableTable authorizationTable =
      $AuthorizationTableTable(this);
  late final $LayoutTableTable layoutTable = $LayoutTableTable(this);
  late final $CachedDocumentsTableTable cachedDocumentsTable =
      $CachedDocumentsTableTable(this);
  late final MeDao meDao = MeDao(this as LelloDatabase);
  late final CondominiumDao condominiumDao =
      CondominiumDao(this as LelloDatabase);
  late final BlockDao blockDao = BlockDao(this as LelloDatabase);
  late final UnitDao unitDao = UnitDao(this as LelloDatabase);
  late final AuthorizationDao authorizationDao =
      AuthorizationDao(this as LelloDatabase);
  late final LayoutDao layoutDao = LayoutDao(this as LelloDatabase);
  late final CachedDocumentsDao cachedDocumentsDao =
      CachedDocumentsDao(this as LelloDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        meTable,
        condominiumTable,
        blockTable,
        unitTable,
        authorizationTable,
        layoutTable,
        cachedDocumentsTable
      ];
}

typedef $$MeTableTableCreateCompanionBuilder = MeTableCompanion Function({
  Value<String?> id,
  required String name,
  required String email,
  Value<String?> cpf,
  Value<String?> phone,
  required String picture,
  Value<String?> pictureHash,
  Value<String?> biometricPictureHash,
  Value<bool?> useFacialBiometric,
  required DateTime updated,
  Value<int> rowid,
});
typedef $$MeTableTableUpdateCompanionBuilder = MeTableCompanion Function({
  Value<String?> id,
  Value<String> name,
  Value<String> email,
  Value<String?> cpf,
  Value<String?> phone,
  Value<String> picture,
  Value<String?> pictureHash,
  Value<String?> biometricPictureHash,
  Value<bool?> useFacialBiometric,
  Value<DateTime> updated,
  Value<int> rowid,
});

class $$MeTableTableFilterComposer
    extends Composer<_$LelloDatabase, $MeTableTable> {
  $$MeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get picture => $composableBuilder(
      column: $table.picture, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pictureHash => $composableBuilder(
      column: $table.pictureHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get biometricPictureHash => $composableBuilder(
      column: $table.biometricPictureHash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get useFacialBiometric => $composableBuilder(
      column: $table.useFacialBiometric,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updated => $composableBuilder(
      column: $table.updated, builder: (column) => ColumnFilters(column));
}

class $$MeTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $MeTableTable> {
  $$MeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get picture => $composableBuilder(
      column: $table.picture, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pictureHash => $composableBuilder(
      column: $table.pictureHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get biometricPictureHash => $composableBuilder(
      column: $table.biometricPictureHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get useFacialBiometric => $composableBuilder(
      column: $table.useFacialBiometric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updated => $composableBuilder(
      column: $table.updated, builder: (column) => ColumnOrderings(column));
}

class $$MeTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $MeTableTable> {
  $$MeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get cpf =>
      $composableBuilder(column: $table.cpf, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get picture =>
      $composableBuilder(column: $table.picture, builder: (column) => column);

  GeneratedColumn<String> get pictureHash => $composableBuilder(
      column: $table.pictureHash, builder: (column) => column);

  GeneratedColumn<String> get biometricPictureHash => $composableBuilder(
      column: $table.biometricPictureHash, builder: (column) => column);

  GeneratedColumn<bool> get useFacialBiometric => $composableBuilder(
      column: $table.useFacialBiometric, builder: (column) => column);

  GeneratedColumn<DateTime> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);
}

class $$MeTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $MeTableTable,
    MeData,
    $$MeTableTableFilterComposer,
    $$MeTableTableOrderingComposer,
    $$MeTableTableAnnotationComposer,
    $$MeTableTableCreateCompanionBuilder,
    $$MeTableTableUpdateCompanionBuilder,
    (MeData, BaseReferences<_$LelloDatabase, $MeTableTable, MeData>),
    MeData,
    PrefetchHooks Function()> {
  $$MeTableTableTableManager(_$LelloDatabase db, $MeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String?> cpf = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> picture = const Value.absent(),
            Value<String?> pictureHash = const Value.absent(),
            Value<String?> biometricPictureHash = const Value.absent(),
            Value<bool?> useFacialBiometric = const Value.absent(),
            Value<DateTime> updated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeTableCompanion(
            id: id,
            name: name,
            email: email,
            cpf: cpf,
            phone: phone,
            picture: picture,
            pictureHash: pictureHash,
            biometricPictureHash: biometricPictureHash,
            useFacialBiometric: useFacialBiometric,
            updated: updated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            required String name,
            required String email,
            Value<String?> cpf = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            required String picture,
            Value<String?> pictureHash = const Value.absent(),
            Value<String?> biometricPictureHash = const Value.absent(),
            Value<bool?> useFacialBiometric = const Value.absent(),
            required DateTime updated,
            Value<int> rowid = const Value.absent(),
          }) =>
              MeTableCompanion.insert(
            id: id,
            name: name,
            email: email,
            cpf: cpf,
            phone: phone,
            picture: picture,
            pictureHash: pictureHash,
            biometricPictureHash: biometricPictureHash,
            useFacialBiometric: useFacialBiometric,
            updated: updated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MeTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $MeTableTable,
    MeData,
    $$MeTableTableFilterComposer,
    $$MeTableTableOrderingComposer,
    $$MeTableTableAnnotationComposer,
    $$MeTableTableCreateCompanionBuilder,
    $$MeTableTableUpdateCompanionBuilder,
    (MeData, BaseReferences<_$LelloDatabase, $MeTableTable, MeData>),
    MeData,
    PrefetchHooks Function()>;
typedef $$CondominiumTableTableCreateCompanionBuilder
    = CondominiumTableCompanion Function({
  required String id,
  Value<String?> reference,
  Value<String?> name,
  Value<String?> address,
  required String regulationUrl,
  Value<bool?> active_manager,
  Value<int> rowid,
});
typedef $$CondominiumTableTableUpdateCompanionBuilder
    = CondominiumTableCompanion Function({
  Value<String> id,
  Value<String?> reference,
  Value<String?> name,
  Value<String?> address,
  Value<String> regulationUrl,
  Value<bool?> active_manager,
  Value<int> rowid,
});

class $$CondominiumTableTableFilterComposer
    extends Composer<_$LelloDatabase, $CondominiumTableTable> {
  $$CondominiumTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get regulationUrl => $composableBuilder(
      column: $table.regulationUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active_manager => $composableBuilder(
      column: $table.active_manager,
      builder: (column) => ColumnFilters(column));
}

class $$CondominiumTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $CondominiumTableTable> {
  $$CondominiumTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get regulationUrl => $composableBuilder(
      column: $table.regulationUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active_manager => $composableBuilder(
      column: $table.active_manager,
      builder: (column) => ColumnOrderings(column));
}

class $$CondominiumTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $CondominiumTableTable> {
  $$CondominiumTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get regulationUrl => $composableBuilder(
      column: $table.regulationUrl, builder: (column) => column);

  GeneratedColumn<bool> get active_manager => $composableBuilder(
      column: $table.active_manager, builder: (column) => column);
}

class $$CondominiumTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $CondominiumTableTable,
    CondominiumData,
    $$CondominiumTableTableFilterComposer,
    $$CondominiumTableTableOrderingComposer,
    $$CondominiumTableTableAnnotationComposer,
    $$CondominiumTableTableCreateCompanionBuilder,
    $$CondominiumTableTableUpdateCompanionBuilder,
    (
      CondominiumData,
      BaseReferences<_$LelloDatabase, $CondominiumTableTable, CondominiumData>
    ),
    CondominiumData,
    PrefetchHooks Function()> {
  $$CondominiumTableTableTableManager(
      _$LelloDatabase db, $CondominiumTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CondominiumTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CondominiumTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CondominiumTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> regulationUrl = const Value.absent(),
            Value<bool?> active_manager = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumTableCompanion(
            id: id,
            reference: reference,
            name: name,
            address: address,
            regulationUrl: regulationUrl,
            active_manager: active_manager,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> reference = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> address = const Value.absent(),
            required String regulationUrl,
            Value<bool?> active_manager = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumTableCompanion.insert(
            id: id,
            reference: reference,
            name: name,
            address: address,
            regulationUrl: regulationUrl,
            active_manager: active_manager,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CondominiumTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $CondominiumTableTable,
    CondominiumData,
    $$CondominiumTableTableFilterComposer,
    $$CondominiumTableTableOrderingComposer,
    $$CondominiumTableTableAnnotationComposer,
    $$CondominiumTableTableCreateCompanionBuilder,
    $$CondominiumTableTableUpdateCompanionBuilder,
    (
      CondominiumData,
      BaseReferences<_$LelloDatabase, $CondominiumTableTable, CondominiumData>
    ),
    CondominiumData,
    PrefetchHooks Function()>;
typedef $$BlockTableTableCreateCompanionBuilder = BlockTableCompanion Function({
  required String id,
  required String condominiumId,
  Value<String?> name,
  Value<int> rowid,
});
typedef $$BlockTableTableUpdateCompanionBuilder = BlockTableCompanion Function({
  Value<String> id,
  Value<String> condominiumId,
  Value<String?> name,
  Value<int> rowid,
});

class $$BlockTableTableFilterComposer
    extends Composer<_$LelloDatabase, $BlockTableTable> {
  $$BlockTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$BlockTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $BlockTableTable> {
  $$BlockTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$BlockTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $BlockTableTable> {
  $$BlockTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$BlockTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $BlockTableTable,
    BlockData,
    $$BlockTableTableFilterComposer,
    $$BlockTableTableOrderingComposer,
    $$BlockTableTableAnnotationComposer,
    $$BlockTableTableCreateCompanionBuilder,
    $$BlockTableTableUpdateCompanionBuilder,
    (BlockData, BaseReferences<_$LelloDatabase, $BlockTableTable, BlockData>),
    BlockData,
    PrefetchHooks Function()> {
  $$BlockTableTableTableManager(_$LelloDatabase db, $BlockTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlockTableCompanion(
            id: id,
            condominiumId: condominiumId,
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String condominiumId,
            Value<String?> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlockTableCompanion.insert(
            id: id,
            condominiumId: condominiumId,
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BlockTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $BlockTableTable,
    BlockData,
    $$BlockTableTableFilterComposer,
    $$BlockTableTableOrderingComposer,
    $$BlockTableTableAnnotationComposer,
    $$BlockTableTableCreateCompanionBuilder,
    $$BlockTableTableUpdateCompanionBuilder,
    (BlockData, BaseReferences<_$LelloDatabase, $BlockTableTable, BlockData>),
    BlockData,
    PrefetchHooks Function()>;
typedef $$UnitTableTableCreateCompanionBuilder = UnitTableCompanion Function({
  required String id,
  Value<String> notificationContext,
  required String blockId,
  Value<String?> title,
  Value<bool?> rented,
  Value<bool?> compliant,
  Value<bool?> agreement,
  Value<bool?> termHomeToGo,
  Value<int> rowid,
});
typedef $$UnitTableTableUpdateCompanionBuilder = UnitTableCompanion Function({
  Value<String> id,
  Value<String> notificationContext,
  Value<String> blockId,
  Value<String?> title,
  Value<bool?> rented,
  Value<bool?> compliant,
  Value<bool?> agreement,
  Value<bool?> termHomeToGo,
  Value<int> rowid,
});

class $$UnitTableTableFilterComposer
    extends Composer<_$LelloDatabase, $UnitTableTable> {
  $$UnitTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationContext => $composableBuilder(
      column: $table.notificationContext,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get rented => $composableBuilder(
      column: $table.rented, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get compliant => $composableBuilder(
      column: $table.compliant, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get agreement => $composableBuilder(
      column: $table.agreement, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get termHomeToGo => $composableBuilder(
      column: $table.termHomeToGo, builder: (column) => ColumnFilters(column));
}

class $$UnitTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $UnitTableTable> {
  $$UnitTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationContext => $composableBuilder(
      column: $table.notificationContext,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get rented => $composableBuilder(
      column: $table.rented, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get compliant => $composableBuilder(
      column: $table.compliant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get agreement => $composableBuilder(
      column: $table.agreement, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get termHomeToGo => $composableBuilder(
      column: $table.termHomeToGo,
      builder: (column) => ColumnOrderings(column));
}

class $$UnitTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $UnitTableTable> {
  $$UnitTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notificationContext => $composableBuilder(
      column: $table.notificationContext, builder: (column) => column);

  GeneratedColumn<String> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get rented =>
      $composableBuilder(column: $table.rented, builder: (column) => column);

  GeneratedColumn<bool> get compliant =>
      $composableBuilder(column: $table.compliant, builder: (column) => column);

  GeneratedColumn<bool> get agreement =>
      $composableBuilder(column: $table.agreement, builder: (column) => column);

  GeneratedColumn<bool> get termHomeToGo => $composableBuilder(
      column: $table.termHomeToGo, builder: (column) => column);
}

class $$UnitTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $UnitTableTable,
    UnitData,
    $$UnitTableTableFilterComposer,
    $$UnitTableTableOrderingComposer,
    $$UnitTableTableAnnotationComposer,
    $$UnitTableTableCreateCompanionBuilder,
    $$UnitTableTableUpdateCompanionBuilder,
    (UnitData, BaseReferences<_$LelloDatabase, $UnitTableTable, UnitData>),
    UnitData,
    PrefetchHooks Function()> {
  $$UnitTableTableTableManager(_$LelloDatabase db, $UnitTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> notificationContext = const Value.absent(),
            Value<String> blockId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<bool?> rented = const Value.absent(),
            Value<bool?> compliant = const Value.absent(),
            Value<bool?> agreement = const Value.absent(),
            Value<bool?> termHomeToGo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitTableCompanion(
            id: id,
            notificationContext: notificationContext,
            blockId: blockId,
            title: title,
            rented: rented,
            compliant: compliant,
            agreement: agreement,
            termHomeToGo: termHomeToGo,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> notificationContext = const Value.absent(),
            required String blockId,
            Value<String?> title = const Value.absent(),
            Value<bool?> rented = const Value.absent(),
            Value<bool?> compliant = const Value.absent(),
            Value<bool?> agreement = const Value.absent(),
            Value<bool?> termHomeToGo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitTableCompanion.insert(
            id: id,
            notificationContext: notificationContext,
            blockId: blockId,
            title: title,
            rented: rented,
            compliant: compliant,
            agreement: agreement,
            termHomeToGo: termHomeToGo,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnitTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $UnitTableTable,
    UnitData,
    $$UnitTableTableFilterComposer,
    $$UnitTableTableOrderingComposer,
    $$UnitTableTableAnnotationComposer,
    $$UnitTableTableCreateCompanionBuilder,
    $$UnitTableTableUpdateCompanionBuilder,
    (UnitData, BaseReferences<_$LelloDatabase, $UnitTableTable, UnitData>),
    UnitData,
    PrefetchHooks Function()>;
typedef $$AuthorizationTableTableCreateCompanionBuilder
    = AuthorizationTableCompanion Function({
  required String role,
  Value<int> rowid,
});
typedef $$AuthorizationTableTableUpdateCompanionBuilder
    = AuthorizationTableCompanion Function({
  Value<String> role,
  Value<int> rowid,
});

class $$AuthorizationTableTableFilterComposer
    extends Composer<_$LelloDatabase, $AuthorizationTableTable> {
  $$AuthorizationTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));
}

class $$AuthorizationTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $AuthorizationTableTable> {
  $$AuthorizationTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));
}

class $$AuthorizationTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $AuthorizationTableTable> {
  $$AuthorizationTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$AuthorizationTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $AuthorizationTableTable,
    AuthorizationData,
    $$AuthorizationTableTableFilterComposer,
    $$AuthorizationTableTableOrderingComposer,
    $$AuthorizationTableTableAnnotationComposer,
    $$AuthorizationTableTableCreateCompanionBuilder,
    $$AuthorizationTableTableUpdateCompanionBuilder,
    (
      AuthorizationData,
      BaseReferences<_$LelloDatabase, $AuthorizationTableTable,
          AuthorizationData>
    ),
    AuthorizationData,
    PrefetchHooks Function()> {
  $$AuthorizationTableTableTableManager(
      _$LelloDatabase db, $AuthorizationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthorizationTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthorizationTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthorizationTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> role = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthorizationTableCompanion(
            role: role,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String role,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthorizationTableCompanion.insert(
            role: role,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthorizationTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $AuthorizationTableTable,
    AuthorizationData,
    $$AuthorizationTableTableFilterComposer,
    $$AuthorizationTableTableOrderingComposer,
    $$AuthorizationTableTableAnnotationComposer,
    $$AuthorizationTableTableCreateCompanionBuilder,
    $$AuthorizationTableTableUpdateCompanionBuilder,
    (
      AuthorizationData,
      BaseReferences<_$LelloDatabase, $AuthorizationTableTable,
          AuthorizationData>
    ),
    AuthorizationData,
    PrefetchHooks Function()>;
typedef $$LayoutTableTableCreateCompanionBuilder = LayoutTableCompanion
    Function({
  required String id,
  required String condoId,
  Value<String?> cod,
  Value<String?> name,
  Value<String?> reference,
  Value<String?> primary,
  Value<String?> secondary,
  Value<String?> logoPath,
  Value<int> rowid,
});
typedef $$LayoutTableTableUpdateCompanionBuilder = LayoutTableCompanion
    Function({
  Value<String> id,
  Value<String> condoId,
  Value<String?> cod,
  Value<String?> name,
  Value<String?> reference,
  Value<String?> primary,
  Value<String?> secondary,
  Value<String?> logoPath,
  Value<int> rowid,
});

class $$LayoutTableTableFilterComposer
    extends Composer<_$LelloDatabase, $LayoutTableTable> {
  $$LayoutTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condoId => $composableBuilder(
      column: $table.condoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cod => $composableBuilder(
      column: $table.cod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primary => $composableBuilder(
      column: $table.primary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secondary => $composableBuilder(
      column: $table.secondary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));
}

class $$LayoutTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $LayoutTableTable> {
  $$LayoutTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condoId => $composableBuilder(
      column: $table.condoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cod => $composableBuilder(
      column: $table.cod, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primary => $composableBuilder(
      column: $table.primary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondary => $composableBuilder(
      column: $table.secondary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));
}

class $$LayoutTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $LayoutTableTable> {
  $$LayoutTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get condoId =>
      $composableBuilder(column: $table.condoId, builder: (column) => column);

  GeneratedColumn<String> get cod =>
      $composableBuilder(column: $table.cod, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get primary =>
      $composableBuilder(column: $table.primary, builder: (column) => column);

  GeneratedColumn<String> get secondary =>
      $composableBuilder(column: $table.secondary, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);
}

class $$LayoutTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $LayoutTableTable,
    LayoutData,
    $$LayoutTableTableFilterComposer,
    $$LayoutTableTableOrderingComposer,
    $$LayoutTableTableAnnotationComposer,
    $$LayoutTableTableCreateCompanionBuilder,
    $$LayoutTableTableUpdateCompanionBuilder,
    (
      LayoutData,
      BaseReferences<_$LelloDatabase, $LayoutTableTable, LayoutData>
    ),
    LayoutData,
    PrefetchHooks Function()> {
  $$LayoutTableTableTableManager(_$LelloDatabase db, $LayoutTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayoutTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayoutTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayoutTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> condoId = const Value.absent(),
            Value<String?> cod = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> primary = const Value.absent(),
            Value<String?> secondary = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LayoutTableCompanion(
            id: id,
            condoId: condoId,
            cod: cod,
            name: name,
            reference: reference,
            primary: primary,
            secondary: secondary,
            logoPath: logoPath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String condoId,
            Value<String?> cod = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> primary = const Value.absent(),
            Value<String?> secondary = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LayoutTableCompanion.insert(
            id: id,
            condoId: condoId,
            cod: cod,
            name: name,
            reference: reference,
            primary: primary,
            secondary: secondary,
            logoPath: logoPath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LayoutTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $LayoutTableTable,
    LayoutData,
    $$LayoutTableTableFilterComposer,
    $$LayoutTableTableOrderingComposer,
    $$LayoutTableTableAnnotationComposer,
    $$LayoutTableTableCreateCompanionBuilder,
    $$LayoutTableTableUpdateCompanionBuilder,
    (
      LayoutData,
      BaseReferences<_$LelloDatabase, $LayoutTableTable, LayoutData>
    ),
    LayoutData,
    PrefetchHooks Function()>;
typedef $$CachedDocumentsTableTableCreateCompanionBuilder
    = CachedDocumentsTableCompanion Function({
  required String condominiumId,
  required String unitId,
  required String documentType,
  required String documentsJson,
  required int lastFetchedAt,
  Value<int?> lastErrorAt,
  Value<int> rowid,
});
typedef $$CachedDocumentsTableTableUpdateCompanionBuilder
    = CachedDocumentsTableCompanion Function({
  Value<String> condominiumId,
  Value<String> unitId,
  Value<String> documentType,
  Value<String> documentsJson,
  Value<int> lastFetchedAt,
  Value<int?> lastErrorAt,
  Value<int> rowid,
});

class $$CachedDocumentsTableTableFilterComposer
    extends Composer<_$LelloDatabase, $CachedDocumentsTableTable> {
  $$CachedDocumentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentType => $composableBuilder(
      column: $table.documentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentsJson => $composableBuilder(
      column: $table.documentsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastErrorAt => $composableBuilder(
      column: $table.lastErrorAt, builder: (column) => ColumnFilters(column));
}

class $$CachedDocumentsTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $CachedDocumentsTableTable> {
  $$CachedDocumentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentType => $composableBuilder(
      column: $table.documentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentsJson => $composableBuilder(
      column: $table.documentsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastErrorAt => $composableBuilder(
      column: $table.lastErrorAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedDocumentsTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $CachedDocumentsTableTable> {
  $$CachedDocumentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get documentType => $composableBuilder(
      column: $table.documentType, builder: (column) => column);

  GeneratedColumn<String> get documentsJson => $composableBuilder(
      column: $table.documentsJson, builder: (column) => column);

  GeneratedColumn<int> get lastFetchedAt => $composableBuilder(
      column: $table.lastFetchedAt, builder: (column) => column);

  GeneratedColumn<int> get lastErrorAt => $composableBuilder(
      column: $table.lastErrorAt, builder: (column) => column);
}

class $$CachedDocumentsTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $CachedDocumentsTableTable,
    CachedDocumentsData,
    $$CachedDocumentsTableTableFilterComposer,
    $$CachedDocumentsTableTableOrderingComposer,
    $$CachedDocumentsTableTableAnnotationComposer,
    $$CachedDocumentsTableTableCreateCompanionBuilder,
    $$CachedDocumentsTableTableUpdateCompanionBuilder,
    (
      CachedDocumentsData,
      BaseReferences<_$LelloDatabase, $CachedDocumentsTableTable,
          CachedDocumentsData>
    ),
    CachedDocumentsData,
    PrefetchHooks Function()> {
  $$CachedDocumentsTableTableTableManager(
      _$LelloDatabase db, $CachedDocumentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDocumentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDocumentsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDocumentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<String> unitId = const Value.absent(),
            Value<String> documentType = const Value.absent(),
            Value<String> documentsJson = const Value.absent(),
            Value<int> lastFetchedAt = const Value.absent(),
            Value<int?> lastErrorAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedDocumentsTableCompanion(
            condominiumId: condominiumId,
            unitId: unitId,
            documentType: documentType,
            documentsJson: documentsJson,
            lastFetchedAt: lastFetchedAt,
            lastErrorAt: lastErrorAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required String unitId,
            required String documentType,
            required String documentsJson,
            required int lastFetchedAt,
            Value<int?> lastErrorAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedDocumentsTableCompanion.insert(
            condominiumId: condominiumId,
            unitId: unitId,
            documentType: documentType,
            documentsJson: documentsJson,
            lastFetchedAt: lastFetchedAt,
            lastErrorAt: lastErrorAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedDocumentsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $CachedDocumentsTableTable,
        CachedDocumentsData,
        $$CachedDocumentsTableTableFilterComposer,
        $$CachedDocumentsTableTableOrderingComposer,
        $$CachedDocumentsTableTableAnnotationComposer,
        $$CachedDocumentsTableTableCreateCompanionBuilder,
        $$CachedDocumentsTableTableUpdateCompanionBuilder,
        (
          CachedDocumentsData,
          BaseReferences<_$LelloDatabase, $CachedDocumentsTableTable,
              CachedDocumentsData>
        ),
        CachedDocumentsData,
        PrefetchHooks Function()>;

class $LelloDatabaseManager {
  final _$LelloDatabase _db;
  $LelloDatabaseManager(this._db);
  $$MeTableTableTableManager get meTable =>
      $$MeTableTableTableManager(_db, _db.meTable);
  $$CondominiumTableTableTableManager get condominiumTable =>
      $$CondominiumTableTableTableManager(_db, _db.condominiumTable);
  $$BlockTableTableTableManager get blockTable =>
      $$BlockTableTableTableManager(_db, _db.blockTable);
  $$UnitTableTableTableManager get unitTable =>
      $$UnitTableTableTableManager(_db, _db.unitTable);
  $$AuthorizationTableTableTableManager get authorizationTable =>
      $$AuthorizationTableTableTableManager(_db, _db.authorizationTable);
  $$LayoutTableTableTableManager get layoutTable =>
      $$LayoutTableTableTableManager(_db, _db.layoutTable);
  $$CachedDocumentsTableTableTableManager get cachedDocumentsTable =>
      $$CachedDocumentsTableTableTableManager(_db, _db.cachedDocumentsTable);
}
