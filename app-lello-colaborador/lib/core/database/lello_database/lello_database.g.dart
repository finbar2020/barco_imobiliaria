// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lello_database.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _meIdMeta = const VerificationMeta('meId');
  @override
  late final GeneratedColumn<String> meId = GeneratedColumn<String>(
      'me_id', aliasedName, false,
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
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jobPositionMeta =
      const VerificationMeta('jobPosition');
  @override
  late final GeneratedColumn<String> jobPosition = GeneratedColumn<String>(
      'job_position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workShiftMeta =
      const VerificationMeta('workShift');
  @override
  late final GeneratedColumn<String> workShift = GeneratedColumn<String>(
      'work_shift', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _digitalTimesheetStatusMeta =
      const VerificationMeta('digitalTimesheetStatus');
  @override
  late final GeneratedColumn<String> digitalTimesheetStatus =
      GeneratedColumn<String>('digital_timesheet_status', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usesDigitalTimesheetMeta =
      const VerificationMeta('usesDigitalTimesheet');
  @override
  late final GeneratedColumn<bool> usesDigitalTimesheet = GeneratedColumn<bool>(
      'uses_digital_timesheet', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("uses_digital_timesheet" IN (0, 1))'));
  static const VerificationMeta _workLeaveDescriptionMeta =
      const VerificationMeta('workLeaveDescription');
  @override
  late final GeneratedColumn<String> workLeaveDescription =
      GeneratedColumn<String>('work_leave_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shouldIgnoreDigitalPointMeta =
      const VerificationMeta('shouldIgnoreDigitalPoint');
  @override
  late final GeneratedColumn<bool> shouldIgnoreDigitalPoint =
      GeneratedColumn<bool>(
          'should_ignore_digital_point', aliasedName, true,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("should_ignore_digital_point" IN (0, 1))'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<String> latitude = GeneratedColumn<String>(
      'latitude', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<String> longitude = GeneratedColumn<String>(
      'longitude', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        meId,
        reference,
        name,
        jobPosition,
        workShift,
        digitalTimesheetStatus,
        usesDigitalTimesheet,
        workLeaveDescription,
        shouldIgnoreDigitalPoint,
        latitude,
        longitude
      ];
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
    if (data.containsKey('me_id')) {
      context.handle(
          _meIdMeta, meId.isAcceptableOrUnknown(data['me_id']!, _meIdMeta));
    } else if (isInserting) {
      context.missing(_meIdMeta);
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
    }
    if (data.containsKey('job_position')) {
      context.handle(
          _jobPositionMeta,
          jobPosition.isAcceptableOrUnknown(
              data['job_position']!, _jobPositionMeta));
    }
    if (data.containsKey('work_shift')) {
      context.handle(_workShiftMeta,
          workShift.isAcceptableOrUnknown(data['work_shift']!, _workShiftMeta));
    }
    if (data.containsKey('digital_timesheet_status')) {
      context.handle(
          _digitalTimesheetStatusMeta,
          digitalTimesheetStatus.isAcceptableOrUnknown(
              data['digital_timesheet_status']!, _digitalTimesheetStatusMeta));
    }
    if (data.containsKey('uses_digital_timesheet')) {
      context.handle(
          _usesDigitalTimesheetMeta,
          usesDigitalTimesheet.isAcceptableOrUnknown(
              data['uses_digital_timesheet']!, _usesDigitalTimesheetMeta));
    }
    if (data.containsKey('work_leave_description')) {
      context.handle(
          _workLeaveDescriptionMeta,
          workLeaveDescription.isAcceptableOrUnknown(
              data['work_leave_description']!, _workLeaveDescriptionMeta));
    }
    if (data.containsKey('should_ignore_digital_point')) {
      context.handle(
          _shouldIgnoreDigitalPointMeta,
          shouldIgnoreDigitalPoint.isAcceptableOrUnknown(
              data['should_ignore_digital_point']!,
              _shouldIgnoreDigitalPointMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
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
      meId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}me_id'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      jobPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job_position']),
      workShift: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_shift']),
      digitalTimesheetStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}digital_timesheet_status']),
      usesDigitalTimesheet: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}uses_digital_timesheet']),
      workLeaveDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}work_leave_description']),
      shouldIgnoreDigitalPoint: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}should_ignore_digital_point']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}longitude']),
    );
  }

  @override
  $CondominiumTableTable createAlias(String alias) {
    return $CondominiumTableTable(attachedDatabase, alias);
  }
}

class CondominiumData extends DataClass implements Insertable<CondominiumData> {
  final String id;
  final String meId;
  final String reference;
  final String? name;
  final String? jobPosition;
  final String? workShift;
  final String? digitalTimesheetStatus;
  final bool? usesDigitalTimesheet;
  final String? workLeaveDescription;
  final bool? shouldIgnoreDigitalPoint;
  final String? latitude;
  final String? longitude;
  const CondominiumData(
      {required this.id,
      required this.meId,
      required this.reference,
      this.name,
      this.jobPosition,
      this.workShift,
      this.digitalTimesheetStatus,
      this.usesDigitalTimesheet,
      this.workLeaveDescription,
      this.shouldIgnoreDigitalPoint,
      this.latitude,
      this.longitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['me_id'] = Variable<String>(meId);
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || jobPosition != null) {
      map['job_position'] = Variable<String>(jobPosition);
    }
    if (!nullToAbsent || workShift != null) {
      map['work_shift'] = Variable<String>(workShift);
    }
    if (!nullToAbsent || digitalTimesheetStatus != null) {
      map['digital_timesheet_status'] =
          Variable<String>(digitalTimesheetStatus);
    }
    if (!nullToAbsent || usesDigitalTimesheet != null) {
      map['uses_digital_timesheet'] = Variable<bool>(usesDigitalTimesheet);
    }
    if (!nullToAbsent || workLeaveDescription != null) {
      map['work_leave_description'] = Variable<String>(workLeaveDescription);
    }
    if (!nullToAbsent || shouldIgnoreDigitalPoint != null) {
      map['should_ignore_digital_point'] =
          Variable<bool>(shouldIgnoreDigitalPoint);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<String>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<String>(longitude);
    }
    return map;
  }

  CondominiumTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumTableCompanion(
      id: Value(id),
      meId: Value(meId),
      reference: Value(reference),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      jobPosition: jobPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(jobPosition),
      workShift: workShift == null && nullToAbsent
          ? const Value.absent()
          : Value(workShift),
      digitalTimesheetStatus: digitalTimesheetStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(digitalTimesheetStatus),
      usesDigitalTimesheet: usesDigitalTimesheet == null && nullToAbsent
          ? const Value.absent()
          : Value(usesDigitalTimesheet),
      workLeaveDescription: workLeaveDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(workLeaveDescription),
      shouldIgnoreDigitalPoint: shouldIgnoreDigitalPoint == null && nullToAbsent
          ? const Value.absent()
          : Value(shouldIgnoreDigitalPoint),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory CondominiumData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumData(
      id: serializer.fromJson<String>(json['id']),
      meId: serializer.fromJson<String>(json['meId']),
      reference: serializer.fromJson<String>(json['reference']),
      name: serializer.fromJson<String?>(json['name']),
      jobPosition: serializer.fromJson<String?>(json['jobPosition']),
      workShift: serializer.fromJson<String?>(json['workShift']),
      digitalTimesheetStatus:
          serializer.fromJson<String?>(json['digitalTimesheetStatus']),
      usesDigitalTimesheet:
          serializer.fromJson<bool?>(json['usesDigitalTimesheet']),
      workLeaveDescription:
          serializer.fromJson<String?>(json['workLeaveDescription']),
      shouldIgnoreDigitalPoint:
          serializer.fromJson<bool?>(json['shouldIgnoreDigitalPoint']),
      latitude: serializer.fromJson<String?>(json['latitude']),
      longitude: serializer.fromJson<String?>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'meId': serializer.toJson<String>(meId),
      'reference': serializer.toJson<String>(reference),
      'name': serializer.toJson<String?>(name),
      'jobPosition': serializer.toJson<String?>(jobPosition),
      'workShift': serializer.toJson<String?>(workShift),
      'digitalTimesheetStatus':
          serializer.toJson<String?>(digitalTimesheetStatus),
      'usesDigitalTimesheet': serializer.toJson<bool?>(usesDigitalTimesheet),
      'workLeaveDescription': serializer.toJson<String?>(workLeaveDescription),
      'shouldIgnoreDigitalPoint':
          serializer.toJson<bool?>(shouldIgnoreDigitalPoint),
      'latitude': serializer.toJson<String?>(latitude),
      'longitude': serializer.toJson<String?>(longitude),
    };
  }

  CondominiumData copyWith(
          {String? id,
          String? meId,
          String? reference,
          Value<String?> name = const Value.absent(),
          Value<String?> jobPosition = const Value.absent(),
          Value<String?> workShift = const Value.absent(),
          Value<String?> digitalTimesheetStatus = const Value.absent(),
          Value<bool?> usesDigitalTimesheet = const Value.absent(),
          Value<String?> workLeaveDescription = const Value.absent(),
          Value<bool?> shouldIgnoreDigitalPoint = const Value.absent(),
          Value<String?> latitude = const Value.absent(),
          Value<String?> longitude = const Value.absent()}) =>
      CondominiumData(
        id: id ?? this.id,
        meId: meId ?? this.meId,
        reference: reference ?? this.reference,
        name: name.present ? name.value : this.name,
        jobPosition: jobPosition.present ? jobPosition.value : this.jobPosition,
        workShift: workShift.present ? workShift.value : this.workShift,
        digitalTimesheetStatus: digitalTimesheetStatus.present
            ? digitalTimesheetStatus.value
            : this.digitalTimesheetStatus,
        usesDigitalTimesheet: usesDigitalTimesheet.present
            ? usesDigitalTimesheet.value
            : this.usesDigitalTimesheet,
        workLeaveDescription: workLeaveDescription.present
            ? workLeaveDescription.value
            : this.workLeaveDescription,
        shouldIgnoreDigitalPoint: shouldIgnoreDigitalPoint.present
            ? shouldIgnoreDigitalPoint.value
            : this.shouldIgnoreDigitalPoint,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
      );
  CondominiumData copyWithCompanion(CondominiumTableCompanion data) {
    return CondominiumData(
      id: data.id.present ? data.id.value : this.id,
      meId: data.meId.present ? data.meId.value : this.meId,
      reference: data.reference.present ? data.reference.value : this.reference,
      name: data.name.present ? data.name.value : this.name,
      jobPosition:
          data.jobPosition.present ? data.jobPosition.value : this.jobPosition,
      workShift: data.workShift.present ? data.workShift.value : this.workShift,
      digitalTimesheetStatus: data.digitalTimesheetStatus.present
          ? data.digitalTimesheetStatus.value
          : this.digitalTimesheetStatus,
      usesDigitalTimesheet: data.usesDigitalTimesheet.present
          ? data.usesDigitalTimesheet.value
          : this.usesDigitalTimesheet,
      workLeaveDescription: data.workLeaveDescription.present
          ? data.workLeaveDescription.value
          : this.workLeaveDescription,
      shouldIgnoreDigitalPoint: data.shouldIgnoreDigitalPoint.present
          ? data.shouldIgnoreDigitalPoint.value
          : this.shouldIgnoreDigitalPoint,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumData(')
          ..write('id: $id, ')
          ..write('meId: $meId, ')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('jobPosition: $jobPosition, ')
          ..write('workShift: $workShift, ')
          ..write('digitalTimesheetStatus: $digitalTimesheetStatus, ')
          ..write('usesDigitalTimesheet: $usesDigitalTimesheet, ')
          ..write('workLeaveDescription: $workLeaveDescription, ')
          ..write('shouldIgnoreDigitalPoint: $shouldIgnoreDigitalPoint, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      meId,
      reference,
      name,
      jobPosition,
      workShift,
      digitalTimesheetStatus,
      usesDigitalTimesheet,
      workLeaveDescription,
      shouldIgnoreDigitalPoint,
      latitude,
      longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumData &&
          other.id == this.id &&
          other.meId == this.meId &&
          other.reference == this.reference &&
          other.name == this.name &&
          other.jobPosition == this.jobPosition &&
          other.workShift == this.workShift &&
          other.digitalTimesheetStatus == this.digitalTimesheetStatus &&
          other.usesDigitalTimesheet == this.usesDigitalTimesheet &&
          other.workLeaveDescription == this.workLeaveDescription &&
          other.shouldIgnoreDigitalPoint == this.shouldIgnoreDigitalPoint &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class CondominiumTableCompanion extends UpdateCompanion<CondominiumData> {
  final Value<String> id;
  final Value<String> meId;
  final Value<String> reference;
  final Value<String?> name;
  final Value<String?> jobPosition;
  final Value<String?> workShift;
  final Value<String?> digitalTimesheetStatus;
  final Value<bool?> usesDigitalTimesheet;
  final Value<String?> workLeaveDescription;
  final Value<bool?> shouldIgnoreDigitalPoint;
  final Value<String?> latitude;
  final Value<String?> longitude;
  final Value<int> rowid;
  const CondominiumTableCompanion({
    this.id = const Value.absent(),
    this.meId = const Value.absent(),
    this.reference = const Value.absent(),
    this.name = const Value.absent(),
    this.jobPosition = const Value.absent(),
    this.workShift = const Value.absent(),
    this.digitalTimesheetStatus = const Value.absent(),
    this.usesDigitalTimesheet = const Value.absent(),
    this.workLeaveDescription = const Value.absent(),
    this.shouldIgnoreDigitalPoint = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumTableCompanion.insert({
    required String id,
    required String meId,
    required String reference,
    this.name = const Value.absent(),
    this.jobPosition = const Value.absent(),
    this.workShift = const Value.absent(),
    this.digitalTimesheetStatus = const Value.absent(),
    this.usesDigitalTimesheet = const Value.absent(),
    this.workLeaveDescription = const Value.absent(),
    this.shouldIgnoreDigitalPoint = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        meId = Value(meId),
        reference = Value(reference);
  static Insertable<CondominiumData> custom({
    Expression<String>? id,
    Expression<String>? meId,
    Expression<String>? reference,
    Expression<String>? name,
    Expression<String>? jobPosition,
    Expression<String>? workShift,
    Expression<String>? digitalTimesheetStatus,
    Expression<bool>? usesDigitalTimesheet,
    Expression<String>? workLeaveDescription,
    Expression<bool>? shouldIgnoreDigitalPoint,
    Expression<String>? latitude,
    Expression<String>? longitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meId != null) 'me_id': meId,
      if (reference != null) 'reference': reference,
      if (name != null) 'name': name,
      if (jobPosition != null) 'job_position': jobPosition,
      if (workShift != null) 'work_shift': workShift,
      if (digitalTimesheetStatus != null)
        'digital_timesheet_status': digitalTimesheetStatus,
      if (usesDigitalTimesheet != null)
        'uses_digital_timesheet': usesDigitalTimesheet,
      if (workLeaveDescription != null)
        'work_leave_description': workLeaveDescription,
      if (shouldIgnoreDigitalPoint != null)
        'should_ignore_digital_point': shouldIgnoreDigitalPoint,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? meId,
      Value<String>? reference,
      Value<String?>? name,
      Value<String?>? jobPosition,
      Value<String?>? workShift,
      Value<String?>? digitalTimesheetStatus,
      Value<bool?>? usesDigitalTimesheet,
      Value<String?>? workLeaveDescription,
      Value<bool?>? shouldIgnoreDigitalPoint,
      Value<String?>? latitude,
      Value<String?>? longitude,
      Value<int>? rowid}) {
    return CondominiumTableCompanion(
      id: id ?? this.id,
      meId: meId ?? this.meId,
      reference: reference ?? this.reference,
      name: name ?? this.name,
      jobPosition: jobPosition ?? this.jobPosition,
      workShift: workShift ?? this.workShift,
      digitalTimesheetStatus:
          digitalTimesheetStatus ?? this.digitalTimesheetStatus,
      usesDigitalTimesheet: usesDigitalTimesheet ?? this.usesDigitalTimesheet,
      workLeaveDescription: workLeaveDescription ?? this.workLeaveDescription,
      shouldIgnoreDigitalPoint:
          shouldIgnoreDigitalPoint ?? this.shouldIgnoreDigitalPoint,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (meId.present) {
      map['me_id'] = Variable<String>(meId.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (jobPosition.present) {
      map['job_position'] = Variable<String>(jobPosition.value);
    }
    if (workShift.present) {
      map['work_shift'] = Variable<String>(workShift.value);
    }
    if (digitalTimesheetStatus.present) {
      map['digital_timesheet_status'] =
          Variable<String>(digitalTimesheetStatus.value);
    }
    if (usesDigitalTimesheet.present) {
      map['uses_digital_timesheet'] =
          Variable<bool>(usesDigitalTimesheet.value);
    }
    if (workLeaveDescription.present) {
      map['work_leave_description'] =
          Variable<String>(workLeaveDescription.value);
    }
    if (shouldIgnoreDigitalPoint.present) {
      map['should_ignore_digital_point'] =
          Variable<bool>(shouldIgnoreDigitalPoint.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<String>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<String>(longitude.value);
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
          ..write('meId: $meId, ')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('jobPosition: $jobPosition, ')
          ..write('workShift: $workShift, ')
          ..write('digitalTimesheetStatus: $digitalTimesheetStatus, ')
          ..write('usesDigitalTimesheet: $usesDigitalTimesheet, ')
          ..write('workLeaveDescription: $workLeaveDescription, ')
          ..write('shouldIgnoreDigitalPoint: $shouldIgnoreDigitalPoint, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeTableTable extends MeTable with TableInfo<$MeTableTable, MeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
      'picture', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pictureHashMeta =
      const VerificationMeta('pictureHash');
  @override
  late final GeneratedColumn<String> pictureHash = GeneratedColumn<String>(
      'picture_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedMeta =
      const VerificationMeta('updated');
  @override
  late final GeneratedColumn<DateTime> updated = GeneratedColumn<DateTime>(
      'updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, cpf, phone, picture, pictureHash, updated];
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
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
    }
    if (data.containsKey('picture_hash')) {
      context.handle(
          _pictureHashMeta,
          pictureHash.isAcceptableOrUnknown(
              data['picture_hash']!, _pictureHashMeta));
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      picture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture']),
      pictureHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture_hash']),
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
  final String id;
  final String? name;
  final String? email;
  final String? cpf;
  final String? phone;
  final String? picture;
  final String? pictureHash;
  final DateTime updated;
  const MeData(
      {required this.id,
      this.name,
      this.email,
      this.cpf,
      this.phone,
      this.picture,
      this.pictureHash,
      required this.updated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || cpf != null) {
      map['cpf'] = Variable<String>(cpf);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String>(picture);
    }
    if (!nullToAbsent || pictureHash != null) {
      map['picture_hash'] = Variable<String>(pictureHash);
    }
    map['updated'] = Variable<DateTime>(updated);
    return map;
  }

  MeTableCompanion toCompanion(bool nullToAbsent) {
    return MeTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      cpf: cpf == null && nullToAbsent ? const Value.absent() : Value(cpf),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      picture: picture == null && nullToAbsent
          ? const Value.absent()
          : Value(picture),
      pictureHash: pictureHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pictureHash),
      updated: Value(updated),
    );
  }

  factory MeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      cpf: serializer.fromJson<String?>(json['cpf']),
      phone: serializer.fromJson<String?>(json['phone']),
      picture: serializer.fromJson<String?>(json['picture']),
      pictureHash: serializer.fromJson<String?>(json['pictureHash']),
      updated: serializer.fromJson<DateTime>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'cpf': serializer.toJson<String?>(cpf),
      'phone': serializer.toJson<String?>(phone),
      'picture': serializer.toJson<String?>(picture),
      'pictureHash': serializer.toJson<String?>(pictureHash),
      'updated': serializer.toJson<DateTime>(updated),
    };
  }

  MeData copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> cpf = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> picture = const Value.absent(),
          Value<String?> pictureHash = const Value.absent(),
          DateTime? updated}) =>
      MeData(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        email: email.present ? email.value : this.email,
        cpf: cpf.present ? cpf.value : this.cpf,
        phone: phone.present ? phone.value : this.phone,
        picture: picture.present ? picture.value : this.picture,
        pictureHash: pictureHash.present ? pictureHash.value : this.pictureHash,
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
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, cpf, phone, picture, pictureHash, updated);
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
          other.updated == this.updated);
}

class MeTableCompanion extends UpdateCompanion<MeData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> email;
  final Value<String?> cpf;
  final Value<String?> phone;
  final Value<String?> picture;
  final Value<String?> pictureHash;
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
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.cpf = const Value.absent(),
    this.phone = const Value.absent(),
    this.picture = const Value.absent(),
    this.pictureHash = const Value.absent(),
    required DateTime updated,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        updated = Value(updated);
  static Insertable<MeData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? cpf,
    Expression<String>? phone,
    Expression<String>? picture,
    Expression<String>? pictureHash,
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
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<String?>? email,
      Value<String?>? cpf,
      Value<String?>? phone,
      Value<String?>? picture,
      Value<String?>? pictureHash,
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
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeTableTable extends EmployeeTable
    with TableInfo<$EmployeeTableTable, EmployeeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
      'dob', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hiringDateMeta =
      const VerificationMeta('hiringDate');
  @override
  late final GeneratedColumn<DateTime> hiringDate = GeneratedColumn<DateTime>(
      'hiring_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phone2Meta = const VerificationMeta('phone2');
  @override
  late final GeneratedColumn<String> phone2 = GeneratedColumn<String>(
      'phone2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressNumberMeta =
      const VerificationMeta('addressNumber');
  @override
  late final GeneratedColumn<String> addressNumber = GeneratedColumn<String>(
      'address_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressComplementMeta =
      const VerificationMeta('addressComplement');
  @override
  late final GeneratedColumn<String> addressComplement =
      GeneratedColumn<String>('address_complement', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _salaryMeta = const VerificationMeta('salary');
  @override
  late final GeneratedColumn<double> salary = GeneratedColumn<double>(
      'salary', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _schoolingMeta =
      const VerificationMeta('schooling');
  @override
  late final GeneratedColumn<String> schooling = GeneratedColumn<String>(
      'schooling', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        condominiumId,
        id,
        name,
        dob,
        role,
        hiringDate,
        phone,
        phone2,
        address,
        addressNumber,
        addressComplement,
        salary,
        schooling,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_table';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeData> instance,
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('dob')) {
      context.handle(
          _dobMeta, dob.isAcceptableOrUnknown(data['dob']!, _dobMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('hiring_date')) {
      context.handle(
          _hiringDateMeta,
          hiringDate.isAcceptableOrUnknown(
              data['hiring_date']!, _hiringDateMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('phone2')) {
      context.handle(_phone2Meta,
          phone2.isAcceptableOrUnknown(data['phone2']!, _phone2Meta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('address_number')) {
      context.handle(
          _addressNumberMeta,
          addressNumber.isAcceptableOrUnknown(
              data['address_number']!, _addressNumberMeta));
    }
    if (data.containsKey('address_complement')) {
      context.handle(
          _addressComplementMeta,
          addressComplement.isAcceptableOrUnknown(
              data['address_complement']!, _addressComplementMeta));
    }
    if (data.containsKey('salary')) {
      context.handle(_salaryMeta,
          salary.isAcceptableOrUnknown(data['salary']!, _salaryMeta));
    }
    if (data.containsKey('schooling')) {
      context.handle(_schoolingMeta,
          schooling.isAcceptableOrUnknown(data['schooling']!, _schoolingMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, id};
  @override
  EmployeeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      dob: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dob']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role']),
      hiringDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}hiring_date']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      phone2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone2']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      addressNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address_number']),
      addressComplement: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}address_complement']),
      salary: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}salary']),
      schooling: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schooling']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
    );
  }

  @override
  $EmployeeTableTable createAlias(String alias) {
    return $EmployeeTableTable(attachedDatabase, alias);
  }
}

class EmployeeData extends DataClass implements Insertable<EmployeeData> {
  final String condominiumId;
  final String id;
  final String? name;
  final DateTime? dob;
  final String? role;
  final DateTime? hiringDate;
  final String? phone;
  final String? phone2;
  final String? address;
  final String? addressNumber;
  final String? addressComplement;
  final double? salary;
  final String? schooling;
  final String? status;
  const EmployeeData(
      {required this.condominiumId,
      required this.id,
      this.name,
      this.dob,
      this.role,
      this.hiringDate,
      this.phone,
      this.phone2,
      this.address,
      this.addressNumber,
      this.addressComplement,
      this.salary,
      this.schooling,
      this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<DateTime>(dob);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || hiringDate != null) {
      map['hiring_date'] = Variable<DateTime>(hiringDate);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || phone2 != null) {
      map['phone2'] = Variable<String>(phone2);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || addressNumber != null) {
      map['address_number'] = Variable<String>(addressNumber);
    }
    if (!nullToAbsent || addressComplement != null) {
      map['address_complement'] = Variable<String>(addressComplement);
    }
    if (!nullToAbsent || salary != null) {
      map['salary'] = Variable<double>(salary);
    }
    if (!nullToAbsent || schooling != null) {
      map['schooling'] = Variable<String>(schooling);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    return map;
  }

  EmployeeTableCompanion toCompanion(bool nullToAbsent) {
    return EmployeeTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      hiringDate: hiringDate == null && nullToAbsent
          ? const Value.absent()
          : Value(hiringDate),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      phone2:
          phone2 == null && nullToAbsent ? const Value.absent() : Value(phone2),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      addressNumber: addressNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(addressNumber),
      addressComplement: addressComplement == null && nullToAbsent
          ? const Value.absent()
          : Value(addressComplement),
      salary:
          salary == null && nullToAbsent ? const Value.absent() : Value(salary),
      schooling: schooling == null && nullToAbsent
          ? const Value.absent()
          : Value(schooling),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory EmployeeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      dob: serializer.fromJson<DateTime?>(json['dob']),
      role: serializer.fromJson<String?>(json['role']),
      hiringDate: serializer.fromJson<DateTime?>(json['hiringDate']),
      phone: serializer.fromJson<String?>(json['phone']),
      phone2: serializer.fromJson<String?>(json['phone2']),
      address: serializer.fromJson<String?>(json['address']),
      addressNumber: serializer.fromJson<String?>(json['addressNumber']),
      addressComplement:
          serializer.fromJson<String?>(json['addressComplement']),
      salary: serializer.fromJson<double?>(json['salary']),
      schooling: serializer.fromJson<String?>(json['schooling']),
      status: serializer.fromJson<String?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'dob': serializer.toJson<DateTime?>(dob),
      'role': serializer.toJson<String?>(role),
      'hiringDate': serializer.toJson<DateTime?>(hiringDate),
      'phone': serializer.toJson<String?>(phone),
      'phone2': serializer.toJson<String?>(phone2),
      'address': serializer.toJson<String?>(address),
      'addressNumber': serializer.toJson<String?>(addressNumber),
      'addressComplement': serializer.toJson<String?>(addressComplement),
      'salary': serializer.toJson<double?>(salary),
      'schooling': serializer.toJson<String?>(schooling),
      'status': serializer.toJson<String?>(status),
    };
  }

  EmployeeData copyWith(
          {String? condominiumId,
          String? id,
          Value<String?> name = const Value.absent(),
          Value<DateTime?> dob = const Value.absent(),
          Value<String?> role = const Value.absent(),
          Value<DateTime?> hiringDate = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> phone2 = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> addressNumber = const Value.absent(),
          Value<String?> addressComplement = const Value.absent(),
          Value<double?> salary = const Value.absent(),
          Value<String?> schooling = const Value.absent(),
          Value<String?> status = const Value.absent()}) =>
      EmployeeData(
        condominiumId: condominiumId ?? this.condominiumId,
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        dob: dob.present ? dob.value : this.dob,
        role: role.present ? role.value : this.role,
        hiringDate: hiringDate.present ? hiringDate.value : this.hiringDate,
        phone: phone.present ? phone.value : this.phone,
        phone2: phone2.present ? phone2.value : this.phone2,
        address: address.present ? address.value : this.address,
        addressNumber:
            addressNumber.present ? addressNumber.value : this.addressNumber,
        addressComplement: addressComplement.present
            ? addressComplement.value
            : this.addressComplement,
        salary: salary.present ? salary.value : this.salary,
        schooling: schooling.present ? schooling.value : this.schooling,
        status: status.present ? status.value : this.status,
      );
  EmployeeData copyWithCompanion(EmployeeTableCompanion data) {
    return EmployeeData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dob: data.dob.present ? data.dob.value : this.dob,
      role: data.role.present ? data.role.value : this.role,
      hiringDate:
          data.hiringDate.present ? data.hiringDate.value : this.hiringDate,
      phone: data.phone.present ? data.phone.value : this.phone,
      phone2: data.phone2.present ? data.phone2.value : this.phone2,
      address: data.address.present ? data.address.value : this.address,
      addressNumber: data.addressNumber.present
          ? data.addressNumber.value
          : this.addressNumber,
      addressComplement: data.addressComplement.present
          ? data.addressComplement.value
          : this.addressComplement,
      salary: data.salary.present ? data.salary.value : this.salary,
      schooling: data.schooling.present ? data.schooling.value : this.schooling,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dob: $dob, ')
          ..write('role: $role, ')
          ..write('hiringDate: $hiringDate, ')
          ..write('phone: $phone, ')
          ..write('phone2: $phone2, ')
          ..write('address: $address, ')
          ..write('addressNumber: $addressNumber, ')
          ..write('addressComplement: $addressComplement, ')
          ..write('salary: $salary, ')
          ..write('schooling: $schooling, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      condominiumId,
      id,
      name,
      dob,
      role,
      hiringDate,
      phone,
      phone2,
      address,
      addressNumber,
      addressComplement,
      salary,
      schooling,
      status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeData &&
          other.condominiumId == this.condominiumId &&
          other.id == this.id &&
          other.name == this.name &&
          other.dob == this.dob &&
          other.role == this.role &&
          other.hiringDate == this.hiringDate &&
          other.phone == this.phone &&
          other.phone2 == this.phone2 &&
          other.address == this.address &&
          other.addressNumber == this.addressNumber &&
          other.addressComplement == this.addressComplement &&
          other.salary == this.salary &&
          other.schooling == this.schooling &&
          other.status == this.status);
}

class EmployeeTableCompanion extends UpdateCompanion<EmployeeData> {
  final Value<String> condominiumId;
  final Value<String> id;
  final Value<String?> name;
  final Value<DateTime?> dob;
  final Value<String?> role;
  final Value<DateTime?> hiringDate;
  final Value<String?> phone;
  final Value<String?> phone2;
  final Value<String?> address;
  final Value<String?> addressNumber;
  final Value<String?> addressComplement;
  final Value<double?> salary;
  final Value<String?> schooling;
  final Value<String?> status;
  final Value<int> rowid;
  const EmployeeTableCompanion({
    this.condominiumId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dob = const Value.absent(),
    this.role = const Value.absent(),
    this.hiringDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.phone2 = const Value.absent(),
    this.address = const Value.absent(),
    this.addressNumber = const Value.absent(),
    this.addressComplement = const Value.absent(),
    this.salary = const Value.absent(),
    this.schooling = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeTableCompanion.insert({
    required String condominiumId,
    required String id,
    this.name = const Value.absent(),
    this.dob = const Value.absent(),
    this.role = const Value.absent(),
    this.hiringDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.phone2 = const Value.absent(),
    this.address = const Value.absent(),
    this.addressNumber = const Value.absent(),
    this.addressComplement = const Value.absent(),
    this.salary = const Value.absent(),
    this.schooling = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        id = Value(id);
  static Insertable<EmployeeData> custom({
    Expression<String>? condominiumId,
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? dob,
    Expression<String>? role,
    Expression<DateTime>? hiringDate,
    Expression<String>? phone,
    Expression<String>? phone2,
    Expression<String>? address,
    Expression<String>? addressNumber,
    Expression<String>? addressComplement,
    Expression<double>? salary,
    Expression<String>? schooling,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dob != null) 'dob': dob,
      if (role != null) 'role': role,
      if (hiringDate != null) 'hiring_date': hiringDate,
      if (phone != null) 'phone': phone,
      if (phone2 != null) 'phone2': phone2,
      if (address != null) 'address': address,
      if (addressNumber != null) 'address_number': addressNumber,
      if (addressComplement != null) 'address_complement': addressComplement,
      if (salary != null) 'salary': salary,
      if (schooling != null) 'schooling': schooling,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<String>? id,
      Value<String?>? name,
      Value<DateTime?>? dob,
      Value<String?>? role,
      Value<DateTime?>? hiringDate,
      Value<String?>? phone,
      Value<String?>? phone2,
      Value<String?>? address,
      Value<String?>? addressNumber,
      Value<String?>? addressComplement,
      Value<double?>? salary,
      Value<String?>? schooling,
      Value<String?>? status,
      Value<int>? rowid}) {
    return EmployeeTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      id: id ?? this.id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      role: role ?? this.role,
      hiringDate: hiringDate ?? this.hiringDate,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      addressNumber: addressNumber ?? this.addressNumber,
      addressComplement: addressComplement ?? this.addressComplement,
      salary: salary ?? this.salary,
      schooling: schooling ?? this.schooling,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (hiringDate.present) {
      map['hiring_date'] = Variable<DateTime>(hiringDate.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (phone2.present) {
      map['phone2'] = Variable<String>(phone2.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (addressNumber.present) {
      map['address_number'] = Variable<String>(addressNumber.value);
    }
    if (addressComplement.present) {
      map['address_complement'] = Variable<String>(addressComplement.value);
    }
    if (salary.present) {
      map['salary'] = Variable<double>(salary.value);
    }
    if (schooling.present) {
      map['schooling'] = Variable<String>(schooling.value);
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
    return (StringBuffer('EmployeeTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dob: $dob, ')
          ..write('role: $role, ')
          ..write('hiringDate: $hiringDate, ')
          ..write('phone: $phone, ')
          ..write('phone2: $phone2, ')
          ..write('address: $address, ')
          ..write('addressNumber: $addressNumber, ')
          ..write('addressComplement: $addressComplement, ')
          ..write('salary: $salary, ')
          ..write('schooling: $schooling, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CondominiumEmployeeScheduleTableTable
    extends CondominiumEmployeeScheduleTable
    with
        TableInfo<$CondominiumEmployeeScheduleTableTable,
            CondominiumEmployeeScheduleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CondominiumEmployeeScheduleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _badageNumberMeta =
      const VerificationMeta('badageNumber');
  @override
  late final GeneratedColumn<String> badageNumber = GeneratedColumn<String>(
      'badage_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entry1Meta = const VerificationMeta('entry1');
  @override
  late final GeneratedColumn<String> entry1 = GeneratedColumn<String>(
      'entry1', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _out1Meta = const VerificationMeta('out1');
  @override
  late final GeneratedColumn<String> out1 = GeneratedColumn<String>(
      'out1', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entry2Meta = const VerificationMeta('entry2');
  @override
  late final GeneratedColumn<String> entry2 = GeneratedColumn<String>(
      'entry2', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _out2Meta = const VerificationMeta('out2');
  @override
  late final GeneratedColumn<String> out2 = GeneratedColumn<String>(
      'out2', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDayOffMeta =
      const VerificationMeta('isDayOff');
  @override
  late final GeneratedColumn<bool> isDayOff = GeneratedColumn<bool>(
      'is_day_off', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_day_off" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [reference, date, badageNumber, entry1, out1, entry2, out2, isDayOff];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condominium_employee_schedule_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CondominiumEmployeeScheduleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('badage_number')) {
      context.handle(
          _badageNumberMeta,
          badageNumber.isAcceptableOrUnknown(
              data['badage_number']!, _badageNumberMeta));
    } else if (isInserting) {
      context.missing(_badageNumberMeta);
    }
    if (data.containsKey('entry1')) {
      context.handle(_entry1Meta,
          entry1.isAcceptableOrUnknown(data['entry1']!, _entry1Meta));
    } else if (isInserting) {
      context.missing(_entry1Meta);
    }
    if (data.containsKey('out1')) {
      context.handle(
          _out1Meta, out1.isAcceptableOrUnknown(data['out1']!, _out1Meta));
    } else if (isInserting) {
      context.missing(_out1Meta);
    }
    if (data.containsKey('entry2')) {
      context.handle(_entry2Meta,
          entry2.isAcceptableOrUnknown(data['entry2']!, _entry2Meta));
    } else if (isInserting) {
      context.missing(_entry2Meta);
    }
    if (data.containsKey('out2')) {
      context.handle(
          _out2Meta, out2.isAcceptableOrUnknown(data['out2']!, _out2Meta));
    } else if (isInserting) {
      context.missing(_out2Meta);
    }
    if (data.containsKey('is_day_off')) {
      context.handle(_isDayOffMeta,
          isDayOff.isAcceptableOrUnknown(data['is_day_off']!, _isDayOffMeta));
    } else if (isInserting) {
      context.missing(_isDayOffMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {reference, date};
  @override
  CondominiumEmployeeScheduleData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CondominiumEmployeeScheduleData(
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      badageNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}badage_number'])!,
      entry1: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry1'])!,
      out1: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}out1'])!,
      entry2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry2'])!,
      out2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}out2'])!,
      isDayOff: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_day_off'])!,
    );
  }

  @override
  $CondominiumEmployeeScheduleTableTable createAlias(String alias) {
    return $CondominiumEmployeeScheduleTableTable(attachedDatabase, alias);
  }
}

class CondominiumEmployeeScheduleData extends DataClass
    implements Insertable<CondominiumEmployeeScheduleData> {
  final String reference;
  final DateTime date;
  final String badageNumber;
  final String entry1;
  final String out1;
  final String entry2;
  final String out2;
  final bool isDayOff;
  const CondominiumEmployeeScheduleData(
      {required this.reference,
      required this.date,
      required this.badageNumber,
      required this.entry1,
      required this.out1,
      required this.entry2,
      required this.out2,
      required this.isDayOff});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reference'] = Variable<String>(reference);
    map['date'] = Variable<DateTime>(date);
    map['badage_number'] = Variable<String>(badageNumber);
    map['entry1'] = Variable<String>(entry1);
    map['out1'] = Variable<String>(out1);
    map['entry2'] = Variable<String>(entry2);
    map['out2'] = Variable<String>(out2);
    map['is_day_off'] = Variable<bool>(isDayOff);
    return map;
  }

  CondominiumEmployeeScheduleTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumEmployeeScheduleTableCompanion(
      reference: Value(reference),
      date: Value(date),
      badageNumber: Value(badageNumber),
      entry1: Value(entry1),
      out1: Value(out1),
      entry2: Value(entry2),
      out2: Value(out2),
      isDayOff: Value(isDayOff),
    );
  }

  factory CondominiumEmployeeScheduleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumEmployeeScheduleData(
      reference: serializer.fromJson<String>(json['reference']),
      date: serializer.fromJson<DateTime>(json['date']),
      badageNumber: serializer.fromJson<String>(json['badageNumber']),
      entry1: serializer.fromJson<String>(json['entry1']),
      out1: serializer.fromJson<String>(json['out1']),
      entry2: serializer.fromJson<String>(json['entry2']),
      out2: serializer.fromJson<String>(json['out2']),
      isDayOff: serializer.fromJson<bool>(json['isDayOff']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reference': serializer.toJson<String>(reference),
      'date': serializer.toJson<DateTime>(date),
      'badageNumber': serializer.toJson<String>(badageNumber),
      'entry1': serializer.toJson<String>(entry1),
      'out1': serializer.toJson<String>(out1),
      'entry2': serializer.toJson<String>(entry2),
      'out2': serializer.toJson<String>(out2),
      'isDayOff': serializer.toJson<bool>(isDayOff),
    };
  }

  CondominiumEmployeeScheduleData copyWith(
          {String? reference,
          DateTime? date,
          String? badageNumber,
          String? entry1,
          String? out1,
          String? entry2,
          String? out2,
          bool? isDayOff}) =>
      CondominiumEmployeeScheduleData(
        reference: reference ?? this.reference,
        date: date ?? this.date,
        badageNumber: badageNumber ?? this.badageNumber,
        entry1: entry1 ?? this.entry1,
        out1: out1 ?? this.out1,
        entry2: entry2 ?? this.entry2,
        out2: out2 ?? this.out2,
        isDayOff: isDayOff ?? this.isDayOff,
      );
  CondominiumEmployeeScheduleData copyWithCompanion(
      CondominiumEmployeeScheduleTableCompanion data) {
    return CondominiumEmployeeScheduleData(
      reference: data.reference.present ? data.reference.value : this.reference,
      date: data.date.present ? data.date.value : this.date,
      badageNumber: data.badageNumber.present
          ? data.badageNumber.value
          : this.badageNumber,
      entry1: data.entry1.present ? data.entry1.value : this.entry1,
      out1: data.out1.present ? data.out1.value : this.out1,
      entry2: data.entry2.present ? data.entry2.value : this.entry2,
      out2: data.out2.present ? data.out2.value : this.out2,
      isDayOff: data.isDayOff.present ? data.isDayOff.value : this.isDayOff,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumEmployeeScheduleData(')
          ..write('reference: $reference, ')
          ..write('date: $date, ')
          ..write('badageNumber: $badageNumber, ')
          ..write('entry1: $entry1, ')
          ..write('out1: $out1, ')
          ..write('entry2: $entry2, ')
          ..write('out2: $out2, ')
          ..write('isDayOff: $isDayOff')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      reference, date, badageNumber, entry1, out1, entry2, out2, isDayOff);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumEmployeeScheduleData &&
          other.reference == this.reference &&
          other.date == this.date &&
          other.badageNumber == this.badageNumber &&
          other.entry1 == this.entry1 &&
          other.out1 == this.out1 &&
          other.entry2 == this.entry2 &&
          other.out2 == this.out2 &&
          other.isDayOff == this.isDayOff);
}

class CondominiumEmployeeScheduleTableCompanion
    extends UpdateCompanion<CondominiumEmployeeScheduleData> {
  final Value<String> reference;
  final Value<DateTime> date;
  final Value<String> badageNumber;
  final Value<String> entry1;
  final Value<String> out1;
  final Value<String> entry2;
  final Value<String> out2;
  final Value<bool> isDayOff;
  final Value<int> rowid;
  const CondominiumEmployeeScheduleTableCompanion({
    this.reference = const Value.absent(),
    this.date = const Value.absent(),
    this.badageNumber = const Value.absent(),
    this.entry1 = const Value.absent(),
    this.out1 = const Value.absent(),
    this.entry2 = const Value.absent(),
    this.out2 = const Value.absent(),
    this.isDayOff = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumEmployeeScheduleTableCompanion.insert({
    required String reference,
    required DateTime date,
    required String badageNumber,
    required String entry1,
    required String out1,
    required String entry2,
    required String out2,
    required bool isDayOff,
    this.rowid = const Value.absent(),
  })  : reference = Value(reference),
        date = Value(date),
        badageNumber = Value(badageNumber),
        entry1 = Value(entry1),
        out1 = Value(out1),
        entry2 = Value(entry2),
        out2 = Value(out2),
        isDayOff = Value(isDayOff);
  static Insertable<CondominiumEmployeeScheduleData> custom({
    Expression<String>? reference,
    Expression<DateTime>? date,
    Expression<String>? badageNumber,
    Expression<String>? entry1,
    Expression<String>? out1,
    Expression<String>? entry2,
    Expression<String>? out2,
    Expression<bool>? isDayOff,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reference != null) 'reference': reference,
      if (date != null) 'date': date,
      if (badageNumber != null) 'badage_number': badageNumber,
      if (entry1 != null) 'entry1': entry1,
      if (out1 != null) 'out1': out1,
      if (entry2 != null) 'entry2': entry2,
      if (out2 != null) 'out2': out2,
      if (isDayOff != null) 'is_day_off': isDayOff,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumEmployeeScheduleTableCompanion copyWith(
      {Value<String>? reference,
      Value<DateTime>? date,
      Value<String>? badageNumber,
      Value<String>? entry1,
      Value<String>? out1,
      Value<String>? entry2,
      Value<String>? out2,
      Value<bool>? isDayOff,
      Value<int>? rowid}) {
    return CondominiumEmployeeScheduleTableCompanion(
      reference: reference ?? this.reference,
      date: date ?? this.date,
      badageNumber: badageNumber ?? this.badageNumber,
      entry1: entry1 ?? this.entry1,
      out1: out1 ?? this.out1,
      entry2: entry2 ?? this.entry2,
      out2: out2 ?? this.out2,
      isDayOff: isDayOff ?? this.isDayOff,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (badageNumber.present) {
      map['badage_number'] = Variable<String>(badageNumber.value);
    }
    if (entry1.present) {
      map['entry1'] = Variable<String>(entry1.value);
    }
    if (out1.present) {
      map['out1'] = Variable<String>(out1.value);
    }
    if (entry2.present) {
      map['entry2'] = Variable<String>(entry2.value);
    }
    if (out2.present) {
      map['out2'] = Variable<String>(out2.value);
    }
    if (isDayOff.present) {
      map['is_day_off'] = Variable<bool>(isDayOff.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumEmployeeScheduleTableCompanion(')
          ..write('reference: $reference, ')
          ..write('date: $date, ')
          ..write('badageNumber: $badageNumber, ')
          ..write('entry1: $entry1, ')
          ..write('out1: $out1, ')
          ..write('entry2: $entry2, ')
          ..write('out2: $out2, ')
          ..write('isDayOff: $isDayOff, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LelloDatabase extends GeneratedDatabase {
  _$LelloDatabase(QueryExecutor e) : super(e);
  $LelloDatabaseManager get managers => $LelloDatabaseManager(this);
  late final $CondominiumTableTable condominiumTable =
      $CondominiumTableTable(this);
  late final $MeTableTable meTable = $MeTableTable(this);
  late final $EmployeeTableTable employeeTable = $EmployeeTableTable(this);
  late final $CondominiumEmployeeScheduleTableTable
      condominiumEmployeeScheduleTable =
      $CondominiumEmployeeScheduleTableTable(this);
  late final CondominiumDao condominiumDao =
      CondominiumDao(this as LelloDatabase);
  late final MeDao meDao = MeDao(this as LelloDatabase);
  late final EmployeeDao employeeDao = EmployeeDao(this as LelloDatabase);
  late final CondominiumEmployeeScheduleDao condominiumEmployeeScheduleDao =
      CondominiumEmployeeScheduleDao(this as LelloDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        condominiumTable,
        meTable,
        employeeTable,
        condominiumEmployeeScheduleTable
      ];
}

typedef $$CondominiumTableTableCreateCompanionBuilder
    = CondominiumTableCompanion Function({
  required String id,
  required String meId,
  required String reference,
  Value<String?> name,
  Value<String?> jobPosition,
  Value<String?> workShift,
  Value<String?> digitalTimesheetStatus,
  Value<bool?> usesDigitalTimesheet,
  Value<String?> workLeaveDescription,
  Value<bool?> shouldIgnoreDigitalPoint,
  Value<String?> latitude,
  Value<String?> longitude,
  Value<int> rowid,
});
typedef $$CondominiumTableTableUpdateCompanionBuilder
    = CondominiumTableCompanion Function({
  Value<String> id,
  Value<String> meId,
  Value<String> reference,
  Value<String?> name,
  Value<String?> jobPosition,
  Value<String?> workShift,
  Value<String?> digitalTimesheetStatus,
  Value<bool?> usesDigitalTimesheet,
  Value<String?> workLeaveDescription,
  Value<bool?> shouldIgnoreDigitalPoint,
  Value<String?> latitude,
  Value<String?> longitude,
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

  ColumnFilters<String> get meId => $composableBuilder(
      column: $table.meId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobPosition => $composableBuilder(
      column: $table.jobPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workShift => $composableBuilder(
      column: $table.workShift, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get digitalTimesheetStatus => $composableBuilder(
      column: $table.digitalTimesheetStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get usesDigitalTimesheet => $composableBuilder(
      column: $table.usesDigitalTimesheet,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workLeaveDescription => $composableBuilder(
      column: $table.workLeaveDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get shouldIgnoreDigitalPoint => $composableBuilder(
      column: $table.shouldIgnoreDigitalPoint,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get meId => $composableBuilder(
      column: $table.meId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobPosition => $composableBuilder(
      column: $table.jobPosition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workShift => $composableBuilder(
      column: $table.workShift, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get digitalTimesheetStatus => $composableBuilder(
      column: $table.digitalTimesheetStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get usesDigitalTimesheet => $composableBuilder(
      column: $table.usesDigitalTimesheet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workLeaveDescription => $composableBuilder(
      column: $table.workLeaveDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get shouldIgnoreDigitalPoint => $composableBuilder(
      column: $table.shouldIgnoreDigitalPoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get meId =>
      $composableBuilder(column: $table.meId, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get jobPosition => $composableBuilder(
      column: $table.jobPosition, builder: (column) => column);

  GeneratedColumn<String> get workShift =>
      $composableBuilder(column: $table.workShift, builder: (column) => column);

  GeneratedColumn<String> get digitalTimesheetStatus => $composableBuilder(
      column: $table.digitalTimesheetStatus, builder: (column) => column);

  GeneratedColumn<bool> get usesDigitalTimesheet => $composableBuilder(
      column: $table.usesDigitalTimesheet, builder: (column) => column);

  GeneratedColumn<String> get workLeaveDescription => $composableBuilder(
      column: $table.workLeaveDescription, builder: (column) => column);

  GeneratedColumn<bool> get shouldIgnoreDigitalPoint => $composableBuilder(
      column: $table.shouldIgnoreDigitalPoint, builder: (column) => column);

  GeneratedColumn<String> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<String> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
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
            Value<String> meId = const Value.absent(),
            Value<String> reference = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> jobPosition = const Value.absent(),
            Value<String?> workShift = const Value.absent(),
            Value<String?> digitalTimesheetStatus = const Value.absent(),
            Value<bool?> usesDigitalTimesheet = const Value.absent(),
            Value<String?> workLeaveDescription = const Value.absent(),
            Value<bool?> shouldIgnoreDigitalPoint = const Value.absent(),
            Value<String?> latitude = const Value.absent(),
            Value<String?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumTableCompanion(
            id: id,
            meId: meId,
            reference: reference,
            name: name,
            jobPosition: jobPosition,
            workShift: workShift,
            digitalTimesheetStatus: digitalTimesheetStatus,
            usesDigitalTimesheet: usesDigitalTimesheet,
            workLeaveDescription: workLeaveDescription,
            shouldIgnoreDigitalPoint: shouldIgnoreDigitalPoint,
            latitude: latitude,
            longitude: longitude,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String meId,
            required String reference,
            Value<String?> name = const Value.absent(),
            Value<String?> jobPosition = const Value.absent(),
            Value<String?> workShift = const Value.absent(),
            Value<String?> digitalTimesheetStatus = const Value.absent(),
            Value<bool?> usesDigitalTimesheet = const Value.absent(),
            Value<String?> workLeaveDescription = const Value.absent(),
            Value<bool?> shouldIgnoreDigitalPoint = const Value.absent(),
            Value<String?> latitude = const Value.absent(),
            Value<String?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumTableCompanion.insert(
            id: id,
            meId: meId,
            reference: reference,
            name: name,
            jobPosition: jobPosition,
            workShift: workShift,
            digitalTimesheetStatus: digitalTimesheetStatus,
            usesDigitalTimesheet: usesDigitalTimesheet,
            workLeaveDescription: workLeaveDescription,
            shouldIgnoreDigitalPoint: shouldIgnoreDigitalPoint,
            latitude: latitude,
            longitude: longitude,
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
typedef $$MeTableTableCreateCompanionBuilder = MeTableCompanion Function({
  required String id,
  Value<String?> name,
  Value<String?> email,
  Value<String?> cpf,
  Value<String?> phone,
  Value<String?> picture,
  Value<String?> pictureHash,
  required DateTime updated,
  Value<int> rowid,
});
typedef $$MeTableTableUpdateCompanionBuilder = MeTableCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<String?> email,
  Value<String?> cpf,
  Value<String?> phone,
  Value<String?> picture,
  Value<String?> pictureHash,
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
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> cpf = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> picture = const Value.absent(),
            Value<String?> pictureHash = const Value.absent(),
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
            updated: updated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> cpf = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> picture = const Value.absent(),
            Value<String?> pictureHash = const Value.absent(),
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
typedef $$EmployeeTableTableCreateCompanionBuilder = EmployeeTableCompanion
    Function({
  required String condominiumId,
  required String id,
  Value<String?> name,
  Value<DateTime?> dob,
  Value<String?> role,
  Value<DateTime?> hiringDate,
  Value<String?> phone,
  Value<String?> phone2,
  Value<String?> address,
  Value<String?> addressNumber,
  Value<String?> addressComplement,
  Value<double?> salary,
  Value<String?> schooling,
  Value<String?> status,
  Value<int> rowid,
});
typedef $$EmployeeTableTableUpdateCompanionBuilder = EmployeeTableCompanion
    Function({
  Value<String> condominiumId,
  Value<String> id,
  Value<String?> name,
  Value<DateTime?> dob,
  Value<String?> role,
  Value<DateTime?> hiringDate,
  Value<String?> phone,
  Value<String?> phone2,
  Value<String?> address,
  Value<String?> addressNumber,
  Value<String?> addressComplement,
  Value<double?> salary,
  Value<String?> schooling,
  Value<String?> status,
  Value<int> rowid,
});

class $$EmployeeTableTableFilterComposer
    extends Composer<_$LelloDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get hiringDate => $composableBuilder(
      column: $table.hiringDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone2 => $composableBuilder(
      column: $table.phone2, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addressNumber => $composableBuilder(
      column: $table.addressNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addressComplement => $composableBuilder(
      column: $table.addressComplement,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salary => $composableBuilder(
      column: $table.salary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get schooling => $composableBuilder(
      column: $table.schooling, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$EmployeeTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get hiringDate => $composableBuilder(
      column: $table.hiringDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone2 => $composableBuilder(
      column: $table.phone2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addressNumber => $composableBuilder(
      column: $table.addressNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addressComplement => $composableBuilder(
      column: $table.addressComplement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salary => $composableBuilder(
      column: $table.salary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get schooling => $composableBuilder(
      column: $table.schooling, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get hiringDate => $composableBuilder(
      column: $table.hiringDate, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get phone2 =>
      $composableBuilder(column: $table.phone2, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get addressNumber => $composableBuilder(
      column: $table.addressNumber, builder: (column) => column);

  GeneratedColumn<String> get addressComplement => $composableBuilder(
      column: $table.addressComplement, builder: (column) => column);

  GeneratedColumn<double> get salary =>
      $composableBuilder(column: $table.salary, builder: (column) => column);

  GeneratedColumn<String> get schooling =>
      $composableBuilder(column: $table.schooling, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$EmployeeTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $EmployeeTableTable,
    EmployeeData,
    $$EmployeeTableTableFilterComposer,
    $$EmployeeTableTableOrderingComposer,
    $$EmployeeTableTableAnnotationComposer,
    $$EmployeeTableTableCreateCompanionBuilder,
    $$EmployeeTableTableUpdateCompanionBuilder,
    (
      EmployeeData,
      BaseReferences<_$LelloDatabase, $EmployeeTableTable, EmployeeData>
    ),
    EmployeeData,
    PrefetchHooks Function()> {
  $$EmployeeTableTableTableManager(
      _$LelloDatabase db, $EmployeeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<DateTime?> dob = const Value.absent(),
            Value<String?> role = const Value.absent(),
            Value<DateTime?> hiringDate = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> phone2 = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> addressNumber = const Value.absent(),
            Value<String?> addressComplement = const Value.absent(),
            Value<double?> salary = const Value.absent(),
            Value<String?> schooling = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeTableCompanion(
            condominiumId: condominiumId,
            id: id,
            name: name,
            dob: dob,
            role: role,
            hiringDate: hiringDate,
            phone: phone,
            phone2: phone2,
            address: address,
            addressNumber: addressNumber,
            addressComplement: addressComplement,
            salary: salary,
            schooling: schooling,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required String id,
            Value<String?> name = const Value.absent(),
            Value<DateTime?> dob = const Value.absent(),
            Value<String?> role = const Value.absent(),
            Value<DateTime?> hiringDate = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> phone2 = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> addressNumber = const Value.absent(),
            Value<String?> addressComplement = const Value.absent(),
            Value<double?> salary = const Value.absent(),
            Value<String?> schooling = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeTableCompanion.insert(
            condominiumId: condominiumId,
            id: id,
            name: name,
            dob: dob,
            role: role,
            hiringDate: hiringDate,
            phone: phone,
            phone2: phone2,
            address: address,
            addressNumber: addressNumber,
            addressComplement: addressComplement,
            salary: salary,
            schooling: schooling,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $EmployeeTableTable,
    EmployeeData,
    $$EmployeeTableTableFilterComposer,
    $$EmployeeTableTableOrderingComposer,
    $$EmployeeTableTableAnnotationComposer,
    $$EmployeeTableTableCreateCompanionBuilder,
    $$EmployeeTableTableUpdateCompanionBuilder,
    (
      EmployeeData,
      BaseReferences<_$LelloDatabase, $EmployeeTableTable, EmployeeData>
    ),
    EmployeeData,
    PrefetchHooks Function()>;
typedef $$CondominiumEmployeeScheduleTableTableCreateCompanionBuilder
    = CondominiumEmployeeScheduleTableCompanion Function({
  required String reference,
  required DateTime date,
  required String badageNumber,
  required String entry1,
  required String out1,
  required String entry2,
  required String out2,
  required bool isDayOff,
  Value<int> rowid,
});
typedef $$CondominiumEmployeeScheduleTableTableUpdateCompanionBuilder
    = CondominiumEmployeeScheduleTableCompanion Function({
  Value<String> reference,
  Value<DateTime> date,
  Value<String> badageNumber,
  Value<String> entry1,
  Value<String> out1,
  Value<String> entry2,
  Value<String> out2,
  Value<bool> isDayOff,
  Value<int> rowid,
});

class $$CondominiumEmployeeScheduleTableTableFilterComposer
    extends Composer<_$LelloDatabase, $CondominiumEmployeeScheduleTableTable> {
  $$CondominiumEmployeeScheduleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get badageNumber => $composableBuilder(
      column: $table.badageNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entry1 => $composableBuilder(
      column: $table.entry1, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get out1 => $composableBuilder(
      column: $table.out1, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entry2 => $composableBuilder(
      column: $table.entry2, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get out2 => $composableBuilder(
      column: $table.out2, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDayOff => $composableBuilder(
      column: $table.isDayOff, builder: (column) => ColumnFilters(column));
}

class $$CondominiumEmployeeScheduleTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $CondominiumEmployeeScheduleTableTable> {
  $$CondominiumEmployeeScheduleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get badageNumber => $composableBuilder(
      column: $table.badageNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entry1 => $composableBuilder(
      column: $table.entry1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get out1 => $composableBuilder(
      column: $table.out1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entry2 => $composableBuilder(
      column: $table.entry2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get out2 => $composableBuilder(
      column: $table.out2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDayOff => $composableBuilder(
      column: $table.isDayOff, builder: (column) => ColumnOrderings(column));
}

class $$CondominiumEmployeeScheduleTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $CondominiumEmployeeScheduleTableTable> {
  $$CondominiumEmployeeScheduleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get badageNumber => $composableBuilder(
      column: $table.badageNumber, builder: (column) => column);

  GeneratedColumn<String> get entry1 =>
      $composableBuilder(column: $table.entry1, builder: (column) => column);

  GeneratedColumn<String> get out1 =>
      $composableBuilder(column: $table.out1, builder: (column) => column);

  GeneratedColumn<String> get entry2 =>
      $composableBuilder(column: $table.entry2, builder: (column) => column);

  GeneratedColumn<String> get out2 =>
      $composableBuilder(column: $table.out2, builder: (column) => column);

  GeneratedColumn<bool> get isDayOff =>
      $composableBuilder(column: $table.isDayOff, builder: (column) => column);
}

class $$CondominiumEmployeeScheduleTableTableTableManager
    extends RootTableManager<
        _$LelloDatabase,
        $CondominiumEmployeeScheduleTableTable,
        CondominiumEmployeeScheduleData,
        $$CondominiumEmployeeScheduleTableTableFilterComposer,
        $$CondominiumEmployeeScheduleTableTableOrderingComposer,
        $$CondominiumEmployeeScheduleTableTableAnnotationComposer,
        $$CondominiumEmployeeScheduleTableTableCreateCompanionBuilder,
        $$CondominiumEmployeeScheduleTableTableUpdateCompanionBuilder,
        (
          CondominiumEmployeeScheduleData,
          BaseReferences<
              _$LelloDatabase,
              $CondominiumEmployeeScheduleTableTable,
              CondominiumEmployeeScheduleData>
        ),
        CondominiumEmployeeScheduleData,
        PrefetchHooks Function()> {
  $$CondominiumEmployeeScheduleTableTableTableManager(
      _$LelloDatabase db, $CondominiumEmployeeScheduleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CondominiumEmployeeScheduleTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CondominiumEmployeeScheduleTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CondominiumEmployeeScheduleTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> reference = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> badageNumber = const Value.absent(),
            Value<String> entry1 = const Value.absent(),
            Value<String> out1 = const Value.absent(),
            Value<String> entry2 = const Value.absent(),
            Value<String> out2 = const Value.absent(),
            Value<bool> isDayOff = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumEmployeeScheduleTableCompanion(
            reference: reference,
            date: date,
            badageNumber: badageNumber,
            entry1: entry1,
            out1: out1,
            entry2: entry2,
            out2: out2,
            isDayOff: isDayOff,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String reference,
            required DateTime date,
            required String badageNumber,
            required String entry1,
            required String out1,
            required String entry2,
            required String out2,
            required bool isDayOff,
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumEmployeeScheduleTableCompanion.insert(
            reference: reference,
            date: date,
            badageNumber: badageNumber,
            entry1: entry1,
            out1: out1,
            entry2: entry2,
            out2: out2,
            isDayOff: isDayOff,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CondominiumEmployeeScheduleTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $CondominiumEmployeeScheduleTableTable,
        CondominiumEmployeeScheduleData,
        $$CondominiumEmployeeScheduleTableTableFilterComposer,
        $$CondominiumEmployeeScheduleTableTableOrderingComposer,
        $$CondominiumEmployeeScheduleTableTableAnnotationComposer,
        $$CondominiumEmployeeScheduleTableTableCreateCompanionBuilder,
        $$CondominiumEmployeeScheduleTableTableUpdateCompanionBuilder,
        (
          CondominiumEmployeeScheduleData,
          BaseReferences<
              _$LelloDatabase,
              $CondominiumEmployeeScheduleTableTable,
              CondominiumEmployeeScheduleData>
        ),
        CondominiumEmployeeScheduleData,
        PrefetchHooks Function()>;

class $LelloDatabaseManager {
  final _$LelloDatabase _db;
  $LelloDatabaseManager(this._db);
  $$CondominiumTableTableTableManager get condominiumTable =>
      $$CondominiumTableTableTableManager(_db, _db.condominiumTable);
  $$MeTableTableTableManager get meTable =>
      $$MeTableTableTableManager(_db, _db.meTable);
  $$EmployeeTableTableTableManager get employeeTable =>
      $$EmployeeTableTableTableManager(_db, _db.employeeTable);
  $$CondominiumEmployeeScheduleTableTableTableManager
      get condominiumEmployeeScheduleTable =>
          $$CondominiumEmployeeScheduleTableTableTableManager(
              _db, _db.condominiumEmployeeScheduleTable);
}
