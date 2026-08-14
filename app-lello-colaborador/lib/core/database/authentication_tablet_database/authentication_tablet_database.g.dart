// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_tablet_database.dart';

// ignore_for_file: type=lint
class $EmployeeInfoTableTable extends EmployeeInfoTable
    with TableInfo<$EmployeeInfoTableTable, EmployeeInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeInfoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condoCodeMeta =
      const VerificationMeta('condoCode');
  @override
  late final GeneratedColumn<String> condoCode = GeneratedColumn<String>(
      'condo_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numCadMeta = const VerificationMeta('numCad');
  @override
  late final GeneratedColumn<String> numCad = GeneratedColumn<String>(
      'num_cad', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numCraMeta = const VerificationMeta('numCra');
  @override
  late final GeneratedColumn<String> numCra = GeneratedColumn<String>(
      'num_cra', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
      'cpf', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jobPositionMeta =
      const VerificationMeta('jobPosition');
  @override
  late final GeneratedColumn<String> jobPosition = GeneratedColumn<String>(
      'job_position', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idLoginMeta =
      const VerificationMeta('idLogin');
  @override
  late final GeneratedColumn<String> idLogin = GeneratedColumn<String>(
      'id_login', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pictureHashMeta =
      const VerificationMeta('pictureHash');
  @override
  late final GeneratedColumn<String> pictureHash = GeneratedColumn<String>(
      'picture_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _registeredMeta =
      const VerificationMeta('registered');
  @override
  late final GeneratedColumn<bool> registered = GeneratedColumn<bool>(
      'registered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("registered" IN (0, 1))'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        condoCode,
        numCad,
        numCra,
        cpf,
        name,
        jobPosition,
        idLogin,
        pictureHash,
        registered,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_info_table';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('condo_code')) {
      context.handle(_condoCodeMeta,
          condoCode.isAcceptableOrUnknown(data['condo_code']!, _condoCodeMeta));
    } else if (isInserting) {
      context.missing(_condoCodeMeta);
    }
    if (data.containsKey('num_cad')) {
      context.handle(_numCadMeta,
          numCad.isAcceptableOrUnknown(data['num_cad']!, _numCadMeta));
    } else if (isInserting) {
      context.missing(_numCadMeta);
    }
    if (data.containsKey('num_cra')) {
      context.handle(_numCraMeta,
          numCra.isAcceptableOrUnknown(data['num_cra']!, _numCraMeta));
    } else if (isInserting) {
      context.missing(_numCraMeta);
    }
    if (data.containsKey('cpf')) {
      context.handle(
          _cpfMeta, cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta));
    } else if (isInserting) {
      context.missing(_cpfMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('job_position')) {
      context.handle(
          _jobPositionMeta,
          jobPosition.isAcceptableOrUnknown(
              data['job_position']!, _jobPositionMeta));
    } else if (isInserting) {
      context.missing(_jobPositionMeta);
    }
    if (data.containsKey('id_login')) {
      context.handle(_idLoginMeta,
          idLogin.isAcceptableOrUnknown(data['id_login']!, _idLoginMeta));
    } else if (isInserting) {
      context.missing(_idLoginMeta);
    }
    if (data.containsKey('picture_hash')) {
      context.handle(
          _pictureHashMeta,
          pictureHash.isAcceptableOrUnknown(
              data['picture_hash']!, _pictureHashMeta));
    } else if (isInserting) {
      context.missing(_pictureHashMeta);
    }
    if (data.containsKey('registered')) {
      context.handle(
          _registeredMeta,
          registered.isAcceptableOrUnknown(
              data['registered']!, _registeredMeta));
    } else if (isInserting) {
      context.missing(_registeredMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cpf};
  @override
  EmployeeInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeInfoData(
      condoCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condo_code'])!,
      numCad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}num_cad'])!,
      numCra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}num_cra'])!,
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      jobPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job_position'])!,
      idLogin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_login'])!,
      pictureHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture_hash'])!,
      registered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}registered'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $EmployeeInfoTableTable createAlias(String alias) {
    return $EmployeeInfoTableTable(attachedDatabase, alias);
  }
}

class EmployeeInfoData extends DataClass
    implements Insertable<EmployeeInfoData> {
  final String condoCode;
  final String numCad;
  final String numCra;
  final String cpf;
  final String name;
  final String jobPosition;
  final String idLogin;
  final String pictureHash;
  final bool registered;
  final String status;
  const EmployeeInfoData(
      {required this.condoCode,
      required this.numCad,
      required this.numCra,
      required this.cpf,
      required this.name,
      required this.jobPosition,
      required this.idLogin,
      required this.pictureHash,
      required this.registered,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condo_code'] = Variable<String>(condoCode);
    map['num_cad'] = Variable<String>(numCad);
    map['num_cra'] = Variable<String>(numCra);
    map['cpf'] = Variable<String>(cpf);
    map['name'] = Variable<String>(name);
    map['job_position'] = Variable<String>(jobPosition);
    map['id_login'] = Variable<String>(idLogin);
    map['picture_hash'] = Variable<String>(pictureHash);
    map['registered'] = Variable<bool>(registered);
    map['status'] = Variable<String>(status);
    return map;
  }

  EmployeeInfoTableCompanion toCompanion(bool nullToAbsent) {
    return EmployeeInfoTableCompanion(
      condoCode: Value(condoCode),
      numCad: Value(numCad),
      numCra: Value(numCra),
      cpf: Value(cpf),
      name: Value(name),
      jobPosition: Value(jobPosition),
      idLogin: Value(idLogin),
      pictureHash: Value(pictureHash),
      registered: Value(registered),
      status: Value(status),
    );
  }

  factory EmployeeInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeInfoData(
      condoCode: serializer.fromJson<String>(json['condoCode']),
      numCad: serializer.fromJson<String>(json['numCad']),
      numCra: serializer.fromJson<String>(json['numCra']),
      cpf: serializer.fromJson<String>(json['cpf']),
      name: serializer.fromJson<String>(json['name']),
      jobPosition: serializer.fromJson<String>(json['jobPosition']),
      idLogin: serializer.fromJson<String>(json['idLogin']),
      pictureHash: serializer.fromJson<String>(json['pictureHash']),
      registered: serializer.fromJson<bool>(json['registered']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condoCode': serializer.toJson<String>(condoCode),
      'numCad': serializer.toJson<String>(numCad),
      'numCra': serializer.toJson<String>(numCra),
      'cpf': serializer.toJson<String>(cpf),
      'name': serializer.toJson<String>(name),
      'jobPosition': serializer.toJson<String>(jobPosition),
      'idLogin': serializer.toJson<String>(idLogin),
      'pictureHash': serializer.toJson<String>(pictureHash),
      'registered': serializer.toJson<bool>(registered),
      'status': serializer.toJson<String>(status),
    };
  }

  EmployeeInfoData copyWith(
          {String? condoCode,
          String? numCad,
          String? numCra,
          String? cpf,
          String? name,
          String? jobPosition,
          String? idLogin,
          String? pictureHash,
          bool? registered,
          String? status}) =>
      EmployeeInfoData(
        condoCode: condoCode ?? this.condoCode,
        numCad: numCad ?? this.numCad,
        numCra: numCra ?? this.numCra,
        cpf: cpf ?? this.cpf,
        name: name ?? this.name,
        jobPosition: jobPosition ?? this.jobPosition,
        idLogin: idLogin ?? this.idLogin,
        pictureHash: pictureHash ?? this.pictureHash,
        registered: registered ?? this.registered,
        status: status ?? this.status,
      );
  EmployeeInfoData copyWithCompanion(EmployeeInfoTableCompanion data) {
    return EmployeeInfoData(
      condoCode: data.condoCode.present ? data.condoCode.value : this.condoCode,
      numCad: data.numCad.present ? data.numCad.value : this.numCad,
      numCra: data.numCra.present ? data.numCra.value : this.numCra,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      name: data.name.present ? data.name.value : this.name,
      jobPosition:
          data.jobPosition.present ? data.jobPosition.value : this.jobPosition,
      idLogin: data.idLogin.present ? data.idLogin.value : this.idLogin,
      pictureHash:
          data.pictureHash.present ? data.pictureHash.value : this.pictureHash,
      registered:
          data.registered.present ? data.registered.value : this.registered,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeInfoData(')
          ..write('condoCode: $condoCode, ')
          ..write('numCad: $numCad, ')
          ..write('numCra: $numCra, ')
          ..write('cpf: $cpf, ')
          ..write('name: $name, ')
          ..write('jobPosition: $jobPosition, ')
          ..write('idLogin: $idLogin, ')
          ..write('pictureHash: $pictureHash, ')
          ..write('registered: $registered, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condoCode, numCad, numCra, cpf, name,
      jobPosition, idLogin, pictureHash, registered, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeInfoData &&
          other.condoCode == this.condoCode &&
          other.numCad == this.numCad &&
          other.numCra == this.numCra &&
          other.cpf == this.cpf &&
          other.name == this.name &&
          other.jobPosition == this.jobPosition &&
          other.idLogin == this.idLogin &&
          other.pictureHash == this.pictureHash &&
          other.registered == this.registered &&
          other.status == this.status);
}

class EmployeeInfoTableCompanion extends UpdateCompanion<EmployeeInfoData> {
  final Value<String> condoCode;
  final Value<String> numCad;
  final Value<String> numCra;
  final Value<String> cpf;
  final Value<String> name;
  final Value<String> jobPosition;
  final Value<String> idLogin;
  final Value<String> pictureHash;
  final Value<bool> registered;
  final Value<String> status;
  final Value<int> rowid;
  const EmployeeInfoTableCompanion({
    this.condoCode = const Value.absent(),
    this.numCad = const Value.absent(),
    this.numCra = const Value.absent(),
    this.cpf = const Value.absent(),
    this.name = const Value.absent(),
    this.jobPosition = const Value.absent(),
    this.idLogin = const Value.absent(),
    this.pictureHash = const Value.absent(),
    this.registered = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeInfoTableCompanion.insert({
    required String condoCode,
    required String numCad,
    required String numCra,
    required String cpf,
    required String name,
    required String jobPosition,
    required String idLogin,
    required String pictureHash,
    required bool registered,
    required String status,
    this.rowid = const Value.absent(),
  })  : condoCode = Value(condoCode),
        numCad = Value(numCad),
        numCra = Value(numCra),
        cpf = Value(cpf),
        name = Value(name),
        jobPosition = Value(jobPosition),
        idLogin = Value(idLogin),
        pictureHash = Value(pictureHash),
        registered = Value(registered),
        status = Value(status);
  static Insertable<EmployeeInfoData> custom({
    Expression<String>? condoCode,
    Expression<String>? numCad,
    Expression<String>? numCra,
    Expression<String>? cpf,
    Expression<String>? name,
    Expression<String>? jobPosition,
    Expression<String>? idLogin,
    Expression<String>? pictureHash,
    Expression<bool>? registered,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condoCode != null) 'condo_code': condoCode,
      if (numCad != null) 'num_cad': numCad,
      if (numCra != null) 'num_cra': numCra,
      if (cpf != null) 'cpf': cpf,
      if (name != null) 'name': name,
      if (jobPosition != null) 'job_position': jobPosition,
      if (idLogin != null) 'id_login': idLogin,
      if (pictureHash != null) 'picture_hash': pictureHash,
      if (registered != null) 'registered': registered,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeInfoTableCompanion copyWith(
      {Value<String>? condoCode,
      Value<String>? numCad,
      Value<String>? numCra,
      Value<String>? cpf,
      Value<String>? name,
      Value<String>? jobPosition,
      Value<String>? idLogin,
      Value<String>? pictureHash,
      Value<bool>? registered,
      Value<String>? status,
      Value<int>? rowid}) {
    return EmployeeInfoTableCompanion(
      condoCode: condoCode ?? this.condoCode,
      numCad: numCad ?? this.numCad,
      numCra: numCra ?? this.numCra,
      cpf: cpf ?? this.cpf,
      name: name ?? this.name,
      jobPosition: jobPosition ?? this.jobPosition,
      idLogin: idLogin ?? this.idLogin,
      pictureHash: pictureHash ?? this.pictureHash,
      registered: registered ?? this.registered,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condoCode.present) {
      map['condo_code'] = Variable<String>(condoCode.value);
    }
    if (numCad.present) {
      map['num_cad'] = Variable<String>(numCad.value);
    }
    if (numCra.present) {
      map['num_cra'] = Variable<String>(numCra.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (jobPosition.present) {
      map['job_position'] = Variable<String>(jobPosition.value);
    }
    if (idLogin.present) {
      map['id_login'] = Variable<String>(idLogin.value);
    }
    if (pictureHash.present) {
      map['picture_hash'] = Variable<String>(pictureHash.value);
    }
    if (registered.present) {
      map['registered'] = Variable<bool>(registered.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeInfoTableCompanion(')
          ..write('condoCode: $condoCode, ')
          ..write('numCad: $numCad, ')
          ..write('numCra: $numCra, ')
          ..write('cpf: $cpf, ')
          ..write('name: $name, ')
          ..write('jobPosition: $jobPosition, ')
          ..write('idLogin: $idLogin, ')
          ..write('pictureHash: $pictureHash, ')
          ..write('registered: $registered, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CondominiumInfoTableTable extends CondominiumInfoTable
    with TableInfo<$CondominiumInfoTableTable, CondominiumInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CondominiumInfoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condoCodeMeta =
      const VerificationMeta('condoCode');
  @override
  late final GeneratedColumn<String> condoCode = GeneratedColumn<String>(
      'condo_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _picturehashMeta =
      const VerificationMeta('picturehash');
  @override
  late final GeneratedColumn<String> picturehash = GeneratedColumn<String>(
      'picturehash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refMeta = const VerificationMeta('ref');
  @override
  late final GeneratedColumn<String> ref = GeneratedColumn<String>(
      'ref', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [condoCode, reference, name, picturehash, status, ref];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condominium_info_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CondominiumInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('condo_code')) {
      context.handle(_condoCodeMeta,
          condoCode.isAcceptableOrUnknown(data['condo_code']!, _condoCodeMeta));
    } else if (isInserting) {
      context.missing(_condoCodeMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('picturehash')) {
      context.handle(
          _picturehashMeta,
          picturehash.isAcceptableOrUnknown(
              data['picturehash']!, _picturehashMeta));
    } else if (isInserting) {
      context.missing(_picturehashMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('ref')) {
      context.handle(
          _refMeta, ref.isAcceptableOrUnknown(data['ref']!, _refMeta));
    } else if (isInserting) {
      context.missing(_refMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {reference};
  @override
  CondominiumInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CondominiumInfoData(
      condoCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condo_code'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      picturehash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picturehash'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      ref: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref'])!,
    );
  }

  @override
  $CondominiumInfoTableTable createAlias(String alias) {
    return $CondominiumInfoTableTable(attachedDatabase, alias);
  }
}

class CondominiumInfoData extends DataClass
    implements Insertable<CondominiumInfoData> {
  final String condoCode;
  final String reference;
  final String name;
  final String picturehash;
  final String status;
  final String ref;
  const CondominiumInfoData(
      {required this.condoCode,
      required this.reference,
      required this.name,
      required this.picturehash,
      required this.status,
      required this.ref});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condo_code'] = Variable<String>(condoCode);
    map['reference'] = Variable<String>(reference);
    map['name'] = Variable<String>(name);
    map['picturehash'] = Variable<String>(picturehash);
    map['status'] = Variable<String>(status);
    map['ref'] = Variable<String>(ref);
    return map;
  }

  CondominiumInfoTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumInfoTableCompanion(
      condoCode: Value(condoCode),
      reference: Value(reference),
      name: Value(name),
      picturehash: Value(picturehash),
      status: Value(status),
      ref: Value(ref),
    );
  }

  factory CondominiumInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumInfoData(
      condoCode: serializer.fromJson<String>(json['condoCode']),
      reference: serializer.fromJson<String>(json['reference']),
      name: serializer.fromJson<String>(json['name']),
      picturehash: serializer.fromJson<String>(json['picturehash']),
      status: serializer.fromJson<String>(json['status']),
      ref: serializer.fromJson<String>(json['ref']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condoCode': serializer.toJson<String>(condoCode),
      'reference': serializer.toJson<String>(reference),
      'name': serializer.toJson<String>(name),
      'picturehash': serializer.toJson<String>(picturehash),
      'status': serializer.toJson<String>(status),
      'ref': serializer.toJson<String>(ref),
    };
  }

  CondominiumInfoData copyWith(
          {String? condoCode,
          String? reference,
          String? name,
          String? picturehash,
          String? status,
          String? ref}) =>
      CondominiumInfoData(
        condoCode: condoCode ?? this.condoCode,
        reference: reference ?? this.reference,
        name: name ?? this.name,
        picturehash: picturehash ?? this.picturehash,
        status: status ?? this.status,
        ref: ref ?? this.ref,
      );
  CondominiumInfoData copyWithCompanion(CondominiumInfoTableCompanion data) {
    return CondominiumInfoData(
      condoCode: data.condoCode.present ? data.condoCode.value : this.condoCode,
      reference: data.reference.present ? data.reference.value : this.reference,
      name: data.name.present ? data.name.value : this.name,
      picturehash:
          data.picturehash.present ? data.picturehash.value : this.picturehash,
      status: data.status.present ? data.status.value : this.status,
      ref: data.ref.present ? data.ref.value : this.ref,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumInfoData(')
          ..write('condoCode: $condoCode, ')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('picturehash: $picturehash, ')
          ..write('status: $status, ')
          ..write('ref: $ref')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(condoCode, reference, name, picturehash, status, ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumInfoData &&
          other.condoCode == this.condoCode &&
          other.reference == this.reference &&
          other.name == this.name &&
          other.picturehash == this.picturehash &&
          other.status == this.status &&
          other.ref == this.ref);
}

class CondominiumInfoTableCompanion
    extends UpdateCompanion<CondominiumInfoData> {
  final Value<String> condoCode;
  final Value<String> reference;
  final Value<String> name;
  final Value<String> picturehash;
  final Value<String> status;
  final Value<String> ref;
  final Value<int> rowid;
  const CondominiumInfoTableCompanion({
    this.condoCode = const Value.absent(),
    this.reference = const Value.absent(),
    this.name = const Value.absent(),
    this.picturehash = const Value.absent(),
    this.status = const Value.absent(),
    this.ref = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumInfoTableCompanion.insert({
    required String condoCode,
    required String reference,
    required String name,
    required String picturehash,
    required String status,
    required String ref,
    this.rowid = const Value.absent(),
  })  : condoCode = Value(condoCode),
        reference = Value(reference),
        name = Value(name),
        picturehash = Value(picturehash),
        status = Value(status),
        ref = Value(ref);
  static Insertable<CondominiumInfoData> custom({
    Expression<String>? condoCode,
    Expression<String>? reference,
    Expression<String>? name,
    Expression<String>? picturehash,
    Expression<String>? status,
    Expression<String>? ref,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condoCode != null) 'condo_code': condoCode,
      if (reference != null) 'reference': reference,
      if (name != null) 'name': name,
      if (picturehash != null) 'picturehash': picturehash,
      if (status != null) 'status': status,
      if (ref != null) 'ref': ref,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumInfoTableCompanion copyWith(
      {Value<String>? condoCode,
      Value<String>? reference,
      Value<String>? name,
      Value<String>? picturehash,
      Value<String>? status,
      Value<String>? ref,
      Value<int>? rowid}) {
    return CondominiumInfoTableCompanion(
      condoCode: condoCode ?? this.condoCode,
      reference: reference ?? this.reference,
      name: name ?? this.name,
      picturehash: picturehash ?? this.picturehash,
      status: status ?? this.status,
      ref: ref ?? this.ref,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condoCode.present) {
      map['condo_code'] = Variable<String>(condoCode.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (picturehash.present) {
      map['picturehash'] = Variable<String>(picturehash.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (ref.present) {
      map['ref'] = Variable<String>(ref.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumInfoTableCompanion(')
          ..write('condoCode: $condoCode, ')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('picturehash: $picturehash, ')
          ..write('status: $status, ')
          ..write('ref: $ref, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AuthenticationTabletDatabase extends GeneratedDatabase {
  _$AuthenticationTabletDatabase(QueryExecutor e) : super(e);
  $AuthenticationTabletDatabaseManager get managers =>
      $AuthenticationTabletDatabaseManager(this);
  late final $EmployeeInfoTableTable employeeInfoTable =
      $EmployeeInfoTableTable(this);
  late final $CondominiumInfoTableTable condominiumInfoTable =
      $CondominiumInfoTableTable(this);
  late final EmployeeInfoDao employeeInfoDao =
      EmployeeInfoDao(this as AuthenticationTabletDatabase);
  late final CondominiumInfoDao condominiumInfoDao =
      CondominiumInfoDao(this as AuthenticationTabletDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [employeeInfoTable, condominiumInfoTable];
}

typedef $$EmployeeInfoTableTableCreateCompanionBuilder
    = EmployeeInfoTableCompanion Function({
  required String condoCode,
  required String numCad,
  required String numCra,
  required String cpf,
  required String name,
  required String jobPosition,
  required String idLogin,
  required String pictureHash,
  required bool registered,
  required String status,
  Value<int> rowid,
});
typedef $$EmployeeInfoTableTableUpdateCompanionBuilder
    = EmployeeInfoTableCompanion Function({
  Value<String> condoCode,
  Value<String> numCad,
  Value<String> numCra,
  Value<String> cpf,
  Value<String> name,
  Value<String> jobPosition,
  Value<String> idLogin,
  Value<String> pictureHash,
  Value<bool> registered,
  Value<String> status,
  Value<int> rowid,
});

class $$EmployeeInfoTableTableFilterComposer
    extends Composer<_$AuthenticationTabletDatabase, $EmployeeInfoTableTable> {
  $$EmployeeInfoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condoCode => $composableBuilder(
      column: $table.condoCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numCad => $composableBuilder(
      column: $table.numCad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numCra => $composableBuilder(
      column: $table.numCra, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobPosition => $composableBuilder(
      column: $table.jobPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idLogin => $composableBuilder(
      column: $table.idLogin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pictureHash => $composableBuilder(
      column: $table.pictureHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get registered => $composableBuilder(
      column: $table.registered, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$EmployeeInfoTableTableOrderingComposer
    extends Composer<_$AuthenticationTabletDatabase, $EmployeeInfoTableTable> {
  $$EmployeeInfoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condoCode => $composableBuilder(
      column: $table.condoCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numCad => $composableBuilder(
      column: $table.numCad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numCra => $composableBuilder(
      column: $table.numCra, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobPosition => $composableBuilder(
      column: $table.jobPosition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idLogin => $composableBuilder(
      column: $table.idLogin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pictureHash => $composableBuilder(
      column: $table.pictureHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get registered => $composableBuilder(
      column: $table.registered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeInfoTableTableAnnotationComposer
    extends Composer<_$AuthenticationTabletDatabase, $EmployeeInfoTableTable> {
  $$EmployeeInfoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condoCode =>
      $composableBuilder(column: $table.condoCode, builder: (column) => column);

  GeneratedColumn<String> get numCad =>
      $composableBuilder(column: $table.numCad, builder: (column) => column);

  GeneratedColumn<String> get numCra =>
      $composableBuilder(column: $table.numCra, builder: (column) => column);

  GeneratedColumn<String> get cpf =>
      $composableBuilder(column: $table.cpf, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get jobPosition => $composableBuilder(
      column: $table.jobPosition, builder: (column) => column);

  GeneratedColumn<String> get idLogin =>
      $composableBuilder(column: $table.idLogin, builder: (column) => column);

  GeneratedColumn<String> get pictureHash => $composableBuilder(
      column: $table.pictureHash, builder: (column) => column);

  GeneratedColumn<bool> get registered => $composableBuilder(
      column: $table.registered, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$EmployeeInfoTableTableTableManager extends RootTableManager<
    _$AuthenticationTabletDatabase,
    $EmployeeInfoTableTable,
    EmployeeInfoData,
    $$EmployeeInfoTableTableFilterComposer,
    $$EmployeeInfoTableTableOrderingComposer,
    $$EmployeeInfoTableTableAnnotationComposer,
    $$EmployeeInfoTableTableCreateCompanionBuilder,
    $$EmployeeInfoTableTableUpdateCompanionBuilder,
    (
      EmployeeInfoData,
      BaseReferences<_$AuthenticationTabletDatabase, $EmployeeInfoTableTable,
          EmployeeInfoData>
    ),
    EmployeeInfoData,
    PrefetchHooks Function()> {
  $$EmployeeInfoTableTableTableManager(
      _$AuthenticationTabletDatabase db, $EmployeeInfoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeInfoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeInfoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeInfoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condoCode = const Value.absent(),
            Value<String> numCad = const Value.absent(),
            Value<String> numCra = const Value.absent(),
            Value<String> cpf = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> jobPosition = const Value.absent(),
            Value<String> idLogin = const Value.absent(),
            Value<String> pictureHash = const Value.absent(),
            Value<bool> registered = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeInfoTableCompanion(
            condoCode: condoCode,
            numCad: numCad,
            numCra: numCra,
            cpf: cpf,
            name: name,
            jobPosition: jobPosition,
            idLogin: idLogin,
            pictureHash: pictureHash,
            registered: registered,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condoCode,
            required String numCad,
            required String numCra,
            required String cpf,
            required String name,
            required String jobPosition,
            required String idLogin,
            required String pictureHash,
            required bool registered,
            required String status,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeInfoTableCompanion.insert(
            condoCode: condoCode,
            numCad: numCad,
            numCra: numCra,
            cpf: cpf,
            name: name,
            jobPosition: jobPosition,
            idLogin: idLogin,
            pictureHash: pictureHash,
            registered: registered,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeInfoTableTableProcessedTableManager = ProcessedTableManager<
    _$AuthenticationTabletDatabase,
    $EmployeeInfoTableTable,
    EmployeeInfoData,
    $$EmployeeInfoTableTableFilterComposer,
    $$EmployeeInfoTableTableOrderingComposer,
    $$EmployeeInfoTableTableAnnotationComposer,
    $$EmployeeInfoTableTableCreateCompanionBuilder,
    $$EmployeeInfoTableTableUpdateCompanionBuilder,
    (
      EmployeeInfoData,
      BaseReferences<_$AuthenticationTabletDatabase, $EmployeeInfoTableTable,
          EmployeeInfoData>
    ),
    EmployeeInfoData,
    PrefetchHooks Function()>;
typedef $$CondominiumInfoTableTableCreateCompanionBuilder
    = CondominiumInfoTableCompanion Function({
  required String condoCode,
  required String reference,
  required String name,
  required String picturehash,
  required String status,
  required String ref,
  Value<int> rowid,
});
typedef $$CondominiumInfoTableTableUpdateCompanionBuilder
    = CondominiumInfoTableCompanion Function({
  Value<String> condoCode,
  Value<String> reference,
  Value<String> name,
  Value<String> picturehash,
  Value<String> status,
  Value<String> ref,
  Value<int> rowid,
});

class $$CondominiumInfoTableTableFilterComposer extends Composer<
    _$AuthenticationTabletDatabase, $CondominiumInfoTableTable> {
  $$CondominiumInfoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condoCode => $composableBuilder(
      column: $table.condoCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get picturehash => $composableBuilder(
      column: $table.picturehash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ref => $composableBuilder(
      column: $table.ref, builder: (column) => ColumnFilters(column));
}

class $$CondominiumInfoTableTableOrderingComposer extends Composer<
    _$AuthenticationTabletDatabase, $CondominiumInfoTableTable> {
  $$CondominiumInfoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condoCode => $composableBuilder(
      column: $table.condoCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get picturehash => $composableBuilder(
      column: $table.picturehash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ref => $composableBuilder(
      column: $table.ref, builder: (column) => ColumnOrderings(column));
}

class $$CondominiumInfoTableTableAnnotationComposer extends Composer<
    _$AuthenticationTabletDatabase, $CondominiumInfoTableTable> {
  $$CondominiumInfoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condoCode =>
      $composableBuilder(column: $table.condoCode, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get picturehash => $composableBuilder(
      column: $table.picturehash, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get ref =>
      $composableBuilder(column: $table.ref, builder: (column) => column);
}

class $$CondominiumInfoTableTableTableManager extends RootTableManager<
    _$AuthenticationTabletDatabase,
    $CondominiumInfoTableTable,
    CondominiumInfoData,
    $$CondominiumInfoTableTableFilterComposer,
    $$CondominiumInfoTableTableOrderingComposer,
    $$CondominiumInfoTableTableAnnotationComposer,
    $$CondominiumInfoTableTableCreateCompanionBuilder,
    $$CondominiumInfoTableTableUpdateCompanionBuilder,
    (
      CondominiumInfoData,
      BaseReferences<_$AuthenticationTabletDatabase, $CondominiumInfoTableTable,
          CondominiumInfoData>
    ),
    CondominiumInfoData,
    PrefetchHooks Function()> {
  $$CondominiumInfoTableTableTableManager(
      _$AuthenticationTabletDatabase db, $CondominiumInfoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CondominiumInfoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CondominiumInfoTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CondominiumInfoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condoCode = const Value.absent(),
            Value<String> reference = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> picturehash = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> ref = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumInfoTableCompanion(
            condoCode: condoCode,
            reference: reference,
            name: name,
            picturehash: picturehash,
            status: status,
            ref: ref,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condoCode,
            required String reference,
            required String name,
            required String picturehash,
            required String status,
            required String ref,
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumInfoTableCompanion.insert(
            condoCode: condoCode,
            reference: reference,
            name: name,
            picturehash: picturehash,
            status: status,
            ref: ref,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CondominiumInfoTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AuthenticationTabletDatabase,
        $CondominiumInfoTableTable,
        CondominiumInfoData,
        $$CondominiumInfoTableTableFilterComposer,
        $$CondominiumInfoTableTableOrderingComposer,
        $$CondominiumInfoTableTableAnnotationComposer,
        $$CondominiumInfoTableTableCreateCompanionBuilder,
        $$CondominiumInfoTableTableUpdateCompanionBuilder,
        (
          CondominiumInfoData,
          BaseReferences<_$AuthenticationTabletDatabase,
              $CondominiumInfoTableTable, CondominiumInfoData>
        ),
        CondominiumInfoData,
        PrefetchHooks Function()>;

class $AuthenticationTabletDatabaseManager {
  final _$AuthenticationTabletDatabase _db;
  $AuthenticationTabletDatabaseManager(this._db);
  $$EmployeeInfoTableTableTableManager get employeeInfoTable =>
      $$EmployeeInfoTableTableTableManager(_db, _db.employeeInfoTable);
  $$CondominiumInfoTableTableTableManager get condominiumInfoTable =>
      $$CondominiumInfoTableTableTableManager(_db, _db.condominiumInfoTable);
}
