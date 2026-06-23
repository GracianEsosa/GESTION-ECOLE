// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AnneeScolairesTable extends AnneeScolaires
    with TableInfo<$AnneeScolairesTable, AnneeScolaire> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnneeScolairesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idAnneeMeta = const VerificationMeta(
    'idAnnee',
  );
  @override
  late final GeneratedColumn<int> idAnnee = GeneratedColumn<int>(
    'id_annee',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _libelleAnneeMeta = const VerificationMeta(
    'libelleAnnee',
  );
  @override
  late final GeneratedColumn<String> libelleAnnee = GeneratedColumn<String>(
    'libelle_annee',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateDebutMeta = const VerificationMeta(
    'dateDebut',
  );
  @override
  late final GeneratedColumn<DateTime> dateDebut = GeneratedColumn<DateTime>(
    'date_debut',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateFinMeta = const VerificationMeta(
    'dateFin',
  );
  @override
  late final GeneratedColumn<DateTime> dateFin = GeneratedColumn<DateTime>(
    'date_fin',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idAnnee,
    uuid,
    libelleAnnee,
    dateDebut,
    dateFin,
    isSynced,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annee_scolaires';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnneeScolaire> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_annee')) {
      context.handle(
        _idAnneeMeta,
        idAnnee.isAcceptableOrUnknown(data['id_annee']!, _idAnneeMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('libelle_annee')) {
      context.handle(
        _libelleAnneeMeta,
        libelleAnnee.isAcceptableOrUnknown(
          data['libelle_annee']!,
          _libelleAnneeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libelleAnneeMeta);
    }
    if (data.containsKey('date_debut')) {
      context.handle(
        _dateDebutMeta,
        dateDebut.isAcceptableOrUnknown(data['date_debut']!, _dateDebutMeta),
      );
    } else if (isInserting) {
      context.missing(_dateDebutMeta);
    }
    if (data.containsKey('date_fin')) {
      context.handle(
        _dateFinMeta,
        dateFin.isAcceptableOrUnknown(data['date_fin']!, _dateFinMeta),
      );
    } else if (isInserting) {
      context.missing(_dateFinMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idAnnee};
  @override
  AnneeScolaire map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnneeScolaire(
      idAnnee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_annee'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      libelleAnnee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}libelle_annee'],
      )!,
      dateDebut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_debut'],
      )!,
      dateFin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_fin'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AnneeScolairesTable createAlias(String alias) {
    return $AnneeScolairesTable(attachedDatabase, alias);
  }
}

class AnneeScolaire extends DataClass implements Insertable<AnneeScolaire> {
  final int idAnnee;
  final String uuid;
  final String libelleAnnee;
  final DateTime dateDebut;
  final DateTime dateFin;
  final bool isSynced;
  final DateTime updatedAt;
  const AnneeScolaire({
    required this.idAnnee,
    required this.uuid,
    required this.libelleAnnee,
    required this.dateDebut,
    required this.dateFin,
    required this.isSynced,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_annee'] = Variable<int>(idAnnee);
    map['uuid'] = Variable<String>(uuid);
    map['libelle_annee'] = Variable<String>(libelleAnnee);
    map['date_debut'] = Variable<DateTime>(dateDebut);
    map['date_fin'] = Variable<DateTime>(dateFin);
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AnneeScolairesCompanion toCompanion(bool nullToAbsent) {
    return AnneeScolairesCompanion(
      idAnnee: Value(idAnnee),
      uuid: Value(uuid),
      libelleAnnee: Value(libelleAnnee),
      dateDebut: Value(dateDebut),
      dateFin: Value(dateFin),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
    );
  }

  factory AnneeScolaire.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnneeScolaire(
      idAnnee: serializer.fromJson<int>(json['idAnnee']),
      uuid: serializer.fromJson<String>(json['uuid']),
      libelleAnnee: serializer.fromJson<String>(json['libelleAnnee']),
      dateDebut: serializer.fromJson<DateTime>(json['dateDebut']),
      dateFin: serializer.fromJson<DateTime>(json['dateFin']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idAnnee': serializer.toJson<int>(idAnnee),
      'uuid': serializer.toJson<String>(uuid),
      'libelleAnnee': serializer.toJson<String>(libelleAnnee),
      'dateDebut': serializer.toJson<DateTime>(dateDebut),
      'dateFin': serializer.toJson<DateTime>(dateFin),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AnneeScolaire copyWith({
    int? idAnnee,
    String? uuid,
    String? libelleAnnee,
    DateTime? dateDebut,
    DateTime? dateFin,
    bool? isSynced,
    DateTime? updatedAt,
  }) => AnneeScolaire(
    idAnnee: idAnnee ?? this.idAnnee,
    uuid: uuid ?? this.uuid,
    libelleAnnee: libelleAnnee ?? this.libelleAnnee,
    dateDebut: dateDebut ?? this.dateDebut,
    dateFin: dateFin ?? this.dateFin,
    isSynced: isSynced ?? this.isSynced,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AnneeScolaire copyWithCompanion(AnneeScolairesCompanion data) {
    return AnneeScolaire(
      idAnnee: data.idAnnee.present ? data.idAnnee.value : this.idAnnee,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      libelleAnnee: data.libelleAnnee.present
          ? data.libelleAnnee.value
          : this.libelleAnnee,
      dateDebut: data.dateDebut.present ? data.dateDebut.value : this.dateDebut,
      dateFin: data.dateFin.present ? data.dateFin.value : this.dateFin,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnneeScolaire(')
          ..write('idAnnee: $idAnnee, ')
          ..write('uuid: $uuid, ')
          ..write('libelleAnnee: $libelleAnnee, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idAnnee,
    uuid,
    libelleAnnee,
    dateDebut,
    dateFin,
    isSynced,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnneeScolaire &&
          other.idAnnee == this.idAnnee &&
          other.uuid == this.uuid &&
          other.libelleAnnee == this.libelleAnnee &&
          other.dateDebut == this.dateDebut &&
          other.dateFin == this.dateFin &&
          other.isSynced == this.isSynced &&
          other.updatedAt == this.updatedAt);
}

class AnneeScolairesCompanion extends UpdateCompanion<AnneeScolaire> {
  final Value<int> idAnnee;
  final Value<String> uuid;
  final Value<String> libelleAnnee;
  final Value<DateTime> dateDebut;
  final Value<DateTime> dateFin;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  const AnneeScolairesCompanion({
    this.idAnnee = const Value.absent(),
    this.uuid = const Value.absent(),
    this.libelleAnnee = const Value.absent(),
    this.dateDebut = const Value.absent(),
    this.dateFin = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AnneeScolairesCompanion.insert({
    this.idAnnee = const Value.absent(),
    required String uuid,
    required String libelleAnnee,
    required DateTime dateDebut,
    required DateTime dateFin,
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       libelleAnnee = Value(libelleAnnee),
       dateDebut = Value(dateDebut),
       dateFin = Value(dateFin);
  static Insertable<AnneeScolaire> custom({
    Expression<int>? idAnnee,
    Expression<String>? uuid,
    Expression<String>? libelleAnnee,
    Expression<DateTime>? dateDebut,
    Expression<DateTime>? dateFin,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (idAnnee != null) 'id_annee': idAnnee,
      if (uuid != null) 'uuid': uuid,
      if (libelleAnnee != null) 'libelle_annee': libelleAnnee,
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null) 'date_fin': dateFin,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AnneeScolairesCompanion copyWith({
    Value<int>? idAnnee,
    Value<String>? uuid,
    Value<String>? libelleAnnee,
    Value<DateTime>? dateDebut,
    Value<DateTime>? dateFin,
    Value<bool>? isSynced,
    Value<DateTime>? updatedAt,
  }) {
    return AnneeScolairesCompanion(
      idAnnee: idAnnee ?? this.idAnnee,
      uuid: uuid ?? this.uuid,
      libelleAnnee: libelleAnnee ?? this.libelleAnnee,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idAnnee.present) {
      map['id_annee'] = Variable<int>(idAnnee.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (libelleAnnee.present) {
      map['libelle_annee'] = Variable<String>(libelleAnnee.value);
    }
    if (dateDebut.present) {
      map['date_debut'] = Variable<DateTime>(dateDebut.value);
    }
    if (dateFin.present) {
      map['date_fin'] = Variable<DateTime>(dateFin.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnneeScolairesCompanion(')
          ..write('idAnnee: $idAnnee, ')
          ..write('uuid: $uuid, ')
          ..write('libelleAnnee: $libelleAnnee, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ScolaireOptionsTable extends ScolaireOptions
    with TableInfo<$ScolaireOptionsTable, ScolaireOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScolaireOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idOptionMeta = const VerificationMeta(
    'idOption',
  );
  @override
  late final GeneratedColumn<int> idOption = GeneratedColumn<int>(
    'id_option',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomOptionMeta = const VerificationMeta(
    'nomOption',
  );
  @override
  late final GeneratedColumn<String> nomOption = GeneratedColumn<String>(
    'nom_option',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idOption,
    uuid,
    nomOption,
    description,
    isSynced,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scolaire_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScolaireOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_option')) {
      context.handle(
        _idOptionMeta,
        idOption.isAcceptableOrUnknown(data['id_option']!, _idOptionMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nom_option')) {
      context.handle(
        _nomOptionMeta,
        nomOption.isAcceptableOrUnknown(data['nom_option']!, _nomOptionMeta),
      );
    } else if (isInserting) {
      context.missing(_nomOptionMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idOption};
  @override
  ScolaireOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScolaireOption(
      idOption: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_option'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      nomOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom_option'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ScolaireOptionsTable createAlias(String alias) {
    return $ScolaireOptionsTable(attachedDatabase, alias);
  }
}

class ScolaireOption extends DataClass implements Insertable<ScolaireOption> {
  final int idOption;
  final String uuid;
  final String nomOption;
  final String? description;
  final bool isSynced;
  final DateTime updatedAt;
  const ScolaireOption({
    required this.idOption,
    required this.uuid,
    required this.nomOption,
    this.description,
    required this.isSynced,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_option'] = Variable<int>(idOption);
    map['uuid'] = Variable<String>(uuid);
    map['nom_option'] = Variable<String>(nomOption);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScolaireOptionsCompanion toCompanion(bool nullToAbsent) {
    return ScolaireOptionsCompanion(
      idOption: Value(idOption),
      uuid: Value(uuid),
      nomOption: Value(nomOption),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScolaireOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScolaireOption(
      idOption: serializer.fromJson<int>(json['idOption']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nomOption: serializer.fromJson<String>(json['nomOption']),
      description: serializer.fromJson<String?>(json['description']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idOption': serializer.toJson<int>(idOption),
      'uuid': serializer.toJson<String>(uuid),
      'nomOption': serializer.toJson<String>(nomOption),
      'description': serializer.toJson<String?>(description),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScolaireOption copyWith({
    int? idOption,
    String? uuid,
    String? nomOption,
    Value<String?> description = const Value.absent(),
    bool? isSynced,
    DateTime? updatedAt,
  }) => ScolaireOption(
    idOption: idOption ?? this.idOption,
    uuid: uuid ?? this.uuid,
    nomOption: nomOption ?? this.nomOption,
    description: description.present ? description.value : this.description,
    isSynced: isSynced ?? this.isSynced,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ScolaireOption copyWithCompanion(ScolaireOptionsCompanion data) {
    return ScolaireOption(
      idOption: data.idOption.present ? data.idOption.value : this.idOption,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nomOption: data.nomOption.present ? data.nomOption.value : this.nomOption,
      description: data.description.present
          ? data.description.value
          : this.description,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScolaireOption(')
          ..write('idOption: $idOption, ')
          ..write('uuid: $uuid, ')
          ..write('nomOption: $nomOption, ')
          ..write('description: $description, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idOption, uuid, nomOption, description, isSynced, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScolaireOption &&
          other.idOption == this.idOption &&
          other.uuid == this.uuid &&
          other.nomOption == this.nomOption &&
          other.description == this.description &&
          other.isSynced == this.isSynced &&
          other.updatedAt == this.updatedAt);
}

class ScolaireOptionsCompanion extends UpdateCompanion<ScolaireOption> {
  final Value<int> idOption;
  final Value<String> uuid;
  final Value<String> nomOption;
  final Value<String?> description;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  const ScolaireOptionsCompanion({
    this.idOption = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nomOption = const Value.absent(),
    this.description = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ScolaireOptionsCompanion.insert({
    this.idOption = const Value.absent(),
    required String uuid,
    required String nomOption,
    this.description = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       nomOption = Value(nomOption);
  static Insertable<ScolaireOption> custom({
    Expression<int>? idOption,
    Expression<String>? uuid,
    Expression<String>? nomOption,
    Expression<String>? description,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (idOption != null) 'id_option': idOption,
      if (uuid != null) 'uuid': uuid,
      if (nomOption != null) 'nom_option': nomOption,
      if (description != null) 'description': description,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ScolaireOptionsCompanion copyWith({
    Value<int>? idOption,
    Value<String>? uuid,
    Value<String>? nomOption,
    Value<String?>? description,
    Value<bool>? isSynced,
    Value<DateTime>? updatedAt,
  }) {
    return ScolaireOptionsCompanion(
      idOption: idOption ?? this.idOption,
      uuid: uuid ?? this.uuid,
      nomOption: nomOption ?? this.nomOption,
      description: description ?? this.description,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idOption.present) {
      map['id_option'] = Variable<int>(idOption.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nomOption.present) {
      map['nom_option'] = Variable<String>(nomOption.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScolaireOptionsCompanion(')
          ..write('idOption: $idOption, ')
          ..write('uuid: $uuid, ')
          ..write('nomOption: $nomOption, ')
          ..write('description: $description, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ClassesTable extends Classes with TableInfo<$ClassesTable, ClassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idClasseMeta = const VerificationMeta(
    'idClasse',
  );
  @override
  late final GeneratedColumn<int> idClasse = GeneratedColumn<int>(
    'id_classe',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomClasseMeta = const VerificationMeta(
    'nomClasse',
  );
  @override
  late final GeneratedColumn<String> nomClasse = GeneratedColumn<String>(
    'nom_classe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idOptionUuidMeta = const VerificationMeta(
    'idOptionUuid',
  );
  @override
  late final GeneratedColumn<String> idOptionUuid = GeneratedColumn<String>(
    'id_option_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES scolaire_options (uuid)',
    ),
  );
  static const VerificationMeta _effectifMaxMeta = const VerificationMeta(
    'effectifMax',
  );
  @override
  late final GeneratedColumn<int> effectifMax = GeneratedColumn<int>(
    'effectif_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(35),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idClasse,
    uuid,
    nomClasse,
    idOptionUuid,
    effectifMax,
    isSynced,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_classe')) {
      context.handle(
        _idClasseMeta,
        idClasse.isAcceptableOrUnknown(data['id_classe']!, _idClasseMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nom_classe')) {
      context.handle(
        _nomClasseMeta,
        nomClasse.isAcceptableOrUnknown(data['nom_classe']!, _nomClasseMeta),
      );
    } else if (isInserting) {
      context.missing(_nomClasseMeta);
    }
    if (data.containsKey('id_option_uuid')) {
      context.handle(
        _idOptionUuidMeta,
        idOptionUuid.isAcceptableOrUnknown(
          data['id_option_uuid']!,
          _idOptionUuidMeta,
        ),
      );
    }
    if (data.containsKey('effectif_max')) {
      context.handle(
        _effectifMaxMeta,
        effectifMax.isAcceptableOrUnknown(
          data['effectif_max']!,
          _effectifMaxMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idClasse};
  @override
  ClassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassesData(
      idClasse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_classe'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      nomClasse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom_classe'],
      )!,
      idOptionUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_option_uuid'],
      ),
      effectifMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effectif_max'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClassesTable createAlias(String alias) {
    return $ClassesTable(attachedDatabase, alias);
  }
}

class ClassesData extends DataClass implements Insertable<ClassesData> {
  final int idClasse;
  final String uuid;
  final String nomClasse;
  final String? idOptionUuid;
  final int effectifMax;
  final bool isSynced;
  final DateTime updatedAt;
  const ClassesData({
    required this.idClasse,
    required this.uuid,
    required this.nomClasse,
    this.idOptionUuid,
    required this.effectifMax,
    required this.isSynced,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_classe'] = Variable<int>(idClasse);
    map['uuid'] = Variable<String>(uuid);
    map['nom_classe'] = Variable<String>(nomClasse);
    if (!nullToAbsent || idOptionUuid != null) {
      map['id_option_uuid'] = Variable<String>(idOptionUuid);
    }
    map['effectif_max'] = Variable<int>(effectifMax);
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClassesCompanion toCompanion(bool nullToAbsent) {
    return ClassesCompanion(
      idClasse: Value(idClasse),
      uuid: Value(uuid),
      nomClasse: Value(nomClasse),
      idOptionUuid: idOptionUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(idOptionUuid),
      effectifMax: Value(effectifMax),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
    );
  }

  factory ClassesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassesData(
      idClasse: serializer.fromJson<int>(json['idClasse']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nomClasse: serializer.fromJson<String>(json['nomClasse']),
      idOptionUuid: serializer.fromJson<String?>(json['idOptionUuid']),
      effectifMax: serializer.fromJson<int>(json['effectifMax']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idClasse': serializer.toJson<int>(idClasse),
      'uuid': serializer.toJson<String>(uuid),
      'nomClasse': serializer.toJson<String>(nomClasse),
      'idOptionUuid': serializer.toJson<String?>(idOptionUuid),
      'effectifMax': serializer.toJson<int>(effectifMax),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ClassesData copyWith({
    int? idClasse,
    String? uuid,
    String? nomClasse,
    Value<String?> idOptionUuid = const Value.absent(),
    int? effectifMax,
    bool? isSynced,
    DateTime? updatedAt,
  }) => ClassesData(
    idClasse: idClasse ?? this.idClasse,
    uuid: uuid ?? this.uuid,
    nomClasse: nomClasse ?? this.nomClasse,
    idOptionUuid: idOptionUuid.present ? idOptionUuid.value : this.idOptionUuid,
    effectifMax: effectifMax ?? this.effectifMax,
    isSynced: isSynced ?? this.isSynced,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ClassesData copyWithCompanion(ClassesCompanion data) {
    return ClassesData(
      idClasse: data.idClasse.present ? data.idClasse.value : this.idClasse,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nomClasse: data.nomClasse.present ? data.nomClasse.value : this.nomClasse,
      idOptionUuid: data.idOptionUuid.present
          ? data.idOptionUuid.value
          : this.idOptionUuid,
      effectifMax: data.effectifMax.present
          ? data.effectifMax.value
          : this.effectifMax,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassesData(')
          ..write('idClasse: $idClasse, ')
          ..write('uuid: $uuid, ')
          ..write('nomClasse: $nomClasse, ')
          ..write('idOptionUuid: $idOptionUuid, ')
          ..write('effectifMax: $effectifMax, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idClasse,
    uuid,
    nomClasse,
    idOptionUuid,
    effectifMax,
    isSynced,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassesData &&
          other.idClasse == this.idClasse &&
          other.uuid == this.uuid &&
          other.nomClasse == this.nomClasse &&
          other.idOptionUuid == this.idOptionUuid &&
          other.effectifMax == this.effectifMax &&
          other.isSynced == this.isSynced &&
          other.updatedAt == this.updatedAt);
}

class ClassesCompanion extends UpdateCompanion<ClassesData> {
  final Value<int> idClasse;
  final Value<String> uuid;
  final Value<String> nomClasse;
  final Value<String?> idOptionUuid;
  final Value<int> effectifMax;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  const ClassesCompanion({
    this.idClasse = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nomClasse = const Value.absent(),
    this.idOptionUuid = const Value.absent(),
    this.effectifMax = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ClassesCompanion.insert({
    this.idClasse = const Value.absent(),
    required String uuid,
    required String nomClasse,
    this.idOptionUuid = const Value.absent(),
    this.effectifMax = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       nomClasse = Value(nomClasse);
  static Insertable<ClassesData> custom({
    Expression<int>? idClasse,
    Expression<String>? uuid,
    Expression<String>? nomClasse,
    Expression<String>? idOptionUuid,
    Expression<int>? effectifMax,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (idClasse != null) 'id_classe': idClasse,
      if (uuid != null) 'uuid': uuid,
      if (nomClasse != null) 'nom_classe': nomClasse,
      if (idOptionUuid != null) 'id_option_uuid': idOptionUuid,
      if (effectifMax != null) 'effectif_max': effectifMax,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ClassesCompanion copyWith({
    Value<int>? idClasse,
    Value<String>? uuid,
    Value<String>? nomClasse,
    Value<String?>? idOptionUuid,
    Value<int>? effectifMax,
    Value<bool>? isSynced,
    Value<DateTime>? updatedAt,
  }) {
    return ClassesCompanion(
      idClasse: idClasse ?? this.idClasse,
      uuid: uuid ?? this.uuid,
      nomClasse: nomClasse ?? this.nomClasse,
      idOptionUuid: idOptionUuid ?? this.idOptionUuid,
      effectifMax: effectifMax ?? this.effectifMax,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idClasse.present) {
      map['id_classe'] = Variable<int>(idClasse.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nomClasse.present) {
      map['nom_classe'] = Variable<String>(nomClasse.value);
    }
    if (idOptionUuid.present) {
      map['id_option_uuid'] = Variable<String>(idOptionUuid.value);
    }
    if (effectifMax.present) {
      map['effectif_max'] = Variable<int>(effectifMax.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassesCompanion(')
          ..write('idClasse: $idClasse, ')
          ..write('uuid: $uuid, ')
          ..write('nomClasse: $nomClasse, ')
          ..write('idOptionUuid: $idOptionUuid, ')
          ..write('effectifMax: $effectifMax, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EleveInscriptionsTable extends EleveInscriptions
    with TableInfo<$EleveInscriptionsTable, EleveInscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EleveInscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idInscriptionMeta = const VerificationMeta(
    'idInscription',
  );
  @override
  late final GeneratedColumn<int> idInscription = GeneratedColumn<int>(
    'id_inscription',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomEleveMeta = const VerificationMeta(
    'nomEleve',
  );
  @override
  late final GeneratedColumn<String> nomEleve = GeneratedColumn<String>(
    'nom_eleve',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prenomEleveMeta = const VerificationMeta(
    'prenomEleve',
  );
  @override
  late final GeneratedColumn<String> prenomEleve = GeneratedColumn<String>(
    'prenom_eleve',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateNaissanceMeta = const VerificationMeta(
    'dateNaissance',
  );
  @override
  late final GeneratedColumn<DateTime> dateNaissance =
      GeneratedColumn<DateTime>(
        'date_naissance',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sexeMeta = const VerificationMeta('sexe');
  @override
  late final GeneratedColumn<String> sexe = GeneratedColumn<String>(
    'sexe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idAnneeUuidMeta = const VerificationMeta(
    'idAnneeUuid',
  );
  @override
  late final GeneratedColumn<String> idAnneeUuid = GeneratedColumn<String>(
    'id_annee_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES annee_scolaires (uuid)',
    ),
  );
  static const VerificationMeta _idClasseUuidMeta = const VerificationMeta(
    'idClasseUuid',
  );
  @override
  late final GeneratedColumn<String> idClasseUuid = GeneratedColumn<String>(
    'id_classe_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES classes (uuid)',
    ),
  );
  static const VerificationMeta _dateInscriptionMeta = const VerificationMeta(
    'dateInscription',
  );
  @override
  late final GeneratedColumn<DateTime> dateInscription =
      GeneratedColumn<DateTime>(
        'date_inscription',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _statutInscriptionMeta = const VerificationMeta(
    'statutInscription',
  );
  @override
  late final GeneratedColumn<String> statutInscription =
      GeneratedColumn<String>(
        'statut_inscription',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('Pré-inscription'),
      );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idInscription,
    uuid,
    nomEleve,
    prenomEleve,
    dateNaissance,
    sexe,
    idAnneeUuid,
    idClasseUuid,
    dateInscription,
    statutInscription,
    isSynced,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'eleve_inscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<EleveInscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_inscription')) {
      context.handle(
        _idInscriptionMeta,
        idInscription.isAcceptableOrUnknown(
          data['id_inscription']!,
          _idInscriptionMeta,
        ),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nom_eleve')) {
      context.handle(
        _nomEleveMeta,
        nomEleve.isAcceptableOrUnknown(data['nom_eleve']!, _nomEleveMeta),
      );
    } else if (isInserting) {
      context.missing(_nomEleveMeta);
    }
    if (data.containsKey('prenom_eleve')) {
      context.handle(
        _prenomEleveMeta,
        prenomEleve.isAcceptableOrUnknown(
          data['prenom_eleve']!,
          _prenomEleveMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prenomEleveMeta);
    }
    if (data.containsKey('date_naissance')) {
      context.handle(
        _dateNaissanceMeta,
        dateNaissance.isAcceptableOrUnknown(
          data['date_naissance']!,
          _dateNaissanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateNaissanceMeta);
    }
    if (data.containsKey('sexe')) {
      context.handle(
        _sexeMeta,
        sexe.isAcceptableOrUnknown(data['sexe']!, _sexeMeta),
      );
    } else if (isInserting) {
      context.missing(_sexeMeta);
    }
    if (data.containsKey('id_annee_uuid')) {
      context.handle(
        _idAnneeUuidMeta,
        idAnneeUuid.isAcceptableOrUnknown(
          data['id_annee_uuid']!,
          _idAnneeUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idAnneeUuidMeta);
    }
    if (data.containsKey('id_classe_uuid')) {
      context.handle(
        _idClasseUuidMeta,
        idClasseUuid.isAcceptableOrUnknown(
          data['id_classe_uuid']!,
          _idClasseUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idClasseUuidMeta);
    }
    if (data.containsKey('date_inscription')) {
      context.handle(
        _dateInscriptionMeta,
        dateInscription.isAcceptableOrUnknown(
          data['date_inscription']!,
          _dateInscriptionMeta,
        ),
      );
    }
    if (data.containsKey('statut_inscription')) {
      context.handle(
        _statutInscriptionMeta,
        statutInscription.isAcceptableOrUnknown(
          data['statut_inscription']!,
          _statutInscriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idInscription};
  @override
  EleveInscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EleveInscription(
      idInscription: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_inscription'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      nomEleve: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom_eleve'],
      )!,
      prenomEleve: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom_eleve'],
      )!,
      dateNaissance: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_naissance'],
      )!,
      sexe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sexe'],
      )!,
      idAnneeUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_annee_uuid'],
      )!,
      idClasseUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_classe_uuid'],
      )!,
      dateInscription: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_inscription'],
      )!,
      statutInscription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut_inscription'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EleveInscriptionsTable createAlias(String alias) {
    return $EleveInscriptionsTable(attachedDatabase, alias);
  }
}

class EleveInscription extends DataClass
    implements Insertable<EleveInscription> {
  final int idInscription;
  final String uuid;
  final String nomEleve;
  final String prenomEleve;
  final DateTime dateNaissance;
  final String sexe;
  final String idAnneeUuid;
  final String idClasseUuid;
  final DateTime dateInscription;
  final String statutInscription;
  final bool isSynced;
  final DateTime updatedAt;
  const EleveInscription({
    required this.idInscription,
    required this.uuid,
    required this.nomEleve,
    required this.prenomEleve,
    required this.dateNaissance,
    required this.sexe,
    required this.idAnneeUuid,
    required this.idClasseUuid,
    required this.dateInscription,
    required this.statutInscription,
    required this.isSynced,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_inscription'] = Variable<int>(idInscription);
    map['uuid'] = Variable<String>(uuid);
    map['nom_eleve'] = Variable<String>(nomEleve);
    map['prenom_eleve'] = Variable<String>(prenomEleve);
    map['date_naissance'] = Variable<DateTime>(dateNaissance);
    map['sexe'] = Variable<String>(sexe);
    map['id_annee_uuid'] = Variable<String>(idAnneeUuid);
    map['id_classe_uuid'] = Variable<String>(idClasseUuid);
    map['date_inscription'] = Variable<DateTime>(dateInscription);
    map['statut_inscription'] = Variable<String>(statutInscription);
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EleveInscriptionsCompanion toCompanion(bool nullToAbsent) {
    return EleveInscriptionsCompanion(
      idInscription: Value(idInscription),
      uuid: Value(uuid),
      nomEleve: Value(nomEleve),
      prenomEleve: Value(prenomEleve),
      dateNaissance: Value(dateNaissance),
      sexe: Value(sexe),
      idAnneeUuid: Value(idAnneeUuid),
      idClasseUuid: Value(idClasseUuid),
      dateInscription: Value(dateInscription),
      statutInscription: Value(statutInscription),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
    );
  }

  factory EleveInscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EleveInscription(
      idInscription: serializer.fromJson<int>(json['idInscription']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nomEleve: serializer.fromJson<String>(json['nomEleve']),
      prenomEleve: serializer.fromJson<String>(json['prenomEleve']),
      dateNaissance: serializer.fromJson<DateTime>(json['dateNaissance']),
      sexe: serializer.fromJson<String>(json['sexe']),
      idAnneeUuid: serializer.fromJson<String>(json['idAnneeUuid']),
      idClasseUuid: serializer.fromJson<String>(json['idClasseUuid']),
      dateInscription: serializer.fromJson<DateTime>(json['dateInscription']),
      statutInscription: serializer.fromJson<String>(json['statutInscription']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idInscription': serializer.toJson<int>(idInscription),
      'uuid': serializer.toJson<String>(uuid),
      'nomEleve': serializer.toJson<String>(nomEleve),
      'prenomEleve': serializer.toJson<String>(prenomEleve),
      'dateNaissance': serializer.toJson<DateTime>(dateNaissance),
      'sexe': serializer.toJson<String>(sexe),
      'idAnneeUuid': serializer.toJson<String>(idAnneeUuid),
      'idClasseUuid': serializer.toJson<String>(idClasseUuid),
      'dateInscription': serializer.toJson<DateTime>(dateInscription),
      'statutInscription': serializer.toJson<String>(statutInscription),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EleveInscription copyWith({
    int? idInscription,
    String? uuid,
    String? nomEleve,
    String? prenomEleve,
    DateTime? dateNaissance,
    String? sexe,
    String? idAnneeUuid,
    String? idClasseUuid,
    DateTime? dateInscription,
    String? statutInscription,
    bool? isSynced,
    DateTime? updatedAt,
  }) => EleveInscription(
    idInscription: idInscription ?? this.idInscription,
    uuid: uuid ?? this.uuid,
    nomEleve: nomEleve ?? this.nomEleve,
    prenomEleve: prenomEleve ?? this.prenomEleve,
    dateNaissance: dateNaissance ?? this.dateNaissance,
    sexe: sexe ?? this.sexe,
    idAnneeUuid: idAnneeUuid ?? this.idAnneeUuid,
    idClasseUuid: idClasseUuid ?? this.idClasseUuid,
    dateInscription: dateInscription ?? this.dateInscription,
    statutInscription: statutInscription ?? this.statutInscription,
    isSynced: isSynced ?? this.isSynced,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EleveInscription copyWithCompanion(EleveInscriptionsCompanion data) {
    return EleveInscription(
      idInscription: data.idInscription.present
          ? data.idInscription.value
          : this.idInscription,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nomEleve: data.nomEleve.present ? data.nomEleve.value : this.nomEleve,
      prenomEleve: data.prenomEleve.present
          ? data.prenomEleve.value
          : this.prenomEleve,
      dateNaissance: data.dateNaissance.present
          ? data.dateNaissance.value
          : this.dateNaissance,
      sexe: data.sexe.present ? data.sexe.value : this.sexe,
      idAnneeUuid: data.idAnneeUuid.present
          ? data.idAnneeUuid.value
          : this.idAnneeUuid,
      idClasseUuid: data.idClasseUuid.present
          ? data.idClasseUuid.value
          : this.idClasseUuid,
      dateInscription: data.dateInscription.present
          ? data.dateInscription.value
          : this.dateInscription,
      statutInscription: data.statutInscription.present
          ? data.statutInscription.value
          : this.statutInscription,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EleveInscription(')
          ..write('idInscription: $idInscription, ')
          ..write('uuid: $uuid, ')
          ..write('nomEleve: $nomEleve, ')
          ..write('prenomEleve: $prenomEleve, ')
          ..write('dateNaissance: $dateNaissance, ')
          ..write('sexe: $sexe, ')
          ..write('idAnneeUuid: $idAnneeUuid, ')
          ..write('idClasseUuid: $idClasseUuid, ')
          ..write('dateInscription: $dateInscription, ')
          ..write('statutInscription: $statutInscription, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idInscription,
    uuid,
    nomEleve,
    prenomEleve,
    dateNaissance,
    sexe,
    idAnneeUuid,
    idClasseUuid,
    dateInscription,
    statutInscription,
    isSynced,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EleveInscription &&
          other.idInscription == this.idInscription &&
          other.uuid == this.uuid &&
          other.nomEleve == this.nomEleve &&
          other.prenomEleve == this.prenomEleve &&
          other.dateNaissance == this.dateNaissance &&
          other.sexe == this.sexe &&
          other.idAnneeUuid == this.idAnneeUuid &&
          other.idClasseUuid == this.idClasseUuid &&
          other.dateInscription == this.dateInscription &&
          other.statutInscription == this.statutInscription &&
          other.isSynced == this.isSynced &&
          other.updatedAt == this.updatedAt);
}

class EleveInscriptionsCompanion extends UpdateCompanion<EleveInscription> {
  final Value<int> idInscription;
  final Value<String> uuid;
  final Value<String> nomEleve;
  final Value<String> prenomEleve;
  final Value<DateTime> dateNaissance;
  final Value<String> sexe;
  final Value<String> idAnneeUuid;
  final Value<String> idClasseUuid;
  final Value<DateTime> dateInscription;
  final Value<String> statutInscription;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  const EleveInscriptionsCompanion({
    this.idInscription = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nomEleve = const Value.absent(),
    this.prenomEleve = const Value.absent(),
    this.dateNaissance = const Value.absent(),
    this.sexe = const Value.absent(),
    this.idAnneeUuid = const Value.absent(),
    this.idClasseUuid = const Value.absent(),
    this.dateInscription = const Value.absent(),
    this.statutInscription = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EleveInscriptionsCompanion.insert({
    this.idInscription = const Value.absent(),
    required String uuid,
    required String nomEleve,
    required String prenomEleve,
    required DateTime dateNaissance,
    required String sexe,
    required String idAnneeUuid,
    required String idClasseUuid,
    this.dateInscription = const Value.absent(),
    this.statutInscription = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       nomEleve = Value(nomEleve),
       prenomEleve = Value(prenomEleve),
       dateNaissance = Value(dateNaissance),
       sexe = Value(sexe),
       idAnneeUuid = Value(idAnneeUuid),
       idClasseUuid = Value(idClasseUuid);
  static Insertable<EleveInscription> custom({
    Expression<int>? idInscription,
    Expression<String>? uuid,
    Expression<String>? nomEleve,
    Expression<String>? prenomEleve,
    Expression<DateTime>? dateNaissance,
    Expression<String>? sexe,
    Expression<String>? idAnneeUuid,
    Expression<String>? idClasseUuid,
    Expression<DateTime>? dateInscription,
    Expression<String>? statutInscription,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (idInscription != null) 'id_inscription': idInscription,
      if (uuid != null) 'uuid': uuid,
      if (nomEleve != null) 'nom_eleve': nomEleve,
      if (prenomEleve != null) 'prenom_eleve': prenomEleve,
      if (dateNaissance != null) 'date_naissance': dateNaissance,
      if (sexe != null) 'sexe': sexe,
      if (idAnneeUuid != null) 'id_annee_uuid': idAnneeUuid,
      if (idClasseUuid != null) 'id_classe_uuid': idClasseUuid,
      if (dateInscription != null) 'date_inscription': dateInscription,
      if (statutInscription != null) 'statut_inscription': statutInscription,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EleveInscriptionsCompanion copyWith({
    Value<int>? idInscription,
    Value<String>? uuid,
    Value<String>? nomEleve,
    Value<String>? prenomEleve,
    Value<DateTime>? dateNaissance,
    Value<String>? sexe,
    Value<String>? idAnneeUuid,
    Value<String>? idClasseUuid,
    Value<DateTime>? dateInscription,
    Value<String>? statutInscription,
    Value<bool>? isSynced,
    Value<DateTime>? updatedAt,
  }) {
    return EleveInscriptionsCompanion(
      idInscription: idInscription ?? this.idInscription,
      uuid: uuid ?? this.uuid,
      nomEleve: nomEleve ?? this.nomEleve,
      prenomEleve: prenomEleve ?? this.prenomEleve,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      sexe: sexe ?? this.sexe,
      idAnneeUuid: idAnneeUuid ?? this.idAnneeUuid,
      idClasseUuid: idClasseUuid ?? this.idClasseUuid,
      dateInscription: dateInscription ?? this.dateInscription,
      statutInscription: statutInscription ?? this.statutInscription,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idInscription.present) {
      map['id_inscription'] = Variable<int>(idInscription.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nomEleve.present) {
      map['nom_eleve'] = Variable<String>(nomEleve.value);
    }
    if (prenomEleve.present) {
      map['prenom_eleve'] = Variable<String>(prenomEleve.value);
    }
    if (dateNaissance.present) {
      map['date_naissance'] = Variable<DateTime>(dateNaissance.value);
    }
    if (sexe.present) {
      map['sexe'] = Variable<String>(sexe.value);
    }
    if (idAnneeUuid.present) {
      map['id_annee_uuid'] = Variable<String>(idAnneeUuid.value);
    }
    if (idClasseUuid.present) {
      map['id_classe_uuid'] = Variable<String>(idClasseUuid.value);
    }
    if (dateInscription.present) {
      map['date_inscription'] = Variable<DateTime>(dateInscription.value);
    }
    if (statutInscription.present) {
      map['statut_inscription'] = Variable<String>(statutInscription.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EleveInscriptionsCompanion(')
          ..write('idInscription: $idInscription, ')
          ..write('uuid: $uuid, ')
          ..write('nomEleve: $nomEleve, ')
          ..write('prenomEleve: $prenomEleve, ')
          ..write('dateNaissance: $dateNaissance, ')
          ..write('sexe: $sexe, ')
          ..write('idAnneeUuid: $idAnneeUuid, ')
          ..write('idClasseUuid: $idClasseUuid, ')
          ..write('dateInscription: $dateInscription, ')
          ..write('statutInscription: $statutInscription, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PaiementInscriptionsTable extends PaiementInscriptions
    with TableInfo<$PaiementInscriptionsTable, PaiementInscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaiementInscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idPaiementMeta = const VerificationMeta(
    'idPaiement',
  );
  @override
  late final GeneratedColumn<int> idPaiement = GeneratedColumn<int>(
    'id_paiement',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _idInscriptionUuidMeta = const VerificationMeta(
    'idInscriptionUuid',
  );
  @override
  late final GeneratedColumn<String> idInscriptionUuid =
      GeneratedColumn<String>(
        'id_inscription_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES eleve_inscriptions (uuid)',
        ),
      );
  static const VerificationMeta _montantPayeMeta = const VerificationMeta(
    'montantPaye',
  );
  @override
  late final GeneratedColumn<double> montantPaye = GeneratedColumn<double>(
    'montant_paye',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datePaiementMeta = const VerificationMeta(
    'datePaiement',
  );
  @override
  late final GeneratedColumn<DateTime> datePaiement = GeneratedColumn<DateTime>(
    'date_paiement',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _modePaiementMeta = const VerificationMeta(
    'modePaiement',
  );
  @override
  late final GeneratedColumn<String> modePaiement = GeneratedColumn<String>(
    'mode_paiement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motifPaiementMeta = const VerificationMeta(
    'motifPaiement',
  );
  @override
  late final GeneratedColumn<String> motifPaiement = GeneratedColumn<String>(
    'motif_paiement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idPaiement,
    uuid,
    idInscriptionUuid,
    montantPaye,
    datePaiement,
    modePaiement,
    motifPaiement,
    isSynced,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paiement_inscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaiementInscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_paiement')) {
      context.handle(
        _idPaiementMeta,
        idPaiement.isAcceptableOrUnknown(data['id_paiement']!, _idPaiementMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('id_inscription_uuid')) {
      context.handle(
        _idInscriptionUuidMeta,
        idInscriptionUuid.isAcceptableOrUnknown(
          data['id_inscription_uuid']!,
          _idInscriptionUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idInscriptionUuidMeta);
    }
    if (data.containsKey('montant_paye')) {
      context.handle(
        _montantPayeMeta,
        montantPaye.isAcceptableOrUnknown(
          data['montant_paye']!,
          _montantPayeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montantPayeMeta);
    }
    if (data.containsKey('date_paiement')) {
      context.handle(
        _datePaiementMeta,
        datePaiement.isAcceptableOrUnknown(
          data['date_paiement']!,
          _datePaiementMeta,
        ),
      );
    }
    if (data.containsKey('mode_paiement')) {
      context.handle(
        _modePaiementMeta,
        modePaiement.isAcceptableOrUnknown(
          data['mode_paiement']!,
          _modePaiementMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modePaiementMeta);
    }
    if (data.containsKey('motif_paiement')) {
      context.handle(
        _motifPaiementMeta,
        motifPaiement.isAcceptableOrUnknown(
          data['motif_paiement']!,
          _motifPaiementMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_motifPaiementMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idPaiement};
  @override
  PaiementInscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaiementInscription(
      idPaiement: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_paiement'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      idInscriptionUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_inscription_uuid'],
      )!,
      montantPaye: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}montant_paye'],
      )!,
      datePaiement: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_paiement'],
      )!,
      modePaiement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode_paiement'],
      )!,
      motifPaiement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motif_paiement'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PaiementInscriptionsTable createAlias(String alias) {
    return $PaiementInscriptionsTable(attachedDatabase, alias);
  }
}

class PaiementInscription extends DataClass
    implements Insertable<PaiementInscription> {
  final int idPaiement;
  final String uuid;
  final String idInscriptionUuid;
  final double montantPaye;
  final DateTime datePaiement;
  final String modePaiement;
  final String motifPaiement;
  final bool isSynced;
  final DateTime updatedAt;
  const PaiementInscription({
    required this.idPaiement,
    required this.uuid,
    required this.idInscriptionUuid,
    required this.montantPaye,
    required this.datePaiement,
    required this.modePaiement,
    required this.motifPaiement,
    required this.isSynced,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_paiement'] = Variable<int>(idPaiement);
    map['uuid'] = Variable<String>(uuid);
    map['id_inscription_uuid'] = Variable<String>(idInscriptionUuid);
    map['montant_paye'] = Variable<double>(montantPaye);
    map['date_paiement'] = Variable<DateTime>(datePaiement);
    map['mode_paiement'] = Variable<String>(modePaiement);
    map['motif_paiement'] = Variable<String>(motifPaiement);
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PaiementInscriptionsCompanion toCompanion(bool nullToAbsent) {
    return PaiementInscriptionsCompanion(
      idPaiement: Value(idPaiement),
      uuid: Value(uuid),
      idInscriptionUuid: Value(idInscriptionUuid),
      montantPaye: Value(montantPaye),
      datePaiement: Value(datePaiement),
      modePaiement: Value(modePaiement),
      motifPaiement: Value(motifPaiement),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
    );
  }

  factory PaiementInscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaiementInscription(
      idPaiement: serializer.fromJson<int>(json['idPaiement']),
      uuid: serializer.fromJson<String>(json['uuid']),
      idInscriptionUuid: serializer.fromJson<String>(json['idInscriptionUuid']),
      montantPaye: serializer.fromJson<double>(json['montantPaye']),
      datePaiement: serializer.fromJson<DateTime>(json['datePaiement']),
      modePaiement: serializer.fromJson<String>(json['modePaiement']),
      motifPaiement: serializer.fromJson<String>(json['motifPaiement']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idPaiement': serializer.toJson<int>(idPaiement),
      'uuid': serializer.toJson<String>(uuid),
      'idInscriptionUuid': serializer.toJson<String>(idInscriptionUuid),
      'montantPaye': serializer.toJson<double>(montantPaye),
      'datePaiement': serializer.toJson<DateTime>(datePaiement),
      'modePaiement': serializer.toJson<String>(modePaiement),
      'motifPaiement': serializer.toJson<String>(motifPaiement),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PaiementInscription copyWith({
    int? idPaiement,
    String? uuid,
    String? idInscriptionUuid,
    double? montantPaye,
    DateTime? datePaiement,
    String? modePaiement,
    String? motifPaiement,
    bool? isSynced,
    DateTime? updatedAt,
  }) => PaiementInscription(
    idPaiement: idPaiement ?? this.idPaiement,
    uuid: uuid ?? this.uuid,
    idInscriptionUuid: idInscriptionUuid ?? this.idInscriptionUuid,
    montantPaye: montantPaye ?? this.montantPaye,
    datePaiement: datePaiement ?? this.datePaiement,
    modePaiement: modePaiement ?? this.modePaiement,
    motifPaiement: motifPaiement ?? this.motifPaiement,
    isSynced: isSynced ?? this.isSynced,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PaiementInscription copyWithCompanion(PaiementInscriptionsCompanion data) {
    return PaiementInscription(
      idPaiement: data.idPaiement.present
          ? data.idPaiement.value
          : this.idPaiement,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      idInscriptionUuid: data.idInscriptionUuid.present
          ? data.idInscriptionUuid.value
          : this.idInscriptionUuid,
      montantPaye: data.montantPaye.present
          ? data.montantPaye.value
          : this.montantPaye,
      datePaiement: data.datePaiement.present
          ? data.datePaiement.value
          : this.datePaiement,
      modePaiement: data.modePaiement.present
          ? data.modePaiement.value
          : this.modePaiement,
      motifPaiement: data.motifPaiement.present
          ? data.motifPaiement.value
          : this.motifPaiement,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaiementInscription(')
          ..write('idPaiement: $idPaiement, ')
          ..write('uuid: $uuid, ')
          ..write('idInscriptionUuid: $idInscriptionUuid, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('motifPaiement: $motifPaiement, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idPaiement,
    uuid,
    idInscriptionUuid,
    montantPaye,
    datePaiement,
    modePaiement,
    motifPaiement,
    isSynced,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaiementInscription &&
          other.idPaiement == this.idPaiement &&
          other.uuid == this.uuid &&
          other.idInscriptionUuid == this.idInscriptionUuid &&
          other.montantPaye == this.montantPaye &&
          other.datePaiement == this.datePaiement &&
          other.modePaiement == this.modePaiement &&
          other.motifPaiement == this.motifPaiement &&
          other.isSynced == this.isSynced &&
          other.updatedAt == this.updatedAt);
}

class PaiementInscriptionsCompanion
    extends UpdateCompanion<PaiementInscription> {
  final Value<int> idPaiement;
  final Value<String> uuid;
  final Value<String> idInscriptionUuid;
  final Value<double> montantPaye;
  final Value<DateTime> datePaiement;
  final Value<String> modePaiement;
  final Value<String> motifPaiement;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  const PaiementInscriptionsCompanion({
    this.idPaiement = const Value.absent(),
    this.uuid = const Value.absent(),
    this.idInscriptionUuid = const Value.absent(),
    this.montantPaye = const Value.absent(),
    this.datePaiement = const Value.absent(),
    this.modePaiement = const Value.absent(),
    this.motifPaiement = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PaiementInscriptionsCompanion.insert({
    this.idPaiement = const Value.absent(),
    required String uuid,
    required String idInscriptionUuid,
    required double montantPaye,
    this.datePaiement = const Value.absent(),
    required String modePaiement,
    required String motifPaiement,
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       idInscriptionUuid = Value(idInscriptionUuid),
       montantPaye = Value(montantPaye),
       modePaiement = Value(modePaiement),
       motifPaiement = Value(motifPaiement);
  static Insertable<PaiementInscription> custom({
    Expression<int>? idPaiement,
    Expression<String>? uuid,
    Expression<String>? idInscriptionUuid,
    Expression<double>? montantPaye,
    Expression<DateTime>? datePaiement,
    Expression<String>? modePaiement,
    Expression<String>? motifPaiement,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (idPaiement != null) 'id_paiement': idPaiement,
      if (uuid != null) 'uuid': uuid,
      if (idInscriptionUuid != null) 'id_inscription_uuid': idInscriptionUuid,
      if (montantPaye != null) 'montant_paye': montantPaye,
      if (datePaiement != null) 'date_paiement': datePaiement,
      if (modePaiement != null) 'mode_paiement': modePaiement,
      if (motifPaiement != null) 'motif_paiement': motifPaiement,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PaiementInscriptionsCompanion copyWith({
    Value<int>? idPaiement,
    Value<String>? uuid,
    Value<String>? idInscriptionUuid,
    Value<double>? montantPaye,
    Value<DateTime>? datePaiement,
    Value<String>? modePaiement,
    Value<String>? motifPaiement,
    Value<bool>? isSynced,
    Value<DateTime>? updatedAt,
  }) {
    return PaiementInscriptionsCompanion(
      idPaiement: idPaiement ?? this.idPaiement,
      uuid: uuid ?? this.uuid,
      idInscriptionUuid: idInscriptionUuid ?? this.idInscriptionUuid,
      montantPaye: montantPaye ?? this.montantPaye,
      datePaiement: datePaiement ?? this.datePaiement,
      modePaiement: modePaiement ?? this.modePaiement,
      motifPaiement: motifPaiement ?? this.motifPaiement,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idPaiement.present) {
      map['id_paiement'] = Variable<int>(idPaiement.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (idInscriptionUuid.present) {
      map['id_inscription_uuid'] = Variable<String>(idInscriptionUuid.value);
    }
    if (montantPaye.present) {
      map['montant_paye'] = Variable<double>(montantPaye.value);
    }
    if (datePaiement.present) {
      map['date_paiement'] = Variable<DateTime>(datePaiement.value);
    }
    if (modePaiement.present) {
      map['mode_paiement'] = Variable<String>(modePaiement.value);
    }
    if (motifPaiement.present) {
      map['motif_paiement'] = Variable<String>(motifPaiement.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaiementInscriptionsCompanion(')
          ..write('idPaiement: $idPaiement, ')
          ..write('uuid: $uuid, ')
          ..write('idInscriptionUuid: $idInscriptionUuid, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('motifPaiement: $motifPaiement, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UtilisateursTable extends Utilisateurs
    with TableInfo<$UtilisateursTable, Utilisateur> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UtilisateursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idUtilisateurMeta = const VerificationMeta(
    'idUtilisateur',
  );
  @override
  late final GeneratedColumn<int> idUtilisateur = GeneratedColumn<int>(
    'id_utilisateur',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomUtilisateurMeta = const VerificationMeta(
    'nomUtilisateur',
  );
  @override
  late final GeneratedColumn<String> nomUtilisateur = GeneratedColumn<String>(
    'nom_utilisateur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postnomUtilisateurMeta =
      const VerificationMeta('postnomUtilisateur');
  @override
  late final GeneratedColumn<String> postnomUtilisateur =
      GeneratedColumn<String>(
        'postnom_utilisateur',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _motDePasseMeta = const VerificationMeta(
    'motDePasse',
  );
  @override
  late final GeneratedColumn<String> motDePasse = GeneratedColumn<String>(
    'mot_de_passe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idUtilisateur,
    uuid,
    nomUtilisateur,
    postnomUtilisateur,
    motDePasse,
    photo,
    isSynced,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'utilisateurs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Utilisateur> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_utilisateur')) {
      context.handle(
        _idUtilisateurMeta,
        idUtilisateur.isAcceptableOrUnknown(
          data['id_utilisateur']!,
          _idUtilisateurMeta,
        ),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nom_utilisateur')) {
      context.handle(
        _nomUtilisateurMeta,
        nomUtilisateur.isAcceptableOrUnknown(
          data['nom_utilisateur']!,
          _nomUtilisateurMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nomUtilisateurMeta);
    }
    if (data.containsKey('postnom_utilisateur')) {
      context.handle(
        _postnomUtilisateurMeta,
        postnomUtilisateur.isAcceptableOrUnknown(
          data['postnom_utilisateur']!,
          _postnomUtilisateurMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_postnomUtilisateurMeta);
    }
    if (data.containsKey('mot_de_passe')) {
      context.handle(
        _motDePasseMeta,
        motDePasse.isAcceptableOrUnknown(
          data['mot_de_passe']!,
          _motDePasseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_motDePasseMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idUtilisateur};
  @override
  Utilisateur map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Utilisateur(
      idUtilisateur: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_utilisateur'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      nomUtilisateur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom_utilisateur'],
      )!,
      postnomUtilisateur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}postnom_utilisateur'],
      )!,
      motDePasse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mot_de_passe'],
      )!,
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UtilisateursTable createAlias(String alias) {
    return $UtilisateursTable(attachedDatabase, alias);
  }
}

class Utilisateur extends DataClass implements Insertable<Utilisateur> {
  final int idUtilisateur;
  final String uuid;
  final String nomUtilisateur;
  final String postnomUtilisateur;
  final String motDePasse;
  final String? photo;
  final bool isSynced;
  final DateTime updatedAt;
  const Utilisateur({
    required this.idUtilisateur,
    required this.uuid,
    required this.nomUtilisateur,
    required this.postnomUtilisateur,
    required this.motDePasse,
    this.photo,
    required this.isSynced,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_utilisateur'] = Variable<int>(idUtilisateur);
    map['uuid'] = Variable<String>(uuid);
    map['nom_utilisateur'] = Variable<String>(nomUtilisateur);
    map['postnom_utilisateur'] = Variable<String>(postnomUtilisateur);
    map['mot_de_passe'] = Variable<String>(motDePasse);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UtilisateursCompanion toCompanion(bool nullToAbsent) {
    return UtilisateursCompanion(
      idUtilisateur: Value(idUtilisateur),
      uuid: Value(uuid),
      nomUtilisateur: Value(nomUtilisateur),
      postnomUtilisateur: Value(postnomUtilisateur),
      motDePasse: Value(motDePasse),
      photo: photo == null && nullToAbsent
          ? const Value.absent()
          : Value(photo),
      isSynced: Value(isSynced),
      updatedAt: Value(updatedAt),
    );
  }

  factory Utilisateur.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Utilisateur(
      idUtilisateur: serializer.fromJson<int>(json['idUtilisateur']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nomUtilisateur: serializer.fromJson<String>(json['nomUtilisateur']),
      postnomUtilisateur: serializer.fromJson<String>(
        json['postnomUtilisateur'],
      ),
      motDePasse: serializer.fromJson<String>(json['motDePasse']),
      photo: serializer.fromJson<String?>(json['photo']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idUtilisateur': serializer.toJson<int>(idUtilisateur),
      'uuid': serializer.toJson<String>(uuid),
      'nomUtilisateur': serializer.toJson<String>(nomUtilisateur),
      'postnomUtilisateur': serializer.toJson<String>(postnomUtilisateur),
      'motDePasse': serializer.toJson<String>(motDePasse),
      'photo': serializer.toJson<String?>(photo),
      'isSynced': serializer.toJson<bool>(isSynced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Utilisateur copyWith({
    int? idUtilisateur,
    String? uuid,
    String? nomUtilisateur,
    String? postnomUtilisateur,
    String? motDePasse,
    Value<String?> photo = const Value.absent(),
    bool? isSynced,
    DateTime? updatedAt,
  }) => Utilisateur(
    idUtilisateur: idUtilisateur ?? this.idUtilisateur,
    uuid: uuid ?? this.uuid,
    nomUtilisateur: nomUtilisateur ?? this.nomUtilisateur,
    postnomUtilisateur: postnomUtilisateur ?? this.postnomUtilisateur,
    motDePasse: motDePasse ?? this.motDePasse,
    photo: photo.present ? photo.value : this.photo,
    isSynced: isSynced ?? this.isSynced,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Utilisateur copyWithCompanion(UtilisateursCompanion data) {
    return Utilisateur(
      idUtilisateur: data.idUtilisateur.present
          ? data.idUtilisateur.value
          : this.idUtilisateur,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nomUtilisateur: data.nomUtilisateur.present
          ? data.nomUtilisateur.value
          : this.nomUtilisateur,
      postnomUtilisateur: data.postnomUtilisateur.present
          ? data.postnomUtilisateur.value
          : this.postnomUtilisateur,
      motDePasse: data.motDePasse.present
          ? data.motDePasse.value
          : this.motDePasse,
      photo: data.photo.present ? data.photo.value : this.photo,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Utilisateur(')
          ..write('idUtilisateur: $idUtilisateur, ')
          ..write('uuid: $uuid, ')
          ..write('nomUtilisateur: $nomUtilisateur, ')
          ..write('postnomUtilisateur: $postnomUtilisateur, ')
          ..write('motDePasse: $motDePasse, ')
          ..write('photo: $photo, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idUtilisateur,
    uuid,
    nomUtilisateur,
    postnomUtilisateur,
    motDePasse,
    photo,
    isSynced,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Utilisateur &&
          other.idUtilisateur == this.idUtilisateur &&
          other.uuid == this.uuid &&
          other.nomUtilisateur == this.nomUtilisateur &&
          other.postnomUtilisateur == this.postnomUtilisateur &&
          other.motDePasse == this.motDePasse &&
          other.photo == this.photo &&
          other.isSynced == this.isSynced &&
          other.updatedAt == this.updatedAt);
}

class UtilisateursCompanion extends UpdateCompanion<Utilisateur> {
  final Value<int> idUtilisateur;
  final Value<String> uuid;
  final Value<String> nomUtilisateur;
  final Value<String> postnomUtilisateur;
  final Value<String> motDePasse;
  final Value<String?> photo;
  final Value<bool> isSynced;
  final Value<DateTime> updatedAt;
  const UtilisateursCompanion({
    this.idUtilisateur = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nomUtilisateur = const Value.absent(),
    this.postnomUtilisateur = const Value.absent(),
    this.motDePasse = const Value.absent(),
    this.photo = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UtilisateursCompanion.insert({
    this.idUtilisateur = const Value.absent(),
    required String uuid,
    required String nomUtilisateur,
    required String postnomUtilisateur,
    required String motDePasse,
    this.photo = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       nomUtilisateur = Value(nomUtilisateur),
       postnomUtilisateur = Value(postnomUtilisateur),
       motDePasse = Value(motDePasse);
  static Insertable<Utilisateur> custom({
    Expression<int>? idUtilisateur,
    Expression<String>? uuid,
    Expression<String>? nomUtilisateur,
    Expression<String>? postnomUtilisateur,
    Expression<String>? motDePasse,
    Expression<String>? photo,
    Expression<bool>? isSynced,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (idUtilisateur != null) 'id_utilisateur': idUtilisateur,
      if (uuid != null) 'uuid': uuid,
      if (nomUtilisateur != null) 'nom_utilisateur': nomUtilisateur,
      if (postnomUtilisateur != null) 'postnom_utilisateur': postnomUtilisateur,
      if (motDePasse != null) 'mot_de_passe': motDePasse,
      if (photo != null) 'photo': photo,
      if (isSynced != null) 'is_synced': isSynced,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UtilisateursCompanion copyWith({
    Value<int>? idUtilisateur,
    Value<String>? uuid,
    Value<String>? nomUtilisateur,
    Value<String>? postnomUtilisateur,
    Value<String>? motDePasse,
    Value<String?>? photo,
    Value<bool>? isSynced,
    Value<DateTime>? updatedAt,
  }) {
    return UtilisateursCompanion(
      idUtilisateur: idUtilisateur ?? this.idUtilisateur,
      uuid: uuid ?? this.uuid,
      nomUtilisateur: nomUtilisateur ?? this.nomUtilisateur,
      postnomUtilisateur: postnomUtilisateur ?? this.postnomUtilisateur,
      motDePasse: motDePasse ?? this.motDePasse,
      photo: photo ?? this.photo,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idUtilisateur.present) {
      map['id_utilisateur'] = Variable<int>(idUtilisateur.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nomUtilisateur.present) {
      map['nom_utilisateur'] = Variable<String>(nomUtilisateur.value);
    }
    if (postnomUtilisateur.present) {
      map['postnom_utilisateur'] = Variable<String>(postnomUtilisateur.value);
    }
    if (motDePasse.present) {
      map['mot_de_passe'] = Variable<String>(motDePasse.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UtilisateursCompanion(')
          ..write('idUtilisateur: $idUtilisateur, ')
          ..write('uuid: $uuid, ')
          ..write('nomUtilisateur: $nomUtilisateur, ')
          ..write('postnomUtilisateur: $postnomUtilisateur, ')
          ..write('motDePasse: $motDePasse, ')
          ..write('photo: $photo, ')
          ..write('isSynced: $isSynced, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AnneeScolairesTable anneeScolaires = $AnneeScolairesTable(this);
  late final $ScolaireOptionsTable scolaireOptions = $ScolaireOptionsTable(
    this,
  );
  late final $ClassesTable classes = $ClassesTable(this);
  late final $EleveInscriptionsTable eleveInscriptions =
      $EleveInscriptionsTable(this);
  late final $PaiementInscriptionsTable paiementInscriptions =
      $PaiementInscriptionsTable(this);
  late final $UtilisateursTable utilisateurs = $UtilisateursTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    anneeScolaires,
    scolaireOptions,
    classes,
    eleveInscriptions,
    paiementInscriptions,
    utilisateurs,
  ];
}

typedef $$AnneeScolairesTableCreateCompanionBuilder =
    AnneeScolairesCompanion Function({
      Value<int> idAnnee,
      required String uuid,
      required String libelleAnnee,
      required DateTime dateDebut,
      required DateTime dateFin,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });
typedef $$AnneeScolairesTableUpdateCompanionBuilder =
    AnneeScolairesCompanion Function({
      Value<int> idAnnee,
      Value<String> uuid,
      Value<String> libelleAnnee,
      Value<DateTime> dateDebut,
      Value<DateTime> dateFin,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });

final class $$AnneeScolairesTableReferences
    extends BaseReferences<_$AppDatabase, $AnneeScolairesTable, AnneeScolaire> {
  $$AnneeScolairesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EleveInscriptionsTable, List<EleveInscription>>
  _eleveInscriptionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.eleveInscriptions,
        aliasName: $_aliasNameGenerator(
          db.anneeScolaires.uuid,
          db.eleveInscriptions.idAnneeUuid,
        ),
      );

  $$EleveInscriptionsTableProcessedTableManager get eleveInscriptionsRefs {
    final manager =
        $$EleveInscriptionsTableTableManager(
          $_db,
          $_db.eleveInscriptions,
        ).filter(
          (f) => f.idAnneeUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _eleveInscriptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AnneeScolairesTableFilterComposer
    extends Composer<_$AppDatabase, $AnneeScolairesTable> {
  $$AnneeScolairesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idAnnee => $composableBuilder(
    column: $table.idAnnee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libelleAnnee => $composableBuilder(
    column: $table.libelleAnnee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateDebut => $composableBuilder(
    column: $table.dateDebut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateFin => $composableBuilder(
    column: $table.dateFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eleveInscriptionsRefs(
    Expression<bool> Function($$EleveInscriptionsTableFilterComposer f) f,
  ) {
    final $$EleveInscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.eleveInscriptions,
      getReferencedColumn: (t) => t.idAnneeUuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EleveInscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.eleveInscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnneeScolairesTableOrderingComposer
    extends Composer<_$AppDatabase, $AnneeScolairesTable> {
  $$AnneeScolairesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idAnnee => $composableBuilder(
    column: $table.idAnnee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libelleAnnee => $composableBuilder(
    column: $table.libelleAnnee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateDebut => $composableBuilder(
    column: $table.dateDebut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateFin => $composableBuilder(
    column: $table.dateFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnneeScolairesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnneeScolairesTable> {
  $$AnneeScolairesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idAnnee =>
      $composableBuilder(column: $table.idAnnee, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get libelleAnnee => $composableBuilder(
    column: $table.libelleAnnee,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateDebut =>
      $composableBuilder(column: $table.dateDebut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFin =>
      $composableBuilder(column: $table.dateFin, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> eleveInscriptionsRefs<T extends Object>(
    Expression<T> Function($$EleveInscriptionsTableAnnotationComposer a) f,
  ) {
    final $$EleveInscriptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.uuid,
          referencedTable: $db.eleveInscriptions,
          getReferencedColumn: (t) => t.idAnneeUuid,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EleveInscriptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.eleveInscriptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AnneeScolairesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnneeScolairesTable,
          AnneeScolaire,
          $$AnneeScolairesTableFilterComposer,
          $$AnneeScolairesTableOrderingComposer,
          $$AnneeScolairesTableAnnotationComposer,
          $$AnneeScolairesTableCreateCompanionBuilder,
          $$AnneeScolairesTableUpdateCompanionBuilder,
          (AnneeScolaire, $$AnneeScolairesTableReferences),
          AnneeScolaire,
          PrefetchHooks Function({bool eleveInscriptionsRefs})
        > {
  $$AnneeScolairesTableTableManager(
    _$AppDatabase db,
    $AnneeScolairesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnneeScolairesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnneeScolairesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnneeScolairesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idAnnee = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> libelleAnnee = const Value.absent(),
                Value<DateTime> dateDebut = const Value.absent(),
                Value<DateTime> dateFin = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AnneeScolairesCompanion(
                idAnnee: idAnnee,
                uuid: uuid,
                libelleAnnee: libelleAnnee,
                dateDebut: dateDebut,
                dateFin: dateFin,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> idAnnee = const Value.absent(),
                required String uuid,
                required String libelleAnnee,
                required DateTime dateDebut,
                required DateTime dateFin,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AnneeScolairesCompanion.insert(
                idAnnee: idAnnee,
                uuid: uuid,
                libelleAnnee: libelleAnnee,
                dateDebut: dateDebut,
                dateFin: dateFin,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AnneeScolairesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eleveInscriptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eleveInscriptionsRefs) db.eleveInscriptions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eleveInscriptionsRefs)
                    await $_getPrefetchedData<
                      AnneeScolaire,
                      $AnneeScolairesTable,
                      EleveInscription
                    >(
                      currentTable: table,
                      referencedTable: $$AnneeScolairesTableReferences
                          ._eleveInscriptionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AnneeScolairesTableReferences(
                            db,
                            table,
                            p0,
                          ).eleveInscriptionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idAnneeUuid == item.uuid,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AnneeScolairesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnneeScolairesTable,
      AnneeScolaire,
      $$AnneeScolairesTableFilterComposer,
      $$AnneeScolairesTableOrderingComposer,
      $$AnneeScolairesTableAnnotationComposer,
      $$AnneeScolairesTableCreateCompanionBuilder,
      $$AnneeScolairesTableUpdateCompanionBuilder,
      (AnneeScolaire, $$AnneeScolairesTableReferences),
      AnneeScolaire,
      PrefetchHooks Function({bool eleveInscriptionsRefs})
    >;
typedef $$ScolaireOptionsTableCreateCompanionBuilder =
    ScolaireOptionsCompanion Function({
      Value<int> idOption,
      required String uuid,
      required String nomOption,
      Value<String?> description,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });
typedef $$ScolaireOptionsTableUpdateCompanionBuilder =
    ScolaireOptionsCompanion Function({
      Value<int> idOption,
      Value<String> uuid,
      Value<String> nomOption,
      Value<String?> description,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });

final class $$ScolaireOptionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ScolaireOptionsTable, ScolaireOption> {
  $$ScolaireOptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ClassesTable, List<ClassesData>>
  _classesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classes,
    aliasName: $_aliasNameGenerator(
      db.scolaireOptions.uuid,
      db.classes.idOptionUuid,
    ),
  );

  $$ClassesTableProcessedTableManager get classesRefs {
    final manager = $$ClassesTableTableManager($_db, $_db.classes).filter(
      (f) => f.idOptionUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!),
    );

    final cache = $_typedResult.readTableOrNull(_classesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScolaireOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $ScolaireOptionsTable> {
  $$ScolaireOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idOption => $composableBuilder(
    column: $table.idOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomOption => $composableBuilder(
    column: $table.nomOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> classesRefs(
    Expression<bool> Function($$ClassesTableFilterComposer f) f,
  ) {
    final $$ClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.classes,
      getReferencedColumn: (t) => t.idOptionUuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassesTableFilterComposer(
            $db: $db,
            $table: $db.classes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScolaireOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScolaireOptionsTable> {
  $$ScolaireOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idOption => $composableBuilder(
    column: $table.idOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomOption => $composableBuilder(
    column: $table.nomOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScolaireOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScolaireOptionsTable> {
  $$ScolaireOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idOption =>
      $composableBuilder(column: $table.idOption, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nomOption =>
      $composableBuilder(column: $table.nomOption, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> classesRefs<T extends Object>(
    Expression<T> Function($$ClassesTableAnnotationComposer a) f,
  ) {
    final $$ClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.classes,
      getReferencedColumn: (t) => t.idOptionUuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.classes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScolaireOptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScolaireOptionsTable,
          ScolaireOption,
          $$ScolaireOptionsTableFilterComposer,
          $$ScolaireOptionsTableOrderingComposer,
          $$ScolaireOptionsTableAnnotationComposer,
          $$ScolaireOptionsTableCreateCompanionBuilder,
          $$ScolaireOptionsTableUpdateCompanionBuilder,
          (ScolaireOption, $$ScolaireOptionsTableReferences),
          ScolaireOption,
          PrefetchHooks Function({bool classesRefs})
        > {
  $$ScolaireOptionsTableTableManager(
    _$AppDatabase db,
    $ScolaireOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScolaireOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScolaireOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScolaireOptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idOption = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> nomOption = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ScolaireOptionsCompanion(
                idOption: idOption,
                uuid: uuid,
                nomOption: nomOption,
                description: description,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> idOption = const Value.absent(),
                required String uuid,
                required String nomOption,
                Value<String?> description = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ScolaireOptionsCompanion.insert(
                idOption: idOption,
                uuid: uuid,
                nomOption: nomOption,
                description: description,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScolaireOptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({classesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (classesRefs) db.classes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (classesRefs)
                    await $_getPrefetchedData<
                      ScolaireOption,
                      $ScolaireOptionsTable,
                      ClassesData
                    >(
                      currentTable: table,
                      referencedTable: $$ScolaireOptionsTableReferences
                          ._classesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ScolaireOptionsTableReferences(
                            db,
                            table,
                            p0,
                          ).classesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idOptionUuid == item.uuid,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ScolaireOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScolaireOptionsTable,
      ScolaireOption,
      $$ScolaireOptionsTableFilterComposer,
      $$ScolaireOptionsTableOrderingComposer,
      $$ScolaireOptionsTableAnnotationComposer,
      $$ScolaireOptionsTableCreateCompanionBuilder,
      $$ScolaireOptionsTableUpdateCompanionBuilder,
      (ScolaireOption, $$ScolaireOptionsTableReferences),
      ScolaireOption,
      PrefetchHooks Function({bool classesRefs})
    >;
typedef $$ClassesTableCreateCompanionBuilder =
    ClassesCompanion Function({
      Value<int> idClasse,
      required String uuid,
      required String nomClasse,
      Value<String?> idOptionUuid,
      Value<int> effectifMax,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });
typedef $$ClassesTableUpdateCompanionBuilder =
    ClassesCompanion Function({
      Value<int> idClasse,
      Value<String> uuid,
      Value<String> nomClasse,
      Value<String?> idOptionUuid,
      Value<int> effectifMax,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });

final class $$ClassesTableReferences
    extends BaseReferences<_$AppDatabase, $ClassesTable, ClassesData> {
  $$ClassesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ScolaireOptionsTable _idOptionUuidTable(_$AppDatabase db) =>
      db.scolaireOptions.createAlias(
        $_aliasNameGenerator(db.classes.idOptionUuid, db.scolaireOptions.uuid),
      );

  $$ScolaireOptionsTableProcessedTableManager? get idOptionUuid {
    final $_column = $_itemColumn<String>('id_option_uuid');
    if ($_column == null) return null;
    final manager = $$ScolaireOptionsTableTableManager(
      $_db,
      $_db.scolaireOptions,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idOptionUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EleveInscriptionsTable, List<EleveInscription>>
  _eleveInscriptionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.eleveInscriptions,
        aliasName: $_aliasNameGenerator(
          db.classes.uuid,
          db.eleveInscriptions.idClasseUuid,
        ),
      );

  $$EleveInscriptionsTableProcessedTableManager get eleveInscriptionsRefs {
    final manager =
        $$EleveInscriptionsTableTableManager(
          $_db,
          $_db.eleveInscriptions,
        ).filter(
          (f) => f.idClasseUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _eleveInscriptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClassesTableFilterComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idClasse => $composableBuilder(
    column: $table.idClasse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomClasse => $composableBuilder(
    column: $table.nomClasse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effectifMax => $composableBuilder(
    column: $table.effectifMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ScolaireOptionsTableFilterComposer get idOptionUuid {
    final $$ScolaireOptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idOptionUuid,
      referencedTable: $db.scolaireOptions,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScolaireOptionsTableFilterComposer(
            $db: $db,
            $table: $db.scolaireOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eleveInscriptionsRefs(
    Expression<bool> Function($$EleveInscriptionsTableFilterComposer f) f,
  ) {
    final $$EleveInscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.eleveInscriptions,
      getReferencedColumn: (t) => t.idClasseUuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EleveInscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.eleveInscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idClasse => $composableBuilder(
    column: $table.idClasse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomClasse => $composableBuilder(
    column: $table.nomClasse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effectifMax => $composableBuilder(
    column: $table.effectifMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScolaireOptionsTableOrderingComposer get idOptionUuid {
    final $$ScolaireOptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idOptionUuid,
      referencedTable: $db.scolaireOptions,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScolaireOptionsTableOrderingComposer(
            $db: $db,
            $table: $db.scolaireOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassesTable> {
  $$ClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idClasse =>
      $composableBuilder(column: $table.idClasse, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nomClasse =>
      $composableBuilder(column: $table.nomClasse, builder: (column) => column);

  GeneratedColumn<int> get effectifMax => $composableBuilder(
    column: $table.effectifMax,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ScolaireOptionsTableAnnotationComposer get idOptionUuid {
    final $$ScolaireOptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idOptionUuid,
      referencedTable: $db.scolaireOptions,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScolaireOptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.scolaireOptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eleveInscriptionsRefs<T extends Object>(
    Expression<T> Function($$EleveInscriptionsTableAnnotationComposer a) f,
  ) {
    final $$EleveInscriptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.uuid,
          referencedTable: $db.eleveInscriptions,
          getReferencedColumn: (t) => t.idClasseUuid,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EleveInscriptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.eleveInscriptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ClassesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassesTable,
          ClassesData,
          $$ClassesTableFilterComposer,
          $$ClassesTableOrderingComposer,
          $$ClassesTableAnnotationComposer,
          $$ClassesTableCreateCompanionBuilder,
          $$ClassesTableUpdateCompanionBuilder,
          (ClassesData, $$ClassesTableReferences),
          ClassesData,
          PrefetchHooks Function({
            bool idOptionUuid,
            bool eleveInscriptionsRefs,
          })
        > {
  $$ClassesTableTableManager(_$AppDatabase db, $ClassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idClasse = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> nomClasse = const Value.absent(),
                Value<String?> idOptionUuid = const Value.absent(),
                Value<int> effectifMax = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ClassesCompanion(
                idClasse: idClasse,
                uuid: uuid,
                nomClasse: nomClasse,
                idOptionUuid: idOptionUuid,
                effectifMax: effectifMax,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> idClasse = const Value.absent(),
                required String uuid,
                required String nomClasse,
                Value<String?> idOptionUuid = const Value.absent(),
                Value<int> effectifMax = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ClassesCompanion.insert(
                idClasse: idClasse,
                uuid: uuid,
                nomClasse: nomClasse,
                idOptionUuid: idOptionUuid,
                effectifMax: effectifMax,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClassesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({idOptionUuid = false, eleveInscriptionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (eleveInscriptionsRefs) db.eleveInscriptions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idOptionUuid) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idOptionUuid,
                                    referencedTable: $$ClassesTableReferences
                                        ._idOptionUuidTable(db),
                                    referencedColumn: $$ClassesTableReferences
                                        ._idOptionUuidTable(db)
                                        .uuid,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (eleveInscriptionsRefs)
                        await $_getPrefetchedData<
                          ClassesData,
                          $ClassesTable,
                          EleveInscription
                        >(
                          currentTable: table,
                          referencedTable: $$ClassesTableReferences
                              ._eleveInscriptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClassesTableReferences(
                                db,
                                table,
                                p0,
                              ).eleveInscriptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idClasseUuid == item.uuid,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassesTable,
      ClassesData,
      $$ClassesTableFilterComposer,
      $$ClassesTableOrderingComposer,
      $$ClassesTableAnnotationComposer,
      $$ClassesTableCreateCompanionBuilder,
      $$ClassesTableUpdateCompanionBuilder,
      (ClassesData, $$ClassesTableReferences),
      ClassesData,
      PrefetchHooks Function({bool idOptionUuid, bool eleveInscriptionsRefs})
    >;
typedef $$EleveInscriptionsTableCreateCompanionBuilder =
    EleveInscriptionsCompanion Function({
      Value<int> idInscription,
      required String uuid,
      required String nomEleve,
      required String prenomEleve,
      required DateTime dateNaissance,
      required String sexe,
      required String idAnneeUuid,
      required String idClasseUuid,
      Value<DateTime> dateInscription,
      Value<String> statutInscription,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });
typedef $$EleveInscriptionsTableUpdateCompanionBuilder =
    EleveInscriptionsCompanion Function({
      Value<int> idInscription,
      Value<String> uuid,
      Value<String> nomEleve,
      Value<String> prenomEleve,
      Value<DateTime> dateNaissance,
      Value<String> sexe,
      Value<String> idAnneeUuid,
      Value<String> idClasseUuid,
      Value<DateTime> dateInscription,
      Value<String> statutInscription,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });

final class $$EleveInscriptionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EleveInscriptionsTable,
          EleveInscription
        > {
  $$EleveInscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnneeScolairesTable _idAnneeUuidTable(_$AppDatabase db) =>
      db.anneeScolaires.createAlias(
        $_aliasNameGenerator(
          db.eleveInscriptions.idAnneeUuid,
          db.anneeScolaires.uuid,
        ),
      );

  $$AnneeScolairesTableProcessedTableManager get idAnneeUuid {
    final $_column = $_itemColumn<String>('id_annee_uuid')!;

    final manager = $$AnneeScolairesTableTableManager(
      $_db,
      $_db.anneeScolaires,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idAnneeUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClassesTable _idClasseUuidTable(_$AppDatabase db) =>
      db.classes.createAlias(
        $_aliasNameGenerator(
          db.eleveInscriptions.idClasseUuid,
          db.classes.uuid,
        ),
      );

  $$ClassesTableProcessedTableManager get idClasseUuid {
    final $_column = $_itemColumn<String>('id_classe_uuid')!;

    final manager = $$ClassesTableTableManager(
      $_db,
      $_db.classes,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idClasseUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $PaiementInscriptionsTable,
    List<PaiementInscription>
  >
  _paiementInscriptionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paiementInscriptions,
        aliasName: $_aliasNameGenerator(
          db.eleveInscriptions.uuid,
          db.paiementInscriptions.idInscriptionUuid,
        ),
      );

  $$PaiementInscriptionsTableProcessedTableManager
  get paiementInscriptionsRefs {
    final manager =
        $$PaiementInscriptionsTableTableManager(
          $_db,
          $_db.paiementInscriptions,
        ).filter(
          (f) =>
              f.idInscriptionUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _paiementInscriptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EleveInscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $EleveInscriptionsTable> {
  $$EleveInscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idInscription => $composableBuilder(
    column: $table.idInscription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomEleve => $composableBuilder(
    column: $table.nomEleve,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenomEleve => $composableBuilder(
    column: $table.prenomEleve,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sexe => $composableBuilder(
    column: $table.sexe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateInscription => $composableBuilder(
    column: $table.dateInscription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statutInscription => $composableBuilder(
    column: $table.statutInscription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AnneeScolairesTableFilterComposer get idAnneeUuid {
    final $$AnneeScolairesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idAnneeUuid,
      referencedTable: $db.anneeScolaires,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnneeScolairesTableFilterComposer(
            $db: $db,
            $table: $db.anneeScolaires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassesTableFilterComposer get idClasseUuid {
    final $$ClassesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idClasseUuid,
      referencedTable: $db.classes,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassesTableFilterComposer(
            $db: $db,
            $table: $db.classes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paiementInscriptionsRefs(
    Expression<bool> Function($$PaiementInscriptionsTableFilterComposer f) f,
  ) {
    final $$PaiementInscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uuid,
      referencedTable: $db.paiementInscriptions,
      getReferencedColumn: (t) => t.idInscriptionUuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaiementInscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.paiementInscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EleveInscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EleveInscriptionsTable> {
  $$EleveInscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idInscription => $composableBuilder(
    column: $table.idInscription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomEleve => $composableBuilder(
    column: $table.nomEleve,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenomEleve => $composableBuilder(
    column: $table.prenomEleve,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sexe => $composableBuilder(
    column: $table.sexe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateInscription => $composableBuilder(
    column: $table.dateInscription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statutInscription => $composableBuilder(
    column: $table.statutInscription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnneeScolairesTableOrderingComposer get idAnneeUuid {
    final $$AnneeScolairesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idAnneeUuid,
      referencedTable: $db.anneeScolaires,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnneeScolairesTableOrderingComposer(
            $db: $db,
            $table: $db.anneeScolaires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassesTableOrderingComposer get idClasseUuid {
    final $$ClassesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idClasseUuid,
      referencedTable: $db.classes,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassesTableOrderingComposer(
            $db: $db,
            $table: $db.classes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EleveInscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EleveInscriptionsTable> {
  $$EleveInscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idInscription => $composableBuilder(
    column: $table.idInscription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nomEleve =>
      $composableBuilder(column: $table.nomEleve, builder: (column) => column);

  GeneratedColumn<String> get prenomEleve => $composableBuilder(
    column: $table.prenomEleve,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sexe =>
      $composableBuilder(column: $table.sexe, builder: (column) => column);

  GeneratedColumn<DateTime> get dateInscription => $composableBuilder(
    column: $table.dateInscription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statutInscription => $composableBuilder(
    column: $table.statutInscription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AnneeScolairesTableAnnotationComposer get idAnneeUuid {
    final $$AnneeScolairesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idAnneeUuid,
      referencedTable: $db.anneeScolaires,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnneeScolairesTableAnnotationComposer(
            $db: $db,
            $table: $db.anneeScolaires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassesTableAnnotationComposer get idClasseUuid {
    final $$ClassesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idClasseUuid,
      referencedTable: $db.classes,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassesTableAnnotationComposer(
            $db: $db,
            $table: $db.classes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paiementInscriptionsRefs<T extends Object>(
    Expression<T> Function($$PaiementInscriptionsTableAnnotationComposer a) f,
  ) {
    final $$PaiementInscriptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.uuid,
          referencedTable: $db.paiementInscriptions,
          getReferencedColumn: (t) => t.idInscriptionUuid,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaiementInscriptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.paiementInscriptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EleveInscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EleveInscriptionsTable,
          EleveInscription,
          $$EleveInscriptionsTableFilterComposer,
          $$EleveInscriptionsTableOrderingComposer,
          $$EleveInscriptionsTableAnnotationComposer,
          $$EleveInscriptionsTableCreateCompanionBuilder,
          $$EleveInscriptionsTableUpdateCompanionBuilder,
          (EleveInscription, $$EleveInscriptionsTableReferences),
          EleveInscription,
          PrefetchHooks Function({
            bool idAnneeUuid,
            bool idClasseUuid,
            bool paiementInscriptionsRefs,
          })
        > {
  $$EleveInscriptionsTableTableManager(
    _$AppDatabase db,
    $EleveInscriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EleveInscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EleveInscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EleveInscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> idInscription = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> nomEleve = const Value.absent(),
                Value<String> prenomEleve = const Value.absent(),
                Value<DateTime> dateNaissance = const Value.absent(),
                Value<String> sexe = const Value.absent(),
                Value<String> idAnneeUuid = const Value.absent(),
                Value<String> idClasseUuid = const Value.absent(),
                Value<DateTime> dateInscription = const Value.absent(),
                Value<String> statutInscription = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EleveInscriptionsCompanion(
                idInscription: idInscription,
                uuid: uuid,
                nomEleve: nomEleve,
                prenomEleve: prenomEleve,
                dateNaissance: dateNaissance,
                sexe: sexe,
                idAnneeUuid: idAnneeUuid,
                idClasseUuid: idClasseUuid,
                dateInscription: dateInscription,
                statutInscription: statutInscription,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> idInscription = const Value.absent(),
                required String uuid,
                required String nomEleve,
                required String prenomEleve,
                required DateTime dateNaissance,
                required String sexe,
                required String idAnneeUuid,
                required String idClasseUuid,
                Value<DateTime> dateInscription = const Value.absent(),
                Value<String> statutInscription = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EleveInscriptionsCompanion.insert(
                idInscription: idInscription,
                uuid: uuid,
                nomEleve: nomEleve,
                prenomEleve: prenomEleve,
                dateNaissance: dateNaissance,
                sexe: sexe,
                idAnneeUuid: idAnneeUuid,
                idClasseUuid: idClasseUuid,
                dateInscription: dateInscription,
                statutInscription: statutInscription,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EleveInscriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idAnneeUuid = false,
                idClasseUuid = false,
                paiementInscriptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (paiementInscriptionsRefs) db.paiementInscriptions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idAnneeUuid) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idAnneeUuid,
                                    referencedTable:
                                        $$EleveInscriptionsTableReferences
                                            ._idAnneeUuidTable(db),
                                    referencedColumn:
                                        $$EleveInscriptionsTableReferences
                                            ._idAnneeUuidTable(db)
                                            .uuid,
                                  )
                                  as T;
                        }
                        if (idClasseUuid) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idClasseUuid,
                                    referencedTable:
                                        $$EleveInscriptionsTableReferences
                                            ._idClasseUuidTable(db),
                                    referencedColumn:
                                        $$EleveInscriptionsTableReferences
                                            ._idClasseUuidTable(db)
                                            .uuid,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (paiementInscriptionsRefs)
                        await $_getPrefetchedData<
                          EleveInscription,
                          $EleveInscriptionsTable,
                          PaiementInscription
                        >(
                          currentTable: table,
                          referencedTable: $$EleveInscriptionsTableReferences
                              ._paiementInscriptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EleveInscriptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).paiementInscriptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idInscriptionUuid == item.uuid,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EleveInscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EleveInscriptionsTable,
      EleveInscription,
      $$EleveInscriptionsTableFilterComposer,
      $$EleveInscriptionsTableOrderingComposer,
      $$EleveInscriptionsTableAnnotationComposer,
      $$EleveInscriptionsTableCreateCompanionBuilder,
      $$EleveInscriptionsTableUpdateCompanionBuilder,
      (EleveInscription, $$EleveInscriptionsTableReferences),
      EleveInscription,
      PrefetchHooks Function({
        bool idAnneeUuid,
        bool idClasseUuid,
        bool paiementInscriptionsRefs,
      })
    >;
typedef $$PaiementInscriptionsTableCreateCompanionBuilder =
    PaiementInscriptionsCompanion Function({
      Value<int> idPaiement,
      required String uuid,
      required String idInscriptionUuid,
      required double montantPaye,
      Value<DateTime> datePaiement,
      required String modePaiement,
      required String motifPaiement,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });
typedef $$PaiementInscriptionsTableUpdateCompanionBuilder =
    PaiementInscriptionsCompanion Function({
      Value<int> idPaiement,
      Value<String> uuid,
      Value<String> idInscriptionUuid,
      Value<double> montantPaye,
      Value<DateTime> datePaiement,
      Value<String> modePaiement,
      Value<String> motifPaiement,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });

final class $$PaiementInscriptionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaiementInscriptionsTable,
          PaiementInscription
        > {
  $$PaiementInscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EleveInscriptionsTable _idInscriptionUuidTable(_$AppDatabase db) =>
      db.eleveInscriptions.createAlias(
        $_aliasNameGenerator(
          db.paiementInscriptions.idInscriptionUuid,
          db.eleveInscriptions.uuid,
        ),
      );

  $$EleveInscriptionsTableProcessedTableManager get idInscriptionUuid {
    final $_column = $_itemColumn<String>('id_inscription_uuid')!;

    final manager = $$EleveInscriptionsTableTableManager(
      $_db,
      $_db.eleveInscriptions,
    ).filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idInscriptionUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaiementInscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $PaiementInscriptionsTable> {
  $$PaiementInscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idPaiement => $composableBuilder(
    column: $table.idPaiement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montantPaye => $composableBuilder(
    column: $table.montantPaye,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datePaiement => $composableBuilder(
    column: $table.datePaiement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modePaiement => $composableBuilder(
    column: $table.modePaiement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motifPaiement => $composableBuilder(
    column: $table.motifPaiement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EleveInscriptionsTableFilterComposer get idInscriptionUuid {
    final $$EleveInscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idInscriptionUuid,
      referencedTable: $db.eleveInscriptions,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EleveInscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.eleveInscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaiementInscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaiementInscriptionsTable> {
  $$PaiementInscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idPaiement => $composableBuilder(
    column: $table.idPaiement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montantPaye => $composableBuilder(
    column: $table.montantPaye,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datePaiement => $composableBuilder(
    column: $table.datePaiement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modePaiement => $composableBuilder(
    column: $table.modePaiement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motifPaiement => $composableBuilder(
    column: $table.motifPaiement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EleveInscriptionsTableOrderingComposer get idInscriptionUuid {
    final $$EleveInscriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idInscriptionUuid,
      referencedTable: $db.eleveInscriptions,
      getReferencedColumn: (t) => t.uuid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EleveInscriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.eleveInscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaiementInscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaiementInscriptionsTable> {
  $$PaiementInscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idPaiement => $composableBuilder(
    column: $table.idPaiement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<double> get montantPaye => $composableBuilder(
    column: $table.montantPaye,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get datePaiement => $composableBuilder(
    column: $table.datePaiement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modePaiement => $composableBuilder(
    column: $table.modePaiement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motifPaiement => $composableBuilder(
    column: $table.motifPaiement,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EleveInscriptionsTableAnnotationComposer get idInscriptionUuid {
    final $$EleveInscriptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.idInscriptionUuid,
          referencedTable: $db.eleveInscriptions,
          getReferencedColumn: (t) => t.uuid,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EleveInscriptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.eleveInscriptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PaiementInscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaiementInscriptionsTable,
          PaiementInscription,
          $$PaiementInscriptionsTableFilterComposer,
          $$PaiementInscriptionsTableOrderingComposer,
          $$PaiementInscriptionsTableAnnotationComposer,
          $$PaiementInscriptionsTableCreateCompanionBuilder,
          $$PaiementInscriptionsTableUpdateCompanionBuilder,
          (PaiementInscription, $$PaiementInscriptionsTableReferences),
          PaiementInscription,
          PrefetchHooks Function({bool idInscriptionUuid})
        > {
  $$PaiementInscriptionsTableTableManager(
    _$AppDatabase db,
    $PaiementInscriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaiementInscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaiementInscriptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PaiementInscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> idPaiement = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> idInscriptionUuid = const Value.absent(),
                Value<double> montantPaye = const Value.absent(),
                Value<DateTime> datePaiement = const Value.absent(),
                Value<String> modePaiement = const Value.absent(),
                Value<String> motifPaiement = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PaiementInscriptionsCompanion(
                idPaiement: idPaiement,
                uuid: uuid,
                idInscriptionUuid: idInscriptionUuid,
                montantPaye: montantPaye,
                datePaiement: datePaiement,
                modePaiement: modePaiement,
                motifPaiement: motifPaiement,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> idPaiement = const Value.absent(),
                required String uuid,
                required String idInscriptionUuid,
                required double montantPaye,
                Value<DateTime> datePaiement = const Value.absent(),
                required String modePaiement,
                required String motifPaiement,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PaiementInscriptionsCompanion.insert(
                idPaiement: idPaiement,
                uuid: uuid,
                idInscriptionUuid: idInscriptionUuid,
                montantPaye: montantPaye,
                datePaiement: datePaiement,
                modePaiement: modePaiement,
                motifPaiement: motifPaiement,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaiementInscriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idInscriptionUuid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idInscriptionUuid) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idInscriptionUuid,
                                referencedTable:
                                    $$PaiementInscriptionsTableReferences
                                        ._idInscriptionUuidTable(db),
                                referencedColumn:
                                    $$PaiementInscriptionsTableReferences
                                        ._idInscriptionUuidTable(db)
                                        .uuid,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaiementInscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaiementInscriptionsTable,
      PaiementInscription,
      $$PaiementInscriptionsTableFilterComposer,
      $$PaiementInscriptionsTableOrderingComposer,
      $$PaiementInscriptionsTableAnnotationComposer,
      $$PaiementInscriptionsTableCreateCompanionBuilder,
      $$PaiementInscriptionsTableUpdateCompanionBuilder,
      (PaiementInscription, $$PaiementInscriptionsTableReferences),
      PaiementInscription,
      PrefetchHooks Function({bool idInscriptionUuid})
    >;
typedef $$UtilisateursTableCreateCompanionBuilder =
    UtilisateursCompanion Function({
      Value<int> idUtilisateur,
      required String uuid,
      required String nomUtilisateur,
      required String postnomUtilisateur,
      required String motDePasse,
      Value<String?> photo,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });
typedef $$UtilisateursTableUpdateCompanionBuilder =
    UtilisateursCompanion Function({
      Value<int> idUtilisateur,
      Value<String> uuid,
      Value<String> nomUtilisateur,
      Value<String> postnomUtilisateur,
      Value<String> motDePasse,
      Value<String?> photo,
      Value<bool> isSynced,
      Value<DateTime> updatedAt,
    });

class $$UtilisateursTableFilterComposer
    extends Composer<_$AppDatabase, $UtilisateursTable> {
  $$UtilisateursTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idUtilisateur => $composableBuilder(
    column: $table.idUtilisateur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomUtilisateur => $composableBuilder(
    column: $table.nomUtilisateur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postnomUtilisateur => $composableBuilder(
    column: $table.postnomUtilisateur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motDePasse => $composableBuilder(
    column: $table.motDePasse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UtilisateursTableOrderingComposer
    extends Composer<_$AppDatabase, $UtilisateursTable> {
  $$UtilisateursTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idUtilisateur => $composableBuilder(
    column: $table.idUtilisateur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomUtilisateur => $composableBuilder(
    column: $table.nomUtilisateur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postnomUtilisateur => $composableBuilder(
    column: $table.postnomUtilisateur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motDePasse => $composableBuilder(
    column: $table.motDePasse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UtilisateursTableAnnotationComposer
    extends Composer<_$AppDatabase, $UtilisateursTable> {
  $$UtilisateursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idUtilisateur => $composableBuilder(
    column: $table.idUtilisateur,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nomUtilisateur => $composableBuilder(
    column: $table.nomUtilisateur,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postnomUtilisateur => $composableBuilder(
    column: $table.postnomUtilisateur,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motDePasse => $composableBuilder(
    column: $table.motDePasse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UtilisateursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UtilisateursTable,
          Utilisateur,
          $$UtilisateursTableFilterComposer,
          $$UtilisateursTableOrderingComposer,
          $$UtilisateursTableAnnotationComposer,
          $$UtilisateursTableCreateCompanionBuilder,
          $$UtilisateursTableUpdateCompanionBuilder,
          (
            Utilisateur,
            BaseReferences<_$AppDatabase, $UtilisateursTable, Utilisateur>,
          ),
          Utilisateur,
          PrefetchHooks Function()
        > {
  $$UtilisateursTableTableManager(_$AppDatabase db, $UtilisateursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UtilisateursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UtilisateursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UtilisateursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idUtilisateur = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> nomUtilisateur = const Value.absent(),
                Value<String> postnomUtilisateur = const Value.absent(),
                Value<String> motDePasse = const Value.absent(),
                Value<String?> photo = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UtilisateursCompanion(
                idUtilisateur: idUtilisateur,
                uuid: uuid,
                nomUtilisateur: nomUtilisateur,
                postnomUtilisateur: postnomUtilisateur,
                motDePasse: motDePasse,
                photo: photo,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> idUtilisateur = const Value.absent(),
                required String uuid,
                required String nomUtilisateur,
                required String postnomUtilisateur,
                required String motDePasse,
                Value<String?> photo = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UtilisateursCompanion.insert(
                idUtilisateur: idUtilisateur,
                uuid: uuid,
                nomUtilisateur: nomUtilisateur,
                postnomUtilisateur: postnomUtilisateur,
                motDePasse: motDePasse,
                photo: photo,
                isSynced: isSynced,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UtilisateursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UtilisateursTable,
      Utilisateur,
      $$UtilisateursTableFilterComposer,
      $$UtilisateursTableOrderingComposer,
      $$UtilisateursTableAnnotationComposer,
      $$UtilisateursTableCreateCompanionBuilder,
      $$UtilisateursTableUpdateCompanionBuilder,
      (
        Utilisateur,
        BaseReferences<_$AppDatabase, $UtilisateursTable, Utilisateur>,
      ),
      Utilisateur,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AnneeScolairesTableTableManager get anneeScolaires =>
      $$AnneeScolairesTableTableManager(_db, _db.anneeScolaires);
  $$ScolaireOptionsTableTableManager get scolaireOptions =>
      $$ScolaireOptionsTableTableManager(_db, _db.scolaireOptions);
  $$ClassesTableTableManager get classes =>
      $$ClassesTableTableManager(_db, _db.classes);
  $$EleveInscriptionsTableTableManager get eleveInscriptions =>
      $$EleveInscriptionsTableTableManager(_db, _db.eleveInscriptions);
  $$PaiementInscriptionsTableTableManager get paiementInscriptions =>
      $$PaiementInscriptionsTableTableManager(_db, _db.paiementInscriptions);
  $$UtilisateursTableTableManager get utilisateurs =>
      $$UtilisateursTableTableManager(_db, _db.utilisateurs);
}
