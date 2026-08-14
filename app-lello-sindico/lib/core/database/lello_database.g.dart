// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lello_database.dart';

// ignore_for_file: type=lint
class $PendencyTableTable extends PendencyTable
    with TableInfo<$PendencyTableTable, PendencyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendencyTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderNameMeta =
      const VerificationMeta('senderName');
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
      'sender_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _senderPictureMeta =
      const VerificationMeta('senderPicture');
  @override
  late final GeneratedColumn<String> senderPicture = GeneratedColumn<String>(
      'sender_picture', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
      'module', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        condominiumId,
        id,
        title,
        message,
        date,
        type,
        senderId,
        senderName,
        senderPicture,
        module
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pendency_table';
  @override
  VerificationContext validateIntegrity(Insertable<PendencyData> instance,
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
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
          _senderNameMeta,
          senderName.isAcceptableOrUnknown(
              data['sender_name']!, _senderNameMeta));
    }
    if (data.containsKey('sender_picture')) {
      context.handle(
          _senderPictureMeta,
          senderPicture.isAcceptableOrUnknown(
              data['sender_picture']!, _senderPictureMeta));
    }
    if (data.containsKey('module')) {
      context.handle(_moduleMeta,
          module.isAcceptableOrUnknown(data['module']!, _moduleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, id};
  @override
  PendencyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendencyData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      senderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_name']),
      senderPicture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_picture']),
      module: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module']),
    );
  }

  @override
  $PendencyTableTable createAlias(String alias) {
    return $PendencyTableTable(attachedDatabase, alias);
  }
}

class PendencyData extends DataClass implements Insertable<PendencyData> {
  final String condominiumId;
  final String id;
  final String? title;
  final String? message;
  final DateTime? date;
  final String type;
  final String senderId;
  final String? senderName;
  final String? senderPicture;
  final String? module;
  const PendencyData(
      {required this.condominiumId,
      required this.id,
      this.title,
      this.message,
      this.date,
      required this.type,
      required this.senderId,
      this.senderName,
      this.senderPicture,
      this.module});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    map['type'] = Variable<String>(type);
    map['sender_id'] = Variable<String>(senderId);
    if (!nullToAbsent || senderName != null) {
      map['sender_name'] = Variable<String>(senderName);
    }
    if (!nullToAbsent || senderPicture != null) {
      map['sender_picture'] = Variable<String>(senderPicture);
    }
    if (!nullToAbsent || module != null) {
      map['module'] = Variable<String>(module);
    }
    return map;
  }

  PendencyTableCompanion toCompanion(bool nullToAbsent) {
    return PendencyTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      type: Value(type),
      senderId: Value(senderId),
      senderName: senderName == null && nullToAbsent
          ? const Value.absent()
          : Value(senderName),
      senderPicture: senderPicture == null && nullToAbsent
          ? const Value.absent()
          : Value(senderPicture),
      module:
          module == null && nullToAbsent ? const Value.absent() : Value(module),
    );
  }

  factory PendencyData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendencyData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      message: serializer.fromJson<String?>(json['message']),
      date: serializer.fromJson<DateTime?>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      senderId: serializer.fromJson<String>(json['senderId']),
      senderName: serializer.fromJson<String?>(json['senderName']),
      senderPicture: serializer.fromJson<String?>(json['senderPicture']),
      module: serializer.fromJson<String?>(json['module']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'message': serializer.toJson<String?>(message),
      'date': serializer.toJson<DateTime?>(date),
      'type': serializer.toJson<String>(type),
      'senderId': serializer.toJson<String>(senderId),
      'senderName': serializer.toJson<String?>(senderName),
      'senderPicture': serializer.toJson<String?>(senderPicture),
      'module': serializer.toJson<String?>(module),
    };
  }

  PendencyData copyWith(
          {String? condominiumId,
          String? id,
          Value<String?> title = const Value.absent(),
          Value<String?> message = const Value.absent(),
          Value<DateTime?> date = const Value.absent(),
          String? type,
          String? senderId,
          Value<String?> senderName = const Value.absent(),
          Value<String?> senderPicture = const Value.absent(),
          Value<String?> module = const Value.absent()}) =>
      PendencyData(
        condominiumId: condominiumId ?? this.condominiumId,
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        message: message.present ? message.value : this.message,
        date: date.present ? date.value : this.date,
        type: type ?? this.type,
        senderId: senderId ?? this.senderId,
        senderName: senderName.present ? senderName.value : this.senderName,
        senderPicture:
            senderPicture.present ? senderPicture.value : this.senderPicture,
        module: module.present ? module.value : this.module,
      );
  PendencyData copyWithCompanion(PendencyTableCompanion data) {
    return PendencyData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      senderName:
          data.senderName.present ? data.senderName.value : this.senderName,
      senderPicture: data.senderPicture.present
          ? data.senderPicture.value
          : this.senderPicture,
      module: data.module.present ? data.module.value : this.module,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendencyData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('senderPicture: $senderPicture, ')
          ..write('module: $module')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, id, title, message, date, type,
      senderId, senderName, senderPicture, module);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendencyData &&
          other.condominiumId == this.condominiumId &&
          other.id == this.id &&
          other.title == this.title &&
          other.message == this.message &&
          other.date == this.date &&
          other.type == this.type &&
          other.senderId == this.senderId &&
          other.senderName == this.senderName &&
          other.senderPicture == this.senderPicture &&
          other.module == this.module);
}

class PendencyTableCompanion extends UpdateCompanion<PendencyData> {
  final Value<String> condominiumId;
  final Value<String> id;
  final Value<String?> title;
  final Value<String?> message;
  final Value<DateTime?> date;
  final Value<String> type;
  final Value<String> senderId;
  final Value<String?> senderName;
  final Value<String?> senderPicture;
  final Value<String?> module;
  final Value<int> rowid;
  const PendencyTableCompanion({
    this.condominiumId = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderName = const Value.absent(),
    this.senderPicture = const Value.absent(),
    this.module = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendencyTableCompanion.insert({
    required String condominiumId,
    required String id,
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.date = const Value.absent(),
    required String type,
    required String senderId,
    this.senderName = const Value.absent(),
    this.senderPicture = const Value.absent(),
    this.module = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        id = Value(id),
        type = Value(type),
        senderId = Value(senderId);
  static Insertable<PendencyData> custom({
    Expression<String>? condominiumId,
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? message,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? senderId,
    Expression<String>? senderName,
    Expression<String>? senderPicture,
    Expression<String>? module,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (senderId != null) 'sender_id': senderId,
      if (senderName != null) 'sender_name': senderName,
      if (senderPicture != null) 'sender_picture': senderPicture,
      if (module != null) 'module': module,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendencyTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<String>? id,
      Value<String?>? title,
      Value<String?>? message,
      Value<DateTime?>? date,
      Value<String>? type,
      Value<String>? senderId,
      Value<String?>? senderName,
      Value<String?>? senderPicture,
      Value<String?>? module,
      Value<int>? rowid}) {
    return PendencyTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPicture: senderPicture ?? this.senderPicture,
      module: module ?? this.module,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (senderPicture.present) {
      map['sender_picture'] = Variable<String>(senderPicture.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendencyTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('senderPicture: $senderPicture, ')
          ..write('module: $module, ')
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
      'picture', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pictureHashMeta =
      const VerificationMeta('pictureHash');
  @override
  late final GeneratedColumn<String> pictureHash = GeneratedColumn<String>(
      'picture_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [name, email, cpf, phone, picture, pictureHash];
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
    }
    if (data.containsKey('picture_hash')) {
      context.handle(
          _pictureHashMeta,
          pictureHash.isAcceptableOrUnknown(
              data['picture_hash']!, _pictureHashMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {email};
  @override
  MeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      picture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture']),
      pictureHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture_hash']),
    );
  }

  @override
  $MeTableTable createAlias(String alias) {
    return $MeTableTable(attachedDatabase, alias);
  }
}

class MeData extends DataClass implements Insertable<MeData> {
  final String name;
  final String email;
  final String? cpf;
  final String? phone;
  final String? picture;
  final String? pictureHash;
  const MeData(
      {required this.name,
      required this.email,
      this.cpf,
      this.phone,
      this.picture,
      this.pictureHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
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
    return map;
  }

  MeTableCompanion toCompanion(bool nullToAbsent) {
    return MeTableCompanion(
      name: Value(name),
      email: Value(email),
      cpf: cpf == null && nullToAbsent ? const Value.absent() : Value(cpf),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      picture: picture == null && nullToAbsent
          ? const Value.absent()
          : Value(picture),
      pictureHash: pictureHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pictureHash),
    );
  }

  factory MeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeData(
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      cpf: serializer.fromJson<String?>(json['cpf']),
      phone: serializer.fromJson<String?>(json['phone']),
      picture: serializer.fromJson<String?>(json['picture']),
      pictureHash: serializer.fromJson<String?>(json['pictureHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'cpf': serializer.toJson<String?>(cpf),
      'phone': serializer.toJson<String?>(phone),
      'picture': serializer.toJson<String?>(picture),
      'pictureHash': serializer.toJson<String?>(pictureHash),
    };
  }

  MeData copyWith(
          {String? name,
          String? email,
          Value<String?> cpf = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> picture = const Value.absent(),
          Value<String?> pictureHash = const Value.absent()}) =>
      MeData(
        name: name ?? this.name,
        email: email ?? this.email,
        cpf: cpf.present ? cpf.value : this.cpf,
        phone: phone.present ? phone.value : this.phone,
        picture: picture.present ? picture.value : this.picture,
        pictureHash: pictureHash.present ? pictureHash.value : this.pictureHash,
      );
  MeData copyWithCompanion(MeTableCompanion data) {
    return MeData(
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      phone: data.phone.present ? data.phone.value : this.phone,
      picture: data.picture.present ? data.picture.value : this.picture,
      pictureHash:
          data.pictureHash.present ? data.pictureHash.value : this.pictureHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeData(')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('cpf: $cpf, ')
          ..write('phone: $phone, ')
          ..write('picture: $picture, ')
          ..write('pictureHash: $pictureHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(name, email, cpf, phone, picture, pictureHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeData &&
          other.name == this.name &&
          other.email == this.email &&
          other.cpf == this.cpf &&
          other.phone == this.phone &&
          other.picture == this.picture &&
          other.pictureHash == this.pictureHash);
}

class MeTableCompanion extends UpdateCompanion<MeData> {
  final Value<String> name;
  final Value<String> email;
  final Value<String?> cpf;
  final Value<String?> phone;
  final Value<String?> picture;
  final Value<String?> pictureHash;
  final Value<int> rowid;
  const MeTableCompanion({
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.cpf = const Value.absent(),
    this.phone = const Value.absent(),
    this.picture = const Value.absent(),
    this.pictureHash = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeTableCompanion.insert({
    required String name,
    required String email,
    this.cpf = const Value.absent(),
    this.phone = const Value.absent(),
    this.picture = const Value.absent(),
    this.pictureHash = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        email = Value(email);
  static Insertable<MeData> custom({
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? cpf,
    Expression<String>? phone,
    Expression<String>? picture,
    Expression<String>? pictureHash,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (cpf != null) 'cpf': cpf,
      if (phone != null) 'phone': phone,
      if (picture != null) 'picture': picture,
      if (pictureHash != null) 'picture_hash': pictureHash,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeTableCompanion copyWith(
      {Value<String>? name,
      Value<String>? email,
      Value<String?>? cpf,
      Value<String?>? phone,
      Value<String?>? picture,
      Value<String?>? pictureHash,
      Value<int>? rowid}) {
    return MeTableCompanion(
      name: name ?? this.name,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      picture: picture ?? this.picture,
      pictureHash: pictureHash ?? this.pictureHash,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeTableCompanion(')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('cpf: $cpf, ')
          ..write('phone: $phone, ')
          ..write('picture: $picture, ')
          ..write('pictureHash: $pictureHash, ')
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _useFacialBiometricMeta =
      const VerificationMeta('useFacialBiometric');
  @override
  late final GeneratedColumn<bool> useFacialBiometric = GeneratedColumn<bool>(
      'use_facial_biometric', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("use_facial_biometric" IN (0, 1))'));
  static const VerificationMeta _managerAccessControlBiometricStatusMeta =
      const VerificationMeta('managerAccessControlBiometricStatus');
  @override
  late final GeneratedColumn<String> managerAccessControlBiometricStatus =
      GeneratedColumn<String>(
          'manager_access_control_biometric_status', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationContextMeta =
      const VerificationMeta('notificationContext');
  @override
  late final GeneratedColumn<String> notificationContext =
      GeneratedColumn<String>('notification_context', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        address,
        reference,
        useFacialBiometric,
        managerAccessControlBiometricStatus,
        notificationContext
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
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('use_facial_biometric')) {
      context.handle(
          _useFacialBiometricMeta,
          useFacialBiometric.isAcceptableOrUnknown(
              data['use_facial_biometric']!, _useFacialBiometricMeta));
    } else if (isInserting) {
      context.missing(_useFacialBiometricMeta);
    }
    if (data.containsKey('manager_access_control_biometric_status')) {
      context.handle(
          _managerAccessControlBiometricStatusMeta,
          managerAccessControlBiometricStatus.isAcceptableOrUnknown(
              data['manager_access_control_biometric_status']!,
              _managerAccessControlBiometricStatusMeta));
    } else if (isInserting) {
      context.missing(_managerAccessControlBiometricStatusMeta);
    }
    if (data.containsKey('notification_context')) {
      context.handle(
          _notificationContextMeta,
          notificationContext.isAcceptableOrUnknown(
              data['notification_context']!, _notificationContextMeta));
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
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      useFacialBiometric: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}use_facial_biometric'])!,
      managerAccessControlBiometricStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}manager_access_control_biometric_status'])!,
      notificationContext: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_context']),
    );
  }

  @override
  $CondominiumTableTable createAlias(String alias) {
    return $CondominiumTableTable(attachedDatabase, alias);
  }
}

class CondominiumData extends DataClass implements Insertable<CondominiumData> {
  final String id;
  final String name;
  final String address;
  final String reference;
  final bool useFacialBiometric;
  final String managerAccessControlBiometricStatus;
  final String? notificationContext;
  const CondominiumData(
      {required this.id,
      required this.name,
      required this.address,
      required this.reference,
      required this.useFacialBiometric,
      required this.managerAccessControlBiometricStatus,
      this.notificationContext});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['reference'] = Variable<String>(reference);
    map['use_facial_biometric'] = Variable<bool>(useFacialBiometric);
    map['manager_access_control_biometric_status'] =
        Variable<String>(managerAccessControlBiometricStatus);
    if (!nullToAbsent || notificationContext != null) {
      map['notification_context'] = Variable<String>(notificationContext);
    }
    return map;
  }

  CondominiumTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumTableCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      reference: Value(reference),
      useFacialBiometric: Value(useFacialBiometric),
      managerAccessControlBiometricStatus:
          Value(managerAccessControlBiometricStatus),
      notificationContext: notificationContext == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationContext),
    );
  }

  factory CondominiumData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      reference: serializer.fromJson<String>(json['reference']),
      useFacialBiometric: serializer.fromJson<bool>(json['useFacialBiometric']),
      managerAccessControlBiometricStatus: serializer
          .fromJson<String>(json['managerAccessControlBiometricStatus']),
      notificationContext:
          serializer.fromJson<String?>(json['notificationContext']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'reference': serializer.toJson<String>(reference),
      'useFacialBiometric': serializer.toJson<bool>(useFacialBiometric),
      'managerAccessControlBiometricStatus':
          serializer.toJson<String>(managerAccessControlBiometricStatus),
      'notificationContext': serializer.toJson<String?>(notificationContext),
    };
  }

  CondominiumData copyWith(
          {String? id,
          String? name,
          String? address,
          String? reference,
          bool? useFacialBiometric,
          String? managerAccessControlBiometricStatus,
          Value<String?> notificationContext = const Value.absent()}) =>
      CondominiumData(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        reference: reference ?? this.reference,
        useFacialBiometric: useFacialBiometric ?? this.useFacialBiometric,
        managerAccessControlBiometricStatus:
            managerAccessControlBiometricStatus ??
                this.managerAccessControlBiometricStatus,
        notificationContext: notificationContext.present
            ? notificationContext.value
            : this.notificationContext,
      );
  CondominiumData copyWithCompanion(CondominiumTableCompanion data) {
    return CondominiumData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      reference: data.reference.present ? data.reference.value : this.reference,
      useFacialBiometric: data.useFacialBiometric.present
          ? data.useFacialBiometric.value
          : this.useFacialBiometric,
      managerAccessControlBiometricStatus:
          data.managerAccessControlBiometricStatus.present
              ? data.managerAccessControlBiometricStatus.value
              : this.managerAccessControlBiometricStatus,
      notificationContext: data.notificationContext.present
          ? data.notificationContext.value
          : this.notificationContext,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('reference: $reference, ')
          ..write('useFacialBiometric: $useFacialBiometric, ')
          ..write(
              'managerAccessControlBiometricStatus: $managerAccessControlBiometricStatus, ')
          ..write('notificationContext: $notificationContext')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      address,
      reference,
      useFacialBiometric,
      managerAccessControlBiometricStatus,
      notificationContext);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumData &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.reference == this.reference &&
          other.useFacialBiometric == this.useFacialBiometric &&
          other.managerAccessControlBiometricStatus ==
              this.managerAccessControlBiometricStatus &&
          other.notificationContext == this.notificationContext);
}

class CondominiumTableCompanion extends UpdateCompanion<CondominiumData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> reference;
  final Value<bool> useFacialBiometric;
  final Value<String> managerAccessControlBiometricStatus;
  final Value<String?> notificationContext;
  final Value<int> rowid;
  const CondominiumTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.reference = const Value.absent(),
    this.useFacialBiometric = const Value.absent(),
    this.managerAccessControlBiometricStatus = const Value.absent(),
    this.notificationContext = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumTableCompanion.insert({
    required String id,
    required String name,
    required String address,
    required String reference,
    required bool useFacialBiometric,
    required String managerAccessControlBiometricStatus,
    this.notificationContext = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        address = Value(address),
        reference = Value(reference),
        useFacialBiometric = Value(useFacialBiometric),
        managerAccessControlBiometricStatus =
            Value(managerAccessControlBiometricStatus);
  static Insertable<CondominiumData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? reference,
    Expression<bool>? useFacialBiometric,
    Expression<String>? managerAccessControlBiometricStatus,
    Expression<String>? notificationContext,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (reference != null) 'reference': reference,
      if (useFacialBiometric != null)
        'use_facial_biometric': useFacialBiometric,
      if (managerAccessControlBiometricStatus != null)
        'manager_access_control_biometric_status':
            managerAccessControlBiometricStatus,
      if (notificationContext != null)
        'notification_context': notificationContext,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? address,
      Value<String>? reference,
      Value<bool>? useFacialBiometric,
      Value<String>? managerAccessControlBiometricStatus,
      Value<String?>? notificationContext,
      Value<int>? rowid}) {
    return CondominiumTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      reference: reference ?? this.reference,
      useFacialBiometric: useFacialBiometric ?? this.useFacialBiometric,
      managerAccessControlBiometricStatus:
          managerAccessControlBiometricStatus ??
              this.managerAccessControlBiometricStatus,
      notificationContext: notificationContext ?? this.notificationContext,
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
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (useFacialBiometric.present) {
      map['use_facial_biometric'] = Variable<bool>(useFacialBiometric.value);
    }
    if (managerAccessControlBiometricStatus.present) {
      map['manager_access_control_biometric_status'] =
          Variable<String>(managerAccessControlBiometricStatus.value);
    }
    if (notificationContext.present) {
      map['notification_context'] = Variable<String>(notificationContext.value);
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
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('reference: $reference, ')
          ..write('useFacialBiometric: $useFacialBiometric, ')
          ..write(
              'managerAccessControlBiometricStatus: $managerAccessControlBiometricStatus, ')
          ..write('notificationContext: $notificationContext, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountTableTable extends AccountTable
    with TableInfo<$AccountTableTable, AccountData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, number, name, condominiumId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_table';
  @override
  VerificationContext validateIntegrity(Insertable<AccountData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, id};
  @override
  AccountData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
    );
  }

  @override
  $AccountTableTable createAlias(String alias) {
    return $AccountTableTable(attachedDatabase, alias);
  }
}

class AccountData extends DataClass implements Insertable<AccountData> {
  final String id;
  final String? number;
  final String? name;
  final String condominiumId;
  const AccountData(
      {required this.id, this.number, this.name, required this.condominiumId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['condominium_id'] = Variable<String>(condominiumId);
    return map;
  }

  AccountTableCompanion toCompanion(bool nullToAbsent) {
    return AccountTableCompanion(
      id: Value(id),
      number:
          number == null && nullToAbsent ? const Value.absent() : Value(number),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      condominiumId: Value(condominiumId),
    );
  }

  factory AccountData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountData(
      id: serializer.fromJson<String>(json['id']),
      number: serializer.fromJson<String?>(json['number']),
      name: serializer.fromJson<String?>(json['name']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'number': serializer.toJson<String?>(number),
      'name': serializer.toJson<String?>(name),
      'condominiumId': serializer.toJson<String>(condominiumId),
    };
  }

  AccountData copyWith(
          {String? id,
          Value<String?> number = const Value.absent(),
          Value<String?> name = const Value.absent(),
          String? condominiumId}) =>
      AccountData(
        id: id ?? this.id,
        number: number.present ? number.value : this.number,
        name: name.present ? name.value : this.name,
        condominiumId: condominiumId ?? this.condominiumId,
      );
  AccountData copyWithCompanion(AccountTableCompanion data) {
    return AccountData(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      name: data.name.present ? data.name.value : this.name,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountData(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('condominiumId: $condominiumId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, name, condominiumId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountData &&
          other.id == this.id &&
          other.number == this.number &&
          other.name == this.name &&
          other.condominiumId == this.condominiumId);
}

class AccountTableCompanion extends UpdateCompanion<AccountData> {
  final Value<String> id;
  final Value<String?> number;
  final Value<String?> name;
  final Value<String> condominiumId;
  final Value<int> rowid;
  const AccountTableCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.name = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountTableCompanion.insert({
    required String id,
    this.number = const Value.absent(),
    this.name = const Value.absent(),
    required String condominiumId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        condominiumId = Value(condominiumId);
  static Insertable<AccountData> custom({
    Expression<String>? id,
    Expression<String>? number,
    Expression<String>? name,
    Expression<String>? condominiumId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (name != null) 'name': name,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? number,
      Value<String?>? name,
      Value<String>? condominiumId,
      Value<int>? rowid}) {
    return AccountTableCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      condominiumId: condominiumId ?? this.condominiumId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountTableCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LelloHubTableTable extends LelloHubTable
    with TableInfo<$LelloHubTableTable, LelloHubData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LelloHubTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [number];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lello_hub_table';
  @override
  VerificationContext validateIntegrity(Insertable<LelloHubData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number};
  @override
  LelloHubData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LelloHubData(
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number']),
    );
  }

  @override
  $LelloHubTableTable createAlias(String alias) {
    return $LelloHubTableTable(attachedDatabase, alias);
  }
}

class LelloHubData extends DataClass implements Insertable<LelloHubData> {
  final String? number;
  const LelloHubData({this.number});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    return map;
  }

  LelloHubTableCompanion toCompanion(bool nullToAbsent) {
    return LelloHubTableCompanion(
      number:
          number == null && nullToAbsent ? const Value.absent() : Value(number),
    );
  }

  factory LelloHubData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LelloHubData(
      number: serializer.fromJson<String?>(json['number']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<String?>(number),
    };
  }

  LelloHubData copyWith({Value<String?> number = const Value.absent()}) =>
      LelloHubData(
        number: number.present ? number.value : this.number,
      );
  LelloHubData copyWithCompanion(LelloHubTableCompanion data) {
    return LelloHubData(
      number: data.number.present ? data.number.value : this.number,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LelloHubData(')
          ..write('number: $number')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => number.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LelloHubData && other.number == this.number);
}

class LelloHubTableCompanion extends UpdateCompanion<LelloHubData> {
  final Value<String?> number;
  final Value<int> rowid;
  const LelloHubTableCompanion({
    this.number = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LelloHubTableCompanion.insert({
    this.number = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<LelloHubData> custom({
    Expression<String>? number,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LelloHubTableCompanion copyWith({Value<String?>? number, Value<int>? rowid}) {
    return LelloHubTableCompanion(
      number: number ?? this.number,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LelloHubTableCompanion(')
          ..write('number: $number, ')
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupMeta = const VerificationMeta('group');
  @override
  late final GeneratedColumn<String> group = GeneratedColumn<String>(
      'group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _residentCountMeta =
      const VerificationMeta('residentCount');
  @override
  late final GeneratedColumn<int> residentCount = GeneratedColumn<int>(
      'resident_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vehicleCountMeta =
      const VerificationMeta('vehicleCount');
  @override
  late final GeneratedColumn<int> vehicleCount = GeneratedColumn<int>(
      'vehicle_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _adimplenteMeta =
      const VerificationMeta('adimplente');
  @override
  late final GeneratedColumn<bool> adimplente = GeneratedColumn<bool>(
      'adimplente', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("adimplente" IN (0, 1))'));
  static const VerificationMeta _agreementMeta =
      const VerificationMeta('agreement');
  @override
  late final GeneratedColumn<bool> agreement = GeneratedColumn<bool>(
      'agreement', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("agreement" IN (0, 1))'));
  static const VerificationMeta _billingStatusMeta =
      const VerificationMeta('billingStatus');
  @override
  late final GeneratedColumn<String> billingStatus = GeneratedColumn<String>(
      'billing_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usesAppMeta =
      const VerificationMeta('usesApp');
  @override
  late final GeneratedColumn<bool> usesApp = GeneratedColumn<bool>(
      'uses_app', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("uses_app" IN (0, 1))'));
  static const VerificationMeta _fixedPhoneMeta =
      const VerificationMeta('fixedPhone');
  @override
  late final GeneratedColumn<String> fixedPhone = GeneratedColumn<String>(
      'fixed_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mobilePhoneMeta =
      const VerificationMeta('mobilePhone');
  @override
  late final GeneratedColumn<String> mobilePhone = GeneratedColumn<String>(
      'mobile_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        group,
        residentCount,
        condominiumId,
        vehicleCount,
        adimplente,
        agreement,
        billingStatus,
        usesApp,
        fixedPhone,
        mobilePhone,
        lastUpdated
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
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('group')) {
      context.handle(
          _groupMeta, group.isAcceptableOrUnknown(data['group']!, _groupMeta));
    }
    if (data.containsKey('resident_count')) {
      context.handle(
          _residentCountMeta,
          residentCount.isAcceptableOrUnknown(
              data['resident_count']!, _residentCountMeta));
    } else if (isInserting) {
      context.missing(_residentCountMeta);
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    if (data.containsKey('vehicle_count')) {
      context.handle(
          _vehicleCountMeta,
          vehicleCount.isAcceptableOrUnknown(
              data['vehicle_count']!, _vehicleCountMeta));
    } else if (isInserting) {
      context.missing(_vehicleCountMeta);
    }
    if (data.containsKey('adimplente')) {
      context.handle(
          _adimplenteMeta,
          adimplente.isAcceptableOrUnknown(
              data['adimplente']!, _adimplenteMeta));
    } else if (isInserting) {
      context.missing(_adimplenteMeta);
    }
    if (data.containsKey('agreement')) {
      context.handle(_agreementMeta,
          agreement.isAcceptableOrUnknown(data['agreement']!, _agreementMeta));
    } else if (isInserting) {
      context.missing(_agreementMeta);
    }
    if (data.containsKey('billing_status')) {
      context.handle(
          _billingStatusMeta,
          billingStatus.isAcceptableOrUnknown(
              data['billing_status']!, _billingStatusMeta));
    } else if (isInserting) {
      context.missing(_billingStatusMeta);
    }
    if (data.containsKey('uses_app')) {
      context.handle(_usesAppMeta,
          usesApp.isAcceptableOrUnknown(data['uses_app']!, _usesAppMeta));
    } else if (isInserting) {
      context.missing(_usesAppMeta);
    }
    if (data.containsKey('fixed_phone')) {
      context.handle(
          _fixedPhoneMeta,
          fixedPhone.isAcceptableOrUnknown(
              data['fixed_phone']!, _fixedPhoneMeta));
    } else if (isInserting) {
      context.missing(_fixedPhoneMeta);
    }
    if (data.containsKey('mobile_phone')) {
      context.handle(
          _mobilePhoneMeta,
          mobilePhone.isAcceptableOrUnknown(
              data['mobile_phone']!, _mobilePhoneMeta));
    } else if (isInserting) {
      context.missing(_mobilePhoneMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, id};
  @override
  UnitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      group: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group']),
      residentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resident_count'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      vehicleCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vehicle_count'])!,
      adimplente: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}adimplente'])!,
      agreement: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}agreement'])!,
      billingStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_status'])!,
      usesApp: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}uses_app'])!,
      fixedPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fixed_phone'])!,
      mobilePhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile_phone'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $UnitTableTable createAlias(String alias) {
    return $UnitTableTable(attachedDatabase, alias);
  }
}

class UnitData extends DataClass implements Insertable<UnitData> {
  final String id;
  final String title;
  final String? group;
  final int residentCount;
  final String condominiumId;
  final int vehicleCount;
  final bool adimplente;
  final bool agreement;
  final String billingStatus;
  final bool usesApp;
  final String fixedPhone;
  final String mobilePhone;
  final DateTime lastUpdated;
  const UnitData(
      {required this.id,
      required this.title,
      this.group,
      required this.residentCount,
      required this.condominiumId,
      required this.vehicleCount,
      required this.adimplente,
      required this.agreement,
      required this.billingStatus,
      required this.usesApp,
      required this.fixedPhone,
      required this.mobilePhone,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || group != null) {
      map['group'] = Variable<String>(group);
    }
    map['resident_count'] = Variable<int>(residentCount);
    map['condominium_id'] = Variable<String>(condominiumId);
    map['vehicle_count'] = Variable<int>(vehicleCount);
    map['adimplente'] = Variable<bool>(adimplente);
    map['agreement'] = Variable<bool>(agreement);
    map['billing_status'] = Variable<String>(billingStatus);
    map['uses_app'] = Variable<bool>(usesApp);
    map['fixed_phone'] = Variable<String>(fixedPhone);
    map['mobile_phone'] = Variable<String>(mobilePhone);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  UnitTableCompanion toCompanion(bool nullToAbsent) {
    return UnitTableCompanion(
      id: Value(id),
      title: Value(title),
      group:
          group == null && nullToAbsent ? const Value.absent() : Value(group),
      residentCount: Value(residentCount),
      condominiumId: Value(condominiumId),
      vehicleCount: Value(vehicleCount),
      adimplente: Value(adimplente),
      agreement: Value(agreement),
      billingStatus: Value(billingStatus),
      usesApp: Value(usesApp),
      fixedPhone: Value(fixedPhone),
      mobilePhone: Value(mobilePhone),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory UnitData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      group: serializer.fromJson<String?>(json['group']),
      residentCount: serializer.fromJson<int>(json['residentCount']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      vehicleCount: serializer.fromJson<int>(json['vehicleCount']),
      adimplente: serializer.fromJson<bool>(json['adimplente']),
      agreement: serializer.fromJson<bool>(json['agreement']),
      billingStatus: serializer.fromJson<String>(json['billingStatus']),
      usesApp: serializer.fromJson<bool>(json['usesApp']),
      fixedPhone: serializer.fromJson<String>(json['fixedPhone']),
      mobilePhone: serializer.fromJson<String>(json['mobilePhone']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'group': serializer.toJson<String?>(group),
      'residentCount': serializer.toJson<int>(residentCount),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'vehicleCount': serializer.toJson<int>(vehicleCount),
      'adimplente': serializer.toJson<bool>(adimplente),
      'agreement': serializer.toJson<bool>(agreement),
      'billingStatus': serializer.toJson<String>(billingStatus),
      'usesApp': serializer.toJson<bool>(usesApp),
      'fixedPhone': serializer.toJson<String>(fixedPhone),
      'mobilePhone': serializer.toJson<String>(mobilePhone),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  UnitData copyWith(
          {String? id,
          String? title,
          Value<String?> group = const Value.absent(),
          int? residentCount,
          String? condominiumId,
          int? vehicleCount,
          bool? adimplente,
          bool? agreement,
          String? billingStatus,
          bool? usesApp,
          String? fixedPhone,
          String? mobilePhone,
          DateTime? lastUpdated}) =>
      UnitData(
        id: id ?? this.id,
        title: title ?? this.title,
        group: group.present ? group.value : this.group,
        residentCount: residentCount ?? this.residentCount,
        condominiumId: condominiumId ?? this.condominiumId,
        vehicleCount: vehicleCount ?? this.vehicleCount,
        adimplente: adimplente ?? this.adimplente,
        agreement: agreement ?? this.agreement,
        billingStatus: billingStatus ?? this.billingStatus,
        usesApp: usesApp ?? this.usesApp,
        fixedPhone: fixedPhone ?? this.fixedPhone,
        mobilePhone: mobilePhone ?? this.mobilePhone,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  UnitData copyWithCompanion(UnitTableCompanion data) {
    return UnitData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      group: data.group.present ? data.group.value : this.group,
      residentCount: data.residentCount.present
          ? data.residentCount.value
          : this.residentCount,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      vehicleCount: data.vehicleCount.present
          ? data.vehicleCount.value
          : this.vehicleCount,
      adimplente:
          data.adimplente.present ? data.adimplente.value : this.adimplente,
      agreement: data.agreement.present ? data.agreement.value : this.agreement,
      billingStatus: data.billingStatus.present
          ? data.billingStatus.value
          : this.billingStatus,
      usesApp: data.usesApp.present ? data.usesApp.value : this.usesApp,
      fixedPhone:
          data.fixedPhone.present ? data.fixedPhone.value : this.fixedPhone,
      mobilePhone:
          data.mobilePhone.present ? data.mobilePhone.value : this.mobilePhone,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('group: $group, ')
          ..write('residentCount: $residentCount, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('vehicleCount: $vehicleCount, ')
          ..write('adimplente: $adimplente, ')
          ..write('agreement: $agreement, ')
          ..write('billingStatus: $billingStatus, ')
          ..write('usesApp: $usesApp, ')
          ..write('fixedPhone: $fixedPhone, ')
          ..write('mobilePhone: $mobilePhone, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      group,
      residentCount,
      condominiumId,
      vehicleCount,
      adimplente,
      agreement,
      billingStatus,
      usesApp,
      fixedPhone,
      mobilePhone,
      lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitData &&
          other.id == this.id &&
          other.title == this.title &&
          other.group == this.group &&
          other.residentCount == this.residentCount &&
          other.condominiumId == this.condominiumId &&
          other.vehicleCount == this.vehicleCount &&
          other.adimplente == this.adimplente &&
          other.agreement == this.agreement &&
          other.billingStatus == this.billingStatus &&
          other.usesApp == this.usesApp &&
          other.fixedPhone == this.fixedPhone &&
          other.mobilePhone == this.mobilePhone &&
          other.lastUpdated == this.lastUpdated);
}

class UnitTableCompanion extends UpdateCompanion<UnitData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> group;
  final Value<int> residentCount;
  final Value<String> condominiumId;
  final Value<int> vehicleCount;
  final Value<bool> adimplente;
  final Value<bool> agreement;
  final Value<String> billingStatus;
  final Value<bool> usesApp;
  final Value<String> fixedPhone;
  final Value<String> mobilePhone;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const UnitTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.group = const Value.absent(),
    this.residentCount = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.vehicleCount = const Value.absent(),
    this.adimplente = const Value.absent(),
    this.agreement = const Value.absent(),
    this.billingStatus = const Value.absent(),
    this.usesApp = const Value.absent(),
    this.fixedPhone = const Value.absent(),
    this.mobilePhone = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitTableCompanion.insert({
    required String id,
    required String title,
    this.group = const Value.absent(),
    required int residentCount,
    required String condominiumId,
    required int vehicleCount,
    required bool adimplente,
    required bool agreement,
    required String billingStatus,
    required bool usesApp,
    required String fixedPhone,
    required String mobilePhone,
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        residentCount = Value(residentCount),
        condominiumId = Value(condominiumId),
        vehicleCount = Value(vehicleCount),
        adimplente = Value(adimplente),
        agreement = Value(agreement),
        billingStatus = Value(billingStatus),
        usesApp = Value(usesApp),
        fixedPhone = Value(fixedPhone),
        mobilePhone = Value(mobilePhone),
        lastUpdated = Value(lastUpdated);
  static Insertable<UnitData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? group,
    Expression<int>? residentCount,
    Expression<String>? condominiumId,
    Expression<int>? vehicleCount,
    Expression<bool>? adimplente,
    Expression<bool>? agreement,
    Expression<String>? billingStatus,
    Expression<bool>? usesApp,
    Expression<String>? fixedPhone,
    Expression<String>? mobilePhone,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (group != null) 'group': group,
      if (residentCount != null) 'resident_count': residentCount,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (vehicleCount != null) 'vehicle_count': vehicleCount,
      if (adimplente != null) 'adimplente': adimplente,
      if (agreement != null) 'agreement': agreement,
      if (billingStatus != null) 'billing_status': billingStatus,
      if (usesApp != null) 'uses_app': usesApp,
      if (fixedPhone != null) 'fixed_phone': fixedPhone,
      if (mobilePhone != null) 'mobile_phone': mobilePhone,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? group,
      Value<int>? residentCount,
      Value<String>? condominiumId,
      Value<int>? vehicleCount,
      Value<bool>? adimplente,
      Value<bool>? agreement,
      Value<String>? billingStatus,
      Value<bool>? usesApp,
      Value<String>? fixedPhone,
      Value<String>? mobilePhone,
      Value<DateTime>? lastUpdated,
      Value<int>? rowid}) {
    return UnitTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      group: group ?? this.group,
      residentCount: residentCount ?? this.residentCount,
      condominiumId: condominiumId ?? this.condominiumId,
      vehicleCount: vehicleCount ?? this.vehicleCount,
      adimplente: adimplente ?? this.adimplente,
      agreement: agreement ?? this.agreement,
      billingStatus: billingStatus ?? this.billingStatus,
      usesApp: usesApp ?? this.usesApp,
      fixedPhone: fixedPhone ?? this.fixedPhone,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (group.present) {
      map['group'] = Variable<String>(group.value);
    }
    if (residentCount.present) {
      map['resident_count'] = Variable<int>(residentCount.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (vehicleCount.present) {
      map['vehicle_count'] = Variable<int>(vehicleCount.value);
    }
    if (adimplente.present) {
      map['adimplente'] = Variable<bool>(adimplente.value);
    }
    if (agreement.present) {
      map['agreement'] = Variable<bool>(agreement.value);
    }
    if (billingStatus.present) {
      map['billing_status'] = Variable<String>(billingStatus.value);
    }
    if (usesApp.present) {
      map['uses_app'] = Variable<bool>(usesApp.value);
    }
    if (fixedPhone.present) {
      map['fixed_phone'] = Variable<String>(fixedPhone.value);
    }
    if (mobilePhone.present) {
      map['mobile_phone'] = Variable<String>(mobilePhone.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
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
          ..write('title: $title, ')
          ..write('group: $group, ')
          ..write('residentCount: $residentCount, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('vehicleCount: $vehicleCount, ')
          ..write('adimplente: $adimplente, ')
          ..write('agreement: $agreement, ')
          ..write('billingStatus: $billingStatus, ')
          ..write('usesApp: $usesApp, ')
          ..write('fixedPhone: $fixedPhone, ')
          ..write('mobilePhone: $mobilePhone, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResidentTableTable extends ResidentTable
    with TableInfo<$ResidentTableTable, ResidentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResidentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
      'cpf', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitTitleMeta =
      const VerificationMeta('unitTitle');
  @override
  late final GeneratedColumn<String> unitTitle = GeneratedColumn<String>(
      'unit_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitGroupMeta =
      const VerificationMeta('unitGroup');
  @override
  late final GeneratedColumn<String> unitGroup = GeneratedColumn<String>(
      'unit_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitResidentCountMeta =
      const VerificationMeta('unitResidentCount');
  @override
  late final GeneratedColumn<int> unitResidentCount = GeneratedColumn<int>(
      'unit_resident_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        cpf,
        unitId,
        unitTitle,
        unitGroup,
        unitResidentCount,
        condominiumId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resident_table';
  @override
  VerificationContext validateIntegrity(Insertable<ResidentData> instance,
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cpf')) {
      context.handle(
          _cpfMeta, cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta));
    } else if (isInserting) {
      context.missing(_cpfMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('unit_title')) {
      context.handle(_unitTitleMeta,
          unitTitle.isAcceptableOrUnknown(data['unit_title']!, _unitTitleMeta));
    } else if (isInserting) {
      context.missing(_unitTitleMeta);
    }
    if (data.containsKey('unit_group')) {
      context.handle(_unitGroupMeta,
          unitGroup.isAcceptableOrUnknown(data['unit_group']!, _unitGroupMeta));
    }
    if (data.containsKey('unit_resident_count')) {
      context.handle(
          _unitResidentCountMeta,
          unitResidentCount.isAcceptableOrUnknown(
              data['unit_resident_count']!, _unitResidentCountMeta));
    } else if (isInserting) {
      context.missing(_unitResidentCountMeta);
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, id};
  @override
  ResidentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResidentData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id'])!,
      unitTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_title'])!,
      unitGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_group']),
      unitResidentCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_resident_count'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
    );
  }

  @override
  $ResidentTableTable createAlias(String alias) {
    return $ResidentTableTable(attachedDatabase, alias);
  }
}

class ResidentData extends DataClass implements Insertable<ResidentData> {
  final String id;
  final String name;
  final String cpf;
  final String unitId;
  final String unitTitle;
  final String? unitGroup;
  final int unitResidentCount;
  final String condominiumId;
  const ResidentData(
      {required this.id,
      required this.name,
      required this.cpf,
      required this.unitId,
      required this.unitTitle,
      this.unitGroup,
      required this.unitResidentCount,
      required this.condominiumId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['cpf'] = Variable<String>(cpf);
    map['unit_id'] = Variable<String>(unitId);
    map['unit_title'] = Variable<String>(unitTitle);
    if (!nullToAbsent || unitGroup != null) {
      map['unit_group'] = Variable<String>(unitGroup);
    }
    map['unit_resident_count'] = Variable<int>(unitResidentCount);
    map['condominium_id'] = Variable<String>(condominiumId);
    return map;
  }

  ResidentTableCompanion toCompanion(bool nullToAbsent) {
    return ResidentTableCompanion(
      id: Value(id),
      name: Value(name),
      cpf: Value(cpf),
      unitId: Value(unitId),
      unitTitle: Value(unitTitle),
      unitGroup: unitGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(unitGroup),
      unitResidentCount: Value(unitResidentCount),
      condominiumId: Value(condominiumId),
    );
  }

  factory ResidentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResidentData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      cpf: serializer.fromJson<String>(json['cpf']),
      unitId: serializer.fromJson<String>(json['unitId']),
      unitTitle: serializer.fromJson<String>(json['unitTitle']),
      unitGroup: serializer.fromJson<String?>(json['unitGroup']),
      unitResidentCount: serializer.fromJson<int>(json['unitResidentCount']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'cpf': serializer.toJson<String>(cpf),
      'unitId': serializer.toJson<String>(unitId),
      'unitTitle': serializer.toJson<String>(unitTitle),
      'unitGroup': serializer.toJson<String?>(unitGroup),
      'unitResidentCount': serializer.toJson<int>(unitResidentCount),
      'condominiumId': serializer.toJson<String>(condominiumId),
    };
  }

  ResidentData copyWith(
          {String? id,
          String? name,
          String? cpf,
          String? unitId,
          String? unitTitle,
          Value<String?> unitGroup = const Value.absent(),
          int? unitResidentCount,
          String? condominiumId}) =>
      ResidentData(
        id: id ?? this.id,
        name: name ?? this.name,
        cpf: cpf ?? this.cpf,
        unitId: unitId ?? this.unitId,
        unitTitle: unitTitle ?? this.unitTitle,
        unitGroup: unitGroup.present ? unitGroup.value : this.unitGroup,
        unitResidentCount: unitResidentCount ?? this.unitResidentCount,
        condominiumId: condominiumId ?? this.condominiumId,
      );
  ResidentData copyWithCompanion(ResidentTableCompanion data) {
    return ResidentData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      unitTitle: data.unitTitle.present ? data.unitTitle.value : this.unitTitle,
      unitGroup: data.unitGroup.present ? data.unitGroup.value : this.unitGroup,
      unitResidentCount: data.unitResidentCount.present
          ? data.unitResidentCount.value
          : this.unitResidentCount,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResidentData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cpf: $cpf, ')
          ..write('unitId: $unitId, ')
          ..write('unitTitle: $unitTitle, ')
          ..write('unitGroup: $unitGroup, ')
          ..write('unitResidentCount: $unitResidentCount, ')
          ..write('condominiumId: $condominiumId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, cpf, unitId, unitTitle, unitGroup,
      unitResidentCount, condominiumId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResidentData &&
          other.id == this.id &&
          other.name == this.name &&
          other.cpf == this.cpf &&
          other.unitId == this.unitId &&
          other.unitTitle == this.unitTitle &&
          other.unitGroup == this.unitGroup &&
          other.unitResidentCount == this.unitResidentCount &&
          other.condominiumId == this.condominiumId);
}

class ResidentTableCompanion extends UpdateCompanion<ResidentData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> cpf;
  final Value<String> unitId;
  final Value<String> unitTitle;
  final Value<String?> unitGroup;
  final Value<int> unitResidentCount;
  final Value<String> condominiumId;
  final Value<int> rowid;
  const ResidentTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.cpf = const Value.absent(),
    this.unitId = const Value.absent(),
    this.unitTitle = const Value.absent(),
    this.unitGroup = const Value.absent(),
    this.unitResidentCount = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResidentTableCompanion.insert({
    required String id,
    required String name,
    required String cpf,
    required String unitId,
    required String unitTitle,
    this.unitGroup = const Value.absent(),
    required int unitResidentCount,
    required String condominiumId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        cpf = Value(cpf),
        unitId = Value(unitId),
        unitTitle = Value(unitTitle),
        unitResidentCount = Value(unitResidentCount),
        condominiumId = Value(condominiumId);
  static Insertable<ResidentData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? cpf,
    Expression<String>? unitId,
    Expression<String>? unitTitle,
    Expression<String>? unitGroup,
    Expression<int>? unitResidentCount,
    Expression<String>? condominiumId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (cpf != null) 'cpf': cpf,
      if (unitId != null) 'unit_id': unitId,
      if (unitTitle != null) 'unit_title': unitTitle,
      if (unitGroup != null) 'unit_group': unitGroup,
      if (unitResidentCount != null) 'unit_resident_count': unitResidentCount,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResidentTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? cpf,
      Value<String>? unitId,
      Value<String>? unitTitle,
      Value<String?>? unitGroup,
      Value<int>? unitResidentCount,
      Value<String>? condominiumId,
      Value<int>? rowid}) {
    return ResidentTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      unitId: unitId ?? this.unitId,
      unitTitle: unitTitle ?? this.unitTitle,
      unitGroup: unitGroup ?? this.unitGroup,
      unitResidentCount: unitResidentCount ?? this.unitResidentCount,
      condominiumId: condominiumId ?? this.condominiumId,
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
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (unitTitle.present) {
      map['unit_title'] = Variable<String>(unitTitle.value);
    }
    if (unitGroup.present) {
      map['unit_group'] = Variable<String>(unitGroup.value);
    }
    if (unitResidentCount.present) {
      map['unit_resident_count'] = Variable<int>(unitResidentCount.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResidentTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('cpf: $cpf, ')
          ..write('unitId: $unitId, ')
          ..write('unitTitle: $unitTitle, ')
          ..write('unitGroup: $unitGroup, ')
          ..write('unitResidentCount: $unitResidentCount, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeForecastTableTable extends IncomeForecastTable
    with TableInfo<$IncomeForecastTableTable, IncomeForecastData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeForecastTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _forecastPeriodMeta =
      const VerificationMeta('forecastPeriod');
  @override
  late final GeneratedColumn<String> forecastPeriod = GeneratedColumn<String>(
      'forecast_period', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _forecastMeta =
      const VerificationMeta('forecast');
  @override
  late final GeneratedColumn<double> forecast = GeneratedColumn<double>(
      'forecast', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [condominiumId, year, month, forecastPeriod, forecast, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_forecast_table';
  @override
  VerificationContext validateIntegrity(Insertable<IncomeForecastData> instance,
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
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('forecast_period')) {
      context.handle(
          _forecastPeriodMeta,
          forecastPeriod.isAcceptableOrUnknown(
              data['forecast_period']!, _forecastPeriodMeta));
    } else if (isInserting) {
      context.missing(_forecastPeriodMeta);
    }
    if (data.containsKey('forecast')) {
      context.handle(_forecastMeta,
          forecast.isAcceptableOrUnknown(data['forecast']!, _forecastMeta));
    } else if (isInserting) {
      context.missing(_forecastMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {condominiumId, year, month, forecastPeriod};
  @override
  IncomeForecastData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeForecastData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      forecastPeriod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}forecast_period'])!,
      forecast: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}forecast'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $IncomeForecastTableTable createAlias(String alias) {
    return $IncomeForecastTableTable(attachedDatabase, alias);
  }
}

class IncomeForecastData extends DataClass
    implements Insertable<IncomeForecastData> {
  final String condominiumId;
  final int year;
  final int month;
  final String forecastPeriod;
  final double forecast;
  final double value;
  const IncomeForecastData(
      {required this.condominiumId,
      required this.year,
      required this.month,
      required this.forecastPeriod,
      required this.forecast,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['forecast_period'] = Variable<String>(forecastPeriod);
    map['forecast'] = Variable<double>(forecast);
    map['value'] = Variable<double>(value);
    return map;
  }

  IncomeForecastTableCompanion toCompanion(bool nullToAbsent) {
    return IncomeForecastTableCompanion(
      condominiumId: Value(condominiumId),
      year: Value(year),
      month: Value(month),
      forecastPeriod: Value(forecastPeriod),
      forecast: Value(forecast),
      value: Value(value),
    );
  }

  factory IncomeForecastData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeForecastData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      forecastPeriod: serializer.fromJson<String>(json['forecastPeriod']),
      forecast: serializer.fromJson<double>(json['forecast']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'forecastPeriod': serializer.toJson<String>(forecastPeriod),
      'forecast': serializer.toJson<double>(forecast),
      'value': serializer.toJson<double>(value),
    };
  }

  IncomeForecastData copyWith(
          {String? condominiumId,
          int? year,
          int? month,
          String? forecastPeriod,
          double? forecast,
          double? value}) =>
      IncomeForecastData(
        condominiumId: condominiumId ?? this.condominiumId,
        year: year ?? this.year,
        month: month ?? this.month,
        forecastPeriod: forecastPeriod ?? this.forecastPeriod,
        forecast: forecast ?? this.forecast,
        value: value ?? this.value,
      );
  IncomeForecastData copyWithCompanion(IncomeForecastTableCompanion data) {
    return IncomeForecastData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      forecastPeriod: data.forecastPeriod.present
          ? data.forecastPeriod.value
          : this.forecastPeriod,
      forecast: data.forecast.present ? data.forecast.value : this.forecast,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeForecastData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('forecastPeriod: $forecastPeriod, ')
          ..write('forecast: $forecast, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(condominiumId, year, month, forecastPeriod, forecast, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeForecastData &&
          other.condominiumId == this.condominiumId &&
          other.year == this.year &&
          other.month == this.month &&
          other.forecastPeriod == this.forecastPeriod &&
          other.forecast == this.forecast &&
          other.value == this.value);
}

class IncomeForecastTableCompanion extends UpdateCompanion<IncomeForecastData> {
  final Value<String> condominiumId;
  final Value<int> year;
  final Value<int> month;
  final Value<String> forecastPeriod;
  final Value<double> forecast;
  final Value<double> value;
  final Value<int> rowid;
  const IncomeForecastTableCompanion({
    this.condominiumId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.forecastPeriod = const Value.absent(),
    this.forecast = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeForecastTableCompanion.insert({
    required String condominiumId,
    required int year,
    required int month,
    required String forecastPeriod,
    required double forecast,
    required double value,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        year = Value(year),
        month = Value(month),
        forecastPeriod = Value(forecastPeriod),
        forecast = Value(forecast),
        value = Value(value);
  static Insertable<IncomeForecastData> custom({
    Expression<String>? condominiumId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<String>? forecastPeriod,
    Expression<double>? forecast,
    Expression<double>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (forecastPeriod != null) 'forecast_period': forecastPeriod,
      if (forecast != null) 'forecast': forecast,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeForecastTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<int>? year,
      Value<int>? month,
      Value<String>? forecastPeriod,
      Value<double>? forecast,
      Value<double>? value,
      Value<int>? rowid}) {
    return IncomeForecastTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      year: year ?? this.year,
      month: month ?? this.month,
      forecastPeriod: forecastPeriod ?? this.forecastPeriod,
      forecast: forecast ?? this.forecast,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (forecastPeriod.present) {
      map['forecast_period'] = Variable<String>(forecastPeriod.value);
    }
    if (forecast.present) {
      map['forecast'] = Variable<double>(forecast.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeForecastTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('forecastPeriod: $forecastPeriod, ')
          ..write('forecast: $forecast, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeTableTable extends IncomeTable
    with TableInfo<$IncomeTableTable, IncomeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [condominiumId, value, year, month];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_table';
  @override
  VerificationContext validateIntegrity(Insertable<IncomeData> instance,
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
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, year, month};
  @override
  IncomeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
    );
  }

  @override
  $IncomeTableTable createAlias(String alias) {
    return $IncomeTableTable(attachedDatabase, alias);
  }
}

class IncomeData extends DataClass implements Insertable<IncomeData> {
  final String condominiumId;
  final double value;
  final int year;
  final int month;
  const IncomeData(
      {required this.condominiumId,
      required this.value,
      required this.year,
      required this.month});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['value'] = Variable<double>(value);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    return map;
  }

  IncomeTableCompanion toCompanion(bool nullToAbsent) {
    return IncomeTableCompanion(
      condominiumId: Value(condominiumId),
      value: Value(value),
      year: Value(year),
      month: Value(month),
    );
  }

  factory IncomeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      value: serializer.fromJson<double>(json['value']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'value': serializer.toJson<double>(value),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
    };
  }

  IncomeData copyWith(
          {String? condominiumId, double? value, int? year, int? month}) =>
      IncomeData(
        condominiumId: condominiumId ?? this.condominiumId,
        value: value ?? this.value,
        year: year ?? this.year,
        month: month ?? this.month,
      );
  IncomeData copyWithCompanion(IncomeTableCompanion data) {
    return IncomeData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      value: data.value.present ? data.value.value : this.value,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('value: $value, ')
          ..write('year: $year, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, value, year, month);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeData &&
          other.condominiumId == this.condominiumId &&
          other.value == this.value &&
          other.year == this.year &&
          other.month == this.month);
}

class IncomeTableCompanion extends UpdateCompanion<IncomeData> {
  final Value<String> condominiumId;
  final Value<double> value;
  final Value<int> year;
  final Value<int> month;
  final Value<int> rowid;
  const IncomeTableCompanion({
    this.condominiumId = const Value.absent(),
    this.value = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeTableCompanion.insert({
    required String condominiumId,
    required double value,
    required int year,
    required int month,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        value = Value(value),
        year = Value(year),
        month = Value(month);
  static Insertable<IncomeData> custom({
    Expression<String>? condominiumId,
    Expression<double>? value,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (value != null) 'value': value,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<double>? value,
      Value<int>? year,
      Value<int>? month,
      Value<int>? rowid}) {
    return IncomeTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      value: value ?? this.value,
      year: year ?? this.year,
      month: month ?? this.month,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('value: $value, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeShareTableTable extends IncomeShareTable
    with TableInfo<$IncomeShareTableTable, IncomeShareData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeShareTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
      'total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _shareMeta = const VerificationMeta('share');
  @override
  late final GeneratedColumn<double> share = GeneratedColumn<double>(
      'share', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [condominiumId, year, month, title, total, share, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_share_table';
  @override
  VerificationContext validateIntegrity(Insertable<IncomeShareData> instance,
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
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('share')) {
      context.handle(
          _shareMeta, share.isAcceptableOrUnknown(data['share']!, _shareMeta));
    } else if (isInserting) {
      context.missing(_shareMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, year, month, title};
  @override
  IncomeShareData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeShareData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total'])!,
      share: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}share'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
    );
  }

  @override
  $IncomeShareTableTable createAlias(String alias) {
    return $IncomeShareTableTable(attachedDatabase, alias);
  }
}

class IncomeShareData extends DataClass implements Insertable<IncomeShareData> {
  final String condominiumId;
  final int year;
  final int month;
  final String title;
  final int total;
  final double share;
  final String color;
  const IncomeShareData(
      {required this.condominiumId,
      required this.year,
      required this.month,
      required this.title,
      required this.total,
      required this.share,
      required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['title'] = Variable<String>(title);
    map['total'] = Variable<int>(total);
    map['share'] = Variable<double>(share);
    map['color'] = Variable<String>(color);
    return map;
  }

  IncomeShareTableCompanion toCompanion(bool nullToAbsent) {
    return IncomeShareTableCompanion(
      condominiumId: Value(condominiumId),
      year: Value(year),
      month: Value(month),
      title: Value(title),
      total: Value(total),
      share: Value(share),
      color: Value(color),
    );
  }

  factory IncomeShareData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeShareData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      title: serializer.fromJson<String>(json['title']),
      total: serializer.fromJson<int>(json['total']),
      share: serializer.fromJson<double>(json['share']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'title': serializer.toJson<String>(title),
      'total': serializer.toJson<int>(total),
      'share': serializer.toJson<double>(share),
      'color': serializer.toJson<String>(color),
    };
  }

  IncomeShareData copyWith(
          {String? condominiumId,
          int? year,
          int? month,
          String? title,
          int? total,
          double? share,
          String? color}) =>
      IncomeShareData(
        condominiumId: condominiumId ?? this.condominiumId,
        year: year ?? this.year,
        month: month ?? this.month,
        title: title ?? this.title,
        total: total ?? this.total,
        share: share ?? this.share,
        color: color ?? this.color,
      );
  IncomeShareData copyWithCompanion(IncomeShareTableCompanion data) {
    return IncomeShareData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      title: data.title.present ? data.title.value : this.title,
      total: data.total.present ? data.total.value : this.total,
      share: data.share.present ? data.share.value : this.share,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeShareData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('title: $title, ')
          ..write('total: $total, ')
          ..write('share: $share, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(condominiumId, year, month, title, total, share, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeShareData &&
          other.condominiumId == this.condominiumId &&
          other.year == this.year &&
          other.month == this.month &&
          other.title == this.title &&
          other.total == this.total &&
          other.share == this.share &&
          other.color == this.color);
}

class IncomeShareTableCompanion extends UpdateCompanion<IncomeShareData> {
  final Value<String> condominiumId;
  final Value<int> year;
  final Value<int> month;
  final Value<String> title;
  final Value<int> total;
  final Value<double> share;
  final Value<String> color;
  final Value<int> rowid;
  const IncomeShareTableCompanion({
    this.condominiumId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.title = const Value.absent(),
    this.total = const Value.absent(),
    this.share = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeShareTableCompanion.insert({
    required String condominiumId,
    required int year,
    required int month,
    required String title,
    required int total,
    required double share,
    required String color,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        year = Value(year),
        month = Value(month),
        title = Value(title),
        total = Value(total),
        share = Value(share),
        color = Value(color);
  static Insertable<IncomeShareData> custom({
    Expression<String>? condominiumId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<String>? title,
    Expression<int>? total,
    Expression<double>? share,
    Expression<String>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (title != null) 'title': title,
      if (total != null) 'total': total,
      if (share != null) 'share': share,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeShareTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<int>? year,
      Value<int>? month,
      Value<String>? title,
      Value<int>? total,
      Value<double>? share,
      Value<String>? color,
      Value<int>? rowid}) {
    return IncomeShareTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      year: year ?? this.year,
      month: month ?? this.month,
      title: title ?? this.title,
      total: total ?? this.total,
      share: share ?? this.share,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (share.present) {
      map['share'] = Variable<double>(share.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeShareTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('title: $title, ')
          ..write('total: $total, ')
          ..write('share: $share, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatContactTableTable extends ChatContactTable
    with TableInfo<$ChatContactTableTable, ChatContactData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatContactTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitTitleMeta =
      const VerificationMeta('unitTitle');
  @override
  late final GeneratedColumn<String> unitTitle = GeneratedColumn<String>(
      'unit_title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitGroupMeta =
      const VerificationMeta('unitGroup');
  @override
  late final GeneratedColumn<String> unitGroup = GeneratedColumn<String>(
      'unit_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, condominiumId, unitId, unitTitle, unitGroup, phone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_contact_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChatContactData> instance,
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
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    }
    if (data.containsKey('unit_title')) {
      context.handle(_unitTitleMeta,
          unitTitle.isAcceptableOrUnknown(data['unit_title']!, _unitTitleMeta));
    }
    if (data.containsKey('unit_group')) {
      context.handle(_unitGroupMeta,
          unitGroup.isAcceptableOrUnknown(data['unit_group']!, _unitGroupMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, id};
  @override
  ChatContactData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatContactData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id']),
      unitTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_title']),
      unitGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_group']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
    );
  }

  @override
  $ChatContactTableTable createAlias(String alias) {
    return $ChatContactTableTable(attachedDatabase, alias);
  }
}

class ChatContactData extends DataClass implements Insertable<ChatContactData> {
  final String id;
  final String condominiumId;
  final String? unitId;
  final String? unitTitle;
  final String? unitGroup;
  final String? phone;
  const ChatContactData(
      {required this.id,
      required this.condominiumId,
      this.unitId,
      this.unitTitle,
      this.unitGroup,
      this.phone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['condominium_id'] = Variable<String>(condominiumId);
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<String>(unitId);
    }
    if (!nullToAbsent || unitTitle != null) {
      map['unit_title'] = Variable<String>(unitTitle);
    }
    if (!nullToAbsent || unitGroup != null) {
      map['unit_group'] = Variable<String>(unitGroup);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    return map;
  }

  ChatContactTableCompanion toCompanion(bool nullToAbsent) {
    return ChatContactTableCompanion(
      id: Value(id),
      condominiumId: Value(condominiumId),
      unitId:
          unitId == null && nullToAbsent ? const Value.absent() : Value(unitId),
      unitTitle: unitTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(unitTitle),
      unitGroup: unitGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(unitGroup),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
    );
  }

  factory ChatContactData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatContactData(
      id: serializer.fromJson<String>(json['id']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      unitId: serializer.fromJson<String?>(json['unitId']),
      unitTitle: serializer.fromJson<String?>(json['unitTitle']),
      unitGroup: serializer.fromJson<String?>(json['unitGroup']),
      phone: serializer.fromJson<String?>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'unitId': serializer.toJson<String?>(unitId),
      'unitTitle': serializer.toJson<String?>(unitTitle),
      'unitGroup': serializer.toJson<String?>(unitGroup),
      'phone': serializer.toJson<String?>(phone),
    };
  }

  ChatContactData copyWith(
          {String? id,
          String? condominiumId,
          Value<String?> unitId = const Value.absent(),
          Value<String?> unitTitle = const Value.absent(),
          Value<String?> unitGroup = const Value.absent(),
          Value<String?> phone = const Value.absent()}) =>
      ChatContactData(
        id: id ?? this.id,
        condominiumId: condominiumId ?? this.condominiumId,
        unitId: unitId.present ? unitId.value : this.unitId,
        unitTitle: unitTitle.present ? unitTitle.value : this.unitTitle,
        unitGroup: unitGroup.present ? unitGroup.value : this.unitGroup,
        phone: phone.present ? phone.value : this.phone,
      );
  ChatContactData copyWithCompanion(ChatContactTableCompanion data) {
    return ChatContactData(
      id: data.id.present ? data.id.value : this.id,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      unitTitle: data.unitTitle.present ? data.unitTitle.value : this.unitTitle,
      unitGroup: data.unitGroup.present ? data.unitGroup.value : this.unitGroup,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatContactData(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('unitId: $unitId, ')
          ..write('unitTitle: $unitTitle, ')
          ..write('unitGroup: $unitGroup, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, condominiumId, unitId, unitTitle, unitGroup, phone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatContactData &&
          other.id == this.id &&
          other.condominiumId == this.condominiumId &&
          other.unitId == this.unitId &&
          other.unitTitle == this.unitTitle &&
          other.unitGroup == this.unitGroup &&
          other.phone == this.phone);
}

class ChatContactTableCompanion extends UpdateCompanion<ChatContactData> {
  final Value<String> id;
  final Value<String> condominiumId;
  final Value<String?> unitId;
  final Value<String?> unitTitle;
  final Value<String?> unitGroup;
  final Value<String?> phone;
  final Value<int> rowid;
  const ChatContactTableCompanion({
    this.id = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.unitTitle = const Value.absent(),
    this.unitGroup = const Value.absent(),
    this.phone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatContactTableCompanion.insert({
    required String id,
    required String condominiumId,
    this.unitId = const Value.absent(),
    this.unitTitle = const Value.absent(),
    this.unitGroup = const Value.absent(),
    this.phone = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        condominiumId = Value(condominiumId);
  static Insertable<ChatContactData> custom({
    Expression<String>? id,
    Expression<String>? condominiumId,
    Expression<String>? unitId,
    Expression<String>? unitTitle,
    Expression<String>? unitGroup,
    Expression<String>? phone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (unitId != null) 'unit_id': unitId,
      if (unitTitle != null) 'unit_title': unitTitle,
      if (unitGroup != null) 'unit_group': unitGroup,
      if (phone != null) 'phone': phone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatContactTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? condominiumId,
      Value<String?>? unitId,
      Value<String?>? unitTitle,
      Value<String?>? unitGroup,
      Value<String?>? phone,
      Value<int>? rowid}) {
    return ChatContactTableCompanion(
      id: id ?? this.id,
      condominiumId: condominiumId ?? this.condominiumId,
      unitId: unitId ?? this.unitId,
      unitTitle: unitTitle ?? this.unitTitle,
      unitGroup: unitGroup ?? this.unitGroup,
      phone: phone ?? this.phone,
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
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (unitTitle.present) {
      map['unit_title'] = Variable<String>(unitTitle.value);
    }
    if (unitGroup.present) {
      map['unit_group'] = Variable<String>(unitGroup.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatContactTableCompanion(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('unitId: $unitId, ')
          ..write('unitTitle: $unitTitle, ')
          ..write('unitGroup: $unitGroup, ')
          ..write('phone: $phone, ')
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

class $ReservationSummaryTableTable extends ReservationSummaryTable
    with TableInfo<$ReservationSummaryTableTable, ReservationSummaryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservationSummaryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
      'day', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [day, condominiumId, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reservation_summary_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReservationSummaryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, day, type};
  @override
  ReservationSummaryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReservationSummaryData(
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}day'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
    );
  }

  @override
  $ReservationSummaryTableTable createAlias(String alias) {
    return $ReservationSummaryTableTable(attachedDatabase, alias);
  }
}

class ReservationSummaryData extends DataClass
    implements Insertable<ReservationSummaryData> {
  final DateTime day;
  final String condominiumId;
  final String type;
  const ReservationSummaryData(
      {required this.day, required this.condominiumId, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<DateTime>(day);
    map['condominium_id'] = Variable<String>(condominiumId);
    map['type'] = Variable<String>(type);
    return map;
  }

  ReservationSummaryTableCompanion toCompanion(bool nullToAbsent) {
    return ReservationSummaryTableCompanion(
      day: Value(day),
      condominiumId: Value(condominiumId),
      type: Value(type),
    );
  }

  factory ReservationSummaryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReservationSummaryData(
      day: serializer.fromJson<DateTime>(json['day']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<DateTime>(day),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'type': serializer.toJson<String>(type),
    };
  }

  ReservationSummaryData copyWith(
          {DateTime? day, String? condominiumId, String? type}) =>
      ReservationSummaryData(
        day: day ?? this.day,
        condominiumId: condominiumId ?? this.condominiumId,
        type: type ?? this.type,
      );
  ReservationSummaryData copyWithCompanion(
      ReservationSummaryTableCompanion data) {
    return ReservationSummaryData(
      day: data.day.present ? data.day.value : this.day,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReservationSummaryData(')
          ..write('day: $day, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, condominiumId, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReservationSummaryData &&
          other.day == this.day &&
          other.condominiumId == this.condominiumId &&
          other.type == this.type);
}

class ReservationSummaryTableCompanion
    extends UpdateCompanion<ReservationSummaryData> {
  final Value<DateTime> day;
  final Value<String> condominiumId;
  final Value<String> type;
  final Value<int> rowid;
  const ReservationSummaryTableCompanion({
    this.day = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservationSummaryTableCompanion.insert({
    required DateTime day,
    required String condominiumId,
    required String type,
    this.rowid = const Value.absent(),
  })  : day = Value(day),
        condominiumId = Value(condominiumId),
        type = Value(type);
  static Insertable<ReservationSummaryData> custom({
    Expression<DateTime>? day,
    Expression<String>? condominiumId,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservationSummaryTableCompanion copyWith(
      {Value<DateTime>? day,
      Value<String>? condominiumId,
      Value<String>? type,
      Value<int>? rowid}) {
    return ReservationSummaryTableCompanion(
      day: day ?? this.day,
      condominiumId: condominiumId ?? this.condominiumId,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservationSummaryTableCompanion(')
          ..write('day: $day, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpaceTableTable extends SpaceTable
    with TableInfo<$SpaceTableTable, SpaceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpaceTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _pictureUrlMeta =
      const VerificationMeta('pictureUrl');
  @override
  late final GeneratedColumn<String> pictureUrl = GeneratedColumn<String>(
      'picture_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, pictureUrl, condominiumId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'space_table';
  @override
  VerificationContext validateIntegrity(Insertable<SpaceData> instance,
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
    if (data.containsKey('picture_url')) {
      context.handle(
          _pictureUrlMeta,
          pictureUrl.isAcceptableOrUnknown(
              data['picture_url']!, _pictureUrlMeta));
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId, id};
  @override
  SpaceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpaceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      pictureUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture_url']),
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
    );
  }

  @override
  $SpaceTableTable createAlias(String alias) {
    return $SpaceTableTable(attachedDatabase, alias);
  }
}

class SpaceData extends DataClass implements Insertable<SpaceData> {
  final String id;
  final String? name;
  final String? pictureUrl;
  final String condominiumId;
  const SpaceData(
      {required this.id,
      this.name,
      this.pictureUrl,
      required this.condominiumId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || pictureUrl != null) {
      map['picture_url'] = Variable<String>(pictureUrl);
    }
    map['condominium_id'] = Variable<String>(condominiumId);
    return map;
  }

  SpaceTableCompanion toCompanion(bool nullToAbsent) {
    return SpaceTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      pictureUrl: pictureUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(pictureUrl),
      condominiumId: Value(condominiumId),
    );
  }

  factory SpaceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpaceData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      pictureUrl: serializer.fromJson<String?>(json['pictureUrl']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'pictureUrl': serializer.toJson<String?>(pictureUrl),
      'condominiumId': serializer.toJson<String>(condominiumId),
    };
  }

  SpaceData copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          Value<String?> pictureUrl = const Value.absent(),
          String? condominiumId}) =>
      SpaceData(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        pictureUrl: pictureUrl.present ? pictureUrl.value : this.pictureUrl,
        condominiumId: condominiumId ?? this.condominiumId,
      );
  SpaceData copyWithCompanion(SpaceTableCompanion data) {
    return SpaceData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pictureUrl:
          data.pictureUrl.present ? data.pictureUrl.value : this.pictureUrl,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpaceData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pictureUrl: $pictureUrl, ')
          ..write('condominiumId: $condominiumId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, pictureUrl, condominiumId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpaceData &&
          other.id == this.id &&
          other.name == this.name &&
          other.pictureUrl == this.pictureUrl &&
          other.condominiumId == this.condominiumId);
}

class SpaceTableCompanion extends UpdateCompanion<SpaceData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> pictureUrl;
  final Value<String> condominiumId;
  final Value<int> rowid;
  const SpaceTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pictureUrl = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpaceTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.pictureUrl = const Value.absent(),
    required String condominiumId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        condominiumId = Value(condominiumId);
  static Insertable<SpaceData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? pictureUrl,
    Expression<String>? condominiumId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pictureUrl != null) 'picture_url': pictureUrl,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpaceTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<String?>? pictureUrl,
      Value<String>? condominiumId,
      Value<int>? rowid}) {
    return SpaceTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      condominiumId: condominiumId ?? this.condominiumId,
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
    if (pictureUrl.present) {
      map['picture_url'] = Variable<String>(pictureUrl.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpaceTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pictureUrl: $pictureUrl, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CondominiumBalanceTableTable extends CondominiumBalanceTable
    with TableInfo<$CondominiumBalanceTableTable, CondominiumBalanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CondominiumBalanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _previousBalanceMeta =
      const VerificationMeta('previousBalance');
  @override
  late final GeneratedColumn<double> previousBalance = GeneratedColumn<double>(
      'previous_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _forecastMeta =
      const VerificationMeta('forecast');
  @override
  late final GeneratedColumn<double> forecast = GeneratedColumn<double>(
      'forecast', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _incomeMeta = const VerificationMeta('income');
  @override
  late final GeneratedColumn<double> income = GeneratedColumn<double>(
      'income', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _expensesMeta =
      const VerificationMeta('expenses');
  @override
  late final GeneratedColumn<double> expenses = GeneratedColumn<double>(
      'expenses', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>('last_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        reference,
        balance,
        previousBalance,
        forecast,
        income,
        expenses,
        date,
        lastUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condominium_balance_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CondominiumBalanceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('previous_balance')) {
      context.handle(
          _previousBalanceMeta,
          previousBalance.isAcceptableOrUnknown(
              data['previous_balance']!, _previousBalanceMeta));
    }
    if (data.containsKey('forecast')) {
      context.handle(_forecastMeta,
          forecast.isAcceptableOrUnknown(data['forecast']!, _forecastMeta));
    }
    if (data.containsKey('income')) {
      context.handle(_incomeMeta,
          income.isAcceptableOrUnknown(data['income']!, _incomeMeta));
    }
    if (data.containsKey('expenses')) {
      context.handle(_expensesMeta,
          expenses.isAcceptableOrUnknown(data['expenses']!, _expensesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {reference};
  @override
  CondominiumBalanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CondominiumBalanceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance']),
      previousBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}previous_balance']),
      forecast: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}forecast']),
      income: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}income']),
      expenses: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}expenses']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      lastUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_updated_at']),
    );
  }

  @override
  $CondominiumBalanceTableTable createAlias(String alias) {
    return $CondominiumBalanceTableTable(attachedDatabase, alias);
  }
}

class CondominiumBalanceData extends DataClass
    implements Insertable<CondominiumBalanceData> {
  final String? id;
  final String reference;
  final double? balance;
  final double? previousBalance;
  final double? forecast;
  final double? income;
  final double? expenses;
  final DateTime? date;
  final DateTime? lastUpdatedAt;
  const CondominiumBalanceData(
      {this.id,
      required this.reference,
      this.balance,
      this.previousBalance,
      this.forecast,
      this.income,
      this.expenses,
      this.date,
      this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || balance != null) {
      map['balance'] = Variable<double>(balance);
    }
    if (!nullToAbsent || previousBalance != null) {
      map['previous_balance'] = Variable<double>(previousBalance);
    }
    if (!nullToAbsent || forecast != null) {
      map['forecast'] = Variable<double>(forecast);
    }
    if (!nullToAbsent || income != null) {
      map['income'] = Variable<double>(income);
    }
    if (!nullToAbsent || expenses != null) {
      map['expenses'] = Variable<double>(expenses);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || lastUpdatedAt != null) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    }
    return map;
  }

  CondominiumBalanceTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumBalanceTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      reference: Value(reference),
      balance: balance == null && nullToAbsent
          ? const Value.absent()
          : Value(balance),
      previousBalance: previousBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(previousBalance),
      forecast: forecast == null && nullToAbsent
          ? const Value.absent()
          : Value(forecast),
      income:
          income == null && nullToAbsent ? const Value.absent() : Value(income),
      expenses: expenses == null && nullToAbsent
          ? const Value.absent()
          : Value(expenses),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      lastUpdatedAt: lastUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdatedAt),
    );
  }

  factory CondominiumBalanceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumBalanceData(
      id: serializer.fromJson<String?>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      balance: serializer.fromJson<double?>(json['balance']),
      previousBalance: serializer.fromJson<double?>(json['previousBalance']),
      forecast: serializer.fromJson<double?>(json['forecast']),
      income: serializer.fromJson<double?>(json['income']),
      expenses: serializer.fromJson<double?>(json['expenses']),
      date: serializer.fromJson<DateTime?>(json['date']),
      lastUpdatedAt: serializer.fromJson<DateTime?>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'reference': serializer.toJson<String>(reference),
      'balance': serializer.toJson<double?>(balance),
      'previousBalance': serializer.toJson<double?>(previousBalance),
      'forecast': serializer.toJson<double?>(forecast),
      'income': serializer.toJson<double?>(income),
      'expenses': serializer.toJson<double?>(expenses),
      'date': serializer.toJson<DateTime?>(date),
      'lastUpdatedAt': serializer.toJson<DateTime?>(lastUpdatedAt),
    };
  }

  CondominiumBalanceData copyWith(
          {Value<String?> id = const Value.absent(),
          String? reference,
          Value<double?> balance = const Value.absent(),
          Value<double?> previousBalance = const Value.absent(),
          Value<double?> forecast = const Value.absent(),
          Value<double?> income = const Value.absent(),
          Value<double?> expenses = const Value.absent(),
          Value<DateTime?> date = const Value.absent(),
          Value<DateTime?> lastUpdatedAt = const Value.absent()}) =>
      CondominiumBalanceData(
        id: id.present ? id.value : this.id,
        reference: reference ?? this.reference,
        balance: balance.present ? balance.value : this.balance,
        previousBalance: previousBalance.present
            ? previousBalance.value
            : this.previousBalance,
        forecast: forecast.present ? forecast.value : this.forecast,
        income: income.present ? income.value : this.income,
        expenses: expenses.present ? expenses.value : this.expenses,
        date: date.present ? date.value : this.date,
        lastUpdatedAt:
            lastUpdatedAt.present ? lastUpdatedAt.value : this.lastUpdatedAt,
      );
  CondominiumBalanceData copyWithCompanion(
      CondominiumBalanceTableCompanion data) {
    return CondominiumBalanceData(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      balance: data.balance.present ? data.balance.value : this.balance,
      previousBalance: data.previousBalance.present
          ? data.previousBalance.value
          : this.previousBalance,
      forecast: data.forecast.present ? data.forecast.value : this.forecast,
      income: data.income.present ? data.income.value : this.income,
      expenses: data.expenses.present ? data.expenses.value : this.expenses,
      date: data.date.present ? data.date.value : this.date,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceData(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('balance: $balance, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('forecast: $forecast, ')
          ..write('income: $income, ')
          ..write('expenses: $expenses, ')
          ..write('date: $date, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, reference, balance, previousBalance,
      forecast, income, expenses, date, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumBalanceData &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.balance == this.balance &&
          other.previousBalance == this.previousBalance &&
          other.forecast == this.forecast &&
          other.income == this.income &&
          other.expenses == this.expenses &&
          other.date == this.date &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class CondominiumBalanceTableCompanion
    extends UpdateCompanion<CondominiumBalanceData> {
  final Value<String?> id;
  final Value<String> reference;
  final Value<double?> balance;
  final Value<double?> previousBalance;
  final Value<double?> forecast;
  final Value<double?> income;
  final Value<double?> expenses;
  final Value<DateTime?> date;
  final Value<DateTime?> lastUpdatedAt;
  final Value<int> rowid;
  const CondominiumBalanceTableCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.balance = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.forecast = const Value.absent(),
    this.income = const Value.absent(),
    this.expenses = const Value.absent(),
    this.date = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumBalanceTableCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    this.balance = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.forecast = const Value.absent(),
    this.income = const Value.absent(),
    this.expenses = const Value.absent(),
    this.date = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : reference = Value(reference);
  static Insertable<CondominiumBalanceData> custom({
    Expression<String>? id,
    Expression<String>? reference,
    Expression<double>? balance,
    Expression<double>? previousBalance,
    Expression<double>? forecast,
    Expression<double>? income,
    Expression<double>? expenses,
    Expression<DateTime>? date,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (balance != null) 'balance': balance,
      if (previousBalance != null) 'previous_balance': previousBalance,
      if (forecast != null) 'forecast': forecast,
      if (income != null) 'income': income,
      if (expenses != null) 'expenses': expenses,
      if (date != null) 'date': date,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumBalanceTableCompanion copyWith(
      {Value<String?>? id,
      Value<String>? reference,
      Value<double?>? balance,
      Value<double?>? previousBalance,
      Value<double?>? forecast,
      Value<double?>? income,
      Value<double?>? expenses,
      Value<DateTime?>? date,
      Value<DateTime?>? lastUpdatedAt,
      Value<int>? rowid}) {
    return CondominiumBalanceTableCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      balance: balance ?? this.balance,
      previousBalance: previousBalance ?? this.previousBalance,
      forecast: forecast ?? this.forecast,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
      date: date ?? this.date,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
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
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (previousBalance.present) {
      map['previous_balance'] = Variable<double>(previousBalance.value);
    }
    if (forecast.present) {
      map['forecast'] = Variable<double>(forecast.value);
    }
    if (income.present) {
      map['income'] = Variable<double>(income.value);
    }
    if (expenses.present) {
      map['expenses'] = Variable<double>(expenses.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceTableCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('balance: $balance, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('forecast: $forecast, ')
          ..write('income: $income, ')
          ..write('expenses: $expenses, ')
          ..write('date: $date, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CondominiumBalanceDetailTableTable extends CondominiumBalanceDetailTable
    with
        TableInfo<$CondominiumBalanceDetailTableTable,
            CondominiumBalanceDetailData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CondominiumBalanceDetailTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousBalanceMeta =
      const VerificationMeta('previousBalance');
  @override
  late final GeneratedColumn<double> previousBalance = GeneratedColumn<double>(
      'previous_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _accountBalanceMeta =
      const VerificationMeta('accountBalance');
  @override
  late final GeneratedColumn<double> accountBalance = GeneratedColumn<double>(
      'account_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
      'debit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
      'credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>('last_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        reference,
        previousBalance,
        balance,
        accountBalance,
        debit,
        credits,
        lastUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condominium_balance_detail_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CondominiumBalanceDetailData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('previous_balance')) {
      context.handle(
          _previousBalanceMeta,
          previousBalance.isAcceptableOrUnknown(
              data['previous_balance']!, _previousBalanceMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('account_balance')) {
      context.handle(
          _accountBalanceMeta,
          accountBalance.isAcceptableOrUnknown(
              data['account_balance']!, _accountBalanceMeta));
    }
    if (data.containsKey('debit')) {
      context.handle(
          _debitMeta, debit.isAcceptableOrUnknown(data['debit']!, _debitMeta));
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CondominiumBalanceDetailData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CondominiumBalanceDetailData(
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      previousBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}previous_balance']),
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance']),
      accountBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}account_balance']),
      debit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debit']),
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credits']),
      lastUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_updated_at']),
    );
  }

  @override
  $CondominiumBalanceDetailTableTable createAlias(String alias) {
    return $CondominiumBalanceDetailTableTable(attachedDatabase, alias);
  }
}

class CondominiumBalanceDetailData extends DataClass
    implements Insertable<CondominiumBalanceDetailData> {
  final String reference;
  final double? previousBalance;
  final double? balance;
  final double? accountBalance;
  final double? debit;
  final double? credits;
  final DateTime? lastUpdatedAt;
  const CondominiumBalanceDetailData(
      {required this.reference,
      this.previousBalance,
      this.balance,
      this.accountBalance,
      this.debit,
      this.credits,
      this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || previousBalance != null) {
      map['previous_balance'] = Variable<double>(previousBalance);
    }
    if (!nullToAbsent || balance != null) {
      map['balance'] = Variable<double>(balance);
    }
    if (!nullToAbsent || accountBalance != null) {
      map['account_balance'] = Variable<double>(accountBalance);
    }
    if (!nullToAbsent || debit != null) {
      map['debit'] = Variable<double>(debit);
    }
    if (!nullToAbsent || credits != null) {
      map['credits'] = Variable<double>(credits);
    }
    if (!nullToAbsent || lastUpdatedAt != null) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    }
    return map;
  }

  CondominiumBalanceDetailTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumBalanceDetailTableCompanion(
      reference: Value(reference),
      previousBalance: previousBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(previousBalance),
      balance: balance == null && nullToAbsent
          ? const Value.absent()
          : Value(balance),
      accountBalance: accountBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(accountBalance),
      debit:
          debit == null && nullToAbsent ? const Value.absent() : Value(debit),
      credits: credits == null && nullToAbsent
          ? const Value.absent()
          : Value(credits),
      lastUpdatedAt: lastUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdatedAt),
    );
  }

  factory CondominiumBalanceDetailData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumBalanceDetailData(
      reference: serializer.fromJson<String>(json['reference']),
      previousBalance: serializer.fromJson<double?>(json['previousBalance']),
      balance: serializer.fromJson<double?>(json['balance']),
      accountBalance: serializer.fromJson<double?>(json['accountBalance']),
      debit: serializer.fromJson<double?>(json['debit']),
      credits: serializer.fromJson<double?>(json['credits']),
      lastUpdatedAt: serializer.fromJson<DateTime?>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reference': serializer.toJson<String>(reference),
      'previousBalance': serializer.toJson<double?>(previousBalance),
      'balance': serializer.toJson<double?>(balance),
      'accountBalance': serializer.toJson<double?>(accountBalance),
      'debit': serializer.toJson<double?>(debit),
      'credits': serializer.toJson<double?>(credits),
      'lastUpdatedAt': serializer.toJson<DateTime?>(lastUpdatedAt),
    };
  }

  CondominiumBalanceDetailData copyWith(
          {String? reference,
          Value<double?> previousBalance = const Value.absent(),
          Value<double?> balance = const Value.absent(),
          Value<double?> accountBalance = const Value.absent(),
          Value<double?> debit = const Value.absent(),
          Value<double?> credits = const Value.absent(),
          Value<DateTime?> lastUpdatedAt = const Value.absent()}) =>
      CondominiumBalanceDetailData(
        reference: reference ?? this.reference,
        previousBalance: previousBalance.present
            ? previousBalance.value
            : this.previousBalance,
        balance: balance.present ? balance.value : this.balance,
        accountBalance:
            accountBalance.present ? accountBalance.value : this.accountBalance,
        debit: debit.present ? debit.value : this.debit,
        credits: credits.present ? credits.value : this.credits,
        lastUpdatedAt:
            lastUpdatedAt.present ? lastUpdatedAt.value : this.lastUpdatedAt,
      );
  CondominiumBalanceDetailData copyWithCompanion(
      CondominiumBalanceDetailTableCompanion data) {
    return CondominiumBalanceDetailData(
      reference: data.reference.present ? data.reference.value : this.reference,
      previousBalance: data.previousBalance.present
          ? data.previousBalance.value
          : this.previousBalance,
      balance: data.balance.present ? data.balance.value : this.balance,
      accountBalance: data.accountBalance.present
          ? data.accountBalance.value
          : this.accountBalance,
      debit: data.debit.present ? data.debit.value : this.debit,
      credits: data.credits.present ? data.credits.value : this.credits,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceDetailData(')
          ..write('reference: $reference, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('balance: $balance, ')
          ..write('accountBalance: $accountBalance, ')
          ..write('debit: $debit, ')
          ..write('credits: $credits, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(reference, previousBalance, balance,
      accountBalance, debit, credits, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumBalanceDetailData &&
          other.reference == this.reference &&
          other.previousBalance == this.previousBalance &&
          other.balance == this.balance &&
          other.accountBalance == this.accountBalance &&
          other.debit == this.debit &&
          other.credits == this.credits &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class CondominiumBalanceDetailTableCompanion
    extends UpdateCompanion<CondominiumBalanceDetailData> {
  final Value<String> reference;
  final Value<double?> previousBalance;
  final Value<double?> balance;
  final Value<double?> accountBalance;
  final Value<double?> debit;
  final Value<double?> credits;
  final Value<DateTime?> lastUpdatedAt;
  final Value<int> rowid;
  const CondominiumBalanceDetailTableCompanion({
    this.reference = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.balance = const Value.absent(),
    this.accountBalance = const Value.absent(),
    this.debit = const Value.absent(),
    this.credits = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumBalanceDetailTableCompanion.insert({
    required String reference,
    this.previousBalance = const Value.absent(),
    this.balance = const Value.absent(),
    this.accountBalance = const Value.absent(),
    this.debit = const Value.absent(),
    this.credits = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : reference = Value(reference);
  static Insertable<CondominiumBalanceDetailData> custom({
    Expression<String>? reference,
    Expression<double>? previousBalance,
    Expression<double>? balance,
    Expression<double>? accountBalance,
    Expression<double>? debit,
    Expression<double>? credits,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reference != null) 'reference': reference,
      if (previousBalance != null) 'previous_balance': previousBalance,
      if (balance != null) 'balance': balance,
      if (accountBalance != null) 'account_balance': accountBalance,
      if (debit != null) 'debit': debit,
      if (credits != null) 'credits': credits,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumBalanceDetailTableCompanion copyWith(
      {Value<String>? reference,
      Value<double?>? previousBalance,
      Value<double?>? balance,
      Value<double?>? accountBalance,
      Value<double?>? debit,
      Value<double?>? credits,
      Value<DateTime?>? lastUpdatedAt,
      Value<int>? rowid}) {
    return CondominiumBalanceDetailTableCompanion(
      reference: reference ?? this.reference,
      previousBalance: previousBalance ?? this.previousBalance,
      balance: balance ?? this.balance,
      accountBalance: accountBalance ?? this.accountBalance,
      debit: debit ?? this.debit,
      credits: credits ?? this.credits,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (previousBalance.present) {
      map['previous_balance'] = Variable<double>(previousBalance.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (accountBalance.present) {
      map['account_balance'] = Variable<double>(accountBalance.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceDetailTableCompanion(')
          ..write('reference: $reference, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('balance: $balance, ')
          ..write('accountBalance: $accountBalance, ')
          ..write('debit: $debit, ')
          ..write('credits: $credits, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CondominiumBalanceDebitsTableTable extends CondominiumBalanceDebitsTable
    with
        TableInfo<$CondominiumBalanceDebitsTableTable,
            CondominiumBalanceDebitsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CondominiumBalanceDebitsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _previousBalanceMeta =
      const VerificationMeta('previousBalance');
  @override
  late final GeneratedColumn<double> previousBalance = GeneratedColumn<double>(
      'previous_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _accountBalanceMeta =
      const VerificationMeta('accountBalance');
  @override
  late final GeneratedColumn<double> accountBalance = GeneratedColumn<double>(
      'account_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
      'debit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
      'credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<DateTime> period = GeneratedColumn<DateTime>(
      'period', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        reference,
        id,
        name,
        type,
        previousBalance,
        balance,
        accountBalance,
        debit,
        credits,
        period
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condominium_balance_debits_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CondominiumBalanceDebitsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('previous_balance')) {
      context.handle(
          _previousBalanceMeta,
          previousBalance.isAcceptableOrUnknown(
              data['previous_balance']!, _previousBalanceMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('account_balance')) {
      context.handle(
          _accountBalanceMeta,
          accountBalance.isAcceptableOrUnknown(
              data['account_balance']!, _accountBalanceMeta));
    }
    if (data.containsKey('debit')) {
      context.handle(
          _debitMeta, debit.isAcceptableOrUnknown(data['debit']!, _debitMeta));
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    }
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period']!, _periodMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CondominiumBalanceDebitsData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CondominiumBalanceDebitsData(
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      previousBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}previous_balance']),
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance']),
      accountBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}account_balance']),
      debit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debit']),
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credits']),
      period: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period']),
    );
  }

  @override
  $CondominiumBalanceDebitsTableTable createAlias(String alias) {
    return $CondominiumBalanceDebitsTableTable(attachedDatabase, alias);
  }
}

class CondominiumBalanceDebitsData extends DataClass
    implements Insertable<CondominiumBalanceDebitsData> {
  final String reference;
  final String? id;
  final String? name;
  final String? type;
  final double? previousBalance;
  final double? balance;
  final double? accountBalance;
  final double? debit;
  final double? credits;
  final DateTime? period;
  const CondominiumBalanceDebitsData(
      {required this.reference,
      this.id,
      this.name,
      this.type,
      this.previousBalance,
      this.balance,
      this.accountBalance,
      this.debit,
      this.credits,
      this.period});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || previousBalance != null) {
      map['previous_balance'] = Variable<double>(previousBalance);
    }
    if (!nullToAbsent || balance != null) {
      map['balance'] = Variable<double>(balance);
    }
    if (!nullToAbsent || accountBalance != null) {
      map['account_balance'] = Variable<double>(accountBalance);
    }
    if (!nullToAbsent || debit != null) {
      map['debit'] = Variable<double>(debit);
    }
    if (!nullToAbsent || credits != null) {
      map['credits'] = Variable<double>(credits);
    }
    if (!nullToAbsent || period != null) {
      map['period'] = Variable<DateTime>(period);
    }
    return map;
  }

  CondominiumBalanceDebitsTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumBalanceDebitsTableCompanion(
      reference: Value(reference),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      previousBalance: previousBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(previousBalance),
      balance: balance == null && nullToAbsent
          ? const Value.absent()
          : Value(balance),
      accountBalance: accountBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(accountBalance),
      debit:
          debit == null && nullToAbsent ? const Value.absent() : Value(debit),
      credits: credits == null && nullToAbsent
          ? const Value.absent()
          : Value(credits),
      period:
          period == null && nullToAbsent ? const Value.absent() : Value(period),
    );
  }

  factory CondominiumBalanceDebitsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumBalanceDebitsData(
      reference: serializer.fromJson<String>(json['reference']),
      id: serializer.fromJson<String?>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      type: serializer.fromJson<String?>(json['type']),
      previousBalance: serializer.fromJson<double?>(json['previousBalance']),
      balance: serializer.fromJson<double?>(json['balance']),
      accountBalance: serializer.fromJson<double?>(json['accountBalance']),
      debit: serializer.fromJson<double?>(json['debit']),
      credits: serializer.fromJson<double?>(json['credits']),
      period: serializer.fromJson<DateTime?>(json['period']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reference': serializer.toJson<String>(reference),
      'id': serializer.toJson<String?>(id),
      'name': serializer.toJson<String?>(name),
      'type': serializer.toJson<String?>(type),
      'previousBalance': serializer.toJson<double?>(previousBalance),
      'balance': serializer.toJson<double?>(balance),
      'accountBalance': serializer.toJson<double?>(accountBalance),
      'debit': serializer.toJson<double?>(debit),
      'credits': serializer.toJson<double?>(credits),
      'period': serializer.toJson<DateTime?>(period),
    };
  }

  CondominiumBalanceDebitsData copyWith(
          {String? reference,
          Value<String?> id = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<double?> previousBalance = const Value.absent(),
          Value<double?> balance = const Value.absent(),
          Value<double?> accountBalance = const Value.absent(),
          Value<double?> debit = const Value.absent(),
          Value<double?> credits = const Value.absent(),
          Value<DateTime?> period = const Value.absent()}) =>
      CondominiumBalanceDebitsData(
        reference: reference ?? this.reference,
        id: id.present ? id.value : this.id,
        name: name.present ? name.value : this.name,
        type: type.present ? type.value : this.type,
        previousBalance: previousBalance.present
            ? previousBalance.value
            : this.previousBalance,
        balance: balance.present ? balance.value : this.balance,
        accountBalance:
            accountBalance.present ? accountBalance.value : this.accountBalance,
        debit: debit.present ? debit.value : this.debit,
        credits: credits.present ? credits.value : this.credits,
        period: period.present ? period.value : this.period,
      );
  CondominiumBalanceDebitsData copyWithCompanion(
      CondominiumBalanceDebitsTableCompanion data) {
    return CondominiumBalanceDebitsData(
      reference: data.reference.present ? data.reference.value : this.reference,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      previousBalance: data.previousBalance.present
          ? data.previousBalance.value
          : this.previousBalance,
      balance: data.balance.present ? data.balance.value : this.balance,
      accountBalance: data.accountBalance.present
          ? data.accountBalance.value
          : this.accountBalance,
      debit: data.debit.present ? data.debit.value : this.debit,
      credits: data.credits.present ? data.credits.value : this.credits,
      period: data.period.present ? data.period.value : this.period,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceDebitsData(')
          ..write('reference: $reference, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('balance: $balance, ')
          ..write('accountBalance: $accountBalance, ')
          ..write('debit: $debit, ')
          ..write('credits: $credits, ')
          ..write('period: $period')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(reference, id, name, type, previousBalance,
      balance, accountBalance, debit, credits, period);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumBalanceDebitsData &&
          other.reference == this.reference &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.previousBalance == this.previousBalance &&
          other.balance == this.balance &&
          other.accountBalance == this.accountBalance &&
          other.debit == this.debit &&
          other.credits == this.credits &&
          other.period == this.period);
}

class CondominiumBalanceDebitsTableCompanion
    extends UpdateCompanion<CondominiumBalanceDebitsData> {
  final Value<String> reference;
  final Value<String?> id;
  final Value<String?> name;
  final Value<String?> type;
  final Value<double?> previousBalance;
  final Value<double?> balance;
  final Value<double?> accountBalance;
  final Value<double?> debit;
  final Value<double?> credits;
  final Value<DateTime?> period;
  final Value<int> rowid;
  const CondominiumBalanceDebitsTableCompanion({
    this.reference = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.balance = const Value.absent(),
    this.accountBalance = const Value.absent(),
    this.debit = const Value.absent(),
    this.credits = const Value.absent(),
    this.period = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumBalanceDebitsTableCompanion.insert({
    required String reference,
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.balance = const Value.absent(),
    this.accountBalance = const Value.absent(),
    this.debit = const Value.absent(),
    this.credits = const Value.absent(),
    this.period = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : reference = Value(reference);
  static Insertable<CondominiumBalanceDebitsData> custom({
    Expression<String>? reference,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? previousBalance,
    Expression<double>? balance,
    Expression<double>? accountBalance,
    Expression<double>? debit,
    Expression<double>? credits,
    Expression<DateTime>? period,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reference != null) 'reference': reference,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (previousBalance != null) 'previous_balance': previousBalance,
      if (balance != null) 'balance': balance,
      if (accountBalance != null) 'account_balance': accountBalance,
      if (debit != null) 'debit': debit,
      if (credits != null) 'credits': credits,
      if (period != null) 'period': period,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumBalanceDebitsTableCompanion copyWith(
      {Value<String>? reference,
      Value<String?>? id,
      Value<String?>? name,
      Value<String?>? type,
      Value<double?>? previousBalance,
      Value<double?>? balance,
      Value<double?>? accountBalance,
      Value<double?>? debit,
      Value<double?>? credits,
      Value<DateTime?>? period,
      Value<int>? rowid}) {
    return CondominiumBalanceDebitsTableCompanion(
      reference: reference ?? this.reference,
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      previousBalance: previousBalance ?? this.previousBalance,
      balance: balance ?? this.balance,
      accountBalance: accountBalance ?? this.accountBalance,
      debit: debit ?? this.debit,
      credits: credits ?? this.credits,
      period: period ?? this.period,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (previousBalance.present) {
      map['previous_balance'] = Variable<double>(previousBalance.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (accountBalance.present) {
      map['account_balance'] = Variable<double>(accountBalance.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (period.present) {
      map['period'] = Variable<DateTime>(period.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceDebitsTableCompanion(')
          ..write('reference: $reference, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('balance: $balance, ')
          ..write('accountBalance: $accountBalance, ')
          ..write('debit: $debit, ')
          ..write('credits: $credits, ')
          ..write('period: $period, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CondominiumBalanceSummaryTableTable
    extends CondominiumBalanceSummaryTable
    with
        TableInfo<$CondominiumBalanceSummaryTableTable,
            CondominiumBalanceSummaryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CondominiumBalanceSummaryTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _debitsMeta = const VerificationMeta('debits');
  @override
  late final GeneratedColumn<double> debits = GeneratedColumn<double>(
      'debits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
      'credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [reference, name, debits, credits];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'condominium_balance_summary_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CondominiumBalanceSummaryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('debits')) {
      context.handle(_debitsMeta,
          debits.isAcceptableOrUnknown(data['debits']!, _debitsMeta));
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {reference};
  @override
  CondominiumBalanceSummaryData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CondominiumBalanceSummaryData(
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      debits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debits']),
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credits']),
    );
  }

  @override
  $CondominiumBalanceSummaryTableTable createAlias(String alias) {
    return $CondominiumBalanceSummaryTableTable(attachedDatabase, alias);
  }
}

class CondominiumBalanceSummaryData extends DataClass
    implements Insertable<CondominiumBalanceSummaryData> {
  final String reference;
  final String? name;
  final double? debits;
  final double? credits;
  const CondominiumBalanceSummaryData(
      {required this.reference, this.name, this.debits, this.credits});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || debits != null) {
      map['debits'] = Variable<double>(debits);
    }
    if (!nullToAbsent || credits != null) {
      map['credits'] = Variable<double>(credits);
    }
    return map;
  }

  CondominiumBalanceSummaryTableCompanion toCompanion(bool nullToAbsent) {
    return CondominiumBalanceSummaryTableCompanion(
      reference: Value(reference),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      debits:
          debits == null && nullToAbsent ? const Value.absent() : Value(debits),
      credits: credits == null && nullToAbsent
          ? const Value.absent()
          : Value(credits),
    );
  }

  factory CondominiumBalanceSummaryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CondominiumBalanceSummaryData(
      reference: serializer.fromJson<String>(json['reference']),
      name: serializer.fromJson<String?>(json['name']),
      debits: serializer.fromJson<double?>(json['debits']),
      credits: serializer.fromJson<double?>(json['credits']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reference': serializer.toJson<String>(reference),
      'name': serializer.toJson<String?>(name),
      'debits': serializer.toJson<double?>(debits),
      'credits': serializer.toJson<double?>(credits),
    };
  }

  CondominiumBalanceSummaryData copyWith(
          {String? reference,
          Value<String?> name = const Value.absent(),
          Value<double?> debits = const Value.absent(),
          Value<double?> credits = const Value.absent()}) =>
      CondominiumBalanceSummaryData(
        reference: reference ?? this.reference,
        name: name.present ? name.value : this.name,
        debits: debits.present ? debits.value : this.debits,
        credits: credits.present ? credits.value : this.credits,
      );
  CondominiumBalanceSummaryData copyWithCompanion(
      CondominiumBalanceSummaryTableCompanion data) {
    return CondominiumBalanceSummaryData(
      reference: data.reference.present ? data.reference.value : this.reference,
      name: data.name.present ? data.name.value : this.name,
      debits: data.debits.present ? data.debits.value : this.debits,
      credits: data.credits.present ? data.credits.value : this.credits,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceSummaryData(')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('debits: $debits, ')
          ..write('credits: $credits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(reference, name, debits, credits);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CondominiumBalanceSummaryData &&
          other.reference == this.reference &&
          other.name == this.name &&
          other.debits == this.debits &&
          other.credits == this.credits);
}

class CondominiumBalanceSummaryTableCompanion
    extends UpdateCompanion<CondominiumBalanceSummaryData> {
  final Value<String> reference;
  final Value<String?> name;
  final Value<double?> debits;
  final Value<double?> credits;
  final Value<int> rowid;
  const CondominiumBalanceSummaryTableCompanion({
    this.reference = const Value.absent(),
    this.name = const Value.absent(),
    this.debits = const Value.absent(),
    this.credits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CondominiumBalanceSummaryTableCompanion.insert({
    required String reference,
    this.name = const Value.absent(),
    this.debits = const Value.absent(),
    this.credits = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : reference = Value(reference);
  static Insertable<CondominiumBalanceSummaryData> custom({
    Expression<String>? reference,
    Expression<String>? name,
    Expression<double>? debits,
    Expression<double>? credits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reference != null) 'reference': reference,
      if (name != null) 'name': name,
      if (debits != null) 'debits': debits,
      if (credits != null) 'credits': credits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CondominiumBalanceSummaryTableCompanion copyWith(
      {Value<String>? reference,
      Value<String?>? name,
      Value<double?>? debits,
      Value<double?>? credits,
      Value<int>? rowid}) {
    return CondominiumBalanceSummaryTableCompanion(
      reference: reference ?? this.reference,
      name: name ?? this.name,
      debits: debits ?? this.debits,
      credits: credits ?? this.credits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (debits.present) {
      map['debits'] = Variable<double>(debits.value);
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CondominiumBalanceSummaryTableCompanion(')
          ..write('reference: $reference, ')
          ..write('name: $name, ')
          ..write('debits: $debits, ')
          ..write('credits: $credits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgreementsTableTable extends AgreementsTable
    with TableInfo<$AgreementsTableTable, AgreementsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgreementsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<int> reference = GeneratedColumn<int>(
      'reference', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitOwnerMeta =
      const VerificationMeta('unitOwner');
  @override
  late final GeneratedColumn<String> unitOwner = GeneratedColumn<String>(
      'unit_owner', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _baseValueMeta =
      const VerificationMeta('baseValue');
  @override
  late final GeneratedColumn<double> baseValue = GeneratedColumn<double>(
      'base_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fineAndCostsMeta =
      const VerificationMeta('fineAndCosts');
  @override
  late final GeneratedColumn<double> fineAndCosts = GeneratedColumn<double>(
      'fine_and_costs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _installmentQuantityMeta =
      const VerificationMeta('installmentQuantity');
  @override
  late final GeneratedColumn<int> installmentQuantity = GeneratedColumn<int>(
      'installment_quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMessageMeta =
      const VerificationMeta('statusMessage');
  @override
  late final GeneratedColumn<String> statusMessage = GeneratedColumn<String>(
      'status_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expirationMeta =
      const VerificationMeta('expiration');
  @override
  late final GeneratedColumn<DateTime> expiration = GeneratedColumn<DateTime>(
      'expiration', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _proposaldedDateMeta =
      const VerificationMeta('proposaldedDate');
  @override
  late final GeneratedColumn<DateTime> proposaldedDate =
      GeneratedColumn<DateTime>('proposalded_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _approvalDateMeta =
      const VerificationMeta('approvalDate');
  @override
  late final GeneratedColumn<DateTime> approvalDate = GeneratedColumn<DateTime>(
      'approval_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
      'due_date', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastInstallmentDateMeta =
      const VerificationMeta('lastInstallmentDate');
  @override
  late final GeneratedColumn<DateTime> lastInstallmentDate =
      GeneratedColumn<DateTime>('last_installment_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        condominiumId,
        reference,
        unit,
        unitOwner,
        baseValue,
        fineAndCosts,
        installmentQuantity,
        paymentMethod,
        status,
        statusMessage,
        expiration,
        proposaldedDate,
        approvalDate,
        dueDate,
        lastInstallmentDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agreements_table';
  @override
  VerificationContext validateIntegrity(Insertable<AgreementsData> instance,
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
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('unit_owner')) {
      context.handle(_unitOwnerMeta,
          unitOwner.isAcceptableOrUnknown(data['unit_owner']!, _unitOwnerMeta));
    }
    if (data.containsKey('base_value')) {
      context.handle(_baseValueMeta,
          baseValue.isAcceptableOrUnknown(data['base_value']!, _baseValueMeta));
    } else if (isInserting) {
      context.missing(_baseValueMeta);
    }
    if (data.containsKey('fine_and_costs')) {
      context.handle(
          _fineAndCostsMeta,
          fineAndCosts.isAcceptableOrUnknown(
              data['fine_and_costs']!, _fineAndCostsMeta));
    } else if (isInserting) {
      context.missing(_fineAndCostsMeta);
    }
    if (data.containsKey('installment_quantity')) {
      context.handle(
          _installmentQuantityMeta,
          installmentQuantity.isAcceptableOrUnknown(
              data['installment_quantity']!, _installmentQuantityMeta));
    } else if (isInserting) {
      context.missing(_installmentQuantityMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('status_message')) {
      context.handle(
          _statusMessageMeta,
          statusMessage.isAcceptableOrUnknown(
              data['status_message']!, _statusMessageMeta));
    }
    if (data.containsKey('expiration')) {
      context.handle(
          _expirationMeta,
          expiration.isAcceptableOrUnknown(
              data['expiration']!, _expirationMeta));
    }
    if (data.containsKey('proposalded_date')) {
      context.handle(
          _proposaldedDateMeta,
          proposaldedDate.isAcceptableOrUnknown(
              data['proposalded_date']!, _proposaldedDateMeta));
    }
    if (data.containsKey('approval_date')) {
      context.handle(
          _approvalDateMeta,
          approvalDate.isAcceptableOrUnknown(
              data['approval_date']!, _approvalDateMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('last_installment_date')) {
      context.handle(
          _lastInstallmentDateMeta,
          lastInstallmentDate.isAcceptableOrUnknown(
              data['last_installment_date']!, _lastInstallmentDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AgreementsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgreementsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reference'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      unitOwner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_owner']),
      baseValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_value'])!,
      fineAndCosts: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fine_and_costs'])!,
      installmentQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}installment_quantity'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      statusMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status_message']),
      expiration: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiration']),
      proposaldedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}proposalded_date']),
      approvalDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}approval_date']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_date'])!,
      lastInstallmentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_installment_date']),
    );
  }

  @override
  $AgreementsTableTable createAlias(String alias) {
    return $AgreementsTableTable(attachedDatabase, alias);
  }
}

class AgreementsData extends DataClass implements Insertable<AgreementsData> {
  final String id;
  final String condominiumId;
  final int reference;
  final String? unit;
  final String? unitOwner;
  final double baseValue;
  final double fineAndCosts;
  final int installmentQuantity;
  final String? paymentMethod;
  final String? status;
  final String? statusMessage;
  final DateTime? expiration;
  final DateTime? proposaldedDate;
  final DateTime? approvalDate;
  final int dueDate;
  final DateTime? lastInstallmentDate;
  const AgreementsData(
      {required this.id,
      required this.condominiumId,
      required this.reference,
      this.unit,
      this.unitOwner,
      required this.baseValue,
      required this.fineAndCosts,
      required this.installmentQuantity,
      this.paymentMethod,
      this.status,
      this.statusMessage,
      this.expiration,
      this.proposaldedDate,
      this.approvalDate,
      required this.dueDate,
      this.lastInstallmentDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['condominium_id'] = Variable<String>(condominiumId);
    map['reference'] = Variable<int>(reference);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || unitOwner != null) {
      map['unit_owner'] = Variable<String>(unitOwner);
    }
    map['base_value'] = Variable<double>(baseValue);
    map['fine_and_costs'] = Variable<double>(fineAndCosts);
    map['installment_quantity'] = Variable<int>(installmentQuantity);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || statusMessage != null) {
      map['status_message'] = Variable<String>(statusMessage);
    }
    if (!nullToAbsent || expiration != null) {
      map['expiration'] = Variable<DateTime>(expiration);
    }
    if (!nullToAbsent || proposaldedDate != null) {
      map['proposalded_date'] = Variable<DateTime>(proposaldedDate);
    }
    if (!nullToAbsent || approvalDate != null) {
      map['approval_date'] = Variable<DateTime>(approvalDate);
    }
    map['due_date'] = Variable<int>(dueDate);
    if (!nullToAbsent || lastInstallmentDate != null) {
      map['last_installment_date'] = Variable<DateTime>(lastInstallmentDate);
    }
    return map;
  }

  AgreementsTableCompanion toCompanion(bool nullToAbsent) {
    return AgreementsTableCompanion(
      id: Value(id),
      condominiumId: Value(condominiumId),
      reference: Value(reference),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      unitOwner: unitOwner == null && nullToAbsent
          ? const Value.absent()
          : Value(unitOwner),
      baseValue: Value(baseValue),
      fineAndCosts: Value(fineAndCosts),
      installmentQuantity: Value(installmentQuantity),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      statusMessage: statusMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(statusMessage),
      expiration: expiration == null && nullToAbsent
          ? const Value.absent()
          : Value(expiration),
      proposaldedDate: proposaldedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(proposaldedDate),
      approvalDate: approvalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(approvalDate),
      dueDate: Value(dueDate),
      lastInstallmentDate: lastInstallmentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInstallmentDate),
    );
  }

  factory AgreementsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgreementsData(
      id: serializer.fromJson<String>(json['id']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      reference: serializer.fromJson<int>(json['reference']),
      unit: serializer.fromJson<String?>(json['unit']),
      unitOwner: serializer.fromJson<String?>(json['unitOwner']),
      baseValue: serializer.fromJson<double>(json['baseValue']),
      fineAndCosts: serializer.fromJson<double>(json['fineAndCosts']),
      installmentQuantity:
          serializer.fromJson<int>(json['installmentQuantity']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      status: serializer.fromJson<String?>(json['status']),
      statusMessage: serializer.fromJson<String?>(json['statusMessage']),
      expiration: serializer.fromJson<DateTime?>(json['expiration']),
      proposaldedDate: serializer.fromJson<DateTime?>(json['proposaldedDate']),
      approvalDate: serializer.fromJson<DateTime?>(json['approvalDate']),
      dueDate: serializer.fromJson<int>(json['dueDate']),
      lastInstallmentDate:
          serializer.fromJson<DateTime?>(json['lastInstallmentDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'reference': serializer.toJson<int>(reference),
      'unit': serializer.toJson<String?>(unit),
      'unitOwner': serializer.toJson<String?>(unitOwner),
      'baseValue': serializer.toJson<double>(baseValue),
      'fineAndCosts': serializer.toJson<double>(fineAndCosts),
      'installmentQuantity': serializer.toJson<int>(installmentQuantity),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'status': serializer.toJson<String?>(status),
      'statusMessage': serializer.toJson<String?>(statusMessage),
      'expiration': serializer.toJson<DateTime?>(expiration),
      'proposaldedDate': serializer.toJson<DateTime?>(proposaldedDate),
      'approvalDate': serializer.toJson<DateTime?>(approvalDate),
      'dueDate': serializer.toJson<int>(dueDate),
      'lastInstallmentDate': serializer.toJson<DateTime?>(lastInstallmentDate),
    };
  }

  AgreementsData copyWith(
          {String? id,
          String? condominiumId,
          int? reference,
          Value<String?> unit = const Value.absent(),
          Value<String?> unitOwner = const Value.absent(),
          double? baseValue,
          double? fineAndCosts,
          int? installmentQuantity,
          Value<String?> paymentMethod = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> statusMessage = const Value.absent(),
          Value<DateTime?> expiration = const Value.absent(),
          Value<DateTime?> proposaldedDate = const Value.absent(),
          Value<DateTime?> approvalDate = const Value.absent(),
          int? dueDate,
          Value<DateTime?> lastInstallmentDate = const Value.absent()}) =>
      AgreementsData(
        id: id ?? this.id,
        condominiumId: condominiumId ?? this.condominiumId,
        reference: reference ?? this.reference,
        unit: unit.present ? unit.value : this.unit,
        unitOwner: unitOwner.present ? unitOwner.value : this.unitOwner,
        baseValue: baseValue ?? this.baseValue,
        fineAndCosts: fineAndCosts ?? this.fineAndCosts,
        installmentQuantity: installmentQuantity ?? this.installmentQuantity,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        status: status.present ? status.value : this.status,
        statusMessage:
            statusMessage.present ? statusMessage.value : this.statusMessage,
        expiration: expiration.present ? expiration.value : this.expiration,
        proposaldedDate: proposaldedDate.present
            ? proposaldedDate.value
            : this.proposaldedDate,
        approvalDate:
            approvalDate.present ? approvalDate.value : this.approvalDate,
        dueDate: dueDate ?? this.dueDate,
        lastInstallmentDate: lastInstallmentDate.present
            ? lastInstallmentDate.value
            : this.lastInstallmentDate,
      );
  AgreementsData copyWithCompanion(AgreementsTableCompanion data) {
    return AgreementsData(
      id: data.id.present ? data.id.value : this.id,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      reference: data.reference.present ? data.reference.value : this.reference,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitOwner: data.unitOwner.present ? data.unitOwner.value : this.unitOwner,
      baseValue: data.baseValue.present ? data.baseValue.value : this.baseValue,
      fineAndCosts: data.fineAndCosts.present
          ? data.fineAndCosts.value
          : this.fineAndCosts,
      installmentQuantity: data.installmentQuantity.present
          ? data.installmentQuantity.value
          : this.installmentQuantity,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      status: data.status.present ? data.status.value : this.status,
      statusMessage: data.statusMessage.present
          ? data.statusMessage.value
          : this.statusMessage,
      expiration:
          data.expiration.present ? data.expiration.value : this.expiration,
      proposaldedDate: data.proposaldedDate.present
          ? data.proposaldedDate.value
          : this.proposaldedDate,
      approvalDate: data.approvalDate.present
          ? data.approvalDate.value
          : this.approvalDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      lastInstallmentDate: data.lastInstallmentDate.present
          ? data.lastInstallmentDate.value
          : this.lastInstallmentDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsData(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('reference: $reference, ')
          ..write('unit: $unit, ')
          ..write('unitOwner: $unitOwner, ')
          ..write('baseValue: $baseValue, ')
          ..write('fineAndCosts: $fineAndCosts, ')
          ..write('installmentQuantity: $installmentQuantity, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('status: $status, ')
          ..write('statusMessage: $statusMessage, ')
          ..write('expiration: $expiration, ')
          ..write('proposaldedDate: $proposaldedDate, ')
          ..write('approvalDate: $approvalDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('lastInstallmentDate: $lastInstallmentDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      condominiumId,
      reference,
      unit,
      unitOwner,
      baseValue,
      fineAndCosts,
      installmentQuantity,
      paymentMethod,
      status,
      statusMessage,
      expiration,
      proposaldedDate,
      approvalDate,
      dueDate,
      lastInstallmentDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgreementsData &&
          other.id == this.id &&
          other.condominiumId == this.condominiumId &&
          other.reference == this.reference &&
          other.unit == this.unit &&
          other.unitOwner == this.unitOwner &&
          other.baseValue == this.baseValue &&
          other.fineAndCosts == this.fineAndCosts &&
          other.installmentQuantity == this.installmentQuantity &&
          other.paymentMethod == this.paymentMethod &&
          other.status == this.status &&
          other.statusMessage == this.statusMessage &&
          other.expiration == this.expiration &&
          other.proposaldedDate == this.proposaldedDate &&
          other.approvalDate == this.approvalDate &&
          other.dueDate == this.dueDate &&
          other.lastInstallmentDate == this.lastInstallmentDate);
}

class AgreementsTableCompanion extends UpdateCompanion<AgreementsData> {
  final Value<String> id;
  final Value<String> condominiumId;
  final Value<int> reference;
  final Value<String?> unit;
  final Value<String?> unitOwner;
  final Value<double> baseValue;
  final Value<double> fineAndCosts;
  final Value<int> installmentQuantity;
  final Value<String?> paymentMethod;
  final Value<String?> status;
  final Value<String?> statusMessage;
  final Value<DateTime?> expiration;
  final Value<DateTime?> proposaldedDate;
  final Value<DateTime?> approvalDate;
  final Value<int> dueDate;
  final Value<DateTime?> lastInstallmentDate;
  final Value<int> rowid;
  const AgreementsTableCompanion({
    this.id = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.reference = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitOwner = const Value.absent(),
    this.baseValue = const Value.absent(),
    this.fineAndCosts = const Value.absent(),
    this.installmentQuantity = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.statusMessage = const Value.absent(),
    this.expiration = const Value.absent(),
    this.proposaldedDate = const Value.absent(),
    this.approvalDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.lastInstallmentDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgreementsTableCompanion.insert({
    required String id,
    required String condominiumId,
    required int reference,
    this.unit = const Value.absent(),
    this.unitOwner = const Value.absent(),
    required double baseValue,
    required double fineAndCosts,
    required int installmentQuantity,
    this.paymentMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.statusMessage = const Value.absent(),
    this.expiration = const Value.absent(),
    this.proposaldedDate = const Value.absent(),
    this.approvalDate = const Value.absent(),
    required int dueDate,
    this.lastInstallmentDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        condominiumId = Value(condominiumId),
        reference = Value(reference),
        baseValue = Value(baseValue),
        fineAndCosts = Value(fineAndCosts),
        installmentQuantity = Value(installmentQuantity),
        dueDate = Value(dueDate);
  static Insertable<AgreementsData> custom({
    Expression<String>? id,
    Expression<String>? condominiumId,
    Expression<int>? reference,
    Expression<String>? unit,
    Expression<String>? unitOwner,
    Expression<double>? baseValue,
    Expression<double>? fineAndCosts,
    Expression<int>? installmentQuantity,
    Expression<String>? paymentMethod,
    Expression<String>? status,
    Expression<String>? statusMessage,
    Expression<DateTime>? expiration,
    Expression<DateTime>? proposaldedDate,
    Expression<DateTime>? approvalDate,
    Expression<int>? dueDate,
    Expression<DateTime>? lastInstallmentDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (reference != null) 'reference': reference,
      if (unit != null) 'unit': unit,
      if (unitOwner != null) 'unit_owner': unitOwner,
      if (baseValue != null) 'base_value': baseValue,
      if (fineAndCosts != null) 'fine_and_costs': fineAndCosts,
      if (installmentQuantity != null)
        'installment_quantity': installmentQuantity,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (status != null) 'status': status,
      if (statusMessage != null) 'status_message': statusMessage,
      if (expiration != null) 'expiration': expiration,
      if (proposaldedDate != null) 'proposalded_date': proposaldedDate,
      if (approvalDate != null) 'approval_date': approvalDate,
      if (dueDate != null) 'due_date': dueDate,
      if (lastInstallmentDate != null)
        'last_installment_date': lastInstallmentDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgreementsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? condominiumId,
      Value<int>? reference,
      Value<String?>? unit,
      Value<String?>? unitOwner,
      Value<double>? baseValue,
      Value<double>? fineAndCosts,
      Value<int>? installmentQuantity,
      Value<String?>? paymentMethod,
      Value<String?>? status,
      Value<String?>? statusMessage,
      Value<DateTime?>? expiration,
      Value<DateTime?>? proposaldedDate,
      Value<DateTime?>? approvalDate,
      Value<int>? dueDate,
      Value<DateTime?>? lastInstallmentDate,
      Value<int>? rowid}) {
    return AgreementsTableCompanion(
      id: id ?? this.id,
      condominiumId: condominiumId ?? this.condominiumId,
      reference: reference ?? this.reference,
      unit: unit ?? this.unit,
      unitOwner: unitOwner ?? this.unitOwner,
      baseValue: baseValue ?? this.baseValue,
      fineAndCosts: fineAndCosts ?? this.fineAndCosts,
      installmentQuantity: installmentQuantity ?? this.installmentQuantity,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      expiration: expiration ?? this.expiration,
      proposaldedDate: proposaldedDate ?? this.proposaldedDate,
      approvalDate: approvalDate ?? this.approvalDate,
      dueDate: dueDate ?? this.dueDate,
      lastInstallmentDate: lastInstallmentDate ?? this.lastInstallmentDate,
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
    if (reference.present) {
      map['reference'] = Variable<int>(reference.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitOwner.present) {
      map['unit_owner'] = Variable<String>(unitOwner.value);
    }
    if (baseValue.present) {
      map['base_value'] = Variable<double>(baseValue.value);
    }
    if (fineAndCosts.present) {
      map['fine_and_costs'] = Variable<double>(fineAndCosts.value);
    }
    if (installmentQuantity.present) {
      map['installment_quantity'] = Variable<int>(installmentQuantity.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (statusMessage.present) {
      map['status_message'] = Variable<String>(statusMessage.value);
    }
    if (expiration.present) {
      map['expiration'] = Variable<DateTime>(expiration.value);
    }
    if (proposaldedDate.present) {
      map['proposalded_date'] = Variable<DateTime>(proposaldedDate.value);
    }
    if (approvalDate.present) {
      map['approval_date'] = Variable<DateTime>(approvalDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (lastInstallmentDate.present) {
      map['last_installment_date'] =
          Variable<DateTime>(lastInstallmentDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsTableCompanion(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('reference: $reference, ')
          ..write('unit: $unit, ')
          ..write('unitOwner: $unitOwner, ')
          ..write('baseValue: $baseValue, ')
          ..write('fineAndCosts: $fineAndCosts, ')
          ..write('installmentQuantity: $installmentQuantity, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('status: $status, ')
          ..write('statusMessage: $statusMessage, ')
          ..write('expiration: $expiration, ')
          ..write('proposaldedDate: $proposaldedDate, ')
          ..write('approvalDate: $approvalDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('lastInstallmentDate: $lastInstallmentDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgreementsInstallmentsTableTable extends AgreementsInstallmentsTable
    with
        TableInfo<$AgreementsInstallmentsTableTable,
            AgreementsInstallmentsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgreementsInstallmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _installmentIdMeta =
      const VerificationMeta('installmentId');
  @override
  late final GeneratedColumn<String> installmentId = GeneratedColumn<String>(
      'installment_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _agreementIdMeta =
      const VerificationMeta('agreementId');
  @override
  late final GeneratedColumn<String> agreementId = GeneratedColumn<String>(
      'agreement_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<int> reference = GeneratedColumn<int>(
      'reference', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        installmentId,
        condominiumId,
        agreementId,
        reference,
        value,
        dueDate,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agreements_installments_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AgreementsInstallmentsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('installment_id')) {
      context.handle(
          _installmentIdMeta,
          installmentId.isAcceptableOrUnknown(
              data['installment_id']!, _installmentIdMeta));
    } else if (isInserting) {
      context.missing(_installmentIdMeta);
    }
    if (data.containsKey('condominium_id')) {
      context.handle(
          _condominiumIdMeta,
          condominiumId.isAcceptableOrUnknown(
              data['condominium_id']!, _condominiumIdMeta));
    } else if (isInserting) {
      context.missing(_condominiumIdMeta);
    }
    if (data.containsKey('agreement_id')) {
      context.handle(
          _agreementIdMeta,
          agreementId.isAcceptableOrUnknown(
              data['agreement_id']!, _agreementIdMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {installmentId};
  @override
  AgreementsInstallmentsData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgreementsInstallmentsData(
      installmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}installment_id'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      agreementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agreement_id']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reference'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
    );
  }

  @override
  $AgreementsInstallmentsTableTable createAlias(String alias) {
    return $AgreementsInstallmentsTableTable(attachedDatabase, alias);
  }
}

class AgreementsInstallmentsData extends DataClass
    implements Insertable<AgreementsInstallmentsData> {
  final String installmentId;
  final String condominiumId;
  final String? agreementId;
  final int reference;
  final double value;
  final DateTime? dueDate;
  final String? status;
  const AgreementsInstallmentsData(
      {required this.installmentId,
      required this.condominiumId,
      this.agreementId,
      required this.reference,
      required this.value,
      this.dueDate,
      this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['installment_id'] = Variable<String>(installmentId);
    map['condominium_id'] = Variable<String>(condominiumId);
    if (!nullToAbsent || agreementId != null) {
      map['agreement_id'] = Variable<String>(agreementId);
    }
    map['reference'] = Variable<int>(reference);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    return map;
  }

  AgreementsInstallmentsTableCompanion toCompanion(bool nullToAbsent) {
    return AgreementsInstallmentsTableCompanion(
      installmentId: Value(installmentId),
      condominiumId: Value(condominiumId),
      agreementId: agreementId == null && nullToAbsent
          ? const Value.absent()
          : Value(agreementId),
      reference: Value(reference),
      value: Value(value),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory AgreementsInstallmentsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgreementsInstallmentsData(
      installmentId: serializer.fromJson<String>(json['installmentId']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      agreementId: serializer.fromJson<String?>(json['agreementId']),
      reference: serializer.fromJson<int>(json['reference']),
      value: serializer.fromJson<double>(json['value']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      status: serializer.fromJson<String?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'installmentId': serializer.toJson<String>(installmentId),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'agreementId': serializer.toJson<String?>(agreementId),
      'reference': serializer.toJson<int>(reference),
      'value': serializer.toJson<double>(value),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'status': serializer.toJson<String?>(status),
    };
  }

  AgreementsInstallmentsData copyWith(
          {String? installmentId,
          String? condominiumId,
          Value<String?> agreementId = const Value.absent(),
          int? reference,
          double? value,
          Value<DateTime?> dueDate = const Value.absent(),
          Value<String?> status = const Value.absent()}) =>
      AgreementsInstallmentsData(
        installmentId: installmentId ?? this.installmentId,
        condominiumId: condominiumId ?? this.condominiumId,
        agreementId: agreementId.present ? agreementId.value : this.agreementId,
        reference: reference ?? this.reference,
        value: value ?? this.value,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        status: status.present ? status.value : this.status,
      );
  AgreementsInstallmentsData copyWithCompanion(
      AgreementsInstallmentsTableCompanion data) {
    return AgreementsInstallmentsData(
      installmentId: data.installmentId.present
          ? data.installmentId.value
          : this.installmentId,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      agreementId:
          data.agreementId.present ? data.agreementId.value : this.agreementId,
      reference: data.reference.present ? data.reference.value : this.reference,
      value: data.value.present ? data.value.value : this.value,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsInstallmentsData(')
          ..write('installmentId: $installmentId, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('agreementId: $agreementId, ')
          ..write('reference: $reference, ')
          ..write('value: $value, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(installmentId, condominiumId, agreementId,
      reference, value, dueDate, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgreementsInstallmentsData &&
          other.installmentId == this.installmentId &&
          other.condominiumId == this.condominiumId &&
          other.agreementId == this.agreementId &&
          other.reference == this.reference &&
          other.value == this.value &&
          other.dueDate == this.dueDate &&
          other.status == this.status);
}

class AgreementsInstallmentsTableCompanion
    extends UpdateCompanion<AgreementsInstallmentsData> {
  final Value<String> installmentId;
  final Value<String> condominiumId;
  final Value<String?> agreementId;
  final Value<int> reference;
  final Value<double> value;
  final Value<DateTime?> dueDate;
  final Value<String?> status;
  final Value<int> rowid;
  const AgreementsInstallmentsTableCompanion({
    this.installmentId = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.agreementId = const Value.absent(),
    this.reference = const Value.absent(),
    this.value = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgreementsInstallmentsTableCompanion.insert({
    required String installmentId,
    required String condominiumId,
    this.agreementId = const Value.absent(),
    required int reference,
    required double value,
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : installmentId = Value(installmentId),
        condominiumId = Value(condominiumId),
        reference = Value(reference),
        value = Value(value);
  static Insertable<AgreementsInstallmentsData> custom({
    Expression<String>? installmentId,
    Expression<String>? condominiumId,
    Expression<String>? agreementId,
    Expression<int>? reference,
    Expression<double>? value,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (installmentId != null) 'installment_id': installmentId,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (agreementId != null) 'agreement_id': agreementId,
      if (reference != null) 'reference': reference,
      if (value != null) 'value': value,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgreementsInstallmentsTableCompanion copyWith(
      {Value<String>? installmentId,
      Value<String>? condominiumId,
      Value<String?>? agreementId,
      Value<int>? reference,
      Value<double>? value,
      Value<DateTime?>? dueDate,
      Value<String?>? status,
      Value<int>? rowid}) {
    return AgreementsInstallmentsTableCompanion(
      installmentId: installmentId ?? this.installmentId,
      condominiumId: condominiumId ?? this.condominiumId,
      agreementId: agreementId ?? this.agreementId,
      reference: reference ?? this.reference,
      value: value ?? this.value,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (installmentId.present) {
      map['installment_id'] = Variable<String>(installmentId.value);
    }
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (agreementId.present) {
      map['agreement_id'] = Variable<String>(agreementId.value);
    }
    if (reference.present) {
      map['reference'] = Variable<int>(reference.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
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
    return (StringBuffer('AgreementsInstallmentsTableCompanion(')
          ..write('installmentId: $installmentId, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('agreementId: $agreementId, ')
          ..write('reference: $reference, ')
          ..write('value: $value, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgreementsQuoteTableTable extends AgreementsQuoteTable
    with TableInfo<$AgreementsQuoteTableTable, AgreementsQuoteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgreementsQuoteTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _agreementIdMeta =
      const VerificationMeta('agreementId');
  @override
  late final GeneratedColumn<String> agreementId = GeneratedColumn<String>(
      'agreement_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<int> reference = GeneratedColumn<int>(
      'reference', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _originValueMeta =
      const VerificationMeta('originValue');
  @override
  late final GeneratedColumn<double> originValue = GeneratedColumn<double>(
      'origin_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fineValueMeta =
      const VerificationMeta('fineValue');
  @override
  late final GeneratedColumn<double> fineValue = GeneratedColumn<double>(
      'fine_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _feeValueMeta =
      const VerificationMeta('feeValue');
  @override
  late final GeneratedColumn<double> feeValue = GeneratedColumn<double>(
      'fee_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _honoraryValueMeta =
      const VerificationMeta('honoraryValue');
  @override
  late final GeneratedColumn<double> honoraryValue = GeneratedColumn<double>(
      'honorary_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _overdueMessageMeta =
      const VerificationMeta('overdueMessage');
  @override
  late final GeneratedColumn<String> overdueMessage = GeneratedColumn<String>(
      'overdue_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        condominiumId,
        agreementId,
        reference,
        dueDate,
        originValue,
        fineValue,
        feeValue,
        honoraryValue,
        overdueMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agreements_quote_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AgreementsQuoteData> instance,
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
    if (data.containsKey('agreement_id')) {
      context.handle(
          _agreementIdMeta,
          agreementId.isAcceptableOrUnknown(
              data['agreement_id']!, _agreementIdMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('origin_value')) {
      context.handle(
          _originValueMeta,
          originValue.isAcceptableOrUnknown(
              data['origin_value']!, _originValueMeta));
    } else if (isInserting) {
      context.missing(_originValueMeta);
    }
    if (data.containsKey('fine_value')) {
      context.handle(_fineValueMeta,
          fineValue.isAcceptableOrUnknown(data['fine_value']!, _fineValueMeta));
    } else if (isInserting) {
      context.missing(_fineValueMeta);
    }
    if (data.containsKey('fee_value')) {
      context.handle(_feeValueMeta,
          feeValue.isAcceptableOrUnknown(data['fee_value']!, _feeValueMeta));
    } else if (isInserting) {
      context.missing(_feeValueMeta);
    }
    if (data.containsKey('honorary_value')) {
      context.handle(
          _honoraryValueMeta,
          honoraryValue.isAcceptableOrUnknown(
              data['honorary_value']!, _honoraryValueMeta));
    } else if (isInserting) {
      context.missing(_honoraryValueMeta);
    }
    if (data.containsKey('overdue_message')) {
      context.handle(
          _overdueMessageMeta,
          overdueMessage.isAcceptableOrUnknown(
              data['overdue_message']!, _overdueMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AgreementsQuoteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgreementsQuoteData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      agreementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agreement_id']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reference'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      originValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}origin_value'])!,
      fineValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fine_value'])!,
      feeValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fee_value'])!,
      honoraryValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}honorary_value'])!,
      overdueMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overdue_message']),
    );
  }

  @override
  $AgreementsQuoteTableTable createAlias(String alias) {
    return $AgreementsQuoteTableTable(attachedDatabase, alias);
  }
}

class AgreementsQuoteData extends DataClass
    implements Insertable<AgreementsQuoteData> {
  final String id;
  final String condominiumId;
  final String? agreementId;
  final int reference;
  final DateTime? dueDate;
  final double originValue;
  final double fineValue;
  final double feeValue;
  final double honoraryValue;
  final String? overdueMessage;
  const AgreementsQuoteData(
      {required this.id,
      required this.condominiumId,
      this.agreementId,
      required this.reference,
      this.dueDate,
      required this.originValue,
      required this.fineValue,
      required this.feeValue,
      required this.honoraryValue,
      this.overdueMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['condominium_id'] = Variable<String>(condominiumId);
    if (!nullToAbsent || agreementId != null) {
      map['agreement_id'] = Variable<String>(agreementId);
    }
    map['reference'] = Variable<int>(reference);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['origin_value'] = Variable<double>(originValue);
    map['fine_value'] = Variable<double>(fineValue);
    map['fee_value'] = Variable<double>(feeValue);
    map['honorary_value'] = Variable<double>(honoraryValue);
    if (!nullToAbsent || overdueMessage != null) {
      map['overdue_message'] = Variable<String>(overdueMessage);
    }
    return map;
  }

  AgreementsQuoteTableCompanion toCompanion(bool nullToAbsent) {
    return AgreementsQuoteTableCompanion(
      id: Value(id),
      condominiumId: Value(condominiumId),
      agreementId: agreementId == null && nullToAbsent
          ? const Value.absent()
          : Value(agreementId),
      reference: Value(reference),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      originValue: Value(originValue),
      fineValue: Value(fineValue),
      feeValue: Value(feeValue),
      honoraryValue: Value(honoraryValue),
      overdueMessage: overdueMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(overdueMessage),
    );
  }

  factory AgreementsQuoteData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgreementsQuoteData(
      id: serializer.fromJson<String>(json['id']),
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      agreementId: serializer.fromJson<String?>(json['agreementId']),
      reference: serializer.fromJson<int>(json['reference']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      originValue: serializer.fromJson<double>(json['originValue']),
      fineValue: serializer.fromJson<double>(json['fineValue']),
      feeValue: serializer.fromJson<double>(json['feeValue']),
      honoraryValue: serializer.fromJson<double>(json['honoraryValue']),
      overdueMessage: serializer.fromJson<String?>(json['overdueMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'condominiumId': serializer.toJson<String>(condominiumId),
      'agreementId': serializer.toJson<String?>(agreementId),
      'reference': serializer.toJson<int>(reference),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'originValue': serializer.toJson<double>(originValue),
      'fineValue': serializer.toJson<double>(fineValue),
      'feeValue': serializer.toJson<double>(feeValue),
      'honoraryValue': serializer.toJson<double>(honoraryValue),
      'overdueMessage': serializer.toJson<String?>(overdueMessage),
    };
  }

  AgreementsQuoteData copyWith(
          {String? id,
          String? condominiumId,
          Value<String?> agreementId = const Value.absent(),
          int? reference,
          Value<DateTime?> dueDate = const Value.absent(),
          double? originValue,
          double? fineValue,
          double? feeValue,
          double? honoraryValue,
          Value<String?> overdueMessage = const Value.absent()}) =>
      AgreementsQuoteData(
        id: id ?? this.id,
        condominiumId: condominiumId ?? this.condominiumId,
        agreementId: agreementId.present ? agreementId.value : this.agreementId,
        reference: reference ?? this.reference,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        originValue: originValue ?? this.originValue,
        fineValue: fineValue ?? this.fineValue,
        feeValue: feeValue ?? this.feeValue,
        honoraryValue: honoraryValue ?? this.honoraryValue,
        overdueMessage:
            overdueMessage.present ? overdueMessage.value : this.overdueMessage,
      );
  AgreementsQuoteData copyWithCompanion(AgreementsQuoteTableCompanion data) {
    return AgreementsQuoteData(
      id: data.id.present ? data.id.value : this.id,
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      agreementId:
          data.agreementId.present ? data.agreementId.value : this.agreementId,
      reference: data.reference.present ? data.reference.value : this.reference,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      originValue:
          data.originValue.present ? data.originValue.value : this.originValue,
      fineValue: data.fineValue.present ? data.fineValue.value : this.fineValue,
      feeValue: data.feeValue.present ? data.feeValue.value : this.feeValue,
      honoraryValue: data.honoraryValue.present
          ? data.honoraryValue.value
          : this.honoraryValue,
      overdueMessage: data.overdueMessage.present
          ? data.overdueMessage.value
          : this.overdueMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsQuoteData(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('agreementId: $agreementId, ')
          ..write('reference: $reference, ')
          ..write('dueDate: $dueDate, ')
          ..write('originValue: $originValue, ')
          ..write('fineValue: $fineValue, ')
          ..write('feeValue: $feeValue, ')
          ..write('honoraryValue: $honoraryValue, ')
          ..write('overdueMessage: $overdueMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, condominiumId, agreementId, reference,
      dueDate, originValue, fineValue, feeValue, honoraryValue, overdueMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgreementsQuoteData &&
          other.id == this.id &&
          other.condominiumId == this.condominiumId &&
          other.agreementId == this.agreementId &&
          other.reference == this.reference &&
          other.dueDate == this.dueDate &&
          other.originValue == this.originValue &&
          other.fineValue == this.fineValue &&
          other.feeValue == this.feeValue &&
          other.honoraryValue == this.honoraryValue &&
          other.overdueMessage == this.overdueMessage);
}

class AgreementsQuoteTableCompanion
    extends UpdateCompanion<AgreementsQuoteData> {
  final Value<String> id;
  final Value<String> condominiumId;
  final Value<String?> agreementId;
  final Value<int> reference;
  final Value<DateTime?> dueDate;
  final Value<double> originValue;
  final Value<double> fineValue;
  final Value<double> feeValue;
  final Value<double> honoraryValue;
  final Value<String?> overdueMessage;
  final Value<int> rowid;
  const AgreementsQuoteTableCompanion({
    this.id = const Value.absent(),
    this.condominiumId = const Value.absent(),
    this.agreementId = const Value.absent(),
    this.reference = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.originValue = const Value.absent(),
    this.fineValue = const Value.absent(),
    this.feeValue = const Value.absent(),
    this.honoraryValue = const Value.absent(),
    this.overdueMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgreementsQuoteTableCompanion.insert({
    required String id,
    required String condominiumId,
    this.agreementId = const Value.absent(),
    required int reference,
    this.dueDate = const Value.absent(),
    required double originValue,
    required double fineValue,
    required double feeValue,
    required double honoraryValue,
    this.overdueMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        condominiumId = Value(condominiumId),
        reference = Value(reference),
        originValue = Value(originValue),
        fineValue = Value(fineValue),
        feeValue = Value(feeValue),
        honoraryValue = Value(honoraryValue);
  static Insertable<AgreementsQuoteData> custom({
    Expression<String>? id,
    Expression<String>? condominiumId,
    Expression<String>? agreementId,
    Expression<int>? reference,
    Expression<DateTime>? dueDate,
    Expression<double>? originValue,
    Expression<double>? fineValue,
    Expression<double>? feeValue,
    Expression<double>? honoraryValue,
    Expression<String>? overdueMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (agreementId != null) 'agreement_id': agreementId,
      if (reference != null) 'reference': reference,
      if (dueDate != null) 'due_date': dueDate,
      if (originValue != null) 'origin_value': originValue,
      if (fineValue != null) 'fine_value': fineValue,
      if (feeValue != null) 'fee_value': feeValue,
      if (honoraryValue != null) 'honorary_value': honoraryValue,
      if (overdueMessage != null) 'overdue_message': overdueMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgreementsQuoteTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? condominiumId,
      Value<String?>? agreementId,
      Value<int>? reference,
      Value<DateTime?>? dueDate,
      Value<double>? originValue,
      Value<double>? fineValue,
      Value<double>? feeValue,
      Value<double>? honoraryValue,
      Value<String?>? overdueMessage,
      Value<int>? rowid}) {
    return AgreementsQuoteTableCompanion(
      id: id ?? this.id,
      condominiumId: condominiumId ?? this.condominiumId,
      agreementId: agreementId ?? this.agreementId,
      reference: reference ?? this.reference,
      dueDate: dueDate ?? this.dueDate,
      originValue: originValue ?? this.originValue,
      fineValue: fineValue ?? this.fineValue,
      feeValue: feeValue ?? this.feeValue,
      honoraryValue: honoraryValue ?? this.honoraryValue,
      overdueMessage: overdueMessage ?? this.overdueMessage,
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
    if (agreementId.present) {
      map['agreement_id'] = Variable<String>(agreementId.value);
    }
    if (reference.present) {
      map['reference'] = Variable<int>(reference.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (originValue.present) {
      map['origin_value'] = Variable<double>(originValue.value);
    }
    if (fineValue.present) {
      map['fine_value'] = Variable<double>(fineValue.value);
    }
    if (feeValue.present) {
      map['fee_value'] = Variable<double>(feeValue.value);
    }
    if (honoraryValue.present) {
      map['honorary_value'] = Variable<double>(honoraryValue.value);
    }
    if (overdueMessage.present) {
      map['overdue_message'] = Variable<String>(overdueMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsQuoteTableCompanion(')
          ..write('id: $id, ')
          ..write('condominiumId: $condominiumId, ')
          ..write('agreementId: $agreementId, ')
          ..write('reference: $reference, ')
          ..write('dueDate: $dueDate, ')
          ..write('originValue: $originValue, ')
          ..write('fineValue: $fineValue, ')
          ..write('feeValue: $feeValue, ')
          ..write('honoraryValue: $honoraryValue, ')
          ..write('overdueMessage: $overdueMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgreementsRulesDaysTableTable extends AgreementsRulesDaysTable
    with TableInfo<$AgreementsRulesDaysTableTable, AgreementsRulesDaysData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgreementsRulesDaysTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<int> days = GeneratedColumn<int>(
      'days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [condominiumId, days];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agreements_rules_days_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AgreementsRulesDaysData> instance,
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
    if (data.containsKey('days')) {
      context.handle(
          _daysMeta, days.isAcceptableOrUnknown(data['days']!, _daysMeta));
    } else if (isInserting) {
      context.missing(_daysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AgreementsRulesDaysData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgreementsRulesDaysData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      days: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days'])!,
    );
  }

  @override
  $AgreementsRulesDaysTableTable createAlias(String alias) {
    return $AgreementsRulesDaysTableTable(attachedDatabase, alias);
  }
}

class AgreementsRulesDaysData extends DataClass
    implements Insertable<AgreementsRulesDaysData> {
  final String condominiumId;
  final int days;
  const AgreementsRulesDaysData(
      {required this.condominiumId, required this.days});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['days'] = Variable<int>(days);
    return map;
  }

  AgreementsRulesDaysTableCompanion toCompanion(bool nullToAbsent) {
    return AgreementsRulesDaysTableCompanion(
      condominiumId: Value(condominiumId),
      days: Value(days),
    );
  }

  factory AgreementsRulesDaysData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgreementsRulesDaysData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      days: serializer.fromJson<int>(json['days']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'days': serializer.toJson<int>(days),
    };
  }

  AgreementsRulesDaysData copyWith({String? condominiumId, int? days}) =>
      AgreementsRulesDaysData(
        condominiumId: condominiumId ?? this.condominiumId,
        days: days ?? this.days,
      );
  AgreementsRulesDaysData copyWithCompanion(
      AgreementsRulesDaysTableCompanion data) {
    return AgreementsRulesDaysData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      days: data.days.present ? data.days.value : this.days,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsRulesDaysData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('days: $days')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, days);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgreementsRulesDaysData &&
          other.condominiumId == this.condominiumId &&
          other.days == this.days);
}

class AgreementsRulesDaysTableCompanion
    extends UpdateCompanion<AgreementsRulesDaysData> {
  final Value<String> condominiumId;
  final Value<int> days;
  final Value<int> rowid;
  const AgreementsRulesDaysTableCompanion({
    this.condominiumId = const Value.absent(),
    this.days = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgreementsRulesDaysTableCompanion.insert({
    required String condominiumId,
    required int days,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        days = Value(days);
  static Insertable<AgreementsRulesDaysData> custom({
    Expression<String>? condominiumId,
    Expression<int>? days,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (days != null) 'days': days,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgreementsRulesDaysTableCompanion copyWith(
      {Value<String>? condominiumId, Value<int>? days, Value<int>? rowid}) {
    return AgreementsRulesDaysTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      days: days ?? this.days,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (days.present) {
      map['days'] = Variable<int>(days.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsRulesDaysTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('days: $days, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgreementsRulesInstallmentsTableTable
    extends AgreementsRulesInstallmentsTable
    with
        TableInfo<$AgreementsRulesInstallmentsTableTable,
            AgreementsRulesInstallmentsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgreementsRulesInstallmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _condominiumIdMeta =
      const VerificationMeta('condominiumId');
  @override
  late final GeneratedColumn<String> condominiumId = GeneratedColumn<String>(
      'condominium_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _installmentQtdMeta =
      const VerificationMeta('installmentQtd');
  @override
  late final GeneratedColumn<int> installmentQtd = GeneratedColumn<int>(
      'installment_qtd', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [condominiumId, installmentQtd];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agreements_rules_installments_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AgreementsRulesInstallmentsData> instance,
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
    if (data.containsKey('installment_qtd')) {
      context.handle(
          _installmentQtdMeta,
          installmentQtd.isAcceptableOrUnknown(
              data['installment_qtd']!, _installmentQtdMeta));
    } else if (isInserting) {
      context.missing(_installmentQtdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {condominiumId};
  @override
  AgreementsRulesInstallmentsData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgreementsRulesInstallmentsData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      installmentQtd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installment_qtd'])!,
    );
  }

  @override
  $AgreementsRulesInstallmentsTableTable createAlias(String alias) {
    return $AgreementsRulesInstallmentsTableTable(attachedDatabase, alias);
  }
}

class AgreementsRulesInstallmentsData extends DataClass
    implements Insertable<AgreementsRulesInstallmentsData> {
  final String condominiumId;
  final int installmentQtd;
  const AgreementsRulesInstallmentsData(
      {required this.condominiumId, required this.installmentQtd});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['installment_qtd'] = Variable<int>(installmentQtd);
    return map;
  }

  AgreementsRulesInstallmentsTableCompanion toCompanion(bool nullToAbsent) {
    return AgreementsRulesInstallmentsTableCompanion(
      condominiumId: Value(condominiumId),
      installmentQtd: Value(installmentQtd),
    );
  }

  factory AgreementsRulesInstallmentsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgreementsRulesInstallmentsData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      installmentQtd: serializer.fromJson<int>(json['installmentQtd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'installmentQtd': serializer.toJson<int>(installmentQtd),
    };
  }

  AgreementsRulesInstallmentsData copyWith(
          {String? condominiumId, int? installmentQtd}) =>
      AgreementsRulesInstallmentsData(
        condominiumId: condominiumId ?? this.condominiumId,
        installmentQtd: installmentQtd ?? this.installmentQtd,
      );
  AgreementsRulesInstallmentsData copyWithCompanion(
      AgreementsRulesInstallmentsTableCompanion data) {
    return AgreementsRulesInstallmentsData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      installmentQtd: data.installmentQtd.present
          ? data.installmentQtd.value
          : this.installmentQtd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsRulesInstallmentsData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('installmentQtd: $installmentQtd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, installmentQtd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgreementsRulesInstallmentsData &&
          other.condominiumId == this.condominiumId &&
          other.installmentQtd == this.installmentQtd);
}

class AgreementsRulesInstallmentsTableCompanion
    extends UpdateCompanion<AgreementsRulesInstallmentsData> {
  final Value<String> condominiumId;
  final Value<int> installmentQtd;
  final Value<int> rowid;
  const AgreementsRulesInstallmentsTableCompanion({
    this.condominiumId = const Value.absent(),
    this.installmentQtd = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgreementsRulesInstallmentsTableCompanion.insert({
    required String condominiumId,
    required int installmentQtd,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        installmentQtd = Value(installmentQtd);
  static Insertable<AgreementsRulesInstallmentsData> custom({
    Expression<String>? condominiumId,
    Expression<int>? installmentQtd,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (installmentQtd != null) 'installment_qtd': installmentQtd,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgreementsRulesInstallmentsTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<int>? installmentQtd,
      Value<int>? rowid}) {
    return AgreementsRulesInstallmentsTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      installmentQtd: installmentQtd ?? this.installmentQtd,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (condominiumId.present) {
      map['condominium_id'] = Variable<String>(condominiumId.value);
    }
    if (installmentQtd.present) {
      map['installment_qtd'] = Variable<int>(installmentQtd.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgreementsRulesInstallmentsTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('installmentQtd: $installmentQtd, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResinPeopleTableTable extends ResinPeopleTable
    with TableInfo<$ResinPeopleTableTable, ResinPeopleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResinPeopleTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _documentMeta =
      const VerificationMeta('document');
  @override
  late final GeneratedColumn<String> document = GeneratedColumn<String>(
      'document', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [condominiumId, id, document, name, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resin_people_table';
  @override
  VerificationContext validateIntegrity(Insertable<ResinPeopleData> instance,
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
    if (data.containsKey('document')) {
      context.handle(_documentMeta,
          document.isAcceptableOrUnknown(data['document']!, _documentMeta));
    } else if (isInserting) {
      context.missing(_documentMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {document};
  @override
  ResinPeopleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResinPeopleData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      document: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
    );
  }

  @override
  $ResinPeopleTableTable createAlias(String alias) {
    return $ResinPeopleTableTable(attachedDatabase, alias);
  }
}

class ResinPeopleData extends DataClass implements Insertable<ResinPeopleData> {
  final String condominiumId;
  final String id;
  final String document;
  final String name;
  final String role;
  const ResinPeopleData(
      {required this.condominiumId,
      required this.id,
      required this.document,
      required this.name,
      required this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['id'] = Variable<String>(id);
    map['document'] = Variable<String>(document);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    return map;
  }

  ResinPeopleTableCompanion toCompanion(bool nullToAbsent) {
    return ResinPeopleTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(id),
      document: Value(document),
      name: Value(name),
      role: Value(role),
    );
  }

  factory ResinPeopleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResinPeopleData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      id: serializer.fromJson<String>(json['id']),
      document: serializer.fromJson<String>(json['document']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'id': serializer.toJson<String>(id),
      'document': serializer.toJson<String>(document),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
    };
  }

  ResinPeopleData copyWith(
          {String? condominiumId,
          String? id,
          String? document,
          String? name,
          String? role}) =>
      ResinPeopleData(
        condominiumId: condominiumId ?? this.condominiumId,
        id: id ?? this.id,
        document: document ?? this.document,
        name: name ?? this.name,
        role: role ?? this.role,
      );
  ResinPeopleData copyWithCompanion(ResinPeopleTableCompanion data) {
    return ResinPeopleData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      id: data.id.present ? data.id.value : this.id,
      document: data.document.present ? data.document.value : this.document,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResinPeopleData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('document: $document, ')
          ..write('name: $name, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, id, document, name, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResinPeopleData &&
          other.condominiumId == this.condominiumId &&
          other.id == this.id &&
          other.document == this.document &&
          other.name == this.name &&
          other.role == this.role);
}

class ResinPeopleTableCompanion extends UpdateCompanion<ResinPeopleData> {
  final Value<String> condominiumId;
  final Value<String> id;
  final Value<String> document;
  final Value<String> name;
  final Value<String> role;
  final Value<int> rowid;
  const ResinPeopleTableCompanion({
    this.condominiumId = const Value.absent(),
    this.id = const Value.absent(),
    this.document = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResinPeopleTableCompanion.insert({
    required String condominiumId,
    required String id,
    required String document,
    required String name,
    required String role,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        id = Value(id),
        document = Value(document),
        name = Value(name),
        role = Value(role);
  static Insertable<ResinPeopleData> custom({
    Expression<String>? condominiumId,
    Expression<String>? id,
    Expression<String>? document,
    Expression<String>? name,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (id != null) 'id': id,
      if (document != null) 'document': document,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResinPeopleTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<String>? id,
      Value<String>? document,
      Value<String>? name,
      Value<String>? role,
      Value<int>? rowid}) {
    return ResinPeopleTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      id: id ?? this.id,
      document: document ?? this.document,
      name: name ?? this.name,
      role: role ?? this.role,
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
    if (document.present) {
      map['document'] = Variable<String>(document.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
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
    return (StringBuffer('ResinPeopleTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('document: $document, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResinBanksTableTable extends ResinBanksTable
    with TableInfo<$ResinBanksTableTable, ResinBanksData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResinBanksTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bankCodeMeta =
      const VerificationMeta('bankCode');
  @override
  late final GeneratedColumn<String> bankCode = GeneratedColumn<String>(
      'bank_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [condominiumId, id, bankCode, bankName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resin_banks_table';
  @override
  VerificationContext validateIntegrity(Insertable<ResinBanksData> instance,
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
    if (data.containsKey('bank_code')) {
      context.handle(_bankCodeMeta,
          bankCode.isAcceptableOrUnknown(data['bank_code']!, _bankCodeMeta));
    } else if (isInserting) {
      context.missing(_bankCodeMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResinBanksData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResinBanksData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bankCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_code'])!,
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name'])!,
    );
  }

  @override
  $ResinBanksTableTable createAlias(String alias) {
    return $ResinBanksTableTable(attachedDatabase, alias);
  }
}

class ResinBanksData extends DataClass implements Insertable<ResinBanksData> {
  final String condominiumId;
  final String id;
  final String bankCode;
  final String bankName;
  const ResinBanksData(
      {required this.condominiumId,
      required this.id,
      required this.bankCode,
      required this.bankName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['id'] = Variable<String>(id);
    map['bank_code'] = Variable<String>(bankCode);
    map['bank_name'] = Variable<String>(bankName);
    return map;
  }

  ResinBanksTableCompanion toCompanion(bool nullToAbsent) {
    return ResinBanksTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(id),
      bankCode: Value(bankCode),
      bankName: Value(bankName),
    );
  }

  factory ResinBanksData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResinBanksData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      id: serializer.fromJson<String>(json['id']),
      bankCode: serializer.fromJson<String>(json['bankCode']),
      bankName: serializer.fromJson<String>(json['bankName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'id': serializer.toJson<String>(id),
      'bankCode': serializer.toJson<String>(bankCode),
      'bankName': serializer.toJson<String>(bankName),
    };
  }

  ResinBanksData copyWith(
          {String? condominiumId,
          String? id,
          String? bankCode,
          String? bankName}) =>
      ResinBanksData(
        condominiumId: condominiumId ?? this.condominiumId,
        id: id ?? this.id,
        bankCode: bankCode ?? this.bankCode,
        bankName: bankName ?? this.bankName,
      );
  ResinBanksData copyWithCompanion(ResinBanksTableCompanion data) {
    return ResinBanksData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      id: data.id.present ? data.id.value : this.id,
      bankCode: data.bankCode.present ? data.bankCode.value : this.bankCode,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResinBanksData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('bankCode: $bankCode, ')
          ..write('bankName: $bankName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, id, bankCode, bankName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResinBanksData &&
          other.condominiumId == this.condominiumId &&
          other.id == this.id &&
          other.bankCode == this.bankCode &&
          other.bankName == this.bankName);
}

class ResinBanksTableCompanion extends UpdateCompanion<ResinBanksData> {
  final Value<String> condominiumId;
  final Value<String> id;
  final Value<String> bankCode;
  final Value<String> bankName;
  final Value<int> rowid;
  const ResinBanksTableCompanion({
    this.condominiumId = const Value.absent(),
    this.id = const Value.absent(),
    this.bankCode = const Value.absent(),
    this.bankName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResinBanksTableCompanion.insert({
    required String condominiumId,
    required String id,
    required String bankCode,
    required String bankName,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        id = Value(id),
        bankCode = Value(bankCode),
        bankName = Value(bankName);
  static Insertable<ResinBanksData> custom({
    Expression<String>? condominiumId,
    Expression<String>? id,
    Expression<String>? bankCode,
    Expression<String>? bankName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (id != null) 'id': id,
      if (bankCode != null) 'bank_code': bankCode,
      if (bankName != null) 'bank_name': bankName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResinBanksTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<String>? id,
      Value<String>? bankCode,
      Value<String>? bankName,
      Value<int>? rowid}) {
    return ResinBanksTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      id: id ?? this.id,
      bankCode: bankCode ?? this.bankCode,
      bankName: bankName ?? this.bankName,
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
    if (bankCode.present) {
      map['bank_code'] = Variable<String>(bankCode.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResinBanksTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('bankCode: $bankCode, ')
          ..write('bankName: $bankName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResinBankAccountsTableTable extends ResinBankAccountsTable
    with TableInfo<$ResinBankAccountsTableTable, ResinBankAccountsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResinBankAccountsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
      'bank_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _agencyMeta = const VerificationMeta('agency');
  @override
  late final GeneratedColumn<String> agency = GeneratedColumn<String>(
      'agency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountNumberMeta =
      const VerificationMeta('accountNumber');
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
      'account_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentMeta =
      const VerificationMeta('document');
  @override
  late final GeneratedColumn<String> document = GeneratedColumn<String>(
      'document', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplierNameMeta =
      const VerificationMeta('supplierName');
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
      'supplier_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        condominiumId,
        id,
        bankId,
        agency,
        accountNumber,
        document,
        supplierName,
        type
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resin_bank_accounts_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ResinBankAccountsData> instance,
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
    if (data.containsKey('bank_id')) {
      context.handle(_bankIdMeta,
          bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta));
    } else if (isInserting) {
      context.missing(_bankIdMeta);
    }
    if (data.containsKey('agency')) {
      context.handle(_agencyMeta,
          agency.isAcceptableOrUnknown(data['agency']!, _agencyMeta));
    } else if (isInserting) {
      context.missing(_agencyMeta);
    }
    if (data.containsKey('account_number')) {
      context.handle(
          _accountNumberMeta,
          accountNumber.isAcceptableOrUnknown(
              data['account_number']!, _accountNumberMeta));
    } else if (isInserting) {
      context.missing(_accountNumberMeta);
    }
    if (data.containsKey('document')) {
      context.handle(_documentMeta,
          document.isAcceptableOrUnknown(data['document']!, _documentMeta));
    } else if (isInserting) {
      context.missing(_documentMeta);
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
          _supplierNameMeta,
          supplierName.isAcceptableOrUnknown(
              data['supplier_name']!, _supplierNameMeta));
    } else if (isInserting) {
      context.missing(_supplierNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResinBankAccountsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResinBankAccountsData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bankId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_id'])!,
      agency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agency'])!,
      accountNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_number'])!,
      document: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document'])!,
      supplierName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
    );
  }

  @override
  $ResinBankAccountsTableTable createAlias(String alias) {
    return $ResinBankAccountsTableTable(attachedDatabase, alias);
  }
}

class ResinBankAccountsData extends DataClass
    implements Insertable<ResinBankAccountsData> {
  final String condominiumId;
  final String id;
  final String bankId;
  final String agency;
  final String accountNumber;
  final String document;
  final String supplierName;
  final String type;
  const ResinBankAccountsData(
      {required this.condominiumId,
      required this.id,
      required this.bankId,
      required this.agency,
      required this.accountNumber,
      required this.document,
      required this.supplierName,
      required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['id'] = Variable<String>(id);
    map['bank_id'] = Variable<String>(bankId);
    map['agency'] = Variable<String>(agency);
    map['account_number'] = Variable<String>(accountNumber);
    map['document'] = Variable<String>(document);
    map['supplier_name'] = Variable<String>(supplierName);
    map['type'] = Variable<String>(type);
    return map;
  }

  ResinBankAccountsTableCompanion toCompanion(bool nullToAbsent) {
    return ResinBankAccountsTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(id),
      bankId: Value(bankId),
      agency: Value(agency),
      accountNumber: Value(accountNumber),
      document: Value(document),
      supplierName: Value(supplierName),
      type: Value(type),
    );
  }

  factory ResinBankAccountsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResinBankAccountsData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      id: serializer.fromJson<String>(json['id']),
      bankId: serializer.fromJson<String>(json['bankId']),
      agency: serializer.fromJson<String>(json['agency']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      document: serializer.fromJson<String>(json['document']),
      supplierName: serializer.fromJson<String>(json['supplierName']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'id': serializer.toJson<String>(id),
      'bankId': serializer.toJson<String>(bankId),
      'agency': serializer.toJson<String>(agency),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'document': serializer.toJson<String>(document),
      'supplierName': serializer.toJson<String>(supplierName),
      'type': serializer.toJson<String>(type),
    };
  }

  ResinBankAccountsData copyWith(
          {String? condominiumId,
          String? id,
          String? bankId,
          String? agency,
          String? accountNumber,
          String? document,
          String? supplierName,
          String? type}) =>
      ResinBankAccountsData(
        condominiumId: condominiumId ?? this.condominiumId,
        id: id ?? this.id,
        bankId: bankId ?? this.bankId,
        agency: agency ?? this.agency,
        accountNumber: accountNumber ?? this.accountNumber,
        document: document ?? this.document,
        supplierName: supplierName ?? this.supplierName,
        type: type ?? this.type,
      );
  ResinBankAccountsData copyWithCompanion(
      ResinBankAccountsTableCompanion data) {
    return ResinBankAccountsData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      id: data.id.present ? data.id.value : this.id,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      agency: data.agency.present ? data.agency.value : this.agency,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      document: data.document.present ? data.document.value : this.document,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResinBankAccountsData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('agency: $agency, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('document: $document, ')
          ..write('supplierName: $supplierName, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(condominiumId, id, bankId, agency,
      accountNumber, document, supplierName, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResinBankAccountsData &&
          other.condominiumId == this.condominiumId &&
          other.id == this.id &&
          other.bankId == this.bankId &&
          other.agency == this.agency &&
          other.accountNumber == this.accountNumber &&
          other.document == this.document &&
          other.supplierName == this.supplierName &&
          other.type == this.type);
}

class ResinBankAccountsTableCompanion
    extends UpdateCompanion<ResinBankAccountsData> {
  final Value<String> condominiumId;
  final Value<String> id;
  final Value<String> bankId;
  final Value<String> agency;
  final Value<String> accountNumber;
  final Value<String> document;
  final Value<String> supplierName;
  final Value<String> type;
  final Value<int> rowid;
  const ResinBankAccountsTableCompanion({
    this.condominiumId = const Value.absent(),
    this.id = const Value.absent(),
    this.bankId = const Value.absent(),
    this.agency = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.document = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResinBankAccountsTableCompanion.insert({
    required String condominiumId,
    required String id,
    required String bankId,
    required String agency,
    required String accountNumber,
    required String document,
    required String supplierName,
    required String type,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        id = Value(id),
        bankId = Value(bankId),
        agency = Value(agency),
        accountNumber = Value(accountNumber),
        document = Value(document),
        supplierName = Value(supplierName),
        type = Value(type);
  static Insertable<ResinBankAccountsData> custom({
    Expression<String>? condominiumId,
    Expression<String>? id,
    Expression<String>? bankId,
    Expression<String>? agency,
    Expression<String>? accountNumber,
    Expression<String>? document,
    Expression<String>? supplierName,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (id != null) 'id': id,
      if (bankId != null) 'bank_id': bankId,
      if (agency != null) 'agency': agency,
      if (accountNumber != null) 'account_number': accountNumber,
      if (document != null) 'document': document,
      if (supplierName != null) 'supplier_name': supplierName,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResinBankAccountsTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<String>? id,
      Value<String>? bankId,
      Value<String>? agency,
      Value<String>? accountNumber,
      Value<String>? document,
      Value<String>? supplierName,
      Value<String>? type,
      Value<int>? rowid}) {
    return ResinBankAccountsTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      agency: agency ?? this.agency,
      accountNumber: accountNumber ?? this.accountNumber,
      document: document ?? this.document,
      supplierName: supplierName ?? this.supplierName,
      type: type ?? this.type,
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
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (agency.present) {
      map['agency'] = Variable<String>(agency.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (document.present) {
      map['document'] = Variable<String>(document.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResinBankAccountsTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('agency: $agency, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('document: $document, ')
          ..write('supplierName: $supplierName, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResinRefundsTableTable extends ResinRefundsTable
    with TableInfo<$ResinRefundsTableTable, ResinRefundsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResinRefundsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<String> destinationAccountId =
      GeneratedColumn<String>('destination_account_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requestDateMeta =
      const VerificationMeta('requestDate');
  @override
  late final GeneratedColumn<DateTime> requestDate = GeneratedColumn<DateTime>(
      'request_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _requesterMeta =
      const VerificationMeta('requester');
  @override
  late final GeneratedColumn<String> requester = GeneratedColumn<String>(
      'requester', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _protocolMeta =
      const VerificationMeta('protocol');
  @override
  late final GeneratedColumn<String> protocol = GeneratedColumn<String>(
      'protocol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _canEditMeta =
      const VerificationMeta('canEdit');
  @override
  late final GeneratedColumn<bool> canEdit = GeneratedColumn<bool>(
      'can_edit', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("can_edit" IN (0, 1))'));
  static const VerificationMeta _canCancelMeta =
      const VerificationMeta('canCancel');
  @override
  late final GeneratedColumn<bool> canCancel = GeneratedColumn<bool>(
      'can_cancel', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("can_cancel" IN (0, 1))'));
  static const VerificationMeta _inconcistencyMeta =
      const VerificationMeta('inconcistency');
  @override
  late final GeneratedColumn<String> inconcistency = GeneratedColumn<String>(
      'inconcistency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        condominiumId,
        id,
        destinationAccountId,
        requestDate,
        requester,
        status,
        type,
        value,
        protocol,
        description,
        canEdit,
        canCancel,
        inconcistency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resin_refunds_table';
  @override
  VerificationContext validateIntegrity(Insertable<ResinRefundsData> instance,
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
    if (data.containsKey('destination_account_id')) {
      context.handle(
          _destinationAccountIdMeta,
          destinationAccountId.isAcceptableOrUnknown(
              data['destination_account_id']!, _destinationAccountIdMeta));
    } else if (isInserting) {
      context.missing(_destinationAccountIdMeta);
    }
    if (data.containsKey('request_date')) {
      context.handle(
          _requestDateMeta,
          requestDate.isAcceptableOrUnknown(
              data['request_date']!, _requestDateMeta));
    }
    if (data.containsKey('requester')) {
      context.handle(_requesterMeta,
          requester.isAcceptableOrUnknown(data['requester']!, _requesterMeta));
    } else if (isInserting) {
      context.missing(_requesterMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('protocol')) {
      context.handle(_protocolMeta,
          protocol.isAcceptableOrUnknown(data['protocol']!, _protocolMeta));
    } else if (isInserting) {
      context.missing(_protocolMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('can_edit')) {
      context.handle(_canEditMeta,
          canEdit.isAcceptableOrUnknown(data['can_edit']!, _canEditMeta));
    } else if (isInserting) {
      context.missing(_canEditMeta);
    }
    if (data.containsKey('can_cancel')) {
      context.handle(_canCancelMeta,
          canCancel.isAcceptableOrUnknown(data['can_cancel']!, _canCancelMeta));
    } else if (isInserting) {
      context.missing(_canCancelMeta);
    }
    if (data.containsKey('inconcistency')) {
      context.handle(
          _inconcistencyMeta,
          inconcistency.isAcceptableOrUnknown(
              data['inconcistency']!, _inconcistencyMeta));
    } else if (isInserting) {
      context.missing(_inconcistencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResinRefundsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResinRefundsData(
      condominiumId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condominium_id'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      destinationAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}destination_account_id'])!,
      requestDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}request_date']),
      requester: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}requester'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      protocol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}protocol'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      canEdit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_edit'])!,
      canCancel: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_cancel'])!,
      inconcistency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inconcistency'])!,
    );
  }

  @override
  $ResinRefundsTableTable createAlias(String alias) {
    return $ResinRefundsTableTable(attachedDatabase, alias);
  }
}

class ResinRefundsData extends DataClass
    implements Insertable<ResinRefundsData> {
  final String condominiumId;
  final String id;
  final String destinationAccountId;
  final DateTime? requestDate;
  final String requester;
  final String status;
  final String type;
  final double value;
  final String protocol;
  final String? description;
  final bool canEdit;
  final bool canCancel;
  final String inconcistency;
  const ResinRefundsData(
      {required this.condominiumId,
      required this.id,
      required this.destinationAccountId,
      this.requestDate,
      required this.requester,
      required this.status,
      required this.type,
      required this.value,
      required this.protocol,
      this.description,
      required this.canEdit,
      required this.canCancel,
      required this.inconcistency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['condominium_id'] = Variable<String>(condominiumId);
    map['id'] = Variable<String>(id);
    map['destination_account_id'] = Variable<String>(destinationAccountId);
    if (!nullToAbsent || requestDate != null) {
      map['request_date'] = Variable<DateTime>(requestDate);
    }
    map['requester'] = Variable<String>(requester);
    map['status'] = Variable<String>(status);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<double>(value);
    map['protocol'] = Variable<String>(protocol);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['can_edit'] = Variable<bool>(canEdit);
    map['can_cancel'] = Variable<bool>(canCancel);
    map['inconcistency'] = Variable<String>(inconcistency);
    return map;
  }

  ResinRefundsTableCompanion toCompanion(bool nullToAbsent) {
    return ResinRefundsTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(id),
      destinationAccountId: Value(destinationAccountId),
      requestDate: requestDate == null && nullToAbsent
          ? const Value.absent()
          : Value(requestDate),
      requester: Value(requester),
      status: Value(status),
      type: Value(type),
      value: Value(value),
      protocol: Value(protocol),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      canEdit: Value(canEdit),
      canCancel: Value(canCancel),
      inconcistency: Value(inconcistency),
    );
  }

  factory ResinRefundsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResinRefundsData(
      condominiumId: serializer.fromJson<String>(json['condominiumId']),
      id: serializer.fromJson<String>(json['id']),
      destinationAccountId:
          serializer.fromJson<String>(json['destinationAccountId']),
      requestDate: serializer.fromJson<DateTime?>(json['requestDate']),
      requester: serializer.fromJson<String>(json['requester']),
      status: serializer.fromJson<String>(json['status']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<double>(json['value']),
      protocol: serializer.fromJson<String>(json['protocol']),
      description: serializer.fromJson<String?>(json['description']),
      canEdit: serializer.fromJson<bool>(json['canEdit']),
      canCancel: serializer.fromJson<bool>(json['canCancel']),
      inconcistency: serializer.fromJson<String>(json['inconcistency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'condominiumId': serializer.toJson<String>(condominiumId),
      'id': serializer.toJson<String>(id),
      'destinationAccountId': serializer.toJson<String>(destinationAccountId),
      'requestDate': serializer.toJson<DateTime?>(requestDate),
      'requester': serializer.toJson<String>(requester),
      'status': serializer.toJson<String>(status),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<double>(value),
      'protocol': serializer.toJson<String>(protocol),
      'description': serializer.toJson<String?>(description),
      'canEdit': serializer.toJson<bool>(canEdit),
      'canCancel': serializer.toJson<bool>(canCancel),
      'inconcistency': serializer.toJson<String>(inconcistency),
    };
  }

  ResinRefundsData copyWith(
          {String? condominiumId,
          String? id,
          String? destinationAccountId,
          Value<DateTime?> requestDate = const Value.absent(),
          String? requester,
          String? status,
          String? type,
          double? value,
          String? protocol,
          Value<String?> description = const Value.absent(),
          bool? canEdit,
          bool? canCancel,
          String? inconcistency}) =>
      ResinRefundsData(
        condominiumId: condominiumId ?? this.condominiumId,
        id: id ?? this.id,
        destinationAccountId: destinationAccountId ?? this.destinationAccountId,
        requestDate: requestDate.present ? requestDate.value : this.requestDate,
        requester: requester ?? this.requester,
        status: status ?? this.status,
        type: type ?? this.type,
        value: value ?? this.value,
        protocol: protocol ?? this.protocol,
        description: description.present ? description.value : this.description,
        canEdit: canEdit ?? this.canEdit,
        canCancel: canCancel ?? this.canCancel,
        inconcistency: inconcistency ?? this.inconcistency,
      );
  ResinRefundsData copyWithCompanion(ResinRefundsTableCompanion data) {
    return ResinRefundsData(
      condominiumId: data.condominiumId.present
          ? data.condominiumId.value
          : this.condominiumId,
      id: data.id.present ? data.id.value : this.id,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      requestDate:
          data.requestDate.present ? data.requestDate.value : this.requestDate,
      requester: data.requester.present ? data.requester.value : this.requester,
      status: data.status.present ? data.status.value : this.status,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      protocol: data.protocol.present ? data.protocol.value : this.protocol,
      description:
          data.description.present ? data.description.value : this.description,
      canEdit: data.canEdit.present ? data.canEdit.value : this.canEdit,
      canCancel: data.canCancel.present ? data.canCancel.value : this.canCancel,
      inconcistency: data.inconcistency.present
          ? data.inconcistency.value
          : this.inconcistency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResinRefundsData(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('requestDate: $requestDate, ')
          ..write('requester: $requester, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('protocol: $protocol, ')
          ..write('description: $description, ')
          ..write('canEdit: $canEdit, ')
          ..write('canCancel: $canCancel, ')
          ..write('inconcistency: $inconcistency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      condominiumId,
      id,
      destinationAccountId,
      requestDate,
      requester,
      status,
      type,
      value,
      protocol,
      description,
      canEdit,
      canCancel,
      inconcistency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResinRefundsData &&
          other.condominiumId == this.condominiumId &&
          other.id == this.id &&
          other.destinationAccountId == this.destinationAccountId &&
          other.requestDate == this.requestDate &&
          other.requester == this.requester &&
          other.status == this.status &&
          other.type == this.type &&
          other.value == this.value &&
          other.protocol == this.protocol &&
          other.description == this.description &&
          other.canEdit == this.canEdit &&
          other.canCancel == this.canCancel &&
          other.inconcistency == this.inconcistency);
}

class ResinRefundsTableCompanion extends UpdateCompanion<ResinRefundsData> {
  final Value<String> condominiumId;
  final Value<String> id;
  final Value<String> destinationAccountId;
  final Value<DateTime?> requestDate;
  final Value<String> requester;
  final Value<String> status;
  final Value<String> type;
  final Value<double> value;
  final Value<String> protocol;
  final Value<String?> description;
  final Value<bool> canEdit;
  final Value<bool> canCancel;
  final Value<String> inconcistency;
  final Value<int> rowid;
  const ResinRefundsTableCompanion({
    this.condominiumId = const Value.absent(),
    this.id = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.requestDate = const Value.absent(),
    this.requester = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.protocol = const Value.absent(),
    this.description = const Value.absent(),
    this.canEdit = const Value.absent(),
    this.canCancel = const Value.absent(),
    this.inconcistency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResinRefundsTableCompanion.insert({
    required String condominiumId,
    required String id,
    required String destinationAccountId,
    this.requestDate = const Value.absent(),
    required String requester,
    required String status,
    required String type,
    required double value,
    required String protocol,
    this.description = const Value.absent(),
    required bool canEdit,
    required bool canCancel,
    required String inconcistency,
    this.rowid = const Value.absent(),
  })  : condominiumId = Value(condominiumId),
        id = Value(id),
        destinationAccountId = Value(destinationAccountId),
        requester = Value(requester),
        status = Value(status),
        type = Value(type),
        value = Value(value),
        protocol = Value(protocol),
        canEdit = Value(canEdit),
        canCancel = Value(canCancel),
        inconcistency = Value(inconcistency);
  static Insertable<ResinRefundsData> custom({
    Expression<String>? condominiumId,
    Expression<String>? id,
    Expression<String>? destinationAccountId,
    Expression<DateTime>? requestDate,
    Expression<String>? requester,
    Expression<String>? status,
    Expression<String>? type,
    Expression<double>? value,
    Expression<String>? protocol,
    Expression<String>? description,
    Expression<bool>? canEdit,
    Expression<bool>? canCancel,
    Expression<String>? inconcistency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (condominiumId != null) 'condominium_id': condominiumId,
      if (id != null) 'id': id,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (requestDate != null) 'request_date': requestDate,
      if (requester != null) 'requester': requester,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (protocol != null) 'protocol': protocol,
      if (description != null) 'description': description,
      if (canEdit != null) 'can_edit': canEdit,
      if (canCancel != null) 'can_cancel': canCancel,
      if (inconcistency != null) 'inconcistency': inconcistency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResinRefundsTableCompanion copyWith(
      {Value<String>? condominiumId,
      Value<String>? id,
      Value<String>? destinationAccountId,
      Value<DateTime?>? requestDate,
      Value<String>? requester,
      Value<String>? status,
      Value<String>? type,
      Value<double>? value,
      Value<String>? protocol,
      Value<String?>? description,
      Value<bool>? canEdit,
      Value<bool>? canCancel,
      Value<String>? inconcistency,
      Value<int>? rowid}) {
    return ResinRefundsTableCompanion(
      condominiumId: condominiumId ?? this.condominiumId,
      id: id ?? this.id,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      requestDate: requestDate ?? this.requestDate,
      requester: requester ?? this.requester,
      status: status ?? this.status,
      type: type ?? this.type,
      value: value ?? this.value,
      protocol: protocol ?? this.protocol,
      description: description ?? this.description,
      canEdit: canEdit ?? this.canEdit,
      canCancel: canCancel ?? this.canCancel,
      inconcistency: inconcistency ?? this.inconcistency,
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
    if (destinationAccountId.present) {
      map['destination_account_id'] =
          Variable<String>(destinationAccountId.value);
    }
    if (requestDate.present) {
      map['request_date'] = Variable<DateTime>(requestDate.value);
    }
    if (requester.present) {
      map['requester'] = Variable<String>(requester.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (protocol.present) {
      map['protocol'] = Variable<String>(protocol.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (canEdit.present) {
      map['can_edit'] = Variable<bool>(canEdit.value);
    }
    if (canCancel.present) {
      map['can_cancel'] = Variable<bool>(canCancel.value);
    }
    if (inconcistency.present) {
      map['inconcistency'] = Variable<String>(inconcistency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResinRefundsTableCompanion(')
          ..write('condominiumId: $condominiumId, ')
          ..write('id: $id, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('requestDate: $requestDate, ')
          ..write('requester: $requester, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('protocol: $protocol, ')
          ..write('description: $description, ')
          ..write('canEdit: $canEdit, ')
          ..write('canCancel: $canCancel, ')
          ..write('inconcistency: $inconcistency, ')
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

abstract class _$LelloDatabase extends GeneratedDatabase {
  _$LelloDatabase(QueryExecutor e) : super(e);
  $LelloDatabaseManager get managers => $LelloDatabaseManager(this);
  late final $PendencyTableTable pendencyTable = $PendencyTableTable(this);
  late final $MeTableTable meTable = $MeTableTable(this);
  late final $CondominiumTableTable condominiumTable =
      $CondominiumTableTable(this);
  late final $AccountTableTable accountTable = $AccountTableTable(this);
  late final $LelloHubTableTable lelloHubTable = $LelloHubTableTable(this);
  late final $UnitTableTable unitTable = $UnitTableTable(this);
  late final $ResidentTableTable residentTable = $ResidentTableTable(this);
  late final $IncomeForecastTableTable incomeForecastTable =
      $IncomeForecastTableTable(this);
  late final $IncomeTableTable incomeTable = $IncomeTableTable(this);
  late final $IncomeShareTableTable incomeShareTable =
      $IncomeShareTableTable(this);
  late final $ChatContactTableTable chatContactTable =
      $ChatContactTableTable(this);
  late final $EmployeeTableTable employeeTable = $EmployeeTableTable(this);
  late final $ReservationSummaryTableTable reservationSummaryTable =
      $ReservationSummaryTableTable(this);
  late final $SpaceTableTable spaceTable = $SpaceTableTable(this);
  late final $CondominiumBalanceTableTable condominiumBalanceTable =
      $CondominiumBalanceTableTable(this);
  late final $CondominiumBalanceDetailTableTable condominiumBalanceDetailTable =
      $CondominiumBalanceDetailTableTable(this);
  late final $CondominiumBalanceDebitsTableTable condominiumBalanceDebitsTable =
      $CondominiumBalanceDebitsTableTable(this);
  late final $CondominiumBalanceSummaryTableTable
      condominiumBalanceSummaryTable =
      $CondominiumBalanceSummaryTableTable(this);
  late final $AgreementsTableTable agreementsTable =
      $AgreementsTableTable(this);
  late final $AgreementsInstallmentsTableTable agreementsInstallmentsTable =
      $AgreementsInstallmentsTableTable(this);
  late final $AgreementsQuoteTableTable agreementsQuoteTable =
      $AgreementsQuoteTableTable(this);
  late final $AgreementsRulesDaysTableTable agreementsRulesDaysTable =
      $AgreementsRulesDaysTableTable(this);
  late final $AgreementsRulesInstallmentsTableTable
      agreementsRulesInstallmentsTable =
      $AgreementsRulesInstallmentsTableTable(this);
  late final $ResinPeopleTableTable resinPeopleTable =
      $ResinPeopleTableTable(this);
  late final $ResinBanksTableTable resinBanksTable =
      $ResinBanksTableTable(this);
  late final $ResinBankAccountsTableTable resinBankAccountsTable =
      $ResinBankAccountsTableTable(this);
  late final $ResinRefundsTableTable resinRefundsTable =
      $ResinRefundsTableTable(this);
  late final $LayoutTableTable layoutTable = $LayoutTableTable(this);
  late final PendencyDao pendencyDao = PendencyDao(this as LelloDatabase);
  late final MeDao meDao = MeDao(this as LelloDatabase);
  late final CondominiumDao condominiumDao =
      CondominiumDao(this as LelloDatabase);
  late final AccountDao accountDao = AccountDao(this as LelloDatabase);
  late final UnitDao unitDao = UnitDao(this as LelloDatabase);
  late final ResidentDao residentDao = ResidentDao(this as LelloDatabase);
  late final IncomeDao incomeDao = IncomeDao(this as LelloDatabase);
  late final ChatContactDao chatContactDao =
      ChatContactDao(this as LelloDatabase);
  late final EmployeeDao employeeDao = EmployeeDao(this as LelloDatabase);
  late final ReservationSummaryDao reservationSummaryDao =
      ReservationSummaryDao(this as LelloDatabase);
  late final SpaceDao spaceDao = SpaceDao(this as LelloDatabase);
  late final CondominiumBalanceDao condominiumBalanceDao =
      CondominiumBalanceDao(this as LelloDatabase);
  late final CondominiumBalanceDetailDao condominiumBalanceDetailDao =
      CondominiumBalanceDetailDao(this as LelloDatabase);
  late final CondominiumBalanceDebitsDao condominiumBalanceDebitsDao =
      CondominiumBalanceDebitsDao(this as LelloDatabase);
  late final CondominiumBalanceSummaryDao condominiumBalanceSummaryDao =
      CondominiumBalanceSummaryDao(this as LelloDatabase);
  late final AgreementsDao agreementsDao = AgreementsDao(this as LelloDatabase);
  late final AgreementsInstallmentsDao agreementsInstallmentsDao =
      AgreementsInstallmentsDao(this as LelloDatabase);
  late final AgreementsQuoteDao agreementsQuoteDao =
      AgreementsQuoteDao(this as LelloDatabase);
  late final AgreementsRulesDaysDao agreementsRulesDaysDao =
      AgreementsRulesDaysDao(this as LelloDatabase);
  late final AgreementsRulesInstallmentsDao agreementsRulesInstallmentsDao =
      AgreementsRulesInstallmentsDao(this as LelloDatabase);
  late final ResinPeopleDao resinPeopleDao =
      ResinPeopleDao(this as LelloDatabase);
  late final ResinBanksDao resinBanksDao = ResinBanksDao(this as LelloDatabase);
  late final ResinBankAccountsDao resinBankAccountsDao =
      ResinBankAccountsDao(this as LelloDatabase);
  late final ResinRefundsDao resinRefundsDao =
      ResinRefundsDao(this as LelloDatabase);
  late final LayoutDao layoutDao = LayoutDao(this as LelloDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        pendencyTable,
        meTable,
        condominiumTable,
        accountTable,
        lelloHubTable,
        unitTable,
        residentTable,
        incomeForecastTable,
        incomeTable,
        incomeShareTable,
        chatContactTable,
        employeeTable,
        reservationSummaryTable,
        spaceTable,
        condominiumBalanceTable,
        condominiumBalanceDetailTable,
        condominiumBalanceDebitsTable,
        condominiumBalanceSummaryTable,
        agreementsTable,
        agreementsInstallmentsTable,
        agreementsQuoteTable,
        agreementsRulesDaysTable,
        agreementsRulesInstallmentsTable,
        resinPeopleTable,
        resinBanksTable,
        resinBankAccountsTable,
        resinRefundsTable,
        layoutTable
      ];
}

typedef $$PendencyTableTableCreateCompanionBuilder = PendencyTableCompanion
    Function({
  required String condominiumId,
  required String id,
  Value<String?> title,
  Value<String?> message,
  Value<DateTime?> date,
  required String type,
  required String senderId,
  Value<String?> senderName,
  Value<String?> senderPicture,
  Value<String?> module,
  Value<int> rowid,
});
typedef $$PendencyTableTableUpdateCompanionBuilder = PendencyTableCompanion
    Function({
  Value<String> condominiumId,
  Value<String> id,
  Value<String?> title,
  Value<String?> message,
  Value<DateTime?> date,
  Value<String> type,
  Value<String> senderId,
  Value<String?> senderName,
  Value<String?> senderPicture,
  Value<String?> module,
  Value<int> rowid,
});

class $$PendencyTableTableFilterComposer
    extends Composer<_$LelloDatabase, $PendencyTableTable> {
  $$PendencyTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderPicture => $composableBuilder(
      column: $table.senderPicture, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get module => $composableBuilder(
      column: $table.module, builder: (column) => ColumnFilters(column));
}

class $$PendencyTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $PendencyTableTable> {
  $$PendencyTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderPicture => $composableBuilder(
      column: $table.senderPicture,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get module => $composableBuilder(
      column: $table.module, builder: (column) => ColumnOrderings(column));
}

class $$PendencyTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $PendencyTableTable> {
  $$PendencyTableTableAnnotationComposer({
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => column);

  GeneratedColumn<String> get senderPicture => $composableBuilder(
      column: $table.senderPicture, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);
}

class $$PendencyTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $PendencyTableTable,
    PendencyData,
    $$PendencyTableTableFilterComposer,
    $$PendencyTableTableOrderingComposer,
    $$PendencyTableTableAnnotationComposer,
    $$PendencyTableTableCreateCompanionBuilder,
    $$PendencyTableTableUpdateCompanionBuilder,
    (
      PendencyData,
      BaseReferences<_$LelloDatabase, $PendencyTableTable, PendencyData>
    ),
    PendencyData,
    PrefetchHooks Function()> {
  $$PendencyTableTableTableManager(
      _$LelloDatabase db, $PendencyTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendencyTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendencyTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendencyTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> message = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<String?> senderName = const Value.absent(),
            Value<String?> senderPicture = const Value.absent(),
            Value<String?> module = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendencyTableCompanion(
            condominiumId: condominiumId,
            id: id,
            title: title,
            message: message,
            date: date,
            type: type,
            senderId: senderId,
            senderName: senderName,
            senderPicture: senderPicture,
            module: module,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required String id,
            Value<String?> title = const Value.absent(),
            Value<String?> message = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
            required String type,
            required String senderId,
            Value<String?> senderName = const Value.absent(),
            Value<String?> senderPicture = const Value.absent(),
            Value<String?> module = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendencyTableCompanion.insert(
            condominiumId: condominiumId,
            id: id,
            title: title,
            message: message,
            date: date,
            type: type,
            senderId: senderId,
            senderName: senderName,
            senderPicture: senderPicture,
            module: module,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendencyTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $PendencyTableTable,
    PendencyData,
    $$PendencyTableTableFilterComposer,
    $$PendencyTableTableOrderingComposer,
    $$PendencyTableTableAnnotationComposer,
    $$PendencyTableTableCreateCompanionBuilder,
    $$PendencyTableTableUpdateCompanionBuilder,
    (
      PendencyData,
      BaseReferences<_$LelloDatabase, $PendencyTableTable, PendencyData>
    ),
    PendencyData,
    PrefetchHooks Function()>;
typedef $$MeTableTableCreateCompanionBuilder = MeTableCompanion Function({
  required String name,
  required String email,
  Value<String?> cpf,
  Value<String?> phone,
  Value<String?> picture,
  Value<String?> pictureHash,
  Value<int> rowid,
});
typedef $$MeTableTableUpdateCompanionBuilder = MeTableCompanion Function({
  Value<String> name,
  Value<String> email,
  Value<String?> cpf,
  Value<String?> phone,
  Value<String?> picture,
  Value<String?> pictureHash,
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
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String?> cpf = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> picture = const Value.absent(),
            Value<String?> pictureHash = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeTableCompanion(
            name: name,
            email: email,
            cpf: cpf,
            phone: phone,
            picture: picture,
            pictureHash: pictureHash,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            required String email,
            Value<String?> cpf = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> picture = const Value.absent(),
            Value<String?> pictureHash = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeTableCompanion.insert(
            name: name,
            email: email,
            cpf: cpf,
            phone: phone,
            picture: picture,
            pictureHash: pictureHash,
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
  required String name,
  required String address,
  required String reference,
  required bool useFacialBiometric,
  required String managerAccessControlBiometricStatus,
  Value<String?> notificationContext,
  Value<int> rowid,
});
typedef $$CondominiumTableTableUpdateCompanionBuilder
    = CondominiumTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> address,
  Value<String> reference,
  Value<bool> useFacialBiometric,
  Value<String> managerAccessControlBiometricStatus,
  Value<String?> notificationContext,
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

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get useFacialBiometric => $composableBuilder(
      column: $table.useFacialBiometric,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get managerAccessControlBiometricStatus =>
      $composableBuilder(
          column: $table.managerAccessControlBiometricStatus,
          builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationContext => $composableBuilder(
      column: $table.notificationContext,
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

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get useFacialBiometric => $composableBuilder(
      column: $table.useFacialBiometric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get managerAccessControlBiometricStatus =>
      $composableBuilder(
          column: $table.managerAccessControlBiometricStatus,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationContext => $composableBuilder(
      column: $table.notificationContext,
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<bool> get useFacialBiometric => $composableBuilder(
      column: $table.useFacialBiometric, builder: (column) => column);

  GeneratedColumn<String> get managerAccessControlBiometricStatus =>
      $composableBuilder(
          column: $table.managerAccessControlBiometricStatus,
          builder: (column) => column);

  GeneratedColumn<String> get notificationContext => $composableBuilder(
      column: $table.notificationContext, builder: (column) => column);
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
            Value<String> name = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> reference = const Value.absent(),
            Value<bool> useFacialBiometric = const Value.absent(),
            Value<String> managerAccessControlBiometricStatus =
                const Value.absent(),
            Value<String?> notificationContext = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumTableCompanion(
            id: id,
            name: name,
            address: address,
            reference: reference,
            useFacialBiometric: useFacialBiometric,
            managerAccessControlBiometricStatus:
                managerAccessControlBiometricStatus,
            notificationContext: notificationContext,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String address,
            required String reference,
            required bool useFacialBiometric,
            required String managerAccessControlBiometricStatus,
            Value<String?> notificationContext = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumTableCompanion.insert(
            id: id,
            name: name,
            address: address,
            reference: reference,
            useFacialBiometric: useFacialBiometric,
            managerAccessControlBiometricStatus:
                managerAccessControlBiometricStatus,
            notificationContext: notificationContext,
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
typedef $$AccountTableTableCreateCompanionBuilder = AccountTableCompanion
    Function({
  required String id,
  Value<String?> number,
  Value<String?> name,
  required String condominiumId,
  Value<int> rowid,
});
typedef $$AccountTableTableUpdateCompanionBuilder = AccountTableCompanion
    Function({
  Value<String> id,
  Value<String?> number,
  Value<String?> name,
  Value<String> condominiumId,
  Value<int> rowid,
});

class $$AccountTableTableFilterComposer
    extends Composer<_$LelloDatabase, $AccountTableTable> {
  $$AccountTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));
}

class $$AccountTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $AccountTableTable> {
  $$AccountTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));
}

class $$AccountTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $AccountTableTable> {
  $$AccountTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);
}

class $$AccountTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $AccountTableTable,
    AccountData,
    $$AccountTableTableFilterComposer,
    $$AccountTableTableOrderingComposer,
    $$AccountTableTableAnnotationComposer,
    $$AccountTableTableCreateCompanionBuilder,
    $$AccountTableTableUpdateCompanionBuilder,
    (
      AccountData,
      BaseReferences<_$LelloDatabase, $AccountTableTable, AccountData>
    ),
    AccountData,
    PrefetchHooks Function()> {
  $$AccountTableTableTableManager(_$LelloDatabase db, $AccountTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> number = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountTableCompanion(
            id: id,
            number: number,
            name: name,
            condominiumId: condominiumId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> number = const Value.absent(),
            Value<String?> name = const Value.absent(),
            required String condominiumId,
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountTableCompanion.insert(
            id: id,
            number: number,
            name: name,
            condominiumId: condominiumId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $AccountTableTable,
    AccountData,
    $$AccountTableTableFilterComposer,
    $$AccountTableTableOrderingComposer,
    $$AccountTableTableAnnotationComposer,
    $$AccountTableTableCreateCompanionBuilder,
    $$AccountTableTableUpdateCompanionBuilder,
    (
      AccountData,
      BaseReferences<_$LelloDatabase, $AccountTableTable, AccountData>
    ),
    AccountData,
    PrefetchHooks Function()>;
typedef $$LelloHubTableTableCreateCompanionBuilder = LelloHubTableCompanion
    Function({
  Value<String?> number,
  Value<int> rowid,
});
typedef $$LelloHubTableTableUpdateCompanionBuilder = LelloHubTableCompanion
    Function({
  Value<String?> number,
  Value<int> rowid,
});

class $$LelloHubTableTableFilterComposer
    extends Composer<_$LelloDatabase, $LelloHubTableTable> {
  $$LelloHubTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));
}

class $$LelloHubTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $LelloHubTableTable> {
  $$LelloHubTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));
}

class $$LelloHubTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $LelloHubTableTable> {
  $$LelloHubTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);
}

class $$LelloHubTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $LelloHubTableTable,
    LelloHubData,
    $$LelloHubTableTableFilterComposer,
    $$LelloHubTableTableOrderingComposer,
    $$LelloHubTableTableAnnotationComposer,
    $$LelloHubTableTableCreateCompanionBuilder,
    $$LelloHubTableTableUpdateCompanionBuilder,
    (
      LelloHubData,
      BaseReferences<_$LelloDatabase, $LelloHubTableTable, LelloHubData>
    ),
    LelloHubData,
    PrefetchHooks Function()> {
  $$LelloHubTableTableTableManager(
      _$LelloDatabase db, $LelloHubTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LelloHubTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LelloHubTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LelloHubTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String?> number = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LelloHubTableCompanion(
            number: number,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String?> number = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LelloHubTableCompanion.insert(
            number: number,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LelloHubTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $LelloHubTableTable,
    LelloHubData,
    $$LelloHubTableTableFilterComposer,
    $$LelloHubTableTableOrderingComposer,
    $$LelloHubTableTableAnnotationComposer,
    $$LelloHubTableTableCreateCompanionBuilder,
    $$LelloHubTableTableUpdateCompanionBuilder,
    (
      LelloHubData,
      BaseReferences<_$LelloDatabase, $LelloHubTableTable, LelloHubData>
    ),
    LelloHubData,
    PrefetchHooks Function()>;
typedef $$UnitTableTableCreateCompanionBuilder = UnitTableCompanion Function({
  required String id,
  required String title,
  Value<String?> group,
  required int residentCount,
  required String condominiumId,
  required int vehicleCount,
  required bool adimplente,
  required bool agreement,
  required String billingStatus,
  required bool usesApp,
  required String fixedPhone,
  required String mobilePhone,
  required DateTime lastUpdated,
  Value<int> rowid,
});
typedef $$UnitTableTableUpdateCompanionBuilder = UnitTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> group,
  Value<int> residentCount,
  Value<String> condominiumId,
  Value<int> vehicleCount,
  Value<bool> adimplente,
  Value<bool> agreement,
  Value<String> billingStatus,
  Value<bool> usesApp,
  Value<String> fixedPhone,
  Value<String> mobilePhone,
  Value<DateTime> lastUpdated,
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

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get group => $composableBuilder(
      column: $table.group, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get residentCount => $composableBuilder(
      column: $table.residentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vehicleCount => $composableBuilder(
      column: $table.vehicleCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get adimplente => $composableBuilder(
      column: $table.adimplente, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get agreement => $composableBuilder(
      column: $table.agreement, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingStatus => $composableBuilder(
      column: $table.billingStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get usesApp => $composableBuilder(
      column: $table.usesApp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fixedPhone => $composableBuilder(
      column: $table.fixedPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobilePhone => $composableBuilder(
      column: $table.mobilePhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get group => $composableBuilder(
      column: $table.group, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get residentCount => $composableBuilder(
      column: $table.residentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vehicleCount => $composableBuilder(
      column: $table.vehicleCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get adimplente => $composableBuilder(
      column: $table.adimplente, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get agreement => $composableBuilder(
      column: $table.agreement, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingStatus => $composableBuilder(
      column: $table.billingStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get usesApp => $composableBuilder(
      column: $table.usesApp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fixedPhone => $composableBuilder(
      column: $table.fixedPhone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobilePhone => $composableBuilder(
      column: $table.mobilePhone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get group =>
      $composableBuilder(column: $table.group, builder: (column) => column);

  GeneratedColumn<int> get residentCount => $composableBuilder(
      column: $table.residentCount, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<int> get vehicleCount => $composableBuilder(
      column: $table.vehicleCount, builder: (column) => column);

  GeneratedColumn<bool> get adimplente => $composableBuilder(
      column: $table.adimplente, builder: (column) => column);

  GeneratedColumn<bool> get agreement =>
      $composableBuilder(column: $table.agreement, builder: (column) => column);

  GeneratedColumn<String> get billingStatus => $composableBuilder(
      column: $table.billingStatus, builder: (column) => column);

  GeneratedColumn<bool> get usesApp =>
      $composableBuilder(column: $table.usesApp, builder: (column) => column);

  GeneratedColumn<String> get fixedPhone => $composableBuilder(
      column: $table.fixedPhone, builder: (column) => column);

  GeneratedColumn<String> get mobilePhone => $composableBuilder(
      column: $table.mobilePhone, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);
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
            Value<String> title = const Value.absent(),
            Value<String?> group = const Value.absent(),
            Value<int> residentCount = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<int> vehicleCount = const Value.absent(),
            Value<bool> adimplente = const Value.absent(),
            Value<bool> agreement = const Value.absent(),
            Value<String> billingStatus = const Value.absent(),
            Value<bool> usesApp = const Value.absent(),
            Value<String> fixedPhone = const Value.absent(),
            Value<String> mobilePhone = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitTableCompanion(
            id: id,
            title: title,
            group: group,
            residentCount: residentCount,
            condominiumId: condominiumId,
            vehicleCount: vehicleCount,
            adimplente: adimplente,
            agreement: agreement,
            billingStatus: billingStatus,
            usesApp: usesApp,
            fixedPhone: fixedPhone,
            mobilePhone: mobilePhone,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> group = const Value.absent(),
            required int residentCount,
            required String condominiumId,
            required int vehicleCount,
            required bool adimplente,
            required bool agreement,
            required String billingStatus,
            required bool usesApp,
            required String fixedPhone,
            required String mobilePhone,
            required DateTime lastUpdated,
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitTableCompanion.insert(
            id: id,
            title: title,
            group: group,
            residentCount: residentCount,
            condominiumId: condominiumId,
            vehicleCount: vehicleCount,
            adimplente: adimplente,
            agreement: agreement,
            billingStatus: billingStatus,
            usesApp: usesApp,
            fixedPhone: fixedPhone,
            mobilePhone: mobilePhone,
            lastUpdated: lastUpdated,
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
typedef $$ResidentTableTableCreateCompanionBuilder = ResidentTableCompanion
    Function({
  required String id,
  required String name,
  required String cpf,
  required String unitId,
  required String unitTitle,
  Value<String?> unitGroup,
  required int unitResidentCount,
  required String condominiumId,
  Value<int> rowid,
});
typedef $$ResidentTableTableUpdateCompanionBuilder = ResidentTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> cpf,
  Value<String> unitId,
  Value<String> unitTitle,
  Value<String?> unitGroup,
  Value<int> unitResidentCount,
  Value<String> condominiumId,
  Value<int> rowid,
});

class $$ResidentTableTableFilterComposer
    extends Composer<_$LelloDatabase, $ResidentTableTable> {
  $$ResidentTableTableFilterComposer({
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

  ColumnFilters<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitTitle => $composableBuilder(
      column: $table.unitTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitGroup => $composableBuilder(
      column: $table.unitGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitResidentCount => $composableBuilder(
      column: $table.unitResidentCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));
}

class $$ResidentTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $ResidentTableTable> {
  $$ResidentTableTableOrderingComposer({
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

  ColumnOrderings<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitTitle => $composableBuilder(
      column: $table.unitTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitGroup => $composableBuilder(
      column: $table.unitGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitResidentCount => $composableBuilder(
      column: $table.unitResidentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));
}

class $$ResidentTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $ResidentTableTable> {
  $$ResidentTableTableAnnotationComposer({
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

  GeneratedColumn<String> get cpf =>
      $composableBuilder(column: $table.cpf, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get unitTitle =>
      $composableBuilder(column: $table.unitTitle, builder: (column) => column);

  GeneratedColumn<String> get unitGroup =>
      $composableBuilder(column: $table.unitGroup, builder: (column) => column);

  GeneratedColumn<int> get unitResidentCount => $composableBuilder(
      column: $table.unitResidentCount, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);
}

class $$ResidentTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $ResidentTableTable,
    ResidentData,
    $$ResidentTableTableFilterComposer,
    $$ResidentTableTableOrderingComposer,
    $$ResidentTableTableAnnotationComposer,
    $$ResidentTableTableCreateCompanionBuilder,
    $$ResidentTableTableUpdateCompanionBuilder,
    (
      ResidentData,
      BaseReferences<_$LelloDatabase, $ResidentTableTable, ResidentData>
    ),
    ResidentData,
    PrefetchHooks Function()> {
  $$ResidentTableTableTableManager(
      _$LelloDatabase db, $ResidentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResidentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResidentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResidentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> cpf = const Value.absent(),
            Value<String> unitId = const Value.absent(),
            Value<String> unitTitle = const Value.absent(),
            Value<String?> unitGroup = const Value.absent(),
            Value<int> unitResidentCount = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ResidentTableCompanion(
            id: id,
            name: name,
            cpf: cpf,
            unitId: unitId,
            unitTitle: unitTitle,
            unitGroup: unitGroup,
            unitResidentCount: unitResidentCount,
            condominiumId: condominiumId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String cpf,
            required String unitId,
            required String unitTitle,
            Value<String?> unitGroup = const Value.absent(),
            required int unitResidentCount,
            required String condominiumId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ResidentTableCompanion.insert(
            id: id,
            name: name,
            cpf: cpf,
            unitId: unitId,
            unitTitle: unitTitle,
            unitGroup: unitGroup,
            unitResidentCount: unitResidentCount,
            condominiumId: condominiumId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResidentTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $ResidentTableTable,
    ResidentData,
    $$ResidentTableTableFilterComposer,
    $$ResidentTableTableOrderingComposer,
    $$ResidentTableTableAnnotationComposer,
    $$ResidentTableTableCreateCompanionBuilder,
    $$ResidentTableTableUpdateCompanionBuilder,
    (
      ResidentData,
      BaseReferences<_$LelloDatabase, $ResidentTableTable, ResidentData>
    ),
    ResidentData,
    PrefetchHooks Function()>;
typedef $$IncomeForecastTableTableCreateCompanionBuilder
    = IncomeForecastTableCompanion Function({
  required String condominiumId,
  required int year,
  required int month,
  required String forecastPeriod,
  required double forecast,
  required double value,
  Value<int> rowid,
});
typedef $$IncomeForecastTableTableUpdateCompanionBuilder
    = IncomeForecastTableCompanion Function({
  Value<String> condominiumId,
  Value<int> year,
  Value<int> month,
  Value<String> forecastPeriod,
  Value<double> forecast,
  Value<double> value,
  Value<int> rowid,
});

class $$IncomeForecastTableTableFilterComposer
    extends Composer<_$LelloDatabase, $IncomeForecastTableTable> {
  $$IncomeForecastTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get forecastPeriod => $composableBuilder(
      column: $table.forecastPeriod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get forecast => $composableBuilder(
      column: $table.forecast, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$IncomeForecastTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $IncomeForecastTableTable> {
  $$IncomeForecastTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get forecastPeriod => $composableBuilder(
      column: $table.forecastPeriod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get forecast => $composableBuilder(
      column: $table.forecast, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$IncomeForecastTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $IncomeForecastTableTable> {
  $$IncomeForecastTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get forecastPeriod => $composableBuilder(
      column: $table.forecastPeriod, builder: (column) => column);

  GeneratedColumn<double> get forecast =>
      $composableBuilder(column: $table.forecast, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$IncomeForecastTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $IncomeForecastTableTable,
    IncomeForecastData,
    $$IncomeForecastTableTableFilterComposer,
    $$IncomeForecastTableTableOrderingComposer,
    $$IncomeForecastTableTableAnnotationComposer,
    $$IncomeForecastTableTableCreateCompanionBuilder,
    $$IncomeForecastTableTableUpdateCompanionBuilder,
    (
      IncomeForecastData,
      BaseReferences<_$LelloDatabase, $IncomeForecastTableTable,
          IncomeForecastData>
    ),
    IncomeForecastData,
    PrefetchHooks Function()> {
  $$IncomeForecastTableTableTableManager(
      _$LelloDatabase db, $IncomeForecastTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeForecastTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeForecastTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeForecastTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<String> forecastPeriod = const Value.absent(),
            Value<double> forecast = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IncomeForecastTableCompanion(
            condominiumId: condominiumId,
            year: year,
            month: month,
            forecastPeriod: forecastPeriod,
            forecast: forecast,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required int year,
            required int month,
            required String forecastPeriod,
            required double forecast,
            required double value,
            Value<int> rowid = const Value.absent(),
          }) =>
              IncomeForecastTableCompanion.insert(
            condominiumId: condominiumId,
            year: year,
            month: month,
            forecastPeriod: forecastPeriod,
            forecast: forecast,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IncomeForecastTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $IncomeForecastTableTable,
    IncomeForecastData,
    $$IncomeForecastTableTableFilterComposer,
    $$IncomeForecastTableTableOrderingComposer,
    $$IncomeForecastTableTableAnnotationComposer,
    $$IncomeForecastTableTableCreateCompanionBuilder,
    $$IncomeForecastTableTableUpdateCompanionBuilder,
    (
      IncomeForecastData,
      BaseReferences<_$LelloDatabase, $IncomeForecastTableTable,
          IncomeForecastData>
    ),
    IncomeForecastData,
    PrefetchHooks Function()>;
typedef $$IncomeTableTableCreateCompanionBuilder = IncomeTableCompanion
    Function({
  required String condominiumId,
  required double value,
  required int year,
  required int month,
  Value<int> rowid,
});
typedef $$IncomeTableTableUpdateCompanionBuilder = IncomeTableCompanion
    Function({
  Value<String> condominiumId,
  Value<double> value,
  Value<int> year,
  Value<int> month,
  Value<int> rowid,
});

class $$IncomeTableTableFilterComposer
    extends Composer<_$LelloDatabase, $IncomeTableTable> {
  $$IncomeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));
}

class $$IncomeTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $IncomeTableTable> {
  $$IncomeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));
}

class $$IncomeTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $IncomeTableTable> {
  $$IncomeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);
}

class $$IncomeTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $IncomeTableTable,
    IncomeData,
    $$IncomeTableTableFilterComposer,
    $$IncomeTableTableOrderingComposer,
    $$IncomeTableTableAnnotationComposer,
    $$IncomeTableTableCreateCompanionBuilder,
    $$IncomeTableTableUpdateCompanionBuilder,
    (
      IncomeData,
      BaseReferences<_$LelloDatabase, $IncomeTableTable, IncomeData>
    ),
    IncomeData,
    PrefetchHooks Function()> {
  $$IncomeTableTableTableManager(_$LelloDatabase db, $IncomeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IncomeTableCompanion(
            condominiumId: condominiumId,
            value: value,
            year: year,
            month: month,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required double value,
            required int year,
            required int month,
            Value<int> rowid = const Value.absent(),
          }) =>
              IncomeTableCompanion.insert(
            condominiumId: condominiumId,
            value: value,
            year: year,
            month: month,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IncomeTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $IncomeTableTable,
    IncomeData,
    $$IncomeTableTableFilterComposer,
    $$IncomeTableTableOrderingComposer,
    $$IncomeTableTableAnnotationComposer,
    $$IncomeTableTableCreateCompanionBuilder,
    $$IncomeTableTableUpdateCompanionBuilder,
    (
      IncomeData,
      BaseReferences<_$LelloDatabase, $IncomeTableTable, IncomeData>
    ),
    IncomeData,
    PrefetchHooks Function()>;
typedef $$IncomeShareTableTableCreateCompanionBuilder
    = IncomeShareTableCompanion Function({
  required String condominiumId,
  required int year,
  required int month,
  required String title,
  required int total,
  required double share,
  required String color,
  Value<int> rowid,
});
typedef $$IncomeShareTableTableUpdateCompanionBuilder
    = IncomeShareTableCompanion Function({
  Value<String> condominiumId,
  Value<int> year,
  Value<int> month,
  Value<String> title,
  Value<int> total,
  Value<double> share,
  Value<String> color,
  Value<int> rowid,
});

class $$IncomeShareTableTableFilterComposer
    extends Composer<_$LelloDatabase, $IncomeShareTableTable> {
  $$IncomeShareTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get share => $composableBuilder(
      column: $table.share, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));
}

class $$IncomeShareTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $IncomeShareTableTable> {
  $$IncomeShareTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get share => $composableBuilder(
      column: $table.share, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$IncomeShareTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $IncomeShareTableTable> {
  $$IncomeShareTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get share =>
      $composableBuilder(column: $table.share, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$IncomeShareTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $IncomeShareTableTable,
    IncomeShareData,
    $$IncomeShareTableTableFilterComposer,
    $$IncomeShareTableTableOrderingComposer,
    $$IncomeShareTableTableAnnotationComposer,
    $$IncomeShareTableTableCreateCompanionBuilder,
    $$IncomeShareTableTableUpdateCompanionBuilder,
    (
      IncomeShareData,
      BaseReferences<_$LelloDatabase, $IncomeShareTableTable, IncomeShareData>
    ),
    IncomeShareData,
    PrefetchHooks Function()> {
  $$IncomeShareTableTableTableManager(
      _$LelloDatabase db, $IncomeShareTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeShareTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeShareTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeShareTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> total = const Value.absent(),
            Value<double> share = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IncomeShareTableCompanion(
            condominiumId: condominiumId,
            year: year,
            month: month,
            title: title,
            total: total,
            share: share,
            color: color,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required int year,
            required int month,
            required String title,
            required int total,
            required double share,
            required String color,
            Value<int> rowid = const Value.absent(),
          }) =>
              IncomeShareTableCompanion.insert(
            condominiumId: condominiumId,
            year: year,
            month: month,
            title: title,
            total: total,
            share: share,
            color: color,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IncomeShareTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $IncomeShareTableTable,
    IncomeShareData,
    $$IncomeShareTableTableFilterComposer,
    $$IncomeShareTableTableOrderingComposer,
    $$IncomeShareTableTableAnnotationComposer,
    $$IncomeShareTableTableCreateCompanionBuilder,
    $$IncomeShareTableTableUpdateCompanionBuilder,
    (
      IncomeShareData,
      BaseReferences<_$LelloDatabase, $IncomeShareTableTable, IncomeShareData>
    ),
    IncomeShareData,
    PrefetchHooks Function()>;
typedef $$ChatContactTableTableCreateCompanionBuilder
    = ChatContactTableCompanion Function({
  required String id,
  required String condominiumId,
  Value<String?> unitId,
  Value<String?> unitTitle,
  Value<String?> unitGroup,
  Value<String?> phone,
  Value<int> rowid,
});
typedef $$ChatContactTableTableUpdateCompanionBuilder
    = ChatContactTableCompanion Function({
  Value<String> id,
  Value<String> condominiumId,
  Value<String?> unitId,
  Value<String?> unitTitle,
  Value<String?> unitGroup,
  Value<String?> phone,
  Value<int> rowid,
});

class $$ChatContactTableTableFilterComposer
    extends Composer<_$LelloDatabase, $ChatContactTableTable> {
  $$ChatContactTableTableFilterComposer({
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

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitTitle => $composableBuilder(
      column: $table.unitTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitGroup => $composableBuilder(
      column: $table.unitGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));
}

class $$ChatContactTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $ChatContactTableTable> {
  $$ChatContactTableTableOrderingComposer({
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

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitTitle => $composableBuilder(
      column: $table.unitTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitGroup => $composableBuilder(
      column: $table.unitGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));
}

class $$ChatContactTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $ChatContactTableTable> {
  $$ChatContactTableTableAnnotationComposer({
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

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get unitTitle =>
      $composableBuilder(column: $table.unitTitle, builder: (column) => column);

  GeneratedColumn<String> get unitGroup =>
      $composableBuilder(column: $table.unitGroup, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);
}

class $$ChatContactTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $ChatContactTableTable,
    ChatContactData,
    $$ChatContactTableTableFilterComposer,
    $$ChatContactTableTableOrderingComposer,
    $$ChatContactTableTableAnnotationComposer,
    $$ChatContactTableTableCreateCompanionBuilder,
    $$ChatContactTableTableUpdateCompanionBuilder,
    (
      ChatContactData,
      BaseReferences<_$LelloDatabase, $ChatContactTableTable, ChatContactData>
    ),
    ChatContactData,
    PrefetchHooks Function()> {
  $$ChatContactTableTableTableManager(
      _$LelloDatabase db, $ChatContactTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatContactTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatContactTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatContactTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<String?> unitId = const Value.absent(),
            Value<String?> unitTitle = const Value.absent(),
            Value<String?> unitGroup = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatContactTableCompanion(
            id: id,
            condominiumId: condominiumId,
            unitId: unitId,
            unitTitle: unitTitle,
            unitGroup: unitGroup,
            phone: phone,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String condominiumId,
            Value<String?> unitId = const Value.absent(),
            Value<String?> unitTitle = const Value.absent(),
            Value<String?> unitGroup = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatContactTableCompanion.insert(
            id: id,
            condominiumId: condominiumId,
            unitId: unitId,
            unitTitle: unitTitle,
            unitGroup: unitGroup,
            phone: phone,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatContactTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $ChatContactTableTable,
    ChatContactData,
    $$ChatContactTableTableFilterComposer,
    $$ChatContactTableTableOrderingComposer,
    $$ChatContactTableTableAnnotationComposer,
    $$ChatContactTableTableCreateCompanionBuilder,
    $$ChatContactTableTableUpdateCompanionBuilder,
    (
      ChatContactData,
      BaseReferences<_$LelloDatabase, $ChatContactTableTable, ChatContactData>
    ),
    ChatContactData,
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
typedef $$ReservationSummaryTableTableCreateCompanionBuilder
    = ReservationSummaryTableCompanion Function({
  required DateTime day,
  required String condominiumId,
  required String type,
  Value<int> rowid,
});
typedef $$ReservationSummaryTableTableUpdateCompanionBuilder
    = ReservationSummaryTableCompanion Function({
  Value<DateTime> day,
  Value<String> condominiumId,
  Value<String> type,
  Value<int> rowid,
});

class $$ReservationSummaryTableTableFilterComposer
    extends Composer<_$LelloDatabase, $ReservationSummaryTableTable> {
  $$ReservationSummaryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));
}

class $$ReservationSummaryTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $ReservationSummaryTableTable> {
  $$ReservationSummaryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));
}

class $$ReservationSummaryTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $ReservationSummaryTableTable> {
  $$ReservationSummaryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$ReservationSummaryTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $ReservationSummaryTableTable,
    ReservationSummaryData,
    $$ReservationSummaryTableTableFilterComposer,
    $$ReservationSummaryTableTableOrderingComposer,
    $$ReservationSummaryTableTableAnnotationComposer,
    $$ReservationSummaryTableTableCreateCompanionBuilder,
    $$ReservationSummaryTableTableUpdateCompanionBuilder,
    (
      ReservationSummaryData,
      BaseReferences<_$LelloDatabase, $ReservationSummaryTableTable,
          ReservationSummaryData>
    ),
    ReservationSummaryData,
    PrefetchHooks Function()> {
  $$ReservationSummaryTableTableTableManager(
      _$LelloDatabase db, $ReservationSummaryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReservationSummaryTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ReservationSummaryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReservationSummaryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> day = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationSummaryTableCompanion(
            day: day,
            condominiumId: condominiumId,
            type: type,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime day,
            required String condominiumId,
            required String type,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationSummaryTableCompanion.insert(
            day: day,
            condominiumId: condominiumId,
            type: type,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReservationSummaryTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $ReservationSummaryTableTable,
        ReservationSummaryData,
        $$ReservationSummaryTableTableFilterComposer,
        $$ReservationSummaryTableTableOrderingComposer,
        $$ReservationSummaryTableTableAnnotationComposer,
        $$ReservationSummaryTableTableCreateCompanionBuilder,
        $$ReservationSummaryTableTableUpdateCompanionBuilder,
        (
          ReservationSummaryData,
          BaseReferences<_$LelloDatabase, $ReservationSummaryTableTable,
              ReservationSummaryData>
        ),
        ReservationSummaryData,
        PrefetchHooks Function()>;
typedef $$SpaceTableTableCreateCompanionBuilder = SpaceTableCompanion Function({
  required String id,
  Value<String?> name,
  Value<String?> pictureUrl,
  required String condominiumId,
  Value<int> rowid,
});
typedef $$SpaceTableTableUpdateCompanionBuilder = SpaceTableCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<String?> pictureUrl,
  Value<String> condominiumId,
  Value<int> rowid,
});

class $$SpaceTableTableFilterComposer
    extends Composer<_$LelloDatabase, $SpaceTableTable> {
  $$SpaceTableTableFilterComposer({
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

  ColumnFilters<String> get pictureUrl => $composableBuilder(
      column: $table.pictureUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));
}

class $$SpaceTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $SpaceTableTable> {
  $$SpaceTableTableOrderingComposer({
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

  ColumnOrderings<String> get pictureUrl => $composableBuilder(
      column: $table.pictureUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));
}

class $$SpaceTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $SpaceTableTable> {
  $$SpaceTableTableAnnotationComposer({
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

  GeneratedColumn<String> get pictureUrl => $composableBuilder(
      column: $table.pictureUrl, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);
}

class $$SpaceTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $SpaceTableTable,
    SpaceData,
    $$SpaceTableTableFilterComposer,
    $$SpaceTableTableOrderingComposer,
    $$SpaceTableTableAnnotationComposer,
    $$SpaceTableTableCreateCompanionBuilder,
    $$SpaceTableTableUpdateCompanionBuilder,
    (SpaceData, BaseReferences<_$LelloDatabase, $SpaceTableTable, SpaceData>),
    SpaceData,
    PrefetchHooks Function()> {
  $$SpaceTableTableTableManager(_$LelloDatabase db, $SpaceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpaceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpaceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpaceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> pictureUrl = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpaceTableCompanion(
            id: id,
            name: name,
            pictureUrl: pictureUrl,
            condominiumId: condominiumId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            Value<String?> pictureUrl = const Value.absent(),
            required String condominiumId,
            Value<int> rowid = const Value.absent(),
          }) =>
              SpaceTableCompanion.insert(
            id: id,
            name: name,
            pictureUrl: pictureUrl,
            condominiumId: condominiumId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SpaceTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $SpaceTableTable,
    SpaceData,
    $$SpaceTableTableFilterComposer,
    $$SpaceTableTableOrderingComposer,
    $$SpaceTableTableAnnotationComposer,
    $$SpaceTableTableCreateCompanionBuilder,
    $$SpaceTableTableUpdateCompanionBuilder,
    (SpaceData, BaseReferences<_$LelloDatabase, $SpaceTableTable, SpaceData>),
    SpaceData,
    PrefetchHooks Function()>;
typedef $$CondominiumBalanceTableTableCreateCompanionBuilder
    = CondominiumBalanceTableCompanion Function({
  Value<String?> id,
  required String reference,
  Value<double?> balance,
  Value<double?> previousBalance,
  Value<double?> forecast,
  Value<double?> income,
  Value<double?> expenses,
  Value<DateTime?> date,
  Value<DateTime?> lastUpdatedAt,
  Value<int> rowid,
});
typedef $$CondominiumBalanceTableTableUpdateCompanionBuilder
    = CondominiumBalanceTableCompanion Function({
  Value<String?> id,
  Value<String> reference,
  Value<double?> balance,
  Value<double?> previousBalance,
  Value<double?> forecast,
  Value<double?> income,
  Value<double?> expenses,
  Value<DateTime?> date,
  Value<DateTime?> lastUpdatedAt,
  Value<int> rowid,
});

class $$CondominiumBalanceTableTableFilterComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceTableTable> {
  $$CondominiumBalanceTableTableFilterComposer({
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

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get forecast => $composableBuilder(
      column: $table.forecast, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get income => $composableBuilder(
      column: $table.income, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get expenses => $composableBuilder(
      column: $table.expenses, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$CondominiumBalanceTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceTableTable> {
  $$CondominiumBalanceTableTableOrderingComposer({
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

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get forecast => $composableBuilder(
      column: $table.forecast, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get income => $composableBuilder(
      column: $table.income, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get expenses => $composableBuilder(
      column: $table.expenses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$CondominiumBalanceTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceTableTable> {
  $$CondominiumBalanceTableTableAnnotationComposer({
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

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance, builder: (column) => column);

  GeneratedColumn<double> get forecast =>
      $composableBuilder(column: $table.forecast, builder: (column) => column);

  GeneratedColumn<double> get income =>
      $composableBuilder(column: $table.income, builder: (column) => column);

  GeneratedColumn<double> get expenses =>
      $composableBuilder(column: $table.expenses, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$CondominiumBalanceTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $CondominiumBalanceTableTable,
    CondominiumBalanceData,
    $$CondominiumBalanceTableTableFilterComposer,
    $$CondominiumBalanceTableTableOrderingComposer,
    $$CondominiumBalanceTableTableAnnotationComposer,
    $$CondominiumBalanceTableTableCreateCompanionBuilder,
    $$CondominiumBalanceTableTableUpdateCompanionBuilder,
    (
      CondominiumBalanceData,
      BaseReferences<_$LelloDatabase, $CondominiumBalanceTableTable,
          CondominiumBalanceData>
    ),
    CondominiumBalanceData,
    PrefetchHooks Function()> {
  $$CondominiumBalanceTableTableTableManager(
      _$LelloDatabase db, $CondominiumBalanceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CondominiumBalanceTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CondominiumBalanceTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CondominiumBalanceTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            Value<String> reference = const Value.absent(),
            Value<double?> balance = const Value.absent(),
            Value<double?> previousBalance = const Value.absent(),
            Value<double?> forecast = const Value.absent(),
            Value<double?> income = const Value.absent(),
            Value<double?> expenses = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
            Value<DateTime?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceTableCompanion(
            id: id,
            reference: reference,
            balance: balance,
            previousBalance: previousBalance,
            forecast: forecast,
            income: income,
            expenses: expenses,
            date: date,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            required String reference,
            Value<double?> balance = const Value.absent(),
            Value<double?> previousBalance = const Value.absent(),
            Value<double?> forecast = const Value.absent(),
            Value<double?> income = const Value.absent(),
            Value<double?> expenses = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
            Value<DateTime?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceTableCompanion.insert(
            id: id,
            reference: reference,
            balance: balance,
            previousBalance: previousBalance,
            forecast: forecast,
            income: income,
            expenses: expenses,
            date: date,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CondominiumBalanceTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $CondominiumBalanceTableTable,
        CondominiumBalanceData,
        $$CondominiumBalanceTableTableFilterComposer,
        $$CondominiumBalanceTableTableOrderingComposer,
        $$CondominiumBalanceTableTableAnnotationComposer,
        $$CondominiumBalanceTableTableCreateCompanionBuilder,
        $$CondominiumBalanceTableTableUpdateCompanionBuilder,
        (
          CondominiumBalanceData,
          BaseReferences<_$LelloDatabase, $CondominiumBalanceTableTable,
              CondominiumBalanceData>
        ),
        CondominiumBalanceData,
        PrefetchHooks Function()>;
typedef $$CondominiumBalanceDetailTableTableCreateCompanionBuilder
    = CondominiumBalanceDetailTableCompanion Function({
  required String reference,
  Value<double?> previousBalance,
  Value<double?> balance,
  Value<double?> accountBalance,
  Value<double?> debit,
  Value<double?> credits,
  Value<DateTime?> lastUpdatedAt,
  Value<int> rowid,
});
typedef $$CondominiumBalanceDetailTableTableUpdateCompanionBuilder
    = CondominiumBalanceDetailTableCompanion Function({
  Value<String> reference,
  Value<double?> previousBalance,
  Value<double?> balance,
  Value<double?> accountBalance,
  Value<double?> debit,
  Value<double?> credits,
  Value<DateTime?> lastUpdatedAt,
  Value<int> rowid,
});

class $$CondominiumBalanceDetailTableTableFilterComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceDetailTableTable> {
  $$CondominiumBalanceDetailTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accountBalance => $composableBuilder(
      column: $table.accountBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$CondominiumBalanceDetailTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceDetailTableTable> {
  $$CondominiumBalanceDetailTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accountBalance => $composableBuilder(
      column: $table.accountBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$CondominiumBalanceDetailTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceDetailTableTable> {
  $$CondominiumBalanceDetailTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<double> get accountBalance => $composableBuilder(
      column: $table.accountBalance, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$CondominiumBalanceDetailTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $CondominiumBalanceDetailTableTable,
    CondominiumBalanceDetailData,
    $$CondominiumBalanceDetailTableTableFilterComposer,
    $$CondominiumBalanceDetailTableTableOrderingComposer,
    $$CondominiumBalanceDetailTableTableAnnotationComposer,
    $$CondominiumBalanceDetailTableTableCreateCompanionBuilder,
    $$CondominiumBalanceDetailTableTableUpdateCompanionBuilder,
    (
      CondominiumBalanceDetailData,
      BaseReferences<_$LelloDatabase, $CondominiumBalanceDetailTableTable,
          CondominiumBalanceDetailData>
    ),
    CondominiumBalanceDetailData,
    PrefetchHooks Function()> {
  $$CondominiumBalanceDetailTableTableTableManager(
      _$LelloDatabase db, $CondominiumBalanceDetailTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CondominiumBalanceDetailTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CondominiumBalanceDetailTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CondominiumBalanceDetailTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> reference = const Value.absent(),
            Value<double?> previousBalance = const Value.absent(),
            Value<double?> balance = const Value.absent(),
            Value<double?> accountBalance = const Value.absent(),
            Value<double?> debit = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<DateTime?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceDetailTableCompanion(
            reference: reference,
            previousBalance: previousBalance,
            balance: balance,
            accountBalance: accountBalance,
            debit: debit,
            credits: credits,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String reference,
            Value<double?> previousBalance = const Value.absent(),
            Value<double?> balance = const Value.absent(),
            Value<double?> accountBalance = const Value.absent(),
            Value<double?> debit = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<DateTime?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceDetailTableCompanion.insert(
            reference: reference,
            previousBalance: previousBalance,
            balance: balance,
            accountBalance: accountBalance,
            debit: debit,
            credits: credits,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CondominiumBalanceDetailTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $CondominiumBalanceDetailTableTable,
        CondominiumBalanceDetailData,
        $$CondominiumBalanceDetailTableTableFilterComposer,
        $$CondominiumBalanceDetailTableTableOrderingComposer,
        $$CondominiumBalanceDetailTableTableAnnotationComposer,
        $$CondominiumBalanceDetailTableTableCreateCompanionBuilder,
        $$CondominiumBalanceDetailTableTableUpdateCompanionBuilder,
        (
          CondominiumBalanceDetailData,
          BaseReferences<_$LelloDatabase, $CondominiumBalanceDetailTableTable,
              CondominiumBalanceDetailData>
        ),
        CondominiumBalanceDetailData,
        PrefetchHooks Function()>;
typedef $$CondominiumBalanceDebitsTableTableCreateCompanionBuilder
    = CondominiumBalanceDebitsTableCompanion Function({
  required String reference,
  Value<String?> id,
  Value<String?> name,
  Value<String?> type,
  Value<double?> previousBalance,
  Value<double?> balance,
  Value<double?> accountBalance,
  Value<double?> debit,
  Value<double?> credits,
  Value<DateTime?> period,
  Value<int> rowid,
});
typedef $$CondominiumBalanceDebitsTableTableUpdateCompanionBuilder
    = CondominiumBalanceDebitsTableCompanion Function({
  Value<String> reference,
  Value<String?> id,
  Value<String?> name,
  Value<String?> type,
  Value<double?> previousBalance,
  Value<double?> balance,
  Value<double?> accountBalance,
  Value<double?> debit,
  Value<double?> credits,
  Value<DateTime?> period,
  Value<int> rowid,
});

class $$CondominiumBalanceDebitsTableTableFilterComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceDebitsTableTable> {
  $$CondominiumBalanceDebitsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accountBalance => $composableBuilder(
      column: $table.accountBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnFilters(column));
}

class $$CondominiumBalanceDebitsTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceDebitsTableTable> {
  $$CondominiumBalanceDebitsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accountBalance => $composableBuilder(
      column: $table.accountBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnOrderings(column));
}

class $$CondominiumBalanceDebitsTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceDebitsTableTable> {
  $$CondominiumBalanceDebitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get previousBalance => $composableBuilder(
      column: $table.previousBalance, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<double> get accountBalance => $composableBuilder(
      column: $table.accountBalance, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<DateTime> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);
}

class $$CondominiumBalanceDebitsTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $CondominiumBalanceDebitsTableTable,
    CondominiumBalanceDebitsData,
    $$CondominiumBalanceDebitsTableTableFilterComposer,
    $$CondominiumBalanceDebitsTableTableOrderingComposer,
    $$CondominiumBalanceDebitsTableTableAnnotationComposer,
    $$CondominiumBalanceDebitsTableTableCreateCompanionBuilder,
    $$CondominiumBalanceDebitsTableTableUpdateCompanionBuilder,
    (
      CondominiumBalanceDebitsData,
      BaseReferences<_$LelloDatabase, $CondominiumBalanceDebitsTableTable,
          CondominiumBalanceDebitsData>
    ),
    CondominiumBalanceDebitsData,
    PrefetchHooks Function()> {
  $$CondominiumBalanceDebitsTableTableTableManager(
      _$LelloDatabase db, $CondominiumBalanceDebitsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CondominiumBalanceDebitsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CondominiumBalanceDebitsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CondominiumBalanceDebitsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> reference = const Value.absent(),
            Value<String?> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<double?> previousBalance = const Value.absent(),
            Value<double?> balance = const Value.absent(),
            Value<double?> accountBalance = const Value.absent(),
            Value<double?> debit = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<DateTime?> period = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceDebitsTableCompanion(
            reference: reference,
            id: id,
            name: name,
            type: type,
            previousBalance: previousBalance,
            balance: balance,
            accountBalance: accountBalance,
            debit: debit,
            credits: credits,
            period: period,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String reference,
            Value<String?> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<double?> previousBalance = const Value.absent(),
            Value<double?> balance = const Value.absent(),
            Value<double?> accountBalance = const Value.absent(),
            Value<double?> debit = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<DateTime?> period = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceDebitsTableCompanion.insert(
            reference: reference,
            id: id,
            name: name,
            type: type,
            previousBalance: previousBalance,
            balance: balance,
            accountBalance: accountBalance,
            debit: debit,
            credits: credits,
            period: period,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CondominiumBalanceDebitsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $CondominiumBalanceDebitsTableTable,
        CondominiumBalanceDebitsData,
        $$CondominiumBalanceDebitsTableTableFilterComposer,
        $$CondominiumBalanceDebitsTableTableOrderingComposer,
        $$CondominiumBalanceDebitsTableTableAnnotationComposer,
        $$CondominiumBalanceDebitsTableTableCreateCompanionBuilder,
        $$CondominiumBalanceDebitsTableTableUpdateCompanionBuilder,
        (
          CondominiumBalanceDebitsData,
          BaseReferences<_$LelloDatabase, $CondominiumBalanceDebitsTableTable,
              CondominiumBalanceDebitsData>
        ),
        CondominiumBalanceDebitsData,
        PrefetchHooks Function()>;
typedef $$CondominiumBalanceSummaryTableTableCreateCompanionBuilder
    = CondominiumBalanceSummaryTableCompanion Function({
  required String reference,
  Value<String?> name,
  Value<double?> debits,
  Value<double?> credits,
  Value<int> rowid,
});
typedef $$CondominiumBalanceSummaryTableTableUpdateCompanionBuilder
    = CondominiumBalanceSummaryTableCompanion Function({
  Value<String> reference,
  Value<String?> name,
  Value<double?> debits,
  Value<double?> credits,
  Value<int> rowid,
});

class $$CondominiumBalanceSummaryTableTableFilterComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceSummaryTableTable> {
  $$CondominiumBalanceSummaryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get debits => $composableBuilder(
      column: $table.debits, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnFilters(column));
}

class $$CondominiumBalanceSummaryTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceSummaryTableTable> {
  $$CondominiumBalanceSummaryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get debits => $composableBuilder(
      column: $table.debits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnOrderings(column));
}

class $$CondominiumBalanceSummaryTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $CondominiumBalanceSummaryTableTable> {
  $$CondominiumBalanceSummaryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get debits =>
      $composableBuilder(column: $table.debits, builder: (column) => column);

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);
}

class $$CondominiumBalanceSummaryTableTableTableManager
    extends RootTableManager<
        _$LelloDatabase,
        $CondominiumBalanceSummaryTableTable,
        CondominiumBalanceSummaryData,
        $$CondominiumBalanceSummaryTableTableFilterComposer,
        $$CondominiumBalanceSummaryTableTableOrderingComposer,
        $$CondominiumBalanceSummaryTableTableAnnotationComposer,
        $$CondominiumBalanceSummaryTableTableCreateCompanionBuilder,
        $$CondominiumBalanceSummaryTableTableUpdateCompanionBuilder,
        (
          CondominiumBalanceSummaryData,
          BaseReferences<_$LelloDatabase, $CondominiumBalanceSummaryTableTable,
              CondominiumBalanceSummaryData>
        ),
        CondominiumBalanceSummaryData,
        PrefetchHooks Function()> {
  $$CondominiumBalanceSummaryTableTableTableManager(
      _$LelloDatabase db, $CondominiumBalanceSummaryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CondominiumBalanceSummaryTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CondominiumBalanceSummaryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CondominiumBalanceSummaryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> reference = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<double?> debits = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceSummaryTableCompanion(
            reference: reference,
            name: name,
            debits: debits,
            credits: credits,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String reference,
            Value<String?> name = const Value.absent(),
            Value<double?> debits = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CondominiumBalanceSummaryTableCompanion.insert(
            reference: reference,
            name: name,
            debits: debits,
            credits: credits,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CondominiumBalanceSummaryTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $CondominiumBalanceSummaryTableTable,
        CondominiumBalanceSummaryData,
        $$CondominiumBalanceSummaryTableTableFilterComposer,
        $$CondominiumBalanceSummaryTableTableOrderingComposer,
        $$CondominiumBalanceSummaryTableTableAnnotationComposer,
        $$CondominiumBalanceSummaryTableTableCreateCompanionBuilder,
        $$CondominiumBalanceSummaryTableTableUpdateCompanionBuilder,
        (
          CondominiumBalanceSummaryData,
          BaseReferences<_$LelloDatabase, $CondominiumBalanceSummaryTableTable,
              CondominiumBalanceSummaryData>
        ),
        CondominiumBalanceSummaryData,
        PrefetchHooks Function()>;
typedef $$AgreementsTableTableCreateCompanionBuilder = AgreementsTableCompanion
    Function({
  required String id,
  required String condominiumId,
  required int reference,
  Value<String?> unit,
  Value<String?> unitOwner,
  required double baseValue,
  required double fineAndCosts,
  required int installmentQuantity,
  Value<String?> paymentMethod,
  Value<String?> status,
  Value<String?> statusMessage,
  Value<DateTime?> expiration,
  Value<DateTime?> proposaldedDate,
  Value<DateTime?> approvalDate,
  required int dueDate,
  Value<DateTime?> lastInstallmentDate,
  Value<int> rowid,
});
typedef $$AgreementsTableTableUpdateCompanionBuilder = AgreementsTableCompanion
    Function({
  Value<String> id,
  Value<String> condominiumId,
  Value<int> reference,
  Value<String?> unit,
  Value<String?> unitOwner,
  Value<double> baseValue,
  Value<double> fineAndCosts,
  Value<int> installmentQuantity,
  Value<String?> paymentMethod,
  Value<String?> status,
  Value<String?> statusMessage,
  Value<DateTime?> expiration,
  Value<DateTime?> proposaldedDate,
  Value<DateTime?> approvalDate,
  Value<int> dueDate,
  Value<DateTime?> lastInstallmentDate,
  Value<int> rowid,
});

class $$AgreementsTableTableFilterComposer
    extends Composer<_$LelloDatabase, $AgreementsTableTable> {
  $$AgreementsTableTableFilterComposer({
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

  ColumnFilters<int> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitOwner => $composableBuilder(
      column: $table.unitOwner, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseValue => $composableBuilder(
      column: $table.baseValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fineAndCosts => $composableBuilder(
      column: $table.fineAndCosts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installmentQuantity => $composableBuilder(
      column: $table.installmentQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statusMessage => $composableBuilder(
      column: $table.statusMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiration => $composableBuilder(
      column: $table.expiration, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get proposaldedDate => $composableBuilder(
      column: $table.proposaldedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get approvalDate => $composableBuilder(
      column: $table.approvalDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastInstallmentDate => $composableBuilder(
      column: $table.lastInstallmentDate,
      builder: (column) => ColumnFilters(column));
}

class $$AgreementsTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $AgreementsTableTable> {
  $$AgreementsTableTableOrderingComposer({
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

  ColumnOrderings<int> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitOwner => $composableBuilder(
      column: $table.unitOwner, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseValue => $composableBuilder(
      column: $table.baseValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fineAndCosts => $composableBuilder(
      column: $table.fineAndCosts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installmentQuantity => $composableBuilder(
      column: $table.installmentQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statusMessage => $composableBuilder(
      column: $table.statusMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiration => $composableBuilder(
      column: $table.expiration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get proposaldedDate => $composableBuilder(
      column: $table.proposaldedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get approvalDate => $composableBuilder(
      column: $table.approvalDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastInstallmentDate => $composableBuilder(
      column: $table.lastInstallmentDate,
      builder: (column) => ColumnOrderings(column));
}

class $$AgreementsTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $AgreementsTableTable> {
  $$AgreementsTableTableAnnotationComposer({
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

  GeneratedColumn<int> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get unitOwner =>
      $composableBuilder(column: $table.unitOwner, builder: (column) => column);

  GeneratedColumn<double> get baseValue =>
      $composableBuilder(column: $table.baseValue, builder: (column) => column);

  GeneratedColumn<double> get fineAndCosts => $composableBuilder(
      column: $table.fineAndCosts, builder: (column) => column);

  GeneratedColumn<int> get installmentQuantity => $composableBuilder(
      column: $table.installmentQuantity, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get statusMessage => $composableBuilder(
      column: $table.statusMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get expiration => $composableBuilder(
      column: $table.expiration, builder: (column) => column);

  GeneratedColumn<DateTime> get proposaldedDate => $composableBuilder(
      column: $table.proposaldedDate, builder: (column) => column);

  GeneratedColumn<DateTime> get approvalDate => $composableBuilder(
      column: $table.approvalDate, builder: (column) => column);

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastInstallmentDate => $composableBuilder(
      column: $table.lastInstallmentDate, builder: (column) => column);
}

class $$AgreementsTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $AgreementsTableTable,
    AgreementsData,
    $$AgreementsTableTableFilterComposer,
    $$AgreementsTableTableOrderingComposer,
    $$AgreementsTableTableAnnotationComposer,
    $$AgreementsTableTableCreateCompanionBuilder,
    $$AgreementsTableTableUpdateCompanionBuilder,
    (
      AgreementsData,
      BaseReferences<_$LelloDatabase, $AgreementsTableTable, AgreementsData>
    ),
    AgreementsData,
    PrefetchHooks Function()> {
  $$AgreementsTableTableTableManager(
      _$LelloDatabase db, $AgreementsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgreementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgreementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgreementsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<int> reference = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> unitOwner = const Value.absent(),
            Value<double> baseValue = const Value.absent(),
            Value<double> fineAndCosts = const Value.absent(),
            Value<int> installmentQuantity = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> statusMessage = const Value.absent(),
            Value<DateTime?> expiration = const Value.absent(),
            Value<DateTime?> proposaldedDate = const Value.absent(),
            Value<DateTime?> approvalDate = const Value.absent(),
            Value<int> dueDate = const Value.absent(),
            Value<DateTime?> lastInstallmentDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsTableCompanion(
            id: id,
            condominiumId: condominiumId,
            reference: reference,
            unit: unit,
            unitOwner: unitOwner,
            baseValue: baseValue,
            fineAndCosts: fineAndCosts,
            installmentQuantity: installmentQuantity,
            paymentMethod: paymentMethod,
            status: status,
            statusMessage: statusMessage,
            expiration: expiration,
            proposaldedDate: proposaldedDate,
            approvalDate: approvalDate,
            dueDate: dueDate,
            lastInstallmentDate: lastInstallmentDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String condominiumId,
            required int reference,
            Value<String?> unit = const Value.absent(),
            Value<String?> unitOwner = const Value.absent(),
            required double baseValue,
            required double fineAndCosts,
            required int installmentQuantity,
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> statusMessage = const Value.absent(),
            Value<DateTime?> expiration = const Value.absent(),
            Value<DateTime?> proposaldedDate = const Value.absent(),
            Value<DateTime?> approvalDate = const Value.absent(),
            required int dueDate,
            Value<DateTime?> lastInstallmentDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsTableCompanion.insert(
            id: id,
            condominiumId: condominiumId,
            reference: reference,
            unit: unit,
            unitOwner: unitOwner,
            baseValue: baseValue,
            fineAndCosts: fineAndCosts,
            installmentQuantity: installmentQuantity,
            paymentMethod: paymentMethod,
            status: status,
            statusMessage: statusMessage,
            expiration: expiration,
            proposaldedDate: proposaldedDate,
            approvalDate: approvalDate,
            dueDate: dueDate,
            lastInstallmentDate: lastInstallmentDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AgreementsTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $AgreementsTableTable,
    AgreementsData,
    $$AgreementsTableTableFilterComposer,
    $$AgreementsTableTableOrderingComposer,
    $$AgreementsTableTableAnnotationComposer,
    $$AgreementsTableTableCreateCompanionBuilder,
    $$AgreementsTableTableUpdateCompanionBuilder,
    (
      AgreementsData,
      BaseReferences<_$LelloDatabase, $AgreementsTableTable, AgreementsData>
    ),
    AgreementsData,
    PrefetchHooks Function()>;
typedef $$AgreementsInstallmentsTableTableCreateCompanionBuilder
    = AgreementsInstallmentsTableCompanion Function({
  required String installmentId,
  required String condominiumId,
  Value<String?> agreementId,
  required int reference,
  required double value,
  Value<DateTime?> dueDate,
  Value<String?> status,
  Value<int> rowid,
});
typedef $$AgreementsInstallmentsTableTableUpdateCompanionBuilder
    = AgreementsInstallmentsTableCompanion Function({
  Value<String> installmentId,
  Value<String> condominiumId,
  Value<String?> agreementId,
  Value<int> reference,
  Value<double> value,
  Value<DateTime?> dueDate,
  Value<String?> status,
  Value<int> rowid,
});

class $$AgreementsInstallmentsTableTableFilterComposer
    extends Composer<_$LelloDatabase, $AgreementsInstallmentsTableTable> {
  $$AgreementsInstallmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get installmentId => $composableBuilder(
      column: $table.installmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$AgreementsInstallmentsTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $AgreementsInstallmentsTableTable> {
  $$AgreementsInstallmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get installmentId => $composableBuilder(
      column: $table.installmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$AgreementsInstallmentsTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $AgreementsInstallmentsTableTable> {
  $$AgreementsInstallmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get installmentId => $composableBuilder(
      column: $table.installmentId, builder: (column) => column);

  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<String> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => column);

  GeneratedColumn<int> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$AgreementsInstallmentsTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $AgreementsInstallmentsTableTable,
    AgreementsInstallmentsData,
    $$AgreementsInstallmentsTableTableFilterComposer,
    $$AgreementsInstallmentsTableTableOrderingComposer,
    $$AgreementsInstallmentsTableTableAnnotationComposer,
    $$AgreementsInstallmentsTableTableCreateCompanionBuilder,
    $$AgreementsInstallmentsTableTableUpdateCompanionBuilder,
    (
      AgreementsInstallmentsData,
      BaseReferences<_$LelloDatabase, $AgreementsInstallmentsTableTable,
          AgreementsInstallmentsData>
    ),
    AgreementsInstallmentsData,
    PrefetchHooks Function()> {
  $$AgreementsInstallmentsTableTableTableManager(
      _$LelloDatabase db, $AgreementsInstallmentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgreementsInstallmentsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$AgreementsInstallmentsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgreementsInstallmentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> installmentId = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<String?> agreementId = const Value.absent(),
            Value<int> reference = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsInstallmentsTableCompanion(
            installmentId: installmentId,
            condominiumId: condominiumId,
            agreementId: agreementId,
            reference: reference,
            value: value,
            dueDate: dueDate,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String installmentId,
            required String condominiumId,
            Value<String?> agreementId = const Value.absent(),
            required int reference,
            required double value,
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsInstallmentsTableCompanion.insert(
            installmentId: installmentId,
            condominiumId: condominiumId,
            agreementId: agreementId,
            reference: reference,
            value: value,
            dueDate: dueDate,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AgreementsInstallmentsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $AgreementsInstallmentsTableTable,
        AgreementsInstallmentsData,
        $$AgreementsInstallmentsTableTableFilterComposer,
        $$AgreementsInstallmentsTableTableOrderingComposer,
        $$AgreementsInstallmentsTableTableAnnotationComposer,
        $$AgreementsInstallmentsTableTableCreateCompanionBuilder,
        $$AgreementsInstallmentsTableTableUpdateCompanionBuilder,
        (
          AgreementsInstallmentsData,
          BaseReferences<_$LelloDatabase, $AgreementsInstallmentsTableTable,
              AgreementsInstallmentsData>
        ),
        AgreementsInstallmentsData,
        PrefetchHooks Function()>;
typedef $$AgreementsQuoteTableTableCreateCompanionBuilder
    = AgreementsQuoteTableCompanion Function({
  required String id,
  required String condominiumId,
  Value<String?> agreementId,
  required int reference,
  Value<DateTime?> dueDate,
  required double originValue,
  required double fineValue,
  required double feeValue,
  required double honoraryValue,
  Value<String?> overdueMessage,
  Value<int> rowid,
});
typedef $$AgreementsQuoteTableTableUpdateCompanionBuilder
    = AgreementsQuoteTableCompanion Function({
  Value<String> id,
  Value<String> condominiumId,
  Value<String?> agreementId,
  Value<int> reference,
  Value<DateTime?> dueDate,
  Value<double> originValue,
  Value<double> fineValue,
  Value<double> feeValue,
  Value<double> honoraryValue,
  Value<String?> overdueMessage,
  Value<int> rowid,
});

class $$AgreementsQuoteTableTableFilterComposer
    extends Composer<_$LelloDatabase, $AgreementsQuoteTableTable> {
  $$AgreementsQuoteTableTableFilterComposer({
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

  ColumnFilters<String> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originValue => $composableBuilder(
      column: $table.originValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fineValue => $composableBuilder(
      column: $table.fineValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get feeValue => $composableBuilder(
      column: $table.feeValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get honoraryValue => $composableBuilder(
      column: $table.honoraryValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overdueMessage => $composableBuilder(
      column: $table.overdueMessage,
      builder: (column) => ColumnFilters(column));
}

class $$AgreementsQuoteTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $AgreementsQuoteTableTable> {
  $$AgreementsQuoteTableTableOrderingComposer({
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

  ColumnOrderings<String> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originValue => $composableBuilder(
      column: $table.originValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fineValue => $composableBuilder(
      column: $table.fineValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get feeValue => $composableBuilder(
      column: $table.feeValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get honoraryValue => $composableBuilder(
      column: $table.honoraryValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overdueMessage => $composableBuilder(
      column: $table.overdueMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$AgreementsQuoteTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $AgreementsQuoteTableTable> {
  $$AgreementsQuoteTableTableAnnotationComposer({
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

  GeneratedColumn<String> get agreementId => $composableBuilder(
      column: $table.agreementId, builder: (column) => column);

  GeneratedColumn<int> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get originValue => $composableBuilder(
      column: $table.originValue, builder: (column) => column);

  GeneratedColumn<double> get fineValue =>
      $composableBuilder(column: $table.fineValue, builder: (column) => column);

  GeneratedColumn<double> get feeValue =>
      $composableBuilder(column: $table.feeValue, builder: (column) => column);

  GeneratedColumn<double> get honoraryValue => $composableBuilder(
      column: $table.honoraryValue, builder: (column) => column);

  GeneratedColumn<String> get overdueMessage => $composableBuilder(
      column: $table.overdueMessage, builder: (column) => column);
}

class $$AgreementsQuoteTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $AgreementsQuoteTableTable,
    AgreementsQuoteData,
    $$AgreementsQuoteTableTableFilterComposer,
    $$AgreementsQuoteTableTableOrderingComposer,
    $$AgreementsQuoteTableTableAnnotationComposer,
    $$AgreementsQuoteTableTableCreateCompanionBuilder,
    $$AgreementsQuoteTableTableUpdateCompanionBuilder,
    (
      AgreementsQuoteData,
      BaseReferences<_$LelloDatabase, $AgreementsQuoteTableTable,
          AgreementsQuoteData>
    ),
    AgreementsQuoteData,
    PrefetchHooks Function()> {
  $$AgreementsQuoteTableTableTableManager(
      _$LelloDatabase db, $AgreementsQuoteTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgreementsQuoteTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgreementsQuoteTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgreementsQuoteTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> condominiumId = const Value.absent(),
            Value<String?> agreementId = const Value.absent(),
            Value<int> reference = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<double> originValue = const Value.absent(),
            Value<double> fineValue = const Value.absent(),
            Value<double> feeValue = const Value.absent(),
            Value<double> honoraryValue = const Value.absent(),
            Value<String?> overdueMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsQuoteTableCompanion(
            id: id,
            condominiumId: condominiumId,
            agreementId: agreementId,
            reference: reference,
            dueDate: dueDate,
            originValue: originValue,
            fineValue: fineValue,
            feeValue: feeValue,
            honoraryValue: honoraryValue,
            overdueMessage: overdueMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String condominiumId,
            Value<String?> agreementId = const Value.absent(),
            required int reference,
            Value<DateTime?> dueDate = const Value.absent(),
            required double originValue,
            required double fineValue,
            required double feeValue,
            required double honoraryValue,
            Value<String?> overdueMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsQuoteTableCompanion.insert(
            id: id,
            condominiumId: condominiumId,
            agreementId: agreementId,
            reference: reference,
            dueDate: dueDate,
            originValue: originValue,
            fineValue: fineValue,
            feeValue: feeValue,
            honoraryValue: honoraryValue,
            overdueMessage: overdueMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AgreementsQuoteTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $AgreementsQuoteTableTable,
        AgreementsQuoteData,
        $$AgreementsQuoteTableTableFilterComposer,
        $$AgreementsQuoteTableTableOrderingComposer,
        $$AgreementsQuoteTableTableAnnotationComposer,
        $$AgreementsQuoteTableTableCreateCompanionBuilder,
        $$AgreementsQuoteTableTableUpdateCompanionBuilder,
        (
          AgreementsQuoteData,
          BaseReferences<_$LelloDatabase, $AgreementsQuoteTableTable,
              AgreementsQuoteData>
        ),
        AgreementsQuoteData,
        PrefetchHooks Function()>;
typedef $$AgreementsRulesDaysTableTableCreateCompanionBuilder
    = AgreementsRulesDaysTableCompanion Function({
  required String condominiumId,
  required int days,
  Value<int> rowid,
});
typedef $$AgreementsRulesDaysTableTableUpdateCompanionBuilder
    = AgreementsRulesDaysTableCompanion Function({
  Value<String> condominiumId,
  Value<int> days,
  Value<int> rowid,
});

class $$AgreementsRulesDaysTableTableFilterComposer
    extends Composer<_$LelloDatabase, $AgreementsRulesDaysTableTable> {
  $$AgreementsRulesDaysTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnFilters(column));
}

class $$AgreementsRulesDaysTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $AgreementsRulesDaysTableTable> {
  $$AgreementsRulesDaysTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnOrderings(column));
}

class $$AgreementsRulesDaysTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $AgreementsRulesDaysTableTable> {
  $$AgreementsRulesDaysTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<int> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);
}

class $$AgreementsRulesDaysTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $AgreementsRulesDaysTableTable,
    AgreementsRulesDaysData,
    $$AgreementsRulesDaysTableTableFilterComposer,
    $$AgreementsRulesDaysTableTableOrderingComposer,
    $$AgreementsRulesDaysTableTableAnnotationComposer,
    $$AgreementsRulesDaysTableTableCreateCompanionBuilder,
    $$AgreementsRulesDaysTableTableUpdateCompanionBuilder,
    (
      AgreementsRulesDaysData,
      BaseReferences<_$LelloDatabase, $AgreementsRulesDaysTableTable,
          AgreementsRulesDaysData>
    ),
    AgreementsRulesDaysData,
    PrefetchHooks Function()> {
  $$AgreementsRulesDaysTableTableTableManager(
      _$LelloDatabase db, $AgreementsRulesDaysTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgreementsRulesDaysTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$AgreementsRulesDaysTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgreementsRulesDaysTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<int> days = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsRulesDaysTableCompanion(
            condominiumId: condominiumId,
            days: days,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required int days,
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsRulesDaysTableCompanion.insert(
            condominiumId: condominiumId,
            days: days,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AgreementsRulesDaysTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $AgreementsRulesDaysTableTable,
        AgreementsRulesDaysData,
        $$AgreementsRulesDaysTableTableFilterComposer,
        $$AgreementsRulesDaysTableTableOrderingComposer,
        $$AgreementsRulesDaysTableTableAnnotationComposer,
        $$AgreementsRulesDaysTableTableCreateCompanionBuilder,
        $$AgreementsRulesDaysTableTableUpdateCompanionBuilder,
        (
          AgreementsRulesDaysData,
          BaseReferences<_$LelloDatabase, $AgreementsRulesDaysTableTable,
              AgreementsRulesDaysData>
        ),
        AgreementsRulesDaysData,
        PrefetchHooks Function()>;
typedef $$AgreementsRulesInstallmentsTableTableCreateCompanionBuilder
    = AgreementsRulesInstallmentsTableCompanion Function({
  required String condominiumId,
  required int installmentQtd,
  Value<int> rowid,
});
typedef $$AgreementsRulesInstallmentsTableTableUpdateCompanionBuilder
    = AgreementsRulesInstallmentsTableCompanion Function({
  Value<String> condominiumId,
  Value<int> installmentQtd,
  Value<int> rowid,
});

class $$AgreementsRulesInstallmentsTableTableFilterComposer
    extends Composer<_$LelloDatabase, $AgreementsRulesInstallmentsTableTable> {
  $$AgreementsRulesInstallmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installmentQtd => $composableBuilder(
      column: $table.installmentQtd,
      builder: (column) => ColumnFilters(column));
}

class $$AgreementsRulesInstallmentsTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $AgreementsRulesInstallmentsTableTable> {
  $$AgreementsRulesInstallmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installmentQtd => $composableBuilder(
      column: $table.installmentQtd,
      builder: (column) => ColumnOrderings(column));
}

class $$AgreementsRulesInstallmentsTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $AgreementsRulesInstallmentsTableTable> {
  $$AgreementsRulesInstallmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get condominiumId => $composableBuilder(
      column: $table.condominiumId, builder: (column) => column);

  GeneratedColumn<int> get installmentQtd => $composableBuilder(
      column: $table.installmentQtd, builder: (column) => column);
}

class $$AgreementsRulesInstallmentsTableTableTableManager
    extends RootTableManager<
        _$LelloDatabase,
        $AgreementsRulesInstallmentsTableTable,
        AgreementsRulesInstallmentsData,
        $$AgreementsRulesInstallmentsTableTableFilterComposer,
        $$AgreementsRulesInstallmentsTableTableOrderingComposer,
        $$AgreementsRulesInstallmentsTableTableAnnotationComposer,
        $$AgreementsRulesInstallmentsTableTableCreateCompanionBuilder,
        $$AgreementsRulesInstallmentsTableTableUpdateCompanionBuilder,
        (
          AgreementsRulesInstallmentsData,
          BaseReferences<
              _$LelloDatabase,
              $AgreementsRulesInstallmentsTableTable,
              AgreementsRulesInstallmentsData>
        ),
        AgreementsRulesInstallmentsData,
        PrefetchHooks Function()> {
  $$AgreementsRulesInstallmentsTableTableTableManager(
      _$LelloDatabase db, $AgreementsRulesInstallmentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgreementsRulesInstallmentsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$AgreementsRulesInstallmentsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgreementsRulesInstallmentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<int> installmentQtd = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsRulesInstallmentsTableCompanion(
            condominiumId: condominiumId,
            installmentQtd: installmentQtd,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required int installmentQtd,
            Value<int> rowid = const Value.absent(),
          }) =>
              AgreementsRulesInstallmentsTableCompanion.insert(
            condominiumId: condominiumId,
            installmentQtd: installmentQtd,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AgreementsRulesInstallmentsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $AgreementsRulesInstallmentsTableTable,
        AgreementsRulesInstallmentsData,
        $$AgreementsRulesInstallmentsTableTableFilterComposer,
        $$AgreementsRulesInstallmentsTableTableOrderingComposer,
        $$AgreementsRulesInstallmentsTableTableAnnotationComposer,
        $$AgreementsRulesInstallmentsTableTableCreateCompanionBuilder,
        $$AgreementsRulesInstallmentsTableTableUpdateCompanionBuilder,
        (
          AgreementsRulesInstallmentsData,
          BaseReferences<
              _$LelloDatabase,
              $AgreementsRulesInstallmentsTableTable,
              AgreementsRulesInstallmentsData>
        ),
        AgreementsRulesInstallmentsData,
        PrefetchHooks Function()>;
typedef $$ResinPeopleTableTableCreateCompanionBuilder
    = ResinPeopleTableCompanion Function({
  required String condominiumId,
  required String id,
  required String document,
  required String name,
  required String role,
  Value<int> rowid,
});
typedef $$ResinPeopleTableTableUpdateCompanionBuilder
    = ResinPeopleTableCompanion Function({
  Value<String> condominiumId,
  Value<String> id,
  Value<String> document,
  Value<String> name,
  Value<String> role,
  Value<int> rowid,
});

class $$ResinPeopleTableTableFilterComposer
    extends Composer<_$LelloDatabase, $ResinPeopleTableTable> {
  $$ResinPeopleTableTableFilterComposer({
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

  ColumnFilters<String> get document => $composableBuilder(
      column: $table.document, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));
}

class $$ResinPeopleTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $ResinPeopleTableTable> {
  $$ResinPeopleTableTableOrderingComposer({
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

  ColumnOrderings<String> get document => $composableBuilder(
      column: $table.document, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));
}

class $$ResinPeopleTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $ResinPeopleTableTable> {
  $$ResinPeopleTableTableAnnotationComposer({
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

  GeneratedColumn<String> get document =>
      $composableBuilder(column: $table.document, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$ResinPeopleTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $ResinPeopleTableTable,
    ResinPeopleData,
    $$ResinPeopleTableTableFilterComposer,
    $$ResinPeopleTableTableOrderingComposer,
    $$ResinPeopleTableTableAnnotationComposer,
    $$ResinPeopleTableTableCreateCompanionBuilder,
    $$ResinPeopleTableTableUpdateCompanionBuilder,
    (
      ResinPeopleData,
      BaseReferences<_$LelloDatabase, $ResinPeopleTableTable, ResinPeopleData>
    ),
    ResinPeopleData,
    PrefetchHooks Function()> {
  $$ResinPeopleTableTableTableManager(
      _$LelloDatabase db, $ResinPeopleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResinPeopleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResinPeopleTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResinPeopleTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> document = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinPeopleTableCompanion(
            condominiumId: condominiumId,
            id: id,
            document: document,
            name: name,
            role: role,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required String id,
            required String document,
            required String name,
            required String role,
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinPeopleTableCompanion.insert(
            condominiumId: condominiumId,
            id: id,
            document: document,
            name: name,
            role: role,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResinPeopleTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $ResinPeopleTableTable,
    ResinPeopleData,
    $$ResinPeopleTableTableFilterComposer,
    $$ResinPeopleTableTableOrderingComposer,
    $$ResinPeopleTableTableAnnotationComposer,
    $$ResinPeopleTableTableCreateCompanionBuilder,
    $$ResinPeopleTableTableUpdateCompanionBuilder,
    (
      ResinPeopleData,
      BaseReferences<_$LelloDatabase, $ResinPeopleTableTable, ResinPeopleData>
    ),
    ResinPeopleData,
    PrefetchHooks Function()>;
typedef $$ResinBanksTableTableCreateCompanionBuilder = ResinBanksTableCompanion
    Function({
  required String condominiumId,
  required String id,
  required String bankCode,
  required String bankName,
  Value<int> rowid,
});
typedef $$ResinBanksTableTableUpdateCompanionBuilder = ResinBanksTableCompanion
    Function({
  Value<String> condominiumId,
  Value<String> id,
  Value<String> bankCode,
  Value<String> bankName,
  Value<int> rowid,
});

class $$ResinBanksTableTableFilterComposer
    extends Composer<_$LelloDatabase, $ResinBanksTableTable> {
  $$ResinBanksTableTableFilterComposer({
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

  ColumnFilters<String> get bankCode => $composableBuilder(
      column: $table.bankCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnFilters(column));
}

class $$ResinBanksTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $ResinBanksTableTable> {
  $$ResinBanksTableTableOrderingComposer({
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

  ColumnOrderings<String> get bankCode => $composableBuilder(
      column: $table.bankCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnOrderings(column));
}

class $$ResinBanksTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $ResinBanksTableTable> {
  $$ResinBanksTableTableAnnotationComposer({
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

  GeneratedColumn<String> get bankCode =>
      $composableBuilder(column: $table.bankCode, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);
}

class $$ResinBanksTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $ResinBanksTableTable,
    ResinBanksData,
    $$ResinBanksTableTableFilterComposer,
    $$ResinBanksTableTableOrderingComposer,
    $$ResinBanksTableTableAnnotationComposer,
    $$ResinBanksTableTableCreateCompanionBuilder,
    $$ResinBanksTableTableUpdateCompanionBuilder,
    (
      ResinBanksData,
      BaseReferences<_$LelloDatabase, $ResinBanksTableTable, ResinBanksData>
    ),
    ResinBanksData,
    PrefetchHooks Function()> {
  $$ResinBanksTableTableTableManager(
      _$LelloDatabase db, $ResinBanksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResinBanksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResinBanksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResinBanksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> bankCode = const Value.absent(),
            Value<String> bankName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinBanksTableCompanion(
            condominiumId: condominiumId,
            id: id,
            bankCode: bankCode,
            bankName: bankName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required String id,
            required String bankCode,
            required String bankName,
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinBanksTableCompanion.insert(
            condominiumId: condominiumId,
            id: id,
            bankCode: bankCode,
            bankName: bankName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResinBanksTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $ResinBanksTableTable,
    ResinBanksData,
    $$ResinBanksTableTableFilterComposer,
    $$ResinBanksTableTableOrderingComposer,
    $$ResinBanksTableTableAnnotationComposer,
    $$ResinBanksTableTableCreateCompanionBuilder,
    $$ResinBanksTableTableUpdateCompanionBuilder,
    (
      ResinBanksData,
      BaseReferences<_$LelloDatabase, $ResinBanksTableTable, ResinBanksData>
    ),
    ResinBanksData,
    PrefetchHooks Function()>;
typedef $$ResinBankAccountsTableTableCreateCompanionBuilder
    = ResinBankAccountsTableCompanion Function({
  required String condominiumId,
  required String id,
  required String bankId,
  required String agency,
  required String accountNumber,
  required String document,
  required String supplierName,
  required String type,
  Value<int> rowid,
});
typedef $$ResinBankAccountsTableTableUpdateCompanionBuilder
    = ResinBankAccountsTableCompanion Function({
  Value<String> condominiumId,
  Value<String> id,
  Value<String> bankId,
  Value<String> agency,
  Value<String> accountNumber,
  Value<String> document,
  Value<String> supplierName,
  Value<String> type,
  Value<int> rowid,
});

class $$ResinBankAccountsTableTableFilterComposer
    extends Composer<_$LelloDatabase, $ResinBankAccountsTableTable> {
  $$ResinBankAccountsTableTableFilterComposer({
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

  ColumnFilters<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agency => $composableBuilder(
      column: $table.agency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get document => $composableBuilder(
      column: $table.document, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));
}

class $$ResinBankAccountsTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $ResinBankAccountsTableTable> {
  $$ResinBankAccountsTableTableOrderingComposer({
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

  ColumnOrderings<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agency => $composableBuilder(
      column: $table.agency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get document => $composableBuilder(
      column: $table.document, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplierName => $composableBuilder(
      column: $table.supplierName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));
}

class $$ResinBankAccountsTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $ResinBankAccountsTableTable> {
  $$ResinBankAccountsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => column);

  GeneratedColumn<String> get agency =>
      $composableBuilder(column: $table.agency, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber, builder: (column) => column);

  GeneratedColumn<String> get document =>
      $composableBuilder(column: $table.document, builder: (column) => column);

  GeneratedColumn<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$ResinBankAccountsTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $ResinBankAccountsTableTable,
    ResinBankAccountsData,
    $$ResinBankAccountsTableTableFilterComposer,
    $$ResinBankAccountsTableTableOrderingComposer,
    $$ResinBankAccountsTableTableAnnotationComposer,
    $$ResinBankAccountsTableTableCreateCompanionBuilder,
    $$ResinBankAccountsTableTableUpdateCompanionBuilder,
    (
      ResinBankAccountsData,
      BaseReferences<_$LelloDatabase, $ResinBankAccountsTableTable,
          ResinBankAccountsData>
    ),
    ResinBankAccountsData,
    PrefetchHooks Function()> {
  $$ResinBankAccountsTableTableTableManager(
      _$LelloDatabase db, $ResinBankAccountsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResinBankAccountsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ResinBankAccountsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResinBankAccountsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> bankId = const Value.absent(),
            Value<String> agency = const Value.absent(),
            Value<String> accountNumber = const Value.absent(),
            Value<String> document = const Value.absent(),
            Value<String> supplierName = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinBankAccountsTableCompanion(
            condominiumId: condominiumId,
            id: id,
            bankId: bankId,
            agency: agency,
            accountNumber: accountNumber,
            document: document,
            supplierName: supplierName,
            type: type,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required String id,
            required String bankId,
            required String agency,
            required String accountNumber,
            required String document,
            required String supplierName,
            required String type,
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinBankAccountsTableCompanion.insert(
            condominiumId: condominiumId,
            id: id,
            bankId: bankId,
            agency: agency,
            accountNumber: accountNumber,
            document: document,
            supplierName: supplierName,
            type: type,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResinBankAccountsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$LelloDatabase,
        $ResinBankAccountsTableTable,
        ResinBankAccountsData,
        $$ResinBankAccountsTableTableFilterComposer,
        $$ResinBankAccountsTableTableOrderingComposer,
        $$ResinBankAccountsTableTableAnnotationComposer,
        $$ResinBankAccountsTableTableCreateCompanionBuilder,
        $$ResinBankAccountsTableTableUpdateCompanionBuilder,
        (
          ResinBankAccountsData,
          BaseReferences<_$LelloDatabase, $ResinBankAccountsTableTable,
              ResinBankAccountsData>
        ),
        ResinBankAccountsData,
        PrefetchHooks Function()>;
typedef $$ResinRefundsTableTableCreateCompanionBuilder
    = ResinRefundsTableCompanion Function({
  required String condominiumId,
  required String id,
  required String destinationAccountId,
  Value<DateTime?> requestDate,
  required String requester,
  required String status,
  required String type,
  required double value,
  required String protocol,
  Value<String?> description,
  required bool canEdit,
  required bool canCancel,
  required String inconcistency,
  Value<int> rowid,
});
typedef $$ResinRefundsTableTableUpdateCompanionBuilder
    = ResinRefundsTableCompanion Function({
  Value<String> condominiumId,
  Value<String> id,
  Value<String> destinationAccountId,
  Value<DateTime?> requestDate,
  Value<String> requester,
  Value<String> status,
  Value<String> type,
  Value<double> value,
  Value<String> protocol,
  Value<String?> description,
  Value<bool> canEdit,
  Value<bool> canCancel,
  Value<String> inconcistency,
  Value<int> rowid,
});

class $$ResinRefundsTableTableFilterComposer
    extends Composer<_$LelloDatabase, $ResinRefundsTableTable> {
  $$ResinRefundsTableTableFilterComposer({
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

  ColumnFilters<String> get destinationAccountId => $composableBuilder(
      column: $table.destinationAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get requestDate => $composableBuilder(
      column: $table.requestDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get requester => $composableBuilder(
      column: $table.requester, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get protocol => $composableBuilder(
      column: $table.protocol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canEdit => $composableBuilder(
      column: $table.canEdit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canCancel => $composableBuilder(
      column: $table.canCancel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inconcistency => $composableBuilder(
      column: $table.inconcistency, builder: (column) => ColumnFilters(column));
}

class $$ResinRefundsTableTableOrderingComposer
    extends Composer<_$LelloDatabase, $ResinRefundsTableTable> {
  $$ResinRefundsTableTableOrderingComposer({
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

  ColumnOrderings<String> get destinationAccountId => $composableBuilder(
      column: $table.destinationAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get requestDate => $composableBuilder(
      column: $table.requestDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get requester => $composableBuilder(
      column: $table.requester, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get protocol => $composableBuilder(
      column: $table.protocol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canEdit => $composableBuilder(
      column: $table.canEdit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canCancel => $composableBuilder(
      column: $table.canCancel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inconcistency => $composableBuilder(
      column: $table.inconcistency,
      builder: (column) => ColumnOrderings(column));
}

class $$ResinRefundsTableTableAnnotationComposer
    extends Composer<_$LelloDatabase, $ResinRefundsTableTable> {
  $$ResinRefundsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get destinationAccountId => $composableBuilder(
      column: $table.destinationAccountId, builder: (column) => column);

  GeneratedColumn<DateTime> get requestDate => $composableBuilder(
      column: $table.requestDate, builder: (column) => column);

  GeneratedColumn<String> get requester =>
      $composableBuilder(column: $table.requester, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get protocol =>
      $composableBuilder(column: $table.protocol, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get canEdit =>
      $composableBuilder(column: $table.canEdit, builder: (column) => column);

  GeneratedColumn<bool> get canCancel =>
      $composableBuilder(column: $table.canCancel, builder: (column) => column);

  GeneratedColumn<String> get inconcistency => $composableBuilder(
      column: $table.inconcistency, builder: (column) => column);
}

class $$ResinRefundsTableTableTableManager extends RootTableManager<
    _$LelloDatabase,
    $ResinRefundsTableTable,
    ResinRefundsData,
    $$ResinRefundsTableTableFilterComposer,
    $$ResinRefundsTableTableOrderingComposer,
    $$ResinRefundsTableTableAnnotationComposer,
    $$ResinRefundsTableTableCreateCompanionBuilder,
    $$ResinRefundsTableTableUpdateCompanionBuilder,
    (
      ResinRefundsData,
      BaseReferences<_$LelloDatabase, $ResinRefundsTableTable, ResinRefundsData>
    ),
    ResinRefundsData,
    PrefetchHooks Function()> {
  $$ResinRefundsTableTableTableManager(
      _$LelloDatabase db, $ResinRefundsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResinRefundsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResinRefundsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResinRefundsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> condominiumId = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> destinationAccountId = const Value.absent(),
            Value<DateTime?> requestDate = const Value.absent(),
            Value<String> requester = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<String> protocol = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> canEdit = const Value.absent(),
            Value<bool> canCancel = const Value.absent(),
            Value<String> inconcistency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinRefundsTableCompanion(
            condominiumId: condominiumId,
            id: id,
            destinationAccountId: destinationAccountId,
            requestDate: requestDate,
            requester: requester,
            status: status,
            type: type,
            value: value,
            protocol: protocol,
            description: description,
            canEdit: canEdit,
            canCancel: canCancel,
            inconcistency: inconcistency,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String condominiumId,
            required String id,
            required String destinationAccountId,
            Value<DateTime?> requestDate = const Value.absent(),
            required String requester,
            required String status,
            required String type,
            required double value,
            required String protocol,
            Value<String?> description = const Value.absent(),
            required bool canEdit,
            required bool canCancel,
            required String inconcistency,
            Value<int> rowid = const Value.absent(),
          }) =>
              ResinRefundsTableCompanion.insert(
            condominiumId: condominiumId,
            id: id,
            destinationAccountId: destinationAccountId,
            requestDate: requestDate,
            requester: requester,
            status: status,
            type: type,
            value: value,
            protocol: protocol,
            description: description,
            canEdit: canEdit,
            canCancel: canCancel,
            inconcistency: inconcistency,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResinRefundsTableTableProcessedTableManager = ProcessedTableManager<
    _$LelloDatabase,
    $ResinRefundsTableTable,
    ResinRefundsData,
    $$ResinRefundsTableTableFilterComposer,
    $$ResinRefundsTableTableOrderingComposer,
    $$ResinRefundsTableTableAnnotationComposer,
    $$ResinRefundsTableTableCreateCompanionBuilder,
    $$ResinRefundsTableTableUpdateCompanionBuilder,
    (
      ResinRefundsData,
      BaseReferences<_$LelloDatabase, $ResinRefundsTableTable, ResinRefundsData>
    ),
    ResinRefundsData,
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

class $LelloDatabaseManager {
  final _$LelloDatabase _db;
  $LelloDatabaseManager(this._db);
  $$PendencyTableTableTableManager get pendencyTable =>
      $$PendencyTableTableTableManager(_db, _db.pendencyTable);
  $$MeTableTableTableManager get meTable =>
      $$MeTableTableTableManager(_db, _db.meTable);
  $$CondominiumTableTableTableManager get condominiumTable =>
      $$CondominiumTableTableTableManager(_db, _db.condominiumTable);
  $$AccountTableTableTableManager get accountTable =>
      $$AccountTableTableTableManager(_db, _db.accountTable);
  $$LelloHubTableTableTableManager get lelloHubTable =>
      $$LelloHubTableTableTableManager(_db, _db.lelloHubTable);
  $$UnitTableTableTableManager get unitTable =>
      $$UnitTableTableTableManager(_db, _db.unitTable);
  $$ResidentTableTableTableManager get residentTable =>
      $$ResidentTableTableTableManager(_db, _db.residentTable);
  $$IncomeForecastTableTableTableManager get incomeForecastTable =>
      $$IncomeForecastTableTableTableManager(_db, _db.incomeForecastTable);
  $$IncomeTableTableTableManager get incomeTable =>
      $$IncomeTableTableTableManager(_db, _db.incomeTable);
  $$IncomeShareTableTableTableManager get incomeShareTable =>
      $$IncomeShareTableTableTableManager(_db, _db.incomeShareTable);
  $$ChatContactTableTableTableManager get chatContactTable =>
      $$ChatContactTableTableTableManager(_db, _db.chatContactTable);
  $$EmployeeTableTableTableManager get employeeTable =>
      $$EmployeeTableTableTableManager(_db, _db.employeeTable);
  $$ReservationSummaryTableTableTableManager get reservationSummaryTable =>
      $$ReservationSummaryTableTableTableManager(
          _db, _db.reservationSummaryTable);
  $$SpaceTableTableTableManager get spaceTable =>
      $$SpaceTableTableTableManager(_db, _db.spaceTable);
  $$CondominiumBalanceTableTableTableManager get condominiumBalanceTable =>
      $$CondominiumBalanceTableTableTableManager(
          _db, _db.condominiumBalanceTable);
  $$CondominiumBalanceDetailTableTableTableManager
      get condominiumBalanceDetailTable =>
          $$CondominiumBalanceDetailTableTableTableManager(
              _db, _db.condominiumBalanceDetailTable);
  $$CondominiumBalanceDebitsTableTableTableManager
      get condominiumBalanceDebitsTable =>
          $$CondominiumBalanceDebitsTableTableTableManager(
              _db, _db.condominiumBalanceDebitsTable);
  $$CondominiumBalanceSummaryTableTableTableManager
      get condominiumBalanceSummaryTable =>
          $$CondominiumBalanceSummaryTableTableTableManager(
              _db, _db.condominiumBalanceSummaryTable);
  $$AgreementsTableTableTableManager get agreementsTable =>
      $$AgreementsTableTableTableManager(_db, _db.agreementsTable);
  $$AgreementsInstallmentsTableTableTableManager
      get agreementsInstallmentsTable =>
          $$AgreementsInstallmentsTableTableTableManager(
              _db, _db.agreementsInstallmentsTable);
  $$AgreementsQuoteTableTableTableManager get agreementsQuoteTable =>
      $$AgreementsQuoteTableTableTableManager(_db, _db.agreementsQuoteTable);
  $$AgreementsRulesDaysTableTableTableManager get agreementsRulesDaysTable =>
      $$AgreementsRulesDaysTableTableTableManager(
          _db, _db.agreementsRulesDaysTable);
  $$AgreementsRulesInstallmentsTableTableTableManager
      get agreementsRulesInstallmentsTable =>
          $$AgreementsRulesInstallmentsTableTableTableManager(
              _db, _db.agreementsRulesInstallmentsTable);
  $$ResinPeopleTableTableTableManager get resinPeopleTable =>
      $$ResinPeopleTableTableTableManager(_db, _db.resinPeopleTable);
  $$ResinBanksTableTableTableManager get resinBanksTable =>
      $$ResinBanksTableTableTableManager(_db, _db.resinBanksTable);
  $$ResinBankAccountsTableTableTableManager get resinBankAccountsTable =>
      $$ResinBankAccountsTableTableTableManager(
          _db, _db.resinBankAccountsTable);
  $$ResinRefundsTableTableTableManager get resinRefundsTable =>
      $$ResinRefundsTableTableTableManager(_db, _db.resinRefundsTable);
  $$LayoutTableTableTableManager get layoutTable =>
      $$LayoutTableTableTableManager(_db, _db.layoutTable);
}
