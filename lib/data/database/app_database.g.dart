// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles
    with TableInfo<$VehiclesTable, VehicleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tankCapacityMeta = const VerificationMeta(
    'tankCapacity',
  );
  @override
  late final GeneratedColumn<double> tankCapacity = GeneratedColumn<double>(
    'tank_capacity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialOdometerMeta = const VerificationMeta(
    'initialOdometer',
  );
  @override
  late final GeneratedColumn<double> initialOdometer = GeneratedColumn<double>(
    'initial_odometer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    fuelType,
    tankCapacity,
    initialOdometer,
    createdAt,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('tank_capacity')) {
      context.handle(
        _tankCapacityMeta,
        tankCapacity.isAcceptableOrUnknown(
          data['tank_capacity']!,
          _tankCapacityMeta,
        ),
      );
    }
    if (data.containsKey('initial_odometer')) {
      context.handle(
        _initialOdometerMeta,
        initialOdometer.isAcceptableOrUnknown(
          data['initial_odometer']!,
          _initialOdometerMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      tankCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tank_capacity'],
      ),
      initialOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_odometer'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class VehicleEntry extends DataClass implements Insertable<VehicleEntry> {
  final String id;
  final String name;
  final String type;
  final String fuelType;
  final double? tankCapacity;
  final double initialOdometer;
  final String createdAt;
  final DateTime? lastUpdated;
  const VehicleEntry({
    required this.id,
    required this.name,
    required this.type,
    required this.fuelType,
    this.tankCapacity,
    required this.initialOdometer,
    required this.createdAt,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['fuel_type'] = Variable<String>(fuelType);
    if (!nullToAbsent || tankCapacity != null) {
      map['tank_capacity'] = Variable<double>(tankCapacity);
    }
    map['initial_odometer'] = Variable<double>(initialOdometer);
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      fuelType: Value(fuelType),
      tankCapacity: tankCapacity == null && nullToAbsent
          ? const Value.absent()
          : Value(tankCapacity),
      initialOdometer: Value(initialOdometer),
      createdAt: Value(createdAt),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory VehicleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      tankCapacity: serializer.fromJson<double?>(json['tankCapacity']),
      initialOdometer: serializer.fromJson<double>(json['initialOdometer']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'fuelType': serializer.toJson<String>(fuelType),
      'tankCapacity': serializer.toJson<double?>(tankCapacity),
      'initialOdometer': serializer.toJson<double>(initialOdometer),
      'createdAt': serializer.toJson<String>(createdAt),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  VehicleEntry copyWith({
    String? id,
    String? name,
    String? type,
    String? fuelType,
    Value<double?> tankCapacity = const Value.absent(),
    double? initialOdometer,
    String? createdAt,
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => VehicleEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    fuelType: fuelType ?? this.fuelType,
    tankCapacity: tankCapacity.present ? tankCapacity.value : this.tankCapacity,
    initialOdometer: initialOdometer ?? this.initialOdometer,
    createdAt: createdAt ?? this.createdAt,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  VehicleEntry copyWithCompanion(VehiclesCompanion data) {
    return VehicleEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      tankCapacity: data.tankCapacity.present
          ? data.tankCapacity.value
          : this.tankCapacity,
      initialOdometer: data.initialOdometer.present
          ? data.initialOdometer.value
          : this.initialOdometer,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('fuelType: $fuelType, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('initialOdometer: $initialOdometer, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    fuelType,
    tankCapacity,
    initialOdometer,
    createdAt,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.fuelType == this.fuelType &&
          other.tankCapacity == this.tankCapacity &&
          other.initialOdometer == this.initialOdometer &&
          other.createdAt == this.createdAt &&
          other.lastUpdated == this.lastUpdated);
}

class VehiclesCompanion extends UpdateCompanion<VehicleEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> fuelType;
  final Value<double?> tankCapacity;
  final Value<double> initialOdometer;
  final Value<String> createdAt;
  final Value<DateTime?> lastUpdated;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.tankCapacity = const Value.absent(),
    this.initialOdometer = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String fuelType,
    this.tankCapacity = const Value.absent(),
    this.initialOdometer = const Value.absent(),
    required String createdAt,
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       fuelType = Value(fuelType),
       createdAt = Value(createdAt);
  static Insertable<VehicleEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? fuelType,
    Expression<double>? tankCapacity,
    Expression<double>? initialOdometer,
    Expression<String>? createdAt,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (fuelType != null) 'fuel_type': fuelType,
      if (tankCapacity != null) 'tank_capacity': tankCapacity,
      if (initialOdometer != null) 'initial_odometer': initialOdometer,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? fuelType,
    Value<double?>? tankCapacity,
    Value<double>? initialOdometer,
    Value<String>? createdAt,
    Value<DateTime?>? lastUpdated,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      fuelType: fuelType ?? this.fuelType,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      initialOdometer: initialOdometer ?? this.initialOdometer,
      createdAt: createdAt ?? this.createdAt,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (tankCapacity.present) {
      map['tank_capacity'] = Variable<double>(tankCapacity.value);
    }
    if (initialOdometer.present) {
      map['initial_odometer'] = Variable<double>(initialOdometer.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
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
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('fuelType: $fuelType, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('initialOdometer: $initialOdometer, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FuelEntriesTable extends fuel.FuelEntries
    with TableInfo<$FuelEntriesTable, FuelEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelCostMeta = const VerificationMeta(
    'fuelCost',
  );
  @override
  late final GeneratedColumn<double> fuelCost = GeneratedColumn<double>(
    'fuel_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelLitersMeta = const VerificationMeta(
    'fuelLiters',
  );
  @override
  late final GeneratedColumn<double> fuelLiters = GeneratedColumn<double>(
    'fuel_liters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<double> odometer = GeneratedColumn<double>(
    'odometer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationMeta = const VerificationMeta(
    'station',
  );
  @override
  late final GeneratedColumn<String> station = GeneratedColumn<String>(
    'station',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    fuelCost,
    fuelLiters,
    odometer,
    station,
    notes,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('fuel_cost')) {
      context.handle(
        _fuelCostMeta,
        fuelCost.isAcceptableOrUnknown(data['fuel_cost']!, _fuelCostMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelCostMeta);
    }
    if (data.containsKey('fuel_liters')) {
      context.handle(
        _fuelLitersMeta,
        fuelLiters.isAcceptableOrUnknown(data['fuel_liters']!, _fuelLitersMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelLitersMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerMeta);
    }
    if (data.containsKey('station')) {
      context.handle(
        _stationMeta,
        station.isAcceptableOrUnknown(data['station']!, _stationMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelEntryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      fuelCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_cost'],
      )!,
      fuelLiters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_liters'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer'],
      )!,
      station: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  $FuelEntriesTable createAlias(String alias) {
    return $FuelEntriesTable(attachedDatabase, alias);
  }
}

class FuelEntryData extends DataClass implements Insertable<FuelEntryData> {
  final String id;
  final String vehicleId;
  final String date;
  final double fuelCost;
  final double fuelLiters;
  final double odometer;
  final String? station;
  final String? notes;
  final DateTime? lastUpdated;
  const FuelEntryData({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.fuelCost,
    required this.fuelLiters,
    required this.odometer,
    this.station,
    this.notes,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['date'] = Variable<String>(date);
    map['fuel_cost'] = Variable<double>(fuelCost);
    map['fuel_liters'] = Variable<double>(fuelLiters);
    map['odometer'] = Variable<double>(odometer);
    if (!nullToAbsent || station != null) {
      map['station'] = Variable<String>(station);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  FuelEntriesCompanion toCompanion(bool nullToAbsent) {
    return FuelEntriesCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      fuelCost: Value(fuelCost),
      fuelLiters: Value(fuelLiters),
      odometer: Value(odometer),
      station: station == null && nullToAbsent
          ? const Value.absent()
          : Value(station),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory FuelEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelEntryData(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      date: serializer.fromJson<String>(json['date']),
      fuelCost: serializer.fromJson<double>(json['fuelCost']),
      fuelLiters: serializer.fromJson<double>(json['fuelLiters']),
      odometer: serializer.fromJson<double>(json['odometer']),
      station: serializer.fromJson<String?>(json['station']),
      notes: serializer.fromJson<String?>(json['notes']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'date': serializer.toJson<String>(date),
      'fuelCost': serializer.toJson<double>(fuelCost),
      'fuelLiters': serializer.toJson<double>(fuelLiters),
      'odometer': serializer.toJson<double>(odometer),
      'station': serializer.toJson<String?>(station),
      'notes': serializer.toJson<String?>(notes),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  FuelEntryData copyWith({
    String? id,
    String? vehicleId,
    String? date,
    double? fuelCost,
    double? fuelLiters,
    double? odometer,
    Value<String?> station = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => FuelEntryData(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    fuelCost: fuelCost ?? this.fuelCost,
    fuelLiters: fuelLiters ?? this.fuelLiters,
    odometer: odometer ?? this.odometer,
    station: station.present ? station.value : this.station,
    notes: notes.present ? notes.value : this.notes,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  FuelEntryData copyWithCompanion(FuelEntriesCompanion data) {
    return FuelEntryData(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      fuelCost: data.fuelCost.present ? data.fuelCost.value : this.fuelCost,
      fuelLiters: data.fuelLiters.present
          ? data.fuelLiters.value
          : this.fuelLiters,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      station: data.station.present ? data.station.value : this.station,
      notes: data.notes.present ? data.notes.value : this.notes,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelEntryData(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('fuelCost: $fuelCost, ')
          ..write('fuelLiters: $fuelLiters, ')
          ..write('odometer: $odometer, ')
          ..write('station: $station, ')
          ..write('notes: $notes, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    date,
    fuelCost,
    fuelLiters,
    odometer,
    station,
    notes,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelEntryData &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.fuelCost == this.fuelCost &&
          other.fuelLiters == this.fuelLiters &&
          other.odometer == this.odometer &&
          other.station == this.station &&
          other.notes == this.notes &&
          other.lastUpdated == this.lastUpdated);
}

class FuelEntriesCompanion extends UpdateCompanion<FuelEntryData> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> date;
  final Value<double> fuelCost;
  final Value<double> fuelLiters;
  final Value<double> odometer;
  final Value<String?> station;
  final Value<String?> notes;
  final Value<DateTime?> lastUpdated;
  final Value<int> rowid;
  const FuelEntriesCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.fuelCost = const Value.absent(),
    this.fuelLiters = const Value.absent(),
    this.odometer = const Value.absent(),
    this.station = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FuelEntriesCompanion.insert({
    required String id,
    required String vehicleId,
    required String date,
    required double fuelCost,
    required double fuelLiters,
    required double odometer,
    this.station = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       date = Value(date),
       fuelCost = Value(fuelCost),
       fuelLiters = Value(fuelLiters),
       odometer = Value(odometer);
  static Insertable<FuelEntryData> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? date,
    Expression<double>? fuelCost,
    Expression<double>? fuelLiters,
    Expression<double>? odometer,
    Expression<String>? station,
    Expression<String>? notes,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (fuelCost != null) 'fuel_cost': fuelCost,
      if (fuelLiters != null) 'fuel_liters': fuelLiters,
      if (odometer != null) 'odometer': odometer,
      if (station != null) 'station': station,
      if (notes != null) 'notes': notes,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FuelEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? date,
    Value<double>? fuelCost,
    Value<double>? fuelLiters,
    Value<double>? odometer,
    Value<String?>? station,
    Value<String?>? notes,
    Value<DateTime?>? lastUpdated,
    Value<int>? rowid,
  }) {
    return FuelEntriesCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      fuelCost: fuelCost ?? this.fuelCost,
      fuelLiters: fuelLiters ?? this.fuelLiters,
      odometer: odometer ?? this.odometer,
      station: station ?? this.station,
      notes: notes ?? this.notes,
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
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (fuelCost.present) {
      map['fuel_cost'] = Variable<double>(fuelCost.value);
    }
    if (fuelLiters.present) {
      map['fuel_liters'] = Variable<double>(fuelLiters.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<double>(odometer.value);
    }
    if (station.present) {
      map['station'] = Variable<String>(station.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('FuelEntriesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('fuelCost: $fuelCost, ')
          ..write('fuelLiters: $fuelLiters, ')
          ..write('odometer: $odometer, ')
          ..write('station: $station, ')
          ..write('notes: $notes, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends trip.Trips with TableInfo<$TripsTable, TripData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMeta = const VerificationMeta(
    'distance',
  );
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
    'distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _avgSpeedMeta = const VerificationMeta(
    'avgSpeed',
  );
  @override
  late final GeneratedColumn<double> avgSpeed = GeneratedColumn<double>(
    'avg_speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxSpeedMeta = const VerificationMeta(
    'maxSpeed',
  );
  @override
  late final GeneratedColumn<double> maxSpeed = GeneratedColumn<double>(
    'max_speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minSpeedMeta = const VerificationMeta(
    'minSpeed',
  );
  @override
  late final GeneratedColumn<double> minSpeed = GeneratedColumn<double>(
    'min_speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAddressMeta = const VerificationMeta(
    'startAddress',
  );
  @override
  late final GeneratedColumn<String> startAddress = GeneratedColumn<String>(
    'start_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endAddressMeta = const VerificationMeta(
    'endAddress',
  );
  @override
  late final GeneratedColumn<String> endAddress = GeneratedColumn<String>(
    'end_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minLatitudeMeta = const VerificationMeta(
    'minLatitude',
  );
  @override
  late final GeneratedColumn<double> minLatitude = GeneratedColumn<double>(
    'min_latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _maxLatitudeMeta = const VerificationMeta(
    'maxLatitude',
  );
  @override
  late final GeneratedColumn<double> maxLatitude = GeneratedColumn<double>(
    'max_latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _minLongitudeMeta = const VerificationMeta(
    'minLongitude',
  );
  @override
  late final GeneratedColumn<double> minLongitude = GeneratedColumn<double>(
    'min_longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _maxLongitudeMeta = const VerificationMeta(
    'maxLongitude',
  );
  @override
  late final GeneratedColumn<double> maxLongitude = GeneratedColumn<double>(
    'max_longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _routeSnapshotPathMeta = const VerificationMeta(
    'routeSnapshotPath',
  );
  @override
  late final GeneratedColumn<String> routeSnapshotPath =
      GeneratedColumn<String>(
        'route_snapshot_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _routePointsJsonMeta = const VerificationMeta(
    'routePointsJson',
  );
  @override
  late final GeneratedColumn<String> routePointsJson = GeneratedColumn<String>(
    'route_points_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    startTime,
    endTime,
    distance,
    avgSpeed,
    maxSpeed,
    minSpeed,
    startAddress,
    endAddress,
    minLatitude,
    maxLatitude,
    minLongitude,
    maxLongitude,
    routeSnapshotPath,
    routePointsJson,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('distance')) {
      context.handle(
        _distanceMeta,
        distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta),
      );
    }
    if (data.containsKey('avg_speed')) {
      context.handle(
        _avgSpeedMeta,
        avgSpeed.isAcceptableOrUnknown(data['avg_speed']!, _avgSpeedMeta),
      );
    }
    if (data.containsKey('max_speed')) {
      context.handle(
        _maxSpeedMeta,
        maxSpeed.isAcceptableOrUnknown(data['max_speed']!, _maxSpeedMeta),
      );
    }
    if (data.containsKey('min_speed')) {
      context.handle(
        _minSpeedMeta,
        minSpeed.isAcceptableOrUnknown(data['min_speed']!, _minSpeedMeta),
      );
    }
    if (data.containsKey('start_address')) {
      context.handle(
        _startAddressMeta,
        startAddress.isAcceptableOrUnknown(
          data['start_address']!,
          _startAddressMeta,
        ),
      );
    }
    if (data.containsKey('end_address')) {
      context.handle(
        _endAddressMeta,
        endAddress.isAcceptableOrUnknown(data['end_address']!, _endAddressMeta),
      );
    }
    if (data.containsKey('min_latitude')) {
      context.handle(
        _minLatitudeMeta,
        minLatitude.isAcceptableOrUnknown(
          data['min_latitude']!,
          _minLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('max_latitude')) {
      context.handle(
        _maxLatitudeMeta,
        maxLatitude.isAcceptableOrUnknown(
          data['max_latitude']!,
          _maxLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('min_longitude')) {
      context.handle(
        _minLongitudeMeta,
        minLongitude.isAcceptableOrUnknown(
          data['min_longitude']!,
          _minLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('max_longitude')) {
      context.handle(
        _maxLongitudeMeta,
        maxLongitude.isAcceptableOrUnknown(
          data['max_longitude']!,
          _maxLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('route_snapshot_path')) {
      context.handle(
        _routeSnapshotPathMeta,
        routeSnapshotPath.isAcceptableOrUnknown(
          data['route_snapshot_path']!,
          _routeSnapshotPathMeta,
        ),
      );
    }
    if (data.containsKey('route_points_json')) {
      context.handle(
        _routePointsJsonMeta,
        routePointsJson.isAcceptableOrUnknown(
          data['route_points_json']!,
          _routePointsJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      distance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance'],
      )!,
      avgSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_speed'],
      ),
      maxSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed'],
      ),
      minSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_speed'],
      ),
      startAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_address'],
      ),
      endAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_address'],
      ),
      minLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_latitude'],
      )!,
      maxLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_latitude'],
      )!,
      minLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_longitude'],
      )!,
      maxLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_longitude'],
      )!,
      routeSnapshotPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_snapshot_path'],
      ),
      routePointsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_points_json'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class TripData extends DataClass implements Insertable<TripData> {
  final String id;
  final String vehicleId;
  final String startTime;
  final String? endTime;
  final double distance;
  final double? avgSpeed;
  final double? maxSpeed;
  final double? minSpeed;
  final String? startAddress;
  final String? endAddress;
  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;
  final String? routeSnapshotPath;
  final String? routePointsJson;
  final DateTime? lastUpdated;
  const TripData({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    this.endTime,
    required this.distance,
    this.avgSpeed,
    this.maxSpeed,
    this.minSpeed,
    this.startAddress,
    this.endAddress,
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
    this.routeSnapshotPath,
    this.routePointsJson,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['start_time'] = Variable<String>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    map['distance'] = Variable<double>(distance);
    if (!nullToAbsent || avgSpeed != null) {
      map['avg_speed'] = Variable<double>(avgSpeed);
    }
    if (!nullToAbsent || maxSpeed != null) {
      map['max_speed'] = Variable<double>(maxSpeed);
    }
    if (!nullToAbsent || minSpeed != null) {
      map['min_speed'] = Variable<double>(minSpeed);
    }
    if (!nullToAbsent || startAddress != null) {
      map['start_address'] = Variable<String>(startAddress);
    }
    if (!nullToAbsent || endAddress != null) {
      map['end_address'] = Variable<String>(endAddress);
    }
    map['min_latitude'] = Variable<double>(minLatitude);
    map['max_latitude'] = Variable<double>(maxLatitude);
    map['min_longitude'] = Variable<double>(minLongitude);
    map['max_longitude'] = Variable<double>(maxLongitude);
    if (!nullToAbsent || routeSnapshotPath != null) {
      map['route_snapshot_path'] = Variable<String>(routeSnapshotPath);
    }
    if (!nullToAbsent || routePointsJson != null) {
      map['route_points_json'] = Variable<String>(routePointsJson);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      distance: Value(distance),
      avgSpeed: avgSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(avgSpeed),
      maxSpeed: maxSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSpeed),
      minSpeed: minSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(minSpeed),
      startAddress: startAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(startAddress),
      endAddress: endAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(endAddress),
      minLatitude: Value(minLatitude),
      maxLatitude: Value(maxLatitude),
      minLongitude: Value(minLongitude),
      maxLongitude: Value(maxLongitude),
      routeSnapshotPath: routeSnapshotPath == null && nullToAbsent
          ? const Value.absent()
          : Value(routeSnapshotPath),
      routePointsJson: routePointsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(routePointsJson),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory TripData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripData(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      distance: serializer.fromJson<double>(json['distance']),
      avgSpeed: serializer.fromJson<double?>(json['avgSpeed']),
      maxSpeed: serializer.fromJson<double?>(json['maxSpeed']),
      minSpeed: serializer.fromJson<double?>(json['minSpeed']),
      startAddress: serializer.fromJson<String?>(json['startAddress']),
      endAddress: serializer.fromJson<String?>(json['endAddress']),
      minLatitude: serializer.fromJson<double>(json['minLatitude']),
      maxLatitude: serializer.fromJson<double>(json['maxLatitude']),
      minLongitude: serializer.fromJson<double>(json['minLongitude']),
      maxLongitude: serializer.fromJson<double>(json['maxLongitude']),
      routeSnapshotPath: serializer.fromJson<String?>(
        json['routeSnapshotPath'],
      ),
      routePointsJson: serializer.fromJson<String?>(json['routePointsJson']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'distance': serializer.toJson<double>(distance),
      'avgSpeed': serializer.toJson<double?>(avgSpeed),
      'maxSpeed': serializer.toJson<double?>(maxSpeed),
      'minSpeed': serializer.toJson<double?>(minSpeed),
      'startAddress': serializer.toJson<String?>(startAddress),
      'endAddress': serializer.toJson<String?>(endAddress),
      'minLatitude': serializer.toJson<double>(minLatitude),
      'maxLatitude': serializer.toJson<double>(maxLatitude),
      'minLongitude': serializer.toJson<double>(minLongitude),
      'maxLongitude': serializer.toJson<double>(maxLongitude),
      'routeSnapshotPath': serializer.toJson<String?>(routeSnapshotPath),
      'routePointsJson': serializer.toJson<String?>(routePointsJson),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  TripData copyWith({
    String? id,
    String? vehicleId,
    String? startTime,
    Value<String?> endTime = const Value.absent(),
    double? distance,
    Value<double?> avgSpeed = const Value.absent(),
    Value<double?> maxSpeed = const Value.absent(),
    Value<double?> minSpeed = const Value.absent(),
    Value<String?> startAddress = const Value.absent(),
    Value<String?> endAddress = const Value.absent(),
    double? minLatitude,
    double? maxLatitude,
    double? minLongitude,
    double? maxLongitude,
    Value<String?> routeSnapshotPath = const Value.absent(),
    Value<String?> routePointsJson = const Value.absent(),
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => TripData(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    distance: distance ?? this.distance,
    avgSpeed: avgSpeed.present ? avgSpeed.value : this.avgSpeed,
    maxSpeed: maxSpeed.present ? maxSpeed.value : this.maxSpeed,
    minSpeed: minSpeed.present ? minSpeed.value : this.minSpeed,
    startAddress: startAddress.present ? startAddress.value : this.startAddress,
    endAddress: endAddress.present ? endAddress.value : this.endAddress,
    minLatitude: minLatitude ?? this.minLatitude,
    maxLatitude: maxLatitude ?? this.maxLatitude,
    minLongitude: minLongitude ?? this.minLongitude,
    maxLongitude: maxLongitude ?? this.maxLongitude,
    routeSnapshotPath: routeSnapshotPath.present
        ? routeSnapshotPath.value
        : this.routeSnapshotPath,
    routePointsJson: routePointsJson.present
        ? routePointsJson.value
        : this.routePointsJson,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  TripData copyWithCompanion(TripsCompanion data) {
    return TripData(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      distance: data.distance.present ? data.distance.value : this.distance,
      avgSpeed: data.avgSpeed.present ? data.avgSpeed.value : this.avgSpeed,
      maxSpeed: data.maxSpeed.present ? data.maxSpeed.value : this.maxSpeed,
      minSpeed: data.minSpeed.present ? data.minSpeed.value : this.minSpeed,
      startAddress: data.startAddress.present
          ? data.startAddress.value
          : this.startAddress,
      endAddress: data.endAddress.present
          ? data.endAddress.value
          : this.endAddress,
      minLatitude: data.minLatitude.present
          ? data.minLatitude.value
          : this.minLatitude,
      maxLatitude: data.maxLatitude.present
          ? data.maxLatitude.value
          : this.maxLatitude,
      minLongitude: data.minLongitude.present
          ? data.minLongitude.value
          : this.minLongitude,
      maxLongitude: data.maxLongitude.present
          ? data.maxLongitude.value
          : this.maxLongitude,
      routeSnapshotPath: data.routeSnapshotPath.present
          ? data.routeSnapshotPath.value
          : this.routeSnapshotPath,
      routePointsJson: data.routePointsJson.present
          ? data.routePointsJson.value
          : this.routePointsJson,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripData(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('distance: $distance, ')
          ..write('avgSpeed: $avgSpeed, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('minSpeed: $minSpeed, ')
          ..write('startAddress: $startAddress, ')
          ..write('endAddress: $endAddress, ')
          ..write('minLatitude: $minLatitude, ')
          ..write('maxLatitude: $maxLatitude, ')
          ..write('minLongitude: $minLongitude, ')
          ..write('maxLongitude: $maxLongitude, ')
          ..write('routeSnapshotPath: $routeSnapshotPath, ')
          ..write('routePointsJson: $routePointsJson, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    startTime,
    endTime,
    distance,
    avgSpeed,
    maxSpeed,
    minSpeed,
    startAddress,
    endAddress,
    minLatitude,
    maxLatitude,
    minLongitude,
    maxLongitude,
    routeSnapshotPath,
    routePointsJson,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripData &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.distance == this.distance &&
          other.avgSpeed == this.avgSpeed &&
          other.maxSpeed == this.maxSpeed &&
          other.minSpeed == this.minSpeed &&
          other.startAddress == this.startAddress &&
          other.endAddress == this.endAddress &&
          other.minLatitude == this.minLatitude &&
          other.maxLatitude == this.maxLatitude &&
          other.minLongitude == this.minLongitude &&
          other.maxLongitude == this.maxLongitude &&
          other.routeSnapshotPath == this.routeSnapshotPath &&
          other.routePointsJson == this.routePointsJson &&
          other.lastUpdated == this.lastUpdated);
}

class TripsCompanion extends UpdateCompanion<TripData> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> startTime;
  final Value<String?> endTime;
  final Value<double> distance;
  final Value<double?> avgSpeed;
  final Value<double?> maxSpeed;
  final Value<double?> minSpeed;
  final Value<String?> startAddress;
  final Value<String?> endAddress;
  final Value<double> minLatitude;
  final Value<double> maxLatitude;
  final Value<double> minLongitude;
  final Value<double> maxLongitude;
  final Value<String?> routeSnapshotPath;
  final Value<String?> routePointsJson;
  final Value<DateTime?> lastUpdated;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.distance = const Value.absent(),
    this.avgSpeed = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.minSpeed = const Value.absent(),
    this.startAddress = const Value.absent(),
    this.endAddress = const Value.absent(),
    this.minLatitude = const Value.absent(),
    this.maxLatitude = const Value.absent(),
    this.minLongitude = const Value.absent(),
    this.maxLongitude = const Value.absent(),
    this.routeSnapshotPath = const Value.absent(),
    this.routePointsJson = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    required String id,
    required String vehicleId,
    required String startTime,
    this.endTime = const Value.absent(),
    this.distance = const Value.absent(),
    this.avgSpeed = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.minSpeed = const Value.absent(),
    this.startAddress = const Value.absent(),
    this.endAddress = const Value.absent(),
    this.minLatitude = const Value.absent(),
    this.maxLatitude = const Value.absent(),
    this.minLongitude = const Value.absent(),
    this.maxLongitude = const Value.absent(),
    this.routeSnapshotPath = const Value.absent(),
    this.routePointsJson = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       startTime = Value(startTime);
  static Insertable<TripData> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<double>? distance,
    Expression<double>? avgSpeed,
    Expression<double>? maxSpeed,
    Expression<double>? minSpeed,
    Expression<String>? startAddress,
    Expression<String>? endAddress,
    Expression<double>? minLatitude,
    Expression<double>? maxLatitude,
    Expression<double>? minLongitude,
    Expression<double>? maxLongitude,
    Expression<String>? routeSnapshotPath,
    Expression<String>? routePointsJson,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (distance != null) 'distance': distance,
      if (avgSpeed != null) 'avg_speed': avgSpeed,
      if (maxSpeed != null) 'max_speed': maxSpeed,
      if (minSpeed != null) 'min_speed': minSpeed,
      if (startAddress != null) 'start_address': startAddress,
      if (endAddress != null) 'end_address': endAddress,
      if (minLatitude != null) 'min_latitude': minLatitude,
      if (maxLatitude != null) 'max_latitude': maxLatitude,
      if (minLongitude != null) 'min_longitude': minLongitude,
      if (maxLongitude != null) 'max_longitude': maxLongitude,
      if (routeSnapshotPath != null) 'route_snapshot_path': routeSnapshotPath,
      if (routePointsJson != null) 'route_points_json': routePointsJson,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? startTime,
    Value<String?>? endTime,
    Value<double>? distance,
    Value<double?>? avgSpeed,
    Value<double?>? maxSpeed,
    Value<double?>? minSpeed,
    Value<String?>? startAddress,
    Value<String?>? endAddress,
    Value<double>? minLatitude,
    Value<double>? maxLatitude,
    Value<double>? minLongitude,
    Value<double>? maxLongitude,
    Value<String?>? routeSnapshotPath,
    Value<String?>? routePointsJson,
    Value<DateTime?>? lastUpdated,
    Value<int>? rowid,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      minSpeed: minSpeed ?? this.minSpeed,
      startAddress: startAddress ?? this.startAddress,
      endAddress: endAddress ?? this.endAddress,
      minLatitude: minLatitude ?? this.minLatitude,
      maxLatitude: maxLatitude ?? this.maxLatitude,
      minLongitude: minLongitude ?? this.minLongitude,
      maxLongitude: maxLongitude ?? this.maxLongitude,
      routeSnapshotPath: routeSnapshotPath ?? this.routeSnapshotPath,
      routePointsJson: routePointsJson ?? this.routePointsJson,
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
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (avgSpeed.present) {
      map['avg_speed'] = Variable<double>(avgSpeed.value);
    }
    if (maxSpeed.present) {
      map['max_speed'] = Variable<double>(maxSpeed.value);
    }
    if (minSpeed.present) {
      map['min_speed'] = Variable<double>(minSpeed.value);
    }
    if (startAddress.present) {
      map['start_address'] = Variable<String>(startAddress.value);
    }
    if (endAddress.present) {
      map['end_address'] = Variable<String>(endAddress.value);
    }
    if (minLatitude.present) {
      map['min_latitude'] = Variable<double>(minLatitude.value);
    }
    if (maxLatitude.present) {
      map['max_latitude'] = Variable<double>(maxLatitude.value);
    }
    if (minLongitude.present) {
      map['min_longitude'] = Variable<double>(minLongitude.value);
    }
    if (maxLongitude.present) {
      map['max_longitude'] = Variable<double>(maxLongitude.value);
    }
    if (routeSnapshotPath.present) {
      map['route_snapshot_path'] = Variable<String>(routeSnapshotPath.value);
    }
    if (routePointsJson.present) {
      map['route_points_json'] = Variable<String>(routePointsJson.value);
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
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('distance: $distance, ')
          ..write('avgSpeed: $avgSpeed, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('minSpeed: $minSpeed, ')
          ..write('startAddress: $startAddress, ')
          ..write('endAddress: $endAddress, ')
          ..write('minLatitude: $minLatitude, ')
          ..write('maxLatitude: $maxLatitude, ')
          ..write('minLongitude: $minLongitude, ')
          ..write('maxLongitude: $maxLongitude, ')
          ..write('routeSnapshotPath: $routeSnapshotPath, ')
          ..write('routePointsJson: $routePointsJson, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeocodingCacheTable extends GeocodingCache
    with TableInfo<$GeocodingCacheTable, GeocodingCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeocodingCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<String> cachedAt = GeneratedColumn<String>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cacheKey, address, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'geocoding_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeocodingCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  GeocodingCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeocodingCacheEntry(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $GeocodingCacheTable createAlias(String alias) {
    return $GeocodingCacheTable(attachedDatabase, alias);
  }
}

class GeocodingCacheEntry extends DataClass
    implements Insertable<GeocodingCacheEntry> {
  final String cacheKey;
  final String address;
  final String cachedAt;
  const GeocodingCacheEntry({
    required this.cacheKey,
    required this.address,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['address'] = Variable<String>(address);
    map['cached_at'] = Variable<String>(cachedAt);
    return map;
  }

  GeocodingCacheCompanion toCompanion(bool nullToAbsent) {
    return GeocodingCacheCompanion(
      cacheKey: Value(cacheKey),
      address: Value(address),
      cachedAt: Value(cachedAt),
    );
  }

  factory GeocodingCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeocodingCacheEntry(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      address: serializer.fromJson<String>(json['address']),
      cachedAt: serializer.fromJson<String>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'address': serializer.toJson<String>(address),
      'cachedAt': serializer.toJson<String>(cachedAt),
    };
  }

  GeocodingCacheEntry copyWith({
    String? cacheKey,
    String? address,
    String? cachedAt,
  }) => GeocodingCacheEntry(
    cacheKey: cacheKey ?? this.cacheKey,
    address: address ?? this.address,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  GeocodingCacheEntry copyWithCompanion(GeocodingCacheCompanion data) {
    return GeocodingCacheEntry(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      address: data.address.present ? data.address.value : this.address,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeocodingCacheEntry(')
          ..write('cacheKey: $cacheKey, ')
          ..write('address: $address, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, address, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeocodingCacheEntry &&
          other.cacheKey == this.cacheKey &&
          other.address == this.address &&
          other.cachedAt == this.cachedAt);
}

class GeocodingCacheCompanion extends UpdateCompanion<GeocodingCacheEntry> {
  final Value<String> cacheKey;
  final Value<String> address;
  final Value<String> cachedAt;
  final Value<int> rowid;
  const GeocodingCacheCompanion({
    this.cacheKey = const Value.absent(),
    this.address = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeocodingCacheCompanion.insert({
    required String cacheKey,
    required String address,
    required String cachedAt,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       address = Value(address),
       cachedAt = Value(cachedAt);
  static Insertable<GeocodingCacheEntry> custom({
    Expression<String>? cacheKey,
    Expression<String>? address,
    Expression<String>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (address != null) 'address': address,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeocodingCacheCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? address,
    Value<String>? cachedAt,
    Value<int>? rowid,
  }) {
    return GeocodingCacheCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      address: address ?? this.address,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<String>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeocodingCacheCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('address: $address, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    action,
    entityType,
    entityId,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueEntry extends DataClass implements Insertable<SyncQueueEntry> {
  final int id;
  final String userId;
  final String action;
  final String entityType;
  final String entityId;
  final String? payload;
  final DateTime createdAt;
  const SyncQueueEntry({
    required this.id,
    required this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      userId: Value(userId),
      action: Value(action),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntry(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueEntry copyWith({
    int? id,
    String? userId,
    String? action,
    String? entityType,
    String? entityId,
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
  }) => SyncQueueEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    action: action ?? this.action,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueEntry copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, action, entityType, entityId, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueEntry> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> action;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String action,
    required String entityType,
    required String entityId,
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       action = Value(action),
       entityType = Value(entityType),
       entityId = Value(entityId);
  static Insertable<SyncQueueEntry> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? action,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $FuelEntriesTable fuelEntries = $FuelEntriesTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $GeocodingCacheTable geocodingCache = $GeocodingCacheTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    fuelEntries,
    trips,
    geocodingCache,
    syncQueue,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('fuel_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trips', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      required String id,
      required String name,
      required String type,
      required String fuelType,
      Value<double?> tankCapacity,
      Value<double> initialOdometer,
      required String createdAt,
      Value<DateTime?> lastUpdated,
      Value<int> rowid,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> fuelType,
      Value<double?> tankCapacity,
      Value<double> initialOdometer,
      Value<String> createdAt,
      Value<DateTime?> lastUpdated,
      Value<int> rowid,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, VehicleEntry> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FuelEntriesTable, List<FuelEntryData>>
  _fuelEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fuelEntries,
    aliasName: $_aliasNameGenerator(db.vehicles.id, db.fuelEntries.vehicleId),
  );

  $$FuelEntriesTableProcessedTableManager get fuelEntriesRefs {
    final manager = $$FuelEntriesTableTableManager(
      $_db,
      $_db.fuelEntries,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_fuelEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripsTable, List<TripData>> _tripsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trips,
    aliasName: $_aliasNameGenerator(db.vehicles.id, db.trips.vehicleId),
  );

  $$TripsTableProcessedTableManager get tripsRefs {
    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialOdometer => $composableBuilder(
    column: $table.initialOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fuelEntriesRefs(
    Expression<bool> Function($$FuelEntriesTableFilterComposer f) f,
  ) {
    final $$FuelEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fuelEntries,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuelEntriesTableFilterComposer(
            $db: $db,
            $table: $db.fuelEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripsRefs(
    Expression<bool> Function($$TripsTableFilterComposer f) f,
  ) {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialOdometer => $composableBuilder(
    column: $table.initialOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialOdometer => $composableBuilder(
    column: $table.initialOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  Expression<T> fuelEntriesRefs<T extends Object>(
    Expression<T> Function($$FuelEntriesTableAnnotationComposer a) f,
  ) {
    final $$FuelEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fuelEntries,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuelEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.fuelEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripsRefs<T extends Object>(
    Expression<T> Function($$TripsTableAnnotationComposer a) f,
  ) {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          VehicleEntry,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (VehicleEntry, $$VehiclesTableReferences),
          VehicleEntry,
          PrefetchHooks Function({bool fuelEntriesRefs, bool tripsRefs})
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<double?> tankCapacity = const Value.absent(),
                Value<double> initialOdometer = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                type: type,
                fuelType: fuelType,
                tankCapacity: tankCapacity,
                initialOdometer: initialOdometer,
                createdAt: createdAt,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required String fuelType,
                Value<double?> tankCapacity = const Value.absent(),
                Value<double> initialOdometer = const Value.absent(),
                required String createdAt,
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                type: type,
                fuelType: fuelType,
                tankCapacity: tankCapacity,
                initialOdometer: initialOdometer,
                createdAt: createdAt,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fuelEntriesRefs = false, tripsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fuelEntriesRefs) db.fuelEntries,
                    if (tripsRefs) db.trips,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fuelEntriesRefs)
                        await $_getPrefetchedData<
                          VehicleEntry,
                          $VehiclesTable,
                          FuelEntryData
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._fuelEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).fuelEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripsRefs)
                        await $_getPrefetchedData<
                          VehicleEntry,
                          $VehiclesTable,
                          TripData
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._tripsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).tripsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
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

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      VehicleEntry,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (VehicleEntry, $$VehiclesTableReferences),
      VehicleEntry,
      PrefetchHooks Function({bool fuelEntriesRefs, bool tripsRefs})
    >;
typedef $$FuelEntriesTableCreateCompanionBuilder =
    FuelEntriesCompanion Function({
      required String id,
      required String vehicleId,
      required String date,
      required double fuelCost,
      required double fuelLiters,
      required double odometer,
      Value<String?> station,
      Value<String?> notes,
      Value<DateTime?> lastUpdated,
      Value<int> rowid,
    });
typedef $$FuelEntriesTableUpdateCompanionBuilder =
    FuelEntriesCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> date,
      Value<double> fuelCost,
      Value<double> fuelLiters,
      Value<double> odometer,
      Value<String?> station,
      Value<String?> notes,
      Value<DateTime?> lastUpdated,
      Value<int> rowid,
    });

final class $$FuelEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $FuelEntriesTable, FuelEntryData> {
  $$FuelEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.fuelEntries.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FuelEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FuelEntriesTable> {
  $$FuelEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelCost => $composableBuilder(
    column: $table.fuelCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelLiters => $composableBuilder(
    column: $table.fuelLiters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelEntriesTable> {
  $$FuelEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelCost => $composableBuilder(
    column: $table.fuelCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelLiters => $composableBuilder(
    column: $table.fuelLiters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelEntriesTable> {
  $$FuelEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get fuelCost =>
      $composableBuilder(column: $table.fuelCost, builder: (column) => column);

  GeneratedColumn<double> get fuelLiters => $composableBuilder(
    column: $table.fuelLiters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<String> get station =>
      $composableBuilder(column: $table.station, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelEntriesTable,
          FuelEntryData,
          $$FuelEntriesTableFilterComposer,
          $$FuelEntriesTableOrderingComposer,
          $$FuelEntriesTableAnnotationComposer,
          $$FuelEntriesTableCreateCompanionBuilder,
          $$FuelEntriesTableUpdateCompanionBuilder,
          (FuelEntryData, $$FuelEntriesTableReferences),
          FuelEntryData,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$FuelEntriesTableTableManager(_$AppDatabase db, $FuelEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> fuelCost = const Value.absent(),
                Value<double> fuelLiters = const Value.absent(),
                Value<double> odometer = const Value.absent(),
                Value<String?> station = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FuelEntriesCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                fuelCost: fuelCost,
                fuelLiters: fuelLiters,
                odometer: odometer,
                station: station,
                notes: notes,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String date,
                required double fuelCost,
                required double fuelLiters,
                required double odometer,
                Value<String?> station = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FuelEntriesCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                fuelCost: fuelCost,
                fuelLiters: fuelLiters,
                odometer: odometer,
                station: station,
                notes: notes,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FuelEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
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
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$FuelEntriesTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$FuelEntriesTableReferences
                                    ._vehicleIdTable(db)
                                    .id,
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

typedef $$FuelEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelEntriesTable,
      FuelEntryData,
      $$FuelEntriesTableFilterComposer,
      $$FuelEntriesTableOrderingComposer,
      $$FuelEntriesTableAnnotationComposer,
      $$FuelEntriesTableCreateCompanionBuilder,
      $$FuelEntriesTableUpdateCompanionBuilder,
      (FuelEntryData, $$FuelEntriesTableReferences),
      FuelEntryData,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      required String id,
      required String vehicleId,
      required String startTime,
      Value<String?> endTime,
      Value<double> distance,
      Value<double?> avgSpeed,
      Value<double?> maxSpeed,
      Value<double?> minSpeed,
      Value<String?> startAddress,
      Value<String?> endAddress,
      Value<double> minLatitude,
      Value<double> maxLatitude,
      Value<double> minLongitude,
      Value<double> maxLongitude,
      Value<String?> routeSnapshotPath,
      Value<String?> routePointsJson,
      Value<DateTime?> lastUpdated,
      Value<int> rowid,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> startTime,
      Value<String?> endTime,
      Value<double> distance,
      Value<double?> avgSpeed,
      Value<double?> maxSpeed,
      Value<double?> minSpeed,
      Value<String?> startAddress,
      Value<String?> endAddress,
      Value<double> minLatitude,
      Value<double> maxLatitude,
      Value<double> minLongitude,
      Value<double> maxLongitude,
      Value<String?> routeSnapshotPath,
      Value<String?> routePointsJson,
      Value<DateTime?> lastUpdated,
      Value<int> rowid,
    });

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, TripData> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) => db.vehicles
      .createAlias($_aliasNameGenerator(db.trips.vehicleId, db.vehicles.id));

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSpeed => $composableBuilder(
    column: $table.avgSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minSpeed => $composableBuilder(
    column: $table.minSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startAddress => $composableBuilder(
    column: $table.startAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endAddress => $composableBuilder(
    column: $table.endAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minLatitude => $composableBuilder(
    column: $table.minLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxLatitude => $composableBuilder(
    column: $table.maxLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minLongitude => $composableBuilder(
    column: $table.minLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxLongitude => $composableBuilder(
    column: $table.maxLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeSnapshotPath => $composableBuilder(
    column: $table.routeSnapshotPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routePointsJson => $composableBuilder(
    column: $table.routePointsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSpeed => $composableBuilder(
    column: $table.avgSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minSpeed => $composableBuilder(
    column: $table.minSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startAddress => $composableBuilder(
    column: $table.startAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endAddress => $composableBuilder(
    column: $table.endAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minLatitude => $composableBuilder(
    column: $table.minLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxLatitude => $composableBuilder(
    column: $table.maxLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minLongitude => $composableBuilder(
    column: $table.minLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxLongitude => $composableBuilder(
    column: $table.maxLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeSnapshotPath => $composableBuilder(
    column: $table.routeSnapshotPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routePointsJson => $composableBuilder(
    column: $table.routePointsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<double> get avgSpeed =>
      $composableBuilder(column: $table.avgSpeed, builder: (column) => column);

  GeneratedColumn<double> get maxSpeed =>
      $composableBuilder(column: $table.maxSpeed, builder: (column) => column);

  GeneratedColumn<double> get minSpeed =>
      $composableBuilder(column: $table.minSpeed, builder: (column) => column);

  GeneratedColumn<String> get startAddress => $composableBuilder(
    column: $table.startAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endAddress => $composableBuilder(
    column: $table.endAddress,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minLatitude => $composableBuilder(
    column: $table.minLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxLatitude => $composableBuilder(
    column: $table.maxLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minLongitude => $composableBuilder(
    column: $table.minLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxLongitude => $composableBuilder(
    column: $table.maxLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get routeSnapshotPath => $composableBuilder(
    column: $table.routeSnapshotPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get routePointsJson => $composableBuilder(
    column: $table.routePointsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          TripData,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (TripData, $$TripsTableReferences),
          TripData,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<double> distance = const Value.absent(),
                Value<double?> avgSpeed = const Value.absent(),
                Value<double?> maxSpeed = const Value.absent(),
                Value<double?> minSpeed = const Value.absent(),
                Value<String?> startAddress = const Value.absent(),
                Value<String?> endAddress = const Value.absent(),
                Value<double> minLatitude = const Value.absent(),
                Value<double> maxLatitude = const Value.absent(),
                Value<double> minLongitude = const Value.absent(),
                Value<double> maxLongitude = const Value.absent(),
                Value<String?> routeSnapshotPath = const Value.absent(),
                Value<String?> routePointsJson = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                vehicleId: vehicleId,
                startTime: startTime,
                endTime: endTime,
                distance: distance,
                avgSpeed: avgSpeed,
                maxSpeed: maxSpeed,
                minSpeed: minSpeed,
                startAddress: startAddress,
                endAddress: endAddress,
                minLatitude: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude,
                routeSnapshotPath: routeSnapshotPath,
                routePointsJson: routePointsJson,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String startTime,
                Value<String?> endTime = const Value.absent(),
                Value<double> distance = const Value.absent(),
                Value<double?> avgSpeed = const Value.absent(),
                Value<double?> maxSpeed = const Value.absent(),
                Value<double?> minSpeed = const Value.absent(),
                Value<String?> startAddress = const Value.absent(),
                Value<String?> endAddress = const Value.absent(),
                Value<double> minLatitude = const Value.absent(),
                Value<double> maxLatitude = const Value.absent(),
                Value<double> minLongitude = const Value.absent(),
                Value<double> maxLongitude = const Value.absent(),
                Value<String?> routeSnapshotPath = const Value.absent(),
                Value<String?> routePointsJson = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                startTime: startTime,
                endTime: endTime,
                distance: distance,
                avgSpeed: avgSpeed,
                maxSpeed: maxSpeed,
                minSpeed: minSpeed,
                startAddress: startAddress,
                endAddress: endAddress,
                minLatitude: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude,
                routeSnapshotPath: routeSnapshotPath,
                routePointsJson: routePointsJson,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TripsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
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
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$TripsTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$TripsTableReferences
                                    ._vehicleIdTable(db)
                                    .id,
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

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      TripData,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (TripData, $$TripsTableReferences),
      TripData,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$GeocodingCacheTableCreateCompanionBuilder =
    GeocodingCacheCompanion Function({
      required String cacheKey,
      required String address,
      required String cachedAt,
      Value<int> rowid,
    });
typedef $$GeocodingCacheTableUpdateCompanionBuilder =
    GeocodingCacheCompanion Function({
      Value<String> cacheKey,
      Value<String> address,
      Value<String> cachedAt,
      Value<int> rowid,
    });

class $$GeocodingCacheTableFilterComposer
    extends Composer<_$AppDatabase, $GeocodingCacheTable> {
  $$GeocodingCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GeocodingCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $GeocodingCacheTable> {
  $$GeocodingCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeocodingCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeocodingCacheTable> {
  $$GeocodingCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$GeocodingCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeocodingCacheTable,
          GeocodingCacheEntry,
          $$GeocodingCacheTableFilterComposer,
          $$GeocodingCacheTableOrderingComposer,
          $$GeocodingCacheTableAnnotationComposer,
          $$GeocodingCacheTableCreateCompanionBuilder,
          $$GeocodingCacheTableUpdateCompanionBuilder,
          (
            GeocodingCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $GeocodingCacheTable,
              GeocodingCacheEntry
            >,
          ),
          GeocodingCacheEntry,
          PrefetchHooks Function()
        > {
  $$GeocodingCacheTableTableManager(
    _$AppDatabase db,
    $GeocodingCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeocodingCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeocodingCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeocodingCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GeocodingCacheCompanion(
                cacheKey: cacheKey,
                address: address,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required String address,
                required String cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => GeocodingCacheCompanion.insert(
                cacheKey: cacheKey,
                address: address,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GeocodingCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeocodingCacheTable,
      GeocodingCacheEntry,
      $$GeocodingCacheTableFilterComposer,
      $$GeocodingCacheTableOrderingComposer,
      $$GeocodingCacheTableAnnotationComposer,
      $$GeocodingCacheTableCreateCompanionBuilder,
      $$GeocodingCacheTableUpdateCompanionBuilder,
      (
        GeocodingCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $GeocodingCacheTable,
          GeocodingCacheEntry
        >,
      ),
      GeocodingCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String userId,
      required String action,
      required String entityType,
      required String entityId,
      Value<String?> payload,
      Value<DateTime> createdAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> action,
      Value<String> entityType,
      Value<String> entityId,
      Value<String?> payload,
      Value<DateTime> createdAt,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueEntry,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueEntry,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueEntry>,
          ),
          SyncQueueEntry,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String action,
                required String entityType,
                required String entityId,
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueEntry,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueEntry,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueEntry>,
      ),
      SyncQueueEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$FuelEntriesTableTableManager get fuelEntries =>
      $$FuelEntriesTableTableManager(_db, _db.fuelEntries);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$GeocodingCacheTableTableManager get geocodingCache =>
      $$GeocodingCacheTableTableManager(_db, _db.geocodingCache);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
