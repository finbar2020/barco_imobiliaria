// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_point_database.dart';

// ignore_for_file: type=lint
class $DigitalPointTableTable extends DigitalPointTable
    with TableInfo<$DigitalPointTableTable, DigitalPointData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigitalPointTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _meIdMeta = const VerificationMeta('meId');
  @override
  late final GeneratedColumn<String> meId = GeneratedColumn<String>(
      'me_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<String> latitude = GeneratedColumn<String>(
      'latitude', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<String> longitude = GeneratedColumn<String>(
      'longitude', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typePointMeta =
      const VerificationMeta('typePoint');
  @override
  late final GeneratedColumn<String> typePoint = GeneratedColumn<String>(
      'type_point', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _photoTempHashMeta =
      const VerificationMeta('photoTempHash');
  @override
  late final GeneratedColumn<String> photoTempHash = GeneratedColumn<String>(
      'photo_temp_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _captureTypeMeta =
      const VerificationMeta('captureType');
  @override
  late final GeneratedColumn<String> captureType = GeneratedColumn<String>(
      'capture_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uniqueHashMeta =
      const VerificationMeta('uniqueHash');
  @override
  late final GeneratedColumn<String> uniqueHash = GeneratedColumn<String>(
      'unique_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tabletSessionMeta =
      const VerificationMeta('tabletSession');
  @override
  late final GeneratedColumn<bool> tabletSession = GeneratedColumn<bool>(
      'tablet_session', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("tablet_session" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numCraMeta = const VerificationMeta('numCra');
  @override
  late final GeneratedColumn<String> numCra = GeneratedColumn<String>(
      'num_cra', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numCadMeta = const VerificationMeta('numCad');
  @override
  late final GeneratedColumn<String> numCad = GeneratedColumn<String>(
      'num_cad', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        meId,
        condominiumId,
        date,
        latitude,
        longitude,
        typePoint,
        photoTempHash,
        photoPath,
        status,
        captureType,
        uniqueHash,
        tabletSession,
        reference,
        numCra,
        numCad
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digital_point_table';
  @override
  VerificationContext validateIntegrity(Insertable<DigitalPointData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('me_id')) {
      context.handle(
          _meIdMeta, meId.isAcceptableOrUnknown(data['me_id']!, _meIdMeta));
    } else if (isInserting) {
      context.missing(_meIdMeta);
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('type_point')) {
      context.handle(_typePointMeta,
          typePoint.isAcceptableOrUnknown(data['type_point']!, _typePointMeta));
    } else if (isInserting) {
      context.missing(_typePointMeta);
    }
    if (data.containsKey('photo_temp_hash')) {
      context.handle(
          _photoTempHashMeta,
          photoTempHash.isAcceptableOrUnknown(
              data['photo_temp_hash']!, _photoTempHashMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('capture_type')) {
      context.handle(
          _captureTypeMeta,
          captureType.isAcceptableOrUnknown(
              data['capture_type']!, _captureTypeMeta));
    } else if (isInserting) {
      context.missing(_captureTypeMeta);
    }
    if (data.containsKey('unique_hash')) {
      context.handle(
          _uniqueHashMeta,
          uniqueHash.isAcceptableOrUnknown(
              data['unique_hash']!, _uniqueHashMeta));
    } else if (isInserting) {
      context.missing(_uniqueHashMeta);
    }
    if (data.containsKey('tablet_session')) {
      context.handle(
          _tabletSessionMeta,
          tabletSession.isAcceptableOrUnknown(
              data['tablet_session']!, _tabletSessionMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('num_cra')) {
      context.handle(_numCraMeta,
          numCra.isAcceptableOrUnknown(data['num_cra']!, _numCraMeta));
    }
    if (data.containsKey('num_cad')) {
      context.handle(_numCadMeta,
          numCad.isAcceptableOrUnknown(data['num_cad']!, _numCadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigitalPointData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigitalPointData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      meId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}me_id'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}longitude'])!,
      typePoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_point'])!,
      photoTempHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_temp_hash']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      captureType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}capture_type'])!,
      uniqueHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unique_hash'])!,
      tabletSession: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}tablet_session'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      numCra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}num_cra']),
      numCad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}num_cad']),
    );
  }

  @override
  $DigitalPointTableTable createAlias(String alias) {
    return $DigitalPointTableTable(attachedDatabase, alias);
  }
}

class DigitalPointData extends DataClass
    implements Insertable<DigitalPointData> {
  final int id;
  final String meId;
  final String condominiumId;
  final DateTime date;
  final String latitude;
  final String longitude;
  final String typePoint;
  final String? photoTempHash;
  final String photoPath;
  final String status;
  final String captureType;
  final String uniqueHash;
  final bool tabletSession;
  final String? reference;
  final String? numCra;
  final String? numCad;
  const DigitalPointData(
      {required this.id,
      required this.meId,
      required this.condominiumId,
      required this.date,
      required this.latitude,
      required this.longitude,
      required this.typePoint,
      this.photoTempHash,
      required this.photoPath,
      required this.status,
      required this.captureType,
      required this.uniqueHash,
      required this.tabletSession,
      this.reference,
      this.numCra,
      this.numCad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['me_id'] = Variable<String>(meId);
    map['condominium_id'] = Variable<String>(condominiumId);
    map['date'] = Variable<DateTime>(date);
    map['latitude'] = Variable<String>(latitude);
    map['longitude'] = Variable<String>(longitude);
    map['type_point'] = Variable<String>(typePoint);
    if (!nullToAbsent || photoTempHash != null) {
      map['photo_temp_hash'] = Variable<String>(photoTempHash);
    }
    map['photo_path'] = Variable<String>(photoPath);
    map['status'] = Variable<String>(status);
    map['capture_type'] = Variable<String>(captureType);
    map['unique_hash'] = Variable<String>(uniqueHash);
    map['tablet_session'] = Variable<bool>(tabletSession);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || numCra != null) {
      map['num_cra'] = Variable<String>(numCra);
    }
    if (!nullToAbsent || numCad != null) {
      map['num_cad'] = Variable<String>(numCad);
    }
    return map;
  }

  DigitalPointTableCompanion toCompanion(bool nullToAbsent) {
    return DigitalPointTableCompanion(
      id: Value(id),
      meId: Value(meId),
      condominiumId: Value(condominiumId),
      date: Value(date),
      latitude: Value(latitude),
      longitude: Value(longitude),
      typePoint: Value(typePoint),
      photoTempHash: photoTempHash == null && nullToAbsent
          ? const Value.absent()
          : Value(photoTempHash),
      photoPath: Value(photoPath),
      status: Value(status),
      captureType: Value(captureType),
      uniqueHash: Value(uniqueHash),
      tabletSession: Value(tabletSession),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      numCra:
          numCra == null && nullToAbsent ? const Value.absent() : Value(numCra),
      numCad:
          numCad == null && nullToAbsent ? const Value.absent() : Value(numCad),
    );
  }

  factory DigitalPointData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigitalPointData(
      id: serializer.fromJson<int>(json['id']),
      meId: serializer.fromJson<String>(json['meId']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      date: serializer.fromJson<DateTime>(json['date']),
      latitude: serializer.fromJson<String>(json['latitude']),
      longitude: serializer.fromJson<String>(json['longitude']),
      typePoint: serializer.fromJson<String>(json['typePoint']),
      photoTempHash: serializer.fromJson<String?>(json['photoTempHash']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      status: serializer.fromJson<String>(json['status']),
      captureType: serializer.fromJson<String>(json['captureType']),
      uniqueHash: serializer.fromJson<String>(json['uniqueHash']),
      tabletSession: serializer.fromJson<bool>(json['tabletSession']),
      reference: serializer.fromJson<String?>(json['reference']),
      numCra: serializer.fromJson<String?>(json['numCra']),
      numCad: serializer.fromJson<String?>(json['numCad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'meId': serializer.toJson<String>(meId),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'date': serializer.toJson<DateTime>(date),
      'latitude': serializer.toJson<String>(latitude),
      'longitude': serializer.toJson<String>(longitude),
      'typePoint': serializer.toJson<String>(typePoint),
      'photoTempHash': serializer.toJson<String?>(photoTempHash),
      'photoPath': serializer.toJson<String>(photoPath),
      'status': serializer.toJson<String>(status),
      'captureType': serializer.toJson<String>(captureType),
      'uniqueHash': serializer.toJson<String>(uniqueHash),
      'tabletSession': serializer.toJson<bool>(tabletSession),
      'reference': serializer.toJson<String?>(reference),
      'numCra': serializer.toJson<String?>(numCra),
      'numCad': serializer.toJson<String?>(numCad),
    };
  }

  DigitalPointData copyWith(
          {int? id,
          String? meId,
          String? condominiumId,
          DateTime? date,
          String? latitude,
          String? longitude,
          String? typePoint,
          Value<String?> photoTempHash = const Value.absent(),
          String? photoPath,
          String? status,
          String? captureType,
          String? uniqueHash,
          bool? tabletSession,
          Value<String?> reference = const Value.absent(),
          Value<String?> numCra = const Value.absent(),
          Value<String?> numCad = const Value.absent()}) =>
      DigitalPointData(
        id: id ?? this.id,
        meId: meId ?? this.meId,
        condominiumId: condominiumId ?? this.condominiumId,
        date: date ?? this.date,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        typePoint: typePoint ?? this.typePoint,
        photoTempHash:
            photoTempHash.present ? photoTempHash.value : this.photoTempHash,
        photoPath: photoPath ?? this.photoPath,
        status: status ?? this.status,
        captureType: captureType ?? this.captureType,
        uniqueHash: uniqueHash ?? this.uniqueHash,
        tabletSession: tabletSession ?? this.tabletSession,
        reference: reference.present ? reference.value : this.reference,
        numCra: numCra.present ? numCra.value : this.numCra,
        numCad: numCad.present ? numCad.value : this.numCad,
      );
  DigitalPointData copyWithCompanion(DigitalPointTableCompanion data) {
    return DigitalPointData(
      id: data.id.present ? data.id.value : this.id,
      meId: data.meId.present ? data.meId.value : this.meId,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      date: data.date.present ? data.date.value : this.date,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      typePoint: data.typePoint.present ? data.typePoint.value : this.typePoint,
      photoTempHash: data.photoTempHash.present
          ? data.photoTempHash.value
          : this.photoTempHash,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      status: data.status.present ? data.status.value : this.status,
      captureType:
          data.captureType.present ? data.captureType.value : this.captureType,
      uniqueHash:
          data.uniqueHash.present ? data.uniqueHash.value : this.uniqueHash,
      tabletSession: data.tabletSession.present
          ? data.tabletSession.value
          : this.tabletSession,
      reference: data.reference.present ? data.reference.value : this.reference,
      numCra: data.numCra.present ? data.numCra.value : this.numCra,
      numCad: data.numCad.present ? data.numCad.value : this.numCad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigitalPointData(')
          ..write('id: $id, ')
          ..write('meId: $meId, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('date: $date, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('typePoint: $typePoint, ')
          ..write('photoTempHash: $photoTempHash, ')
          ..write('photoPath: $photoPath, ')
          ..write('status: $status, ')
          ..write('captureType: $captureType, ')
          ..write('uniqueHash: $uniqueHash, ')
          ..write('tabletSession: $tabletSession, ')
          ..write('reference: $reference, ')
          ..write('numCra: $numCra, ')
          ..write('numCad: $numCad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      meId,
      condominiumId,
      date,
      latitude,
      longitude,
      typePoint,
      photoTempHash,
      photoPath,
      status,
      captureType,
      uniqueHash,
      tabletSession,
      reference,
      numCra,
      numCad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitalPointData &&
          other.id == this.id &&
          other.meId == this.meId &&
          other.condominiumId == this.condominiumId &&
          other.date == this.date &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.typePoint == this.typePoint &&
          other.photoTempHash == this.photoTempHash &&
          other.photoPath == this.photoPath &&
          other.status == this.status &&
          other.captureType == this.captureType &&
          other.uniqueHash == this.uniqueHash &&
          other.tabletSession == this.tabletSession &&
          other.reference == this.reference &&
          other.numCra == this.numCra &&
          other.numCad == this.numCad);
}

class DigitalPointTableCompanion extends UpdateCompanion<DigitalPointData> {
  final Value<int> id;
  final Value<String> meId;
  final Value<String> condominiumId;
  final Value<DateTime> date;
  final Value<String> latitude;
  final Value<String> longitude;
  final Value<String> typePoint;
  final Value<String?> photoTempHash;
  final Value<String> photoPath;
  final Value<String> status;
  final Value<String> captureType;
  final Value<String> uniqueHash;
  final Value<bool> tabletSession;
  final Value<String?> reference;
  final Value<String?> numCra;
  final Value<String?> numCad;
  const DigitalPointTableCompanion({
    this.id = const Value.absent(),
    this.meId = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.date = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.typePoint = const Value.absent(),
    this.photoTempHash = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.status = const Value.absent(),
    this.captureType = const Value.absent(),
    this.uniqueHash = const Value.absent(),
    this.tabletSession = const Value.absent(),
    this.reference = const Value.absent(),
    this.numCra = const Value.absent(),
    this.numCad = const Value.absent(),
  });
  DigitalPointTableCompanion.insert({
    this.id = const Value.absent(),
    required String meId,
    required String condominiumId,
    required DateTime date,
    required String latitude,
    required String longitude,
    required String typePoint,
    this.photoTempHash = const Value.absent(),
    required String photoPath,
    required String status,
    required String captureType,
    required String uniqueHash,
    this.tabletSession = const Value.absent(),
    this.reference = const Value.absent(),
    this.numCra = const Value.absent(),
    this.numCad = const Value.absent(),
  })  : meId = Value(meId),
        condominiumId = Value(condominiumId),
        date = Value(date),
        latitude = Value(latitude),
        longitude = Value(longitude),
        typePoint = Value(typePoint),
        photoPath = Value(photoPath),
        status = Value(status),
        captureType = Value(captureType),
        uniqueHash = Value(uniqueHash);
  static Insertable<DigitalPointData> custom({
    Expression<int>? id,
    Expression<String>? meId,
    Expression<String>? condominiumId,
    Expression<DateTime>? date,
    Expression<String>? latitude,
    Expression<String>? longitude,
    Expression<String>? typePoint,
    Expression<String>? photoTempHash,
    Expression<String>? photoPath,
    Expression<String>? status,
    Expression<String>? captureType,
    Expression<String>? uniqueHash,
    Expression<bool>? tabletSession,
    Expression<String>? reference,
    Expression<String>? numCra,
    Expression<String>? numCad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meId != null) 'me_id': meId,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (date != null) 'date': date,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (typePoint != null) 'type_point': typePoint,
      if (photoTempHash != null) 'photo_temp_hash': photoTempHash,
      if (photoPath != null) 'photo_path': photoPath,
      if (status != null) 'status': status,
      if (captureType != null) 'capture_type': captureType,
      if (uniqueHash != null) 'unique_hash': uniqueHash,
      if (tabletSession != null) 'tablet_session': tabletSession,
      if (reference != null) 'reference': reference,
      if (numCra != null) 'num_cra': numCra,
      if (numCad != null) 'num_cad': numCad,
    });
  }

  DigitalPointTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? meId,
      Value<String>? condominiumId,
      Value<DateTime>? date,
      Value<String>? latitude,
      Value<String>? longitude,
      Value<String>? typePoint,
      Value<String?>? photoTempHash,
      Value<String>? photoPath,
      Value<String>? status,
      Value<String>? captureType,
      Value<String>? uniqueHash,
      Value<bool>? tabletSession,
      Value<String?>? reference,
      Value<String?>? numCra,
      Value<String?>? numCad}) {
    return DigitalPointTableCompanion(
      id: id ?? this.id,
      meId: meId ?? this.meId,
      condominiumId: condominiumId ?? this.condominiumId,
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      typePoint: typePoint ?? this.typePoint,
      photoTempHash: photoTempHash ?? this.photoTempHash,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      captureType: captureType ?? this.captureType,
      uniqueHash: uniqueHash ?? this.uniqueHash,
      tabletSession: tabletSession ?? this.tabletSession,
      reference: reference ?? this.reference,
      numCra: numCra ?? this.numCra,
      numCad: numCad ?? this.numCad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (meId.present) {
      map['me_id'] = Variable<String>(meId.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<String>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<String>(longitude.value);
    }
    if (typePoint.present) {
      map['type_point'] = Variable<String>(typePoint.value);
    }
    if (photoTempHash.present) {
      map['photo_temp_hash'] = Variable<String>(photoTempHash.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (captureType.present) {
      map['capture_type'] = Variable<String>(captureType.value);
    }
    if (uniqueHash.present) {
      map['unique_hash'] = Variable<String>(uniqueHash.value);
    }
    if (tabletSession.present) {
      map['tablet_session'] = Variable<bool>(tabletSession.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (numCra.present) {
      map['num_cra'] = Variable<String>(numCra.value);
    }
    if (numCad.present) {
      map['num_cad'] = Variable<String>(numCad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigitalPointTableCompanion(')
          ..write('id: $id, ')
          ..write('meId: $meId, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('date: $date, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('typePoint: $typePoint, ')
          ..write('photoTempHash: $photoTempHash, ')
          ..write('photoPath: $photoPath, ')
          ..write('status: $status, ')
          ..write('captureType: $captureType, ')
          ..write('uniqueHash: $uniqueHash, ')
          ..write('tabletSession: $tabletSession, ')
          ..write('reference: $reference, ')
          ..write('numCra: $numCra, ')
          ..write('numCad: $numCad')
          ..write(')'))
        .toString();
  }
}

class $DigitalPointLogTableTable extends DigitalPointLogTable
    with TableInfo<$DigitalPointLogTableTable, DigitalPointLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigitalPointLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _digitalPointIdMeta =
      const VerificationMeta('digitalPointId');
  @override
  late final GeneratedColumn<int> digitalPointId = GeneratedColumn<int>(
      'digital_point_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusPreviousMeta =
      const VerificationMeta('statusPrevious');
  @override
  late final GeneratedColumn<String> statusPrevious = GeneratedColumn<String>(
      'status_previous', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusNewMeta =
      const VerificationMeta('statusNew');
  @override
  late final GeneratedColumn<String> statusNew = GeneratedColumn<String>(
      'status_new', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, digitalPointId, date, statusPrevious, statusNew, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digital_point_log_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DigitalPointLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('digital_point_id')) {
      context.handle(
          _digitalPointIdMeta,
          digitalPointId.isAcceptableOrUnknown(
              data['digital_point_id']!, _digitalPointIdMeta));
    } else if (isInserting) {
      context.missing(_digitalPointIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status_previous')) {
      context.handle(
          _statusPreviousMeta,
          statusPrevious.isAcceptableOrUnknown(
              data['status_previous']!, _statusPreviousMeta));
    } else if (isInserting) {
      context.missing(_statusPreviousMeta);
    }
    if (data.containsKey('status_new')) {
      context.handle(_statusNewMeta,
          statusNew.isAcceptableOrUnknown(data['status_new']!, _statusNewMeta));
    } else if (isInserting) {
      context.missing(_statusNewMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigitalPointLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigitalPointLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      digitalPointId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}digital_point_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      statusPrevious: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}status_previous'])!,
      statusNew: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status_new'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $DigitalPointLogTableTable createAlias(String alias) {
    return $DigitalPointLogTableTable(attachedDatabase, alias);
  }
}

class DigitalPointLogData extends DataClass
    implements Insertable<DigitalPointLogData> {
  final int id;
  final int digitalPointId;
  final DateTime date;
  final String statusPrevious;
  final String statusNew;
  final String description;
  const DigitalPointLogData(
      {required this.id,
      required this.digitalPointId,
      required this.date,
      required this.statusPrevious,
      required this.statusNew,
      required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['digital_point_id'] = Variable<int>(digitalPointId);
    map['date'] = Variable<DateTime>(date);
    map['status_previous'] = Variable<String>(statusPrevious);
    map['status_new'] = Variable<String>(statusNew);
    map['description'] = Variable<String>(description);
    return map;
  }

  DigitalPointLogTableCompanion toCompanion(bool nullToAbsent) {
    return DigitalPointLogTableCompanion(
      id: Value(id),
      digitalPointId: Value(digitalPointId),
      date: Value(date),
      statusPrevious: Value(statusPrevious),
      statusNew: Value(statusNew),
      description: Value(description),
    );
  }

  factory DigitalPointLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigitalPointLogData(
      id: serializer.fromJson<int>(json['id']),
      digitalPointId: serializer.fromJson<int>(json['digitalPointId']),
      date: serializer.fromJson<DateTime>(json['date']),
      statusPrevious: serializer.fromJson<String>(json['statusPrevious']),
      statusNew: serializer.fromJson<String>(json['statusNew']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'digitalPointId': serializer.toJson<int>(digitalPointId),
      'date': serializer.toJson<DateTime>(date),
      'statusPrevious': serializer.toJson<String>(statusPrevious),
      'statusNew': serializer.toJson<String>(statusNew),
      'description': serializer.toJson<String>(description),
    };
  }

  DigitalPointLogData copyWith(
          {int? id,
          int? digitalPointId,
          DateTime? date,
          String? statusPrevious,
          String? statusNew,
          String? description}) =>
      DigitalPointLogData(
        id: id ?? this.id,
        digitalPointId: digitalPointId ?? this.digitalPointId,
        date: date ?? this.date,
        statusPrevious: statusPrevious ?? this.statusPrevious,
        statusNew: statusNew ?? this.statusNew,
        description: description ?? this.description,
      );
  DigitalPointLogData copyWithCompanion(DigitalPointLogTableCompanion data) {
    return DigitalPointLogData(
      id: data.id.present ? data.id.value : this.id,
      digitalPointId: data.digitalPointId.present
          ? data.digitalPointId.value
          : this.digitalPointId,
      date: data.date.present ? data.date.value : this.date,
      statusPrevious: data.statusPrevious.present
          ? data.statusPrevious.value
          : this.statusPrevious,
      statusNew: data.statusNew.present ? data.statusNew.value : this.statusNew,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigitalPointLogData(')
          ..write('id: $id, ')
          ..write('digitalPointId: $digitalPointId, ')
          ..write('date: $date, ')
          ..write('statusPrevious: $statusPrevious, ')
          ..write('statusNew: $statusNew, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, digitalPointId, date, statusPrevious, statusNew, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitalPointLogData &&
          other.id == this.id &&
          other.digitalPointId == this.digitalPointId &&
          other.date == this.date &&
          other.statusPrevious == this.statusPrevious &&
          other.statusNew == this.statusNew &&
          other.description == this.description);
}

class DigitalPointLogTableCompanion
    extends UpdateCompanion<DigitalPointLogData> {
  final Value<int> id;
  final Value<int> digitalPointId;
  final Value<DateTime> date;
  final Value<String> statusPrevious;
  final Value<String> statusNew;
  final Value<String> description;
  const DigitalPointLogTableCompanion({
    this.id = const Value.absent(),
    this.digitalPointId = const Value.absent(),
    this.date = const Value.absent(),
    this.statusPrevious = const Value.absent(),
    this.statusNew = const Value.absent(),
    this.description = const Value.absent(),
  });
  DigitalPointLogTableCompanion.insert({
    this.id = const Value.absent(),
    required int digitalPointId,
    required DateTime date,
    required String statusPrevious,
    required String statusNew,
    required String description,
  })  : digitalPointId = Value(digitalPointId),
        date = Value(date),
        statusPrevious = Value(statusPrevious),
        statusNew = Value(statusNew),
        description = Value(description);
  static Insertable<DigitalPointLogData> custom({
    Expression<int>? id,
    Expression<int>? digitalPointId,
    Expression<DateTime>? date,
    Expression<String>? statusPrevious,
    Expression<String>? statusNew,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (digitalPointId != null) 'digital_point_id': digitalPointId,
      if (date != null) 'date': date,
      if (statusPrevious != null) 'status_previous': statusPrevious,
      if (statusNew != null) 'status_new': statusNew,
      if (description != null) 'description': description,
    });
  }

  DigitalPointLogTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? digitalPointId,
      Value<DateTime>? date,
      Value<String>? statusPrevious,
      Value<String>? statusNew,
      Value<String>? description}) {
    return DigitalPointLogTableCompanion(
      id: id ?? this.id,
      digitalPointId: digitalPointId ?? this.digitalPointId,
      date: date ?? this.date,
      statusPrevious: statusPrevious ?? this.statusPrevious,
      statusNew: statusNew ?? this.statusNew,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (digitalPointId.present) {
      map['digital_point_id'] = Variable<int>(digitalPointId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (statusPrevious.present) {
      map['status_previous'] = Variable<String>(statusPrevious.value);
    }
    if (statusNew.present) {
      map['status_new'] = Variable<String>(statusNew.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigitalPointLogTableCompanion(')
          ..write('id: $id, ')
          ..write('digitalPointId: $digitalPointId, ')
          ..write('date: $date, ')
          ..write('statusPrevious: $statusPrevious, ')
          ..write('statusNew: $statusNew, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

abstract class _$DigitalPointDatabase extends GeneratedDatabase {
  _$DigitalPointDatabase(QueryExecutor e) : super(e);
  $DigitalPointDatabaseManager get managers =>
      $DigitalPointDatabaseManager(this);
  late final $DigitalPointTableTable digitalPointTable =
      $DigitalPointTableTable(this);
  late final $DigitalPointLogTableTable digitalPointLogTable =
      $DigitalPointLogTableTable(this);
  late final DigitalPointDao digitalPointDao =
      DigitalPointDao(this as DigitalPointDatabase);
  late final DigitalPointLogDao digitalPointLogDao =
      DigitalPointLogDao(this as DigitalPointDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [digitalPointTable, digitalPointLogTable];
}

typedef $$DigitalPointTableTableCreateCompanionBuilder
    = DigitalPointTableCompanion Function({
  Value<int> id,
  required String meId,
  required String condominiumId,
  required DateTime date,
  required String latitude,
  required String longitude,
  required String typePoint,
  Value<String?> photoTempHash,
  required String photoPath,
  required String status,
  required String captureType,
  required String uniqueHash,
  Value<bool> tabletSession,
  Value<String?> reference,
  Value<String?> numCra,
  Value<String?> numCad,
});
typedef $$DigitalPointTableTableUpdateCompanionBuilder
    = DigitalPointTableCompanion Function({
  Value<int> id,
  Value<String> meId,
  Value<String> condominiumId,
  Value<DateTime> date,
  Value<String> latitude,
  Value<String> longitude,
  Value<String> typePoint,
  Value<String?> photoTempHash,
  Value<String> photoPath,
  Value<String> status,
  Value<String> captureType,
  Value<String> uniqueHash,
  Value<bool> tabletSession,
  Value<String?> reference,
  Value<String?> numCra,
  Value<String?> numCad,
});

class $$DigitalPointTableTableFilterComposer
    extends Composer<_$DigitalPointDatabase, $DigitalPointTableTable> {
  $$DigitalPointTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meId => $composableBuilder(
      column: $table.meId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typePoint => $composableBuilder(
      column: $table.typePoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoTempHash => $composableBuilder(
      column: $table.photoTempHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get captureType => $composableBuilder(
      column: $table.captureType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uniqueHash => $composableBuilder(
      column: $table.uniqueHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get tabletSession => $composableBuilder(
      column: $table.tabletSession, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numCra => $composableBuilder(
      column: $table.numCra, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numCad => $composableBuilder(
      column: $table.numCad, builder: (column) => ColumnFilters(column));
}

class $$DigitalPointTableTableOrderingComposer
    extends Composer<_$DigitalPointDatabase, $DigitalPointTableTable> {
  $$DigitalPointTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meId => $composableBuilder(
      column: $table.meId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typePoint => $composableBuilder(
      column: $table.typePoint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoTempHash => $composableBuilder(
      column: $table.photoTempHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get captureType => $composableBuilder(
      column: $table.captureType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uniqueHash => $composableBuilder(
      column: $table.uniqueHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get tabletSession => $composableBuilder(
      column: $table.tabletSession,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numCra => $composableBuilder(
      column: $table.numCra, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numCad => $composableBuilder(
      column: $table.numCad, builder: (column) => ColumnOrderings(column));
}

class $$DigitalPointTableTableAnnotationComposer
    extends Composer<_$DigitalPointDatabase, $DigitalPointTableTable> {
  $$DigitalPointTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get meId =>
      $composableBuilder(column: $table.meId, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<String> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get typePoint =>
      $composableBuilder(column: $table.typePoint, builder: (column) => column);

  GeneratedColumn<String> get photoTempHash => $composableBuilder(
      column: $table.photoTempHash, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get captureType => $composableBuilder(
      column: $table.captureType, builder: (column) => column);

  GeneratedColumn<String> get uniqueHash => $composableBuilder(
      column: $table.uniqueHash, builder: (column) => column);

  GeneratedColumn<bool> get tabletSession => $composableBuilder(
      column: $table.tabletSession, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get numCra =>
      $composableBuilder(column: $table.numCra, builder: (column) => column);

  GeneratedColumn<String> get numCad =>
      $composableBuilder(column: $table.numCad, builder: (column) => column);
}

class $$DigitalPointTableTableTableManager extends RootTableManager<
    _$DigitalPointDatabase,
    $DigitalPointTableTable,
    DigitalPointData,
    $$DigitalPointTableTableFilterComposer,
    $$DigitalPointTableTableOrderingComposer,
    $$DigitalPointTableTableAnnotationComposer,
    $$DigitalPointTableTableCreateCompanionBuilder,
    $$DigitalPointTableTableUpdateCompanionBuilder,
    (
      DigitalPointData,
      BaseReferences<_$DigitalPointDatabase, $DigitalPointTableTable,
          DigitalPointData>
    ),
    DigitalPointData,
    PrefetchHooks Function()> {
  $$DigitalPointTableTableTableManager(
      _$DigitalPointDatabase db, $DigitalPointTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigitalPointTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigitalPointTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigitalPointTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> meId = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> latitude = const Value.absent(),
            Value<String> longitude = const Value.absent(),
            Value<String> typePoint = const Value.absent(),
            Value<String?> photoTempHash = const Value.absent(),
            Value<String> photoPath = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> captureType = const Value.absent(),
            Value<String> uniqueHash = const Value.absent(),
            Value<bool> tabletSession = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> numCra = const Value.absent(),
            Value<String?> numCad = const Value.absent(),
          }) =>
              DigitalPointTableCompanion(
            id: id,
            meId: meId,
            condominiumId: condominiumId,
            date: date,
            latitude: latitude,
            longitude: longitude,
            typePoint: typePoint,
            photoTempHash: photoTempHash,
            photoPath: photoPath,
            status: status,
            captureType: captureType,
            uniqueHash: uniqueHash,
            tabletSession: tabletSession,
            reference: reference,
            numCra: numCra,
            numCad: numCad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String meId,
            required String condominiumId,
            required DateTime date,
            required String latitude,
            required String longitude,
            required String typePoint,
            Value<String?> photoTempHash = const Value.absent(),
            required String photoPath,
            required String status,
            required String captureType,
            required String uniqueHash,
            Value<bool> tabletSession = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String?> numCra = const Value.absent(),
            Value<String?> numCad = const Value.absent(),
          }) =>
              DigitalPointTableCompanion.insert(
            id: id,
            meId: meId,
            condominiumId: condominiumId,
            date: date,
            latitude: latitude,
            longitude: longitude,
            typePoint: typePoint,
            photoTempHash: photoTempHash,
            photoPath: photoPath,
            status: status,
            captureType: captureType,
            uniqueHash: uniqueHash,
            tabletSession: tabletSession,
            reference: reference,
            numCra: numCra,
            numCad: numCad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DigitalPointTableTableProcessedTableManager = ProcessedTableManager<
    _$DigitalPointDatabase,
    $DigitalPointTableTable,
    DigitalPointData,
    $$DigitalPointTableTableFilterComposer,
    $$DigitalPointTableTableOrderingComposer,
    $$DigitalPointTableTableAnnotationComposer,
    $$DigitalPointTableTableCreateCompanionBuilder,
    $$DigitalPointTableTableUpdateCompanionBuilder,
    (
      DigitalPointData,
      BaseReferences<_$DigitalPointDatabase, $DigitalPointTableTable,
          DigitalPointData>
    ),
    DigitalPointData,
    PrefetchHooks Function()>;
typedef $$DigitalPointLogTableTableCreateCompanionBuilder
    = DigitalPointLogTableCompanion Function({
  Value<int> id,
  required int digitalPointId,
  required DateTime date,
  required String statusPrevious,
  required String statusNew,
  required String description,
});
typedef $$DigitalPointLogTableTableUpdateCompanionBuilder
    = DigitalPointLogTableCompanion Function({
  Value<int> id,
  Value<int> digitalPointId,
  Value<DateTime> date,
  Value<String> statusPrevious,
  Value<String> statusNew,
  Value<String> description,
});

class $$DigitalPointLogTableTableFilterComposer
    extends Composer<_$DigitalPointDatabase, $DigitalPointLogTableTable> {
  $$DigitalPointLogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get digitalPointId => $composableBuilder(
      column: $table.digitalPointId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statusPrevious => $composableBuilder(
      column: $table.statusPrevious,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statusNew => $composableBuilder(
      column: $table.statusNew, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));
}

class $$DigitalPointLogTableTableOrderingComposer
    extends Composer<_$DigitalPointDatabase, $DigitalPointLogTableTable> {
  $$DigitalPointLogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get digitalPointId => $composableBuilder(
      column: $table.digitalPointId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statusPrevious => $composableBuilder(
      column: $table.statusPrevious,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statusNew => $composableBuilder(
      column: $table.statusNew, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
}

class $$DigitalPointLogTableTableAnnotationComposer
    extends Composer<_$DigitalPointDatabase, $DigitalPointLogTableTable> {
  $$DigitalPointLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get digitalPointId => $composableBuilder(
      column: $table.digitalPointId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get statusPrevious => $composableBuilder(
      column: $table.statusPrevious, builder: (column) => column);

  GeneratedColumn<String> get statusNew =>
      $composableBuilder(column: $table.statusNew, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);
}

class $$DigitalPointLogTableTableTableManager extends RootTableManager<
    _$DigitalPointDatabase,
    $DigitalPointLogTableTable,
    DigitalPointLogData,
    $$DigitalPointLogTableTableFilterComposer,
    $$DigitalPointLogTableTableOrderingComposer,
    $$DigitalPointLogTableTableAnnotationComposer,
    $$DigitalPointLogTableTableCreateCompanionBuilder,
    $$DigitalPointLogTableTableUpdateCompanionBuilder,
    (
      DigitalPointLogData,
      BaseReferences<_$DigitalPointDatabase, $DigitalPointLogTableTable,
          DigitalPointLogData>
    ),
    DigitalPointLogData,
    PrefetchHooks Function()> {
  $$DigitalPointLogTableTableTableManager(
      _$DigitalPointDatabase db, $DigitalPointLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigitalPointLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigitalPointLogTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigitalPointLogTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> digitalPointId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> statusPrevious = const Value.absent(),
            Value<String> statusNew = const Value.absent(),
            Value<String> description = const Value.absent(),
          }) =>
              DigitalPointLogTableCompanion(
            id: id,
            digitalPointId: digitalPointId,
            date: date,
            statusPrevious: statusPrevious,
            statusNew: statusNew,
            description: description,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int digitalPointId,
            required DateTime date,
            required String statusPrevious,
            required String statusNew,
            required String description,
          }) =>
              DigitalPointLogTableCompanion.insert(
            id: id,
            digitalPointId: digitalPointId,
            date: date,
            statusPrevious: statusPrevious,
            statusNew: statusNew,
            description: description,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DigitalPointLogTableTableProcessedTableManager
    = ProcessedTableManager<
        _$DigitalPointDatabase,
        $DigitalPointLogTableTable,
        DigitalPointLogData,
        $$DigitalPointLogTableTableFilterComposer,
        $$DigitalPointLogTableTableOrderingComposer,
        $$DigitalPointLogTableTableAnnotationComposer,
        $$DigitalPointLogTableTableCreateCompanionBuilder,
        $$DigitalPointLogTableTableUpdateCompanionBuilder,
        (
          DigitalPointLogData,
          BaseReferences<_$DigitalPointDatabase, $DigitalPointLogTableTable,
              DigitalPointLogData>
        ),
        DigitalPointLogData,
        PrefetchHooks Function()>;

class $DigitalPointDatabaseManager {
  final _$DigitalPointDatabase _db;
  $DigitalPointDatabaseManager(this._db);
  $$DigitalPointTableTableTableManager get digitalPointTable =>
      $$DigitalPointTableTableTableManager(_db, _db.digitalPointTable);
  $$DigitalPointLogTableTableTableManager get digitalPointLogTable =>
      $$DigitalPointLogTableTableTableManager(_db, _db.digitalPointLogTable);
}
