// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_database.dart';

// ignore_for_file: type=lint
class $CatEntriesTable extends CatEntries
    with TableInfo<$CatEntriesTable, CatEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breedNameMeta =
      const VerificationMeta('breedName');
  @override
  late final GeneratedColumn<String> breedName = GeneratedColumn<String>(
      'breed_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breedDescriptionMeta =
      const VerificationMeta('breedDescription');
  @override
  late final GeneratedColumn<String> breedDescription = GeneratedColumn<String>(
      'breed_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
      'origin', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _temperamentMeta =
      const VerificationMeta('temperament');
  @override
  late final GeneratedColumn<String> temperament = GeneratedColumn<String>(
      'temperament', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lifeSpanMeta =
      const VerificationMeta('lifeSpan');
  @override
  late final GeneratedColumn<String> lifeSpan = GeneratedColumn<String>(
      'life_span', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<String> weight = GeneratedColumn<String>(
      'weight', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        url,
        breedName,
        breedDescription,
        origin,
        temperament,
        lifeSpan,
        weight
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cat_entries';
  @override
  VerificationContext validateIntegrity(Insertable<CatEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('breed_name')) {
      context.handle(_breedNameMeta,
          breedName.isAcceptableOrUnknown(data['breed_name']!, _breedNameMeta));
    } else if (isInserting) {
      context.missing(_breedNameMeta);
    }
    if (data.containsKey('breed_description')) {
      context.handle(
          _breedDescriptionMeta,
          breedDescription.isAcceptableOrUnknown(
              data['breed_description']!, _breedDescriptionMeta));
    } else if (isInserting) {
      context.missing(_breedDescriptionMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(_originMeta,
          origin.isAcceptableOrUnknown(data['origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('temperament')) {
      context.handle(
          _temperamentMeta,
          temperament.isAcceptableOrUnknown(
              data['temperament']!, _temperamentMeta));
    } else if (isInserting) {
      context.missing(_temperamentMeta);
    }
    if (data.containsKey('life_span')) {
      context.handle(_lifeSpanMeta,
          lifeSpan.isAcceptableOrUnknown(data['life_span']!, _lifeSpanMeta));
    } else if (isInserting) {
      context.missing(_lifeSpanMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      breedName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breed_name'])!,
      breedDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}breed_description'])!,
      origin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin'])!,
      temperament: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}temperament'])!,
      lifeSpan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}life_span'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weight'])!,
    );
  }

  @override
  $CatEntriesTable createAlias(String alias) {
    return $CatEntriesTable(attachedDatabase, alias);
  }
}

class CatEntry extends DataClass implements Insertable<CatEntry> {
  final String id;
  final String url;
  final String breedName;
  final String breedDescription;
  final String origin;
  final String temperament;
  final String lifeSpan;
  final String weight;
  const CatEntry(
      {required this.id,
      required this.url,
      required this.breedName,
      required this.breedDescription,
      required this.origin,
      required this.temperament,
      required this.lifeSpan,
      required this.weight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['url'] = Variable<String>(url);
    map['breed_name'] = Variable<String>(breedName);
    map['breed_description'] = Variable<String>(breedDescription);
    map['origin'] = Variable<String>(origin);
    map['temperament'] = Variable<String>(temperament);
    map['life_span'] = Variable<String>(lifeSpan);
    map['weight'] = Variable<String>(weight);
    return map;
  }

  CatEntriesCompanion toCompanion(bool nullToAbsent) {
    return CatEntriesCompanion(
      id: Value(id),
      url: Value(url),
      breedName: Value(breedName),
      breedDescription: Value(breedDescription),
      origin: Value(origin),
      temperament: Value(temperament),
      lifeSpan: Value(lifeSpan),
      weight: Value(weight),
    );
  }

  factory CatEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatEntry(
      id: serializer.fromJson<String>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      breedName: serializer.fromJson<String>(json['breedName']),
      breedDescription: serializer.fromJson<String>(json['breedDescription']),
      origin: serializer.fromJson<String>(json['origin']),
      temperament: serializer.fromJson<String>(json['temperament']),
      lifeSpan: serializer.fromJson<String>(json['lifeSpan']),
      weight: serializer.fromJson<String>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'url': serializer.toJson<String>(url),
      'breedName': serializer.toJson<String>(breedName),
      'breedDescription': serializer.toJson<String>(breedDescription),
      'origin': serializer.toJson<String>(origin),
      'temperament': serializer.toJson<String>(temperament),
      'lifeSpan': serializer.toJson<String>(lifeSpan),
      'weight': serializer.toJson<String>(weight),
    };
  }

  CatEntry copyWith(
          {String? id,
          String? url,
          String? breedName,
          String? breedDescription,
          String? origin,
          String? temperament,
          String? lifeSpan,
          String? weight}) =>
      CatEntry(
        id: id ?? this.id,
        url: url ?? this.url,
        breedName: breedName ?? this.breedName,
        breedDescription: breedDescription ?? this.breedDescription,
        origin: origin ?? this.origin,
        temperament: temperament ?? this.temperament,
        lifeSpan: lifeSpan ?? this.lifeSpan,
        weight: weight ?? this.weight,
      );
  CatEntry copyWithCompanion(CatEntriesCompanion data) {
    return CatEntry(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      breedName: data.breedName.present ? data.breedName.value : this.breedName,
      breedDescription: data.breedDescription.present
          ? data.breedDescription.value
          : this.breedDescription,
      origin: data.origin.present ? data.origin.value : this.origin,
      temperament:
          data.temperament.present ? data.temperament.value : this.temperament,
      lifeSpan: data.lifeSpan.present ? data.lifeSpan.value : this.lifeSpan,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatEntry(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('breedName: $breedName, ')
          ..write('breedDescription: $breedDescription, ')
          ..write('origin: $origin, ')
          ..write('temperament: $temperament, ')
          ..write('lifeSpan: $lifeSpan, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, breedName, breedDescription, origin,
      temperament, lifeSpan, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatEntry &&
          other.id == this.id &&
          other.url == this.url &&
          other.breedName == this.breedName &&
          other.breedDescription == this.breedDescription &&
          other.origin == this.origin &&
          other.temperament == this.temperament &&
          other.lifeSpan == this.lifeSpan &&
          other.weight == this.weight);
}

class CatEntriesCompanion extends UpdateCompanion<CatEntry> {
  final Value<String> id;
  final Value<String> url;
  final Value<String> breedName;
  final Value<String> breedDescription;
  final Value<String> origin;
  final Value<String> temperament;
  final Value<String> lifeSpan;
  final Value<String> weight;
  final Value<int> rowid;
  const CatEntriesCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.breedName = const Value.absent(),
    this.breedDescription = const Value.absent(),
    this.origin = const Value.absent(),
    this.temperament = const Value.absent(),
    this.lifeSpan = const Value.absent(),
    this.weight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatEntriesCompanion.insert({
    required String id,
    required String url,
    required String breedName,
    required String breedDescription,
    required String origin,
    required String temperament,
    required String lifeSpan,
    required String weight,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        url = Value(url),
        breedName = Value(breedName),
        breedDescription = Value(breedDescription),
        origin = Value(origin),
        temperament = Value(temperament),
        lifeSpan = Value(lifeSpan),
        weight = Value(weight);
  static Insertable<CatEntry> custom({
    Expression<String>? id,
    Expression<String>? url,
    Expression<String>? breedName,
    Expression<String>? breedDescription,
    Expression<String>? origin,
    Expression<String>? temperament,
    Expression<String>? lifeSpan,
    Expression<String>? weight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (breedName != null) 'breed_name': breedName,
      if (breedDescription != null) 'breed_description': breedDescription,
      if (origin != null) 'origin': origin,
      if (temperament != null) 'temperament': temperament,
      if (lifeSpan != null) 'life_span': lifeSpan,
      if (weight != null) 'weight': weight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? url,
      Value<String>? breedName,
      Value<String>? breedDescription,
      Value<String>? origin,
      Value<String>? temperament,
      Value<String>? lifeSpan,
      Value<String>? weight,
      Value<int>? rowid}) {
    return CatEntriesCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      breedName: breedName ?? this.breedName,
      breedDescription: breedDescription ?? this.breedDescription,
      origin: origin ?? this.origin,
      temperament: temperament ?? this.temperament,
      lifeSpan: lifeSpan ?? this.lifeSpan,
      weight: weight ?? this.weight,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (breedName.present) {
      map['breed_name'] = Variable<String>(breedName.value);
    }
    if (breedDescription.present) {
      map['breed_description'] = Variable<String>(breedDescription.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (temperament.present) {
      map['temperament'] = Variable<String>(temperament.value);
    }
    if (lifeSpan.present) {
      map['life_span'] = Variable<String>(lifeSpan.value);
    }
    if (weight.present) {
      map['weight'] = Variable<String>(weight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatEntriesCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('breedName: $breedName, ')
          ..write('breedDescription: $breedDescription, ')
          ..write('origin: $origin, ')
          ..write('temperament: $temperament, ')
          ..write('lifeSpan: $lifeSpan, ')
          ..write('weight: $weight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CatDatabase extends GeneratedDatabase {
  _$CatDatabase(QueryExecutor e) : super(e);
  $CatDatabaseManager get managers => $CatDatabaseManager(this);
  late final $CatEntriesTable catEntries = $CatEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [catEntries];
}

typedef $$CatEntriesTableCreateCompanionBuilder = CatEntriesCompanion Function({
  required String id,
  required String url,
  required String breedName,
  required String breedDescription,
  required String origin,
  required String temperament,
  required String lifeSpan,
  required String weight,
  Value<int> rowid,
});
typedef $$CatEntriesTableUpdateCompanionBuilder = CatEntriesCompanion Function({
  Value<String> id,
  Value<String> url,
  Value<String> breedName,
  Value<String> breedDescription,
  Value<String> origin,
  Value<String> temperament,
  Value<String> lifeSpan,
  Value<String> weight,
  Value<int> rowid,
});

class $$CatEntriesTableFilterComposer
    extends Composer<_$CatDatabase, $CatEntriesTable> {
  $$CatEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breedName => $composableBuilder(
      column: $table.breedName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breedDescription => $composableBuilder(
      column: $table.breedDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get temperament => $composableBuilder(
      column: $table.temperament, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lifeSpan => $composableBuilder(
      column: $table.lifeSpan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));
}

class $$CatEntriesTableOrderingComposer
    extends Composer<_$CatDatabase, $CatEntriesTable> {
  $$CatEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breedName => $composableBuilder(
      column: $table.breedName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breedDescription => $composableBuilder(
      column: $table.breedDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get temperament => $composableBuilder(
      column: $table.temperament, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lifeSpan => $composableBuilder(
      column: $table.lifeSpan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));
}

class $$CatEntriesTableAnnotationComposer
    extends Composer<_$CatDatabase, $CatEntriesTable> {
  $$CatEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get breedName =>
      $composableBuilder(column: $table.breedName, builder: (column) => column);

  GeneratedColumn<String> get breedDescription => $composableBuilder(
      column: $table.breedDescription, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get temperament => $composableBuilder(
      column: $table.temperament, builder: (column) => column);

  GeneratedColumn<String> get lifeSpan =>
      $composableBuilder(column: $table.lifeSpan, builder: (column) => column);

  GeneratedColumn<String> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);
}

class $$CatEntriesTableTableManager extends RootTableManager<
    _$CatDatabase,
    $CatEntriesTable,
    CatEntry,
    $$CatEntriesTableFilterComposer,
    $$CatEntriesTableOrderingComposer,
    $$CatEntriesTableAnnotationComposer,
    $$CatEntriesTableCreateCompanionBuilder,
    $$CatEntriesTableUpdateCompanionBuilder,
    (CatEntry, BaseReferences<_$CatDatabase, $CatEntriesTable, CatEntry>),
    CatEntry,
    PrefetchHooks Function()> {
  $$CatEntriesTableTableManager(_$CatDatabase db, $CatEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> breedName = const Value.absent(),
            Value<String> breedDescription = const Value.absent(),
            Value<String> origin = const Value.absent(),
            Value<String> temperament = const Value.absent(),
            Value<String> lifeSpan = const Value.absent(),
            Value<String> weight = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CatEntriesCompanion(
            id: id,
            url: url,
            breedName: breedName,
            breedDescription: breedDescription,
            origin: origin,
            temperament: temperament,
            lifeSpan: lifeSpan,
            weight: weight,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String url,
            required String breedName,
            required String breedDescription,
            required String origin,
            required String temperament,
            required String lifeSpan,
            required String weight,
            Value<int> rowid = const Value.absent(),
          }) =>
              CatEntriesCompanion.insert(
            id: id,
            url: url,
            breedName: breedName,
            breedDescription: breedDescription,
            origin: origin,
            temperament: temperament,
            lifeSpan: lifeSpan,
            weight: weight,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CatEntriesTableProcessedTableManager = ProcessedTableManager<
    _$CatDatabase,
    $CatEntriesTable,
    CatEntry,
    $$CatEntriesTableFilterComposer,
    $$CatEntriesTableOrderingComposer,
    $$CatEntriesTableAnnotationComposer,
    $$CatEntriesTableCreateCompanionBuilder,
    $$CatEntriesTableUpdateCompanionBuilder,
    (CatEntry, BaseReferences<_$CatDatabase, $CatEntriesTable, CatEntry>),
    CatEntry,
    PrefetchHooks Function()>;

class $CatDatabaseManager {
  final _$CatDatabase _db;
  $CatDatabaseManager(this._db);
  $$CatEntriesTableTableManager get catEntries =>
      $$CatEntriesTableTableManager(_db, _db.catEntries);
}
