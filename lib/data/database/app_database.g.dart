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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    fuelType,
    tankCapacity,
    initialOdometer,
    createdAt,
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
  const VehicleEntry({
    required this.id,
    required this.name,
    required this.type,
    required this.fuelType,
    this.tankCapacity,
    required this.initialOdometer,
    required this.createdAt,
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
  }) => VehicleEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    fuelType: fuelType ?? this.fuelType,
    tankCapacity: tankCapacity.present ? tankCapacity.value : this.tankCapacity,
    initialOdometer: initialOdometer ?? this.initialOdometer,
    createdAt: createdAt ?? this.createdAt,
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
          ..write('createdAt: $createdAt')
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
          other.createdAt == this.createdAt);
}

class VehiclesCompanion extends UpdateCompanion<VehicleEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> fuelType;
  final Value<double?> tankCapacity;
  final Value<double> initialOdometer;
  final Value<String> createdAt;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.tankCapacity = const Value.absent(),
    this.initialOdometer = const Value.absent(),
    this.createdAt = const Value.absent(),
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
  const FuelEntryData({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.fuelCost,
    required this.fuelLiters,
    required this.odometer,
    this.station,
    this.notes,
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
  }) => FuelEntryData(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    fuelCost: fuelCost ?? this.fuelCost,
    fuelLiters: fuelLiters ?? this.fuelLiters,
    odometer: odometer ?? this.odometer,
    station: station.present ? station.value : this.station,
    notes: notes.present ? notes.value : this.notes,
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
          ..write('notes: $notes')
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
          other.notes == this.notes);
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
  const TripData({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    this.endTime,
    required this.distance,
    this.avgSpeed,
    this.maxSpeed,
    this.minSpeed,
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
  }) => TripData(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    distance: distance ?? this.distance,
    avgSpeed: avgSpeed.present ? avgSpeed.value : this.avgSpeed,
    maxSpeed: maxSpeed.present ? maxSpeed.value : this.maxSpeed,
    minSpeed: minSpeed.present ? minSpeed.value : this.minSpeed,
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
          ..write('minSpeed: $minSpeed')
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
          other.minSpeed == this.minSpeed);
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
          ..write('rowid: $rowid')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    fuelEntries,
    trips,
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
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                type: type,
                fuelType: fuelType,
                tankCapacity: tankCapacity,
                initialOdometer: initialOdometer,
                createdAt: createdAt,
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
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                type: type,
                fuelType: fuelType,
                tankCapacity: tankCapacity,
                initialOdometer: initialOdometer,
                createdAt: createdAt,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$FuelEntriesTableTableManager get fuelEntries =>
      $$FuelEntriesTableTableManager(_db, _db.fuelEntries);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
}
