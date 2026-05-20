// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MemoryEventsTable extends MemoryEvents
    with TableInfo<$MemoryEventsTable, MemoryEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _memoryTypeMeta = const VerificationMeta(
    'memoryType',
  );
  @override
  late final GeneratedColumn<String> memoryType = GeneratedColumn<String>(
    'memory_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('moment'),
  );
  static const VerificationMeta _feelingMeta = const VerificationMeta(
    'feeling',
  );
  @override
  late final GeneratedColumn<String> feeling = GeneratedColumn<String>(
    'feeling',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('warm'),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<int> occurredAt = GeneratedColumn<int>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverColorValueMeta = const VerificationMeta(
    'coverColorValue',
  );
  @override
  late final GeneratedColumn<int> coverColorValue = GeneratedColumn<int>(
    'cover_color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wallXMeta = const VerificationMeta('wallX');
  @override
  late final GeneratedColumn<double> wallX = GeneratedColumn<double>(
    'wall_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wallYMeta = const VerificationMeta('wallY');
  @override
  late final GeneratedColumn<double> wallY = GeneratedColumn<double>(
    'wall_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<double> rotation = GeneratedColumn<double>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationLabelMeta = const VerificationMeta(
    'locationLabel',
  );
  @override
  late final GeneratedColumn<String> locationLabel = GeneratedColumn<String>(
    'location_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPhotoPathMeta = const VerificationMeta(
    'coverPhotoPath',
  );
  @override
  late final GeneratedColumn<String> coverPhotoPath = GeneratedColumn<String>(
    'cover_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    memoryType,
    feeling,
    occurredAt,
    createdAt,
    coverColorValue,
    wallX,
    wallY,
    rotation,
    locationLabel,
    latitude,
    longitude,
    coverPhotoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('memory_type')) {
      context.handle(
        _memoryTypeMeta,
        memoryType.isAcceptableOrUnknown(data['memory_type']!, _memoryTypeMeta),
      );
    }
    if (data.containsKey('feeling')) {
      context.handle(
        _feelingMeta,
        feeling.isAcceptableOrUnknown(data['feeling']!, _feelingMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('cover_color_value')) {
      context.handle(
        _coverColorValueMeta,
        coverColorValue.isAcceptableOrUnknown(
          data['cover_color_value']!,
          _coverColorValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coverColorValueMeta);
    }
    if (data.containsKey('wall_x')) {
      context.handle(
        _wallXMeta,
        wallX.isAcceptableOrUnknown(data['wall_x']!, _wallXMeta),
      );
    } else if (isInserting) {
      context.missing(_wallXMeta);
    }
    if (data.containsKey('wall_y')) {
      context.handle(
        _wallYMeta,
        wallY.isAcceptableOrUnknown(data['wall_y']!, _wallYMeta),
      );
    } else if (isInserting) {
      context.missing(_wallYMeta);
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    } else if (isInserting) {
      context.missing(_rotationMeta);
    }
    if (data.containsKey('location_label')) {
      context.handle(
        _locationLabelMeta,
        locationLabel.isAcceptableOrUnknown(
          data['location_label']!,
          _locationLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_locationLabelMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('cover_photo_path')) {
      context.handle(
        _coverPhotoPathMeta,
        coverPhotoPath.isAcceptableOrUnknown(
          data['cover_photo_path']!,
          _coverPhotoPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      memoryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memory_type'],
      )!,
      feeling: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feeling'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      coverColorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_color_value'],
      )!,
      wallX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wall_x'],
      )!,
      wallY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wall_y'],
      )!,
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotation'],
      )!,
      locationLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_label'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      coverPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_photo_path'],
      ),
    );
  }

  @override
  $MemoryEventsTable createAlias(String alias) {
    return $MemoryEventsTable(attachedDatabase, alias);
  }
}

class MemoryEvent extends DataClass implements Insertable<MemoryEvent> {
  final String id;
  final String title;
  final String description;
  final String category;
  final String memoryType;
  final String feeling;
  final int occurredAt;
  final int createdAt;
  final int coverColorValue;
  final double wallX;
  final double wallY;
  final double rotation;
  final String locationLabel;
  final double? latitude;
  final double? longitude;
  final String? coverPhotoPath;
  const MemoryEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.memoryType,
    required this.feeling,
    required this.occurredAt,
    required this.createdAt,
    required this.coverColorValue,
    required this.wallX,
    required this.wallY,
    required this.rotation,
    required this.locationLabel,
    this.latitude,
    this.longitude,
    this.coverPhotoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['memory_type'] = Variable<String>(memoryType);
    map['feeling'] = Variable<String>(feeling);
    map['occurred_at'] = Variable<int>(occurredAt);
    map['created_at'] = Variable<int>(createdAt);
    map['cover_color_value'] = Variable<int>(coverColorValue);
    map['wall_x'] = Variable<double>(wallX);
    map['wall_y'] = Variable<double>(wallY);
    map['rotation'] = Variable<double>(rotation);
    map['location_label'] = Variable<String>(locationLabel);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || coverPhotoPath != null) {
      map['cover_photo_path'] = Variable<String>(coverPhotoPath);
    }
    return map;
  }

  MemoryEventsCompanion toCompanion(bool nullToAbsent) {
    return MemoryEventsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      memoryType: Value(memoryType),
      feeling: Value(feeling),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      coverColorValue: Value(coverColorValue),
      wallX: Value(wallX),
      wallY: Value(wallY),
      rotation: Value(rotation),
      locationLabel: Value(locationLabel),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      coverPhotoPath: coverPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPhotoPath),
    );
  }

  factory MemoryEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEvent(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      memoryType: serializer.fromJson<String>(json['memoryType']),
      feeling: serializer.fromJson<String>(json['feeling']),
      occurredAt: serializer.fromJson<int>(json['occurredAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      coverColorValue: serializer.fromJson<int>(json['coverColorValue']),
      wallX: serializer.fromJson<double>(json['wallX']),
      wallY: serializer.fromJson<double>(json['wallY']),
      rotation: serializer.fromJson<double>(json['rotation']),
      locationLabel: serializer.fromJson<String>(json['locationLabel']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      coverPhotoPath: serializer.fromJson<String?>(json['coverPhotoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'memoryType': serializer.toJson<String>(memoryType),
      'feeling': serializer.toJson<String>(feeling),
      'occurredAt': serializer.toJson<int>(occurredAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'coverColorValue': serializer.toJson<int>(coverColorValue),
      'wallX': serializer.toJson<double>(wallX),
      'wallY': serializer.toJson<double>(wallY),
      'rotation': serializer.toJson<double>(rotation),
      'locationLabel': serializer.toJson<String>(locationLabel),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'coverPhotoPath': serializer.toJson<String?>(coverPhotoPath),
    };
  }

  MemoryEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? memoryType,
    String? feeling,
    int? occurredAt,
    int? createdAt,
    int? coverColorValue,
    double? wallX,
    double? wallY,
    double? rotation,
    String? locationLabel,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> coverPhotoPath = const Value.absent(),
  }) => MemoryEvent(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    memoryType: memoryType ?? this.memoryType,
    feeling: feeling ?? this.feeling,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
    coverColorValue: coverColorValue ?? this.coverColorValue,
    wallX: wallX ?? this.wallX,
    wallY: wallY ?? this.wallY,
    rotation: rotation ?? this.rotation,
    locationLabel: locationLabel ?? this.locationLabel,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    coverPhotoPath: coverPhotoPath.present
        ? coverPhotoPath.value
        : this.coverPhotoPath,
  );
  MemoryEvent copyWithCompanion(MemoryEventsCompanion data) {
    return MemoryEvent(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      memoryType: data.memoryType.present
          ? data.memoryType.value
          : this.memoryType,
      feeling: data.feeling.present ? data.feeling.value : this.feeling,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      coverColorValue: data.coverColorValue.present
          ? data.coverColorValue.value
          : this.coverColorValue,
      wallX: data.wallX.present ? data.wallX.value : this.wallX,
      wallY: data.wallY.present ? data.wallY.value : this.wallY,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
      locationLabel: data.locationLabel.present
          ? data.locationLabel.value
          : this.locationLabel,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      coverPhotoPath: data.coverPhotoPath.present
          ? data.coverPhotoPath.value
          : this.coverPhotoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEvent(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('memoryType: $memoryType, ')
          ..write('feeling: $feeling, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('coverColorValue: $coverColorValue, ')
          ..write('wallX: $wallX, ')
          ..write('wallY: $wallY, ')
          ..write('rotation: $rotation, ')
          ..write('locationLabel: $locationLabel, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('coverPhotoPath: $coverPhotoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    memoryType,
    feeling,
    occurredAt,
    createdAt,
    coverColorValue,
    wallX,
    wallY,
    rotation,
    locationLabel,
    latitude,
    longitude,
    coverPhotoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryEvent &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.memoryType == this.memoryType &&
          other.feeling == this.feeling &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.coverColorValue == this.coverColorValue &&
          other.wallX == this.wallX &&
          other.wallY == this.wallY &&
          other.rotation == this.rotation &&
          other.locationLabel == this.locationLabel &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.coverPhotoPath == this.coverPhotoPath);
}

class MemoryEventsCompanion extends UpdateCompanion<MemoryEvent> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<String> memoryType;
  final Value<String> feeling;
  final Value<int> occurredAt;
  final Value<int> createdAt;
  final Value<int> coverColorValue;
  final Value<double> wallX;
  final Value<double> wallY;
  final Value<double> rotation;
  final Value<String> locationLabel;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> coverPhotoPath;
  final Value<int> rowid;
  const MemoryEventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.memoryType = const Value.absent(),
    this.feeling = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.coverColorValue = const Value.absent(),
    this.wallX = const Value.absent(),
    this.wallY = const Value.absent(),
    this.rotation = const Value.absent(),
    this.locationLabel = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.coverPhotoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryEventsCompanion.insert({
    required String id,
    required String title,
    required String description,
    this.category = const Value.absent(),
    this.memoryType = const Value.absent(),
    this.feeling = const Value.absent(),
    required int occurredAt,
    required int createdAt,
    required int coverColorValue,
    required double wallX,
    required double wallY,
    required double rotation,
    required String locationLabel,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.coverPhotoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       coverColorValue = Value(coverColorValue),
       wallX = Value(wallX),
       wallY = Value(wallY),
       rotation = Value(rotation),
       locationLabel = Value(locationLabel);
  static Insertable<MemoryEvent> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? memoryType,
    Expression<String>? feeling,
    Expression<int>? occurredAt,
    Expression<int>? createdAt,
    Expression<int>? coverColorValue,
    Expression<double>? wallX,
    Expression<double>? wallY,
    Expression<double>? rotation,
    Expression<String>? locationLabel,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? coverPhotoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (memoryType != null) 'memory_type': memoryType,
      if (feeling != null) 'feeling': feeling,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (coverColorValue != null) 'cover_color_value': coverColorValue,
      if (wallX != null) 'wall_x': wallX,
      if (wallY != null) 'wall_y': wallY,
      if (rotation != null) 'rotation': rotation,
      if (locationLabel != null) 'location_label': locationLabel,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (coverPhotoPath != null) 'cover_photo_path': coverPhotoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? category,
    Value<String>? memoryType,
    Value<String>? feeling,
    Value<int>? occurredAt,
    Value<int>? createdAt,
    Value<int>? coverColorValue,
    Value<double>? wallX,
    Value<double>? wallY,
    Value<double>? rotation,
    Value<String>? locationLabel,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? coverPhotoPath,
    Value<int>? rowid,
  }) {
    return MemoryEventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      memoryType: memoryType ?? this.memoryType,
      feeling: feeling ?? this.feeling,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      coverColorValue: coverColorValue ?? this.coverColorValue,
      wallX: wallX ?? this.wallX,
      wallY: wallY ?? this.wallY,
      rotation: rotation ?? this.rotation,
      locationLabel: locationLabel ?? this.locationLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (memoryType.present) {
      map['memory_type'] = Variable<String>(memoryType.value);
    }
    if (feeling.present) {
      map['feeling'] = Variable<String>(feeling.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<int>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (coverColorValue.present) {
      map['cover_color_value'] = Variable<int>(coverColorValue.value);
    }
    if (wallX.present) {
      map['wall_x'] = Variable<double>(wallX.value);
    }
    if (wallY.present) {
      map['wall_y'] = Variable<double>(wallY.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<double>(rotation.value);
    }
    if (locationLabel.present) {
      map['location_label'] = Variable<String>(locationLabel.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (coverPhotoPath.present) {
      map['cover_photo_path'] = Variable<String>(coverPhotoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('memoryType: $memoryType, ')
          ..write('feeling: $feeling, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('coverColorValue: $coverColorValue, ')
          ..write('wallX: $wallX, ')
          ..write('wallY: $wallY, ')
          ..write('rotation: $rotation, ')
          ..write('locationLabel: $locationLabel, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('coverPhotoPath: $coverPhotoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryPhotosTable extends MemoryPhotos
    with TableInfo<$MemoryPhotosTable, MemoryPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalAssetIdMeta = const VerificationMeta(
    'originalAssetId',
  );
  @override
  late final GeneratedColumn<String> originalAssetId = GeneratedColumn<String>(
    'original_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<int> capturedAt = GeneratedColumn<int>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    localPath,
    originalAssetId,
    capturedAt,
    latitude,
    longitude,
    width,
    height,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('original_asset_id')) {
      context.handle(
        _originalAssetIdMeta,
        originalAssetId.isAcceptableOrUnknown(
          data['original_asset_id']!,
          _originalAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      originalAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_asset_id'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}captured_at'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
    );
  }

  @override
  $MemoryPhotosTable createAlias(String alias) {
    return $MemoryPhotosTable(attachedDatabase, alias);
  }
}

class MemoryPhoto extends DataClass implements Insertable<MemoryPhoto> {
  final String id;
  final String eventId;
  final String localPath;
  final String? originalAssetId;
  final int capturedAt;
  final double? latitude;
  final double? longitude;
  final int width;
  final int height;
  const MemoryPhoto({
    required this.id,
    required this.eventId,
    required this.localPath,
    this.originalAssetId,
    required this.capturedAt,
    this.latitude,
    this.longitude,
    required this.width,
    required this.height,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || originalAssetId != null) {
      map['original_asset_id'] = Variable<String>(originalAssetId);
    }
    map['captured_at'] = Variable<int>(capturedAt);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    return map;
  }

  MemoryPhotosCompanion toCompanion(bool nullToAbsent) {
    return MemoryPhotosCompanion(
      id: Value(id),
      eventId: Value(eventId),
      localPath: Value(localPath),
      originalAssetId: originalAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(originalAssetId),
      capturedAt: Value(capturedAt),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      width: Value(width),
      height: Value(height),
    );
  }

  factory MemoryPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryPhoto(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      originalAssetId: serializer.fromJson<String?>(json['originalAssetId']),
      capturedAt: serializer.fromJson<int>(json['capturedAt']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'localPath': serializer.toJson<String>(localPath),
      'originalAssetId': serializer.toJson<String?>(originalAssetId),
      'capturedAt': serializer.toJson<int>(capturedAt),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
    };
  }

  MemoryPhoto copyWith({
    String? id,
    String? eventId,
    String? localPath,
    Value<String?> originalAssetId = const Value.absent(),
    int? capturedAt,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    int? width,
    int? height,
  }) => MemoryPhoto(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    localPath: localPath ?? this.localPath,
    originalAssetId: originalAssetId.present
        ? originalAssetId.value
        : this.originalAssetId,
    capturedAt: capturedAt ?? this.capturedAt,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    width: width ?? this.width,
    height: height ?? this.height,
  );
  MemoryPhoto copyWithCompanion(MemoryPhotosCompanion data) {
    return MemoryPhoto(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      originalAssetId: data.originalAssetId.present
          ? data.originalAssetId.value
          : this.originalAssetId,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryPhoto(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('localPath: $localPath, ')
          ..write('originalAssetId: $originalAssetId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('width: $width, ')
          ..write('height: $height')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    localPath,
    originalAssetId,
    capturedAt,
    latitude,
    longitude,
    width,
    height,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryPhoto &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.localPath == this.localPath &&
          other.originalAssetId == this.originalAssetId &&
          other.capturedAt == this.capturedAt &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.width == this.width &&
          other.height == this.height);
}

class MemoryPhotosCompanion extends UpdateCompanion<MemoryPhoto> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> localPath;
  final Value<String?> originalAssetId;
  final Value<int> capturedAt;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> width;
  final Value<int> height;
  final Value<int> rowid;
  const MemoryPhotosCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.originalAssetId = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryPhotosCompanion.insert({
    required String id,
    required String eventId,
    required String localPath,
    this.originalAssetId = const Value.absent(),
    required int capturedAt,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required int width,
    required int height,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       localPath = Value(localPath),
       capturedAt = Value(capturedAt),
       width = Value(width),
       height = Value(height);
  static Insertable<MemoryPhoto> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? localPath,
    Expression<String>? originalAssetId,
    Expression<int>? capturedAt,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (localPath != null) 'local_path': localPath,
      if (originalAssetId != null) 'original_asset_id': originalAssetId,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? localPath,
    Value<String?>? originalAssetId,
    Value<int>? capturedAt,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<int>? width,
    Value<int>? height,
    Value<int>? rowid,
  }) {
    return MemoryPhotosCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      localPath: localPath ?? this.localPath,
      originalAssetId: originalAssetId ?? this.originalAssetId,
      capturedAt: capturedAt ?? this.capturedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      width: width ?? this.width,
      height: height ?? this.height,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (originalAssetId.present) {
      map['original_asset_id'] = Variable<String>(originalAssetId.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<int>(capturedAt.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryPhotosCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('localPath: $localPath, ')
          ..write('originalAssetId: $originalAssetId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryConnectionsTable extends MemoryConnections
    with TableInfo<$MemoryConnectionsTable, MemoryConnection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromEventIdMeta = const VerificationMeta(
    'fromEventId',
  );
  @override
  late final GeneratedColumn<String> fromEventId = GeneratedColumn<String>(
    'from_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toEventIdMeta = const VerificationMeta(
    'toEventId',
  );
  @override
  late final GeneratedColumn<String> toEventId = GeneratedColumn<String>(
    'to_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, fromEventId, toEventId, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_connections';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryConnection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_event_id')) {
      context.handle(
        _fromEventIdMeta,
        fromEventId.isAcceptableOrUnknown(
          data['from_event_id']!,
          _fromEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromEventIdMeta);
    }
    if (data.containsKey('to_event_id')) {
      context.handle(
        _toEventIdMeta,
        toEventId.isAcceptableOrUnknown(data['to_event_id']!, _toEventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toEventIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryConnection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryConnection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fromEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_event_id'],
      )!,
      toEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_event_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $MemoryConnectionsTable createAlias(String alias) {
    return $MemoryConnectionsTable(attachedDatabase, alias);
  }
}

class MemoryConnection extends DataClass
    implements Insertable<MemoryConnection> {
  final String id;
  final String fromEventId;
  final String toEventId;
  final String label;
  const MemoryConnection({
    required this.id,
    required this.fromEventId,
    required this.toEventId,
    required this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_event_id'] = Variable<String>(fromEventId);
    map['to_event_id'] = Variable<String>(toEventId);
    map['label'] = Variable<String>(label);
    return map;
  }

  MemoryConnectionsCompanion toCompanion(bool nullToAbsent) {
    return MemoryConnectionsCompanion(
      id: Value(id),
      fromEventId: Value(fromEventId),
      toEventId: Value(toEventId),
      label: Value(label),
    );
  }

  factory MemoryConnection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryConnection(
      id: serializer.fromJson<String>(json['id']),
      fromEventId: serializer.fromJson<String>(json['fromEventId']),
      toEventId: serializer.fromJson<String>(json['toEventId']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromEventId': serializer.toJson<String>(fromEventId),
      'toEventId': serializer.toJson<String>(toEventId),
      'label': serializer.toJson<String>(label),
    };
  }

  MemoryConnection copyWith({
    String? id,
    String? fromEventId,
    String? toEventId,
    String? label,
  }) => MemoryConnection(
    id: id ?? this.id,
    fromEventId: fromEventId ?? this.fromEventId,
    toEventId: toEventId ?? this.toEventId,
    label: label ?? this.label,
  );
  MemoryConnection copyWithCompanion(MemoryConnectionsCompanion data) {
    return MemoryConnection(
      id: data.id.present ? data.id.value : this.id,
      fromEventId: data.fromEventId.present
          ? data.fromEventId.value
          : this.fromEventId,
      toEventId: data.toEventId.present ? data.toEventId.value : this.toEventId,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryConnection(')
          ..write('id: $id, ')
          ..write('fromEventId: $fromEventId, ')
          ..write('toEventId: $toEventId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fromEventId, toEventId, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryConnection &&
          other.id == this.id &&
          other.fromEventId == this.fromEventId &&
          other.toEventId == this.toEventId &&
          other.label == this.label);
}

class MemoryConnectionsCompanion extends UpdateCompanion<MemoryConnection> {
  final Value<String> id;
  final Value<String> fromEventId;
  final Value<String> toEventId;
  final Value<String> label;
  final Value<int> rowid;
  const MemoryConnectionsCompanion({
    this.id = const Value.absent(),
    this.fromEventId = const Value.absent(),
    this.toEventId = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryConnectionsCompanion.insert({
    required String id,
    required String fromEventId,
    required String toEventId,
    required String label,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromEventId = Value(fromEventId),
       toEventId = Value(toEventId),
       label = Value(label);
  static Insertable<MemoryConnection> custom({
    Expression<String>? id,
    Expression<String>? fromEventId,
    Expression<String>? toEventId,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromEventId != null) 'from_event_id': fromEventId,
      if (toEventId != null) 'to_event_id': toEventId,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryConnectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? fromEventId,
    Value<String>? toEventId,
    Value<String>? label,
    Value<int>? rowid,
  }) {
    return MemoryConnectionsCompanion(
      id: id ?? this.id,
      fromEventId: fromEventId ?? this.fromEventId,
      toEventId: toEventId ?? this.toEventId,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromEventId.present) {
      map['from_event_id'] = Variable<String>(fromEventId.value);
    }
    if (toEventId.present) {
      map['to_event_id'] = Variable<String>(toEventId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('fromEventId: $fromEventId, ')
          ..write('toEventId: $toEventId, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WallItemsTable extends WallItems
    with TableInfo<$WallItemsTable, WallItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WallItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wallXMeta = const VerificationMeta('wallX');
  @override
  late final GeneratedColumn<double> wallX = GeneratedColumn<double>(
    'wall_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wallYMeta = const VerificationMeta('wallY');
  @override
  late final GeneratedColumn<double> wallY = GeneratedColumn<double>(
    'wall_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    content,
    createdAt,
    wallX,
    wallY,
    colorValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wall_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WallItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('wall_x')) {
      context.handle(
        _wallXMeta,
        wallX.isAcceptableOrUnknown(data['wall_x']!, _wallXMeta),
      );
    } else if (isInserting) {
      context.missing(_wallXMeta);
    }
    if (data.containsKey('wall_y')) {
      context.handle(
        _wallYMeta,
        wallY.isAcceptableOrUnknown(data['wall_y']!, _wallYMeta),
      );
    } else if (isInserting) {
      context.missing(_wallYMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WallItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WallItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      wallX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wall_x'],
      )!,
      wallY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wall_y'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
    );
  }

  @override
  $WallItemsTable createAlias(String alias) {
    return $WallItemsTable(attachedDatabase, alias);
  }
}

class WallItem extends DataClass implements Insertable<WallItem> {
  final String id;
  final String type;
  final String content;
  final int createdAt;
  final double wallX;
  final double wallY;
  final int colorValue;
  const WallItem({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.wallX,
    required this.wallY,
    required this.colorValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<int>(createdAt);
    map['wall_x'] = Variable<double>(wallX);
    map['wall_y'] = Variable<double>(wallY);
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  WallItemsCompanion toCompanion(bool nullToAbsent) {
    return WallItemsCompanion(
      id: Value(id),
      type: Value(type),
      content: Value(content),
      createdAt: Value(createdAt),
      wallX: Value(wallX),
      wallY: Value(wallY),
      colorValue: Value(colorValue),
    );
  }

  factory WallItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WallItem(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      wallX: serializer.fromJson<double>(json['wallX']),
      wallY: serializer.fromJson<double>(json['wallY']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<int>(createdAt),
      'wallX': serializer.toJson<double>(wallX),
      'wallY': serializer.toJson<double>(wallY),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  WallItem copyWith({
    String? id,
    String? type,
    String? content,
    int? createdAt,
    double? wallX,
    double? wallY,
    int? colorValue,
  }) => WallItem(
    id: id ?? this.id,
    type: type ?? this.type,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    wallX: wallX ?? this.wallX,
    wallY: wallY ?? this.wallY,
    colorValue: colorValue ?? this.colorValue,
  );
  WallItem copyWithCompanion(WallItemsCompanion data) {
    return WallItem(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      wallX: data.wallX.present ? data.wallX.value : this.wallX,
      wallY: data.wallY.present ? data.wallY.value : this.wallY,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WallItem(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('wallX: $wallX, ')
          ..write('wallY: $wallY, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, content, createdAt, wallX, wallY, colorValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WallItem &&
          other.id == this.id &&
          other.type == this.type &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.wallX == this.wallX &&
          other.wallY == this.wallY &&
          other.colorValue == this.colorValue);
}

class WallItemsCompanion extends UpdateCompanion<WallItem> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> content;
  final Value<int> createdAt;
  final Value<double> wallX;
  final Value<double> wallY;
  final Value<int> colorValue;
  final Value<int> rowid;
  const WallItemsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.wallX = const Value.absent(),
    this.wallY = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WallItemsCompanion.insert({
    required String id,
    required String type,
    required String content,
    required int createdAt,
    required double wallX,
    required double wallY,
    required int colorValue,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       content = Value(content),
       createdAt = Value(createdAt),
       wallX = Value(wallX),
       wallY = Value(wallY),
       colorValue = Value(colorValue);
  static Insertable<WallItem> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? content,
    Expression<int>? createdAt,
    Expression<double>? wallX,
    Expression<double>? wallY,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (wallX != null) 'wall_x': wallX,
      if (wallY != null) 'wall_y': wallY,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WallItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? content,
    Value<int>? createdAt,
    Value<double>? wallX,
    Value<double>? wallY,
    Value<int>? colorValue,
    Value<int>? rowid,
  }) {
    return WallItemsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      wallX: wallX ?? this.wallX,
      wallY: wallY ?? this.wallY,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (wallX.present) {
      map['wall_x'] = Variable<double>(wallX.value);
    }
    if (wallY.present) {
      map['wall_y'] = Variable<double>(wallY.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WallItemsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('wallX: $wallX, ')
          ..write('wallY: $wallY, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MemoryEventsTable memoryEvents = $MemoryEventsTable(this);
  late final $MemoryPhotosTable memoryPhotos = $MemoryPhotosTable(this);
  late final $MemoryConnectionsTable memoryConnections =
      $MemoryConnectionsTable(this);
  late final $WallItemsTable wallItems = $WallItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    memoryEvents,
    memoryPhotos,
    memoryConnections,
    wallItems,
  ];
}

typedef $$MemoryEventsTableCreateCompanionBuilder =
    MemoryEventsCompanion Function({
      required String id,
      required String title,
      required String description,
      Value<String> category,
      Value<String> memoryType,
      Value<String> feeling,
      required int occurredAt,
      required int createdAt,
      required int coverColorValue,
      required double wallX,
      required double wallY,
      required double rotation,
      required String locationLabel,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> coverPhotoPath,
      Value<int> rowid,
    });
typedef $$MemoryEventsTableUpdateCompanionBuilder =
    MemoryEventsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> category,
      Value<String> memoryType,
      Value<String> feeling,
      Value<int> occurredAt,
      Value<int> createdAt,
      Value<int> coverColorValue,
      Value<double> wallX,
      Value<double> wallY,
      Value<double> rotation,
      Value<String> locationLabel,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> coverPhotoPath,
      Value<int> rowid,
    });

class $$MemoryEventsTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryEventsTable> {
  $$MemoryEventsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memoryType => $composableBuilder(
    column: $table.memoryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coverColorValue => $composableBuilder(
    column: $table.coverColorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wallX => $composableBuilder(
    column: $table.wallX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wallY => $composableBuilder(
    column: $table.wallY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPhotoPath => $composableBuilder(
    column: $table.coverPhotoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemoryEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryEventsTable> {
  $$MemoryEventsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memoryType => $composableBuilder(
    column: $table.memoryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverColorValue => $composableBuilder(
    column: $table.coverColorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wallX => $composableBuilder(
    column: $table.wallX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wallY => $composableBuilder(
    column: $table.wallY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPhotoPath => $composableBuilder(
    column: $table.coverPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoryEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryEventsTable> {
  $$MemoryEventsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get memoryType => $composableBuilder(
    column: $table.memoryType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get feeling =>
      $composableBuilder(column: $table.feeling, builder: (column) => column);

  GeneratedColumn<int> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get coverColorValue => $composableBuilder(
    column: $table.coverColorValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wallX =>
      $composableBuilder(column: $table.wallX, builder: (column) => column);

  GeneratedColumn<double> get wallY =>
      $composableBuilder(column: $table.wallY, builder: (column) => column);

  GeneratedColumn<double> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);

  GeneratedColumn<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get coverPhotoPath => $composableBuilder(
    column: $table.coverPhotoPath,
    builder: (column) => column,
  );
}

class $$MemoryEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryEventsTable,
          MemoryEvent,
          $$MemoryEventsTableFilterComposer,
          $$MemoryEventsTableOrderingComposer,
          $$MemoryEventsTableAnnotationComposer,
          $$MemoryEventsTableCreateCompanionBuilder,
          $$MemoryEventsTableUpdateCompanionBuilder,
          (
            MemoryEvent,
            BaseReferences<_$AppDatabase, $MemoryEventsTable, MemoryEvent>,
          ),
          MemoryEvent,
          PrefetchHooks Function()
        > {
  $$MemoryEventsTableTableManager(_$AppDatabase db, $MemoryEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> memoryType = const Value.absent(),
                Value<String> feeling = const Value.absent(),
                Value<int> occurredAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> coverColorValue = const Value.absent(),
                Value<double> wallX = const Value.absent(),
                Value<double> wallY = const Value.absent(),
                Value<double> rotation = const Value.absent(),
                Value<String> locationLabel = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> coverPhotoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryEventsCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                memoryType: memoryType,
                feeling: feeling,
                occurredAt: occurredAt,
                createdAt: createdAt,
                coverColorValue: coverColorValue,
                wallX: wallX,
                wallY: wallY,
                rotation: rotation,
                locationLabel: locationLabel,
                latitude: latitude,
                longitude: longitude,
                coverPhotoPath: coverPhotoPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                Value<String> category = const Value.absent(),
                Value<String> memoryType = const Value.absent(),
                Value<String> feeling = const Value.absent(),
                required int occurredAt,
                required int createdAt,
                required int coverColorValue,
                required double wallX,
                required double wallY,
                required double rotation,
                required String locationLabel,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> coverPhotoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryEventsCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                memoryType: memoryType,
                feeling: feeling,
                occurredAt: occurredAt,
                createdAt: createdAt,
                coverColorValue: coverColorValue,
                wallX: wallX,
                wallY: wallY,
                rotation: rotation,
                locationLabel: locationLabel,
                latitude: latitude,
                longitude: longitude,
                coverPhotoPath: coverPhotoPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoryEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryEventsTable,
      MemoryEvent,
      $$MemoryEventsTableFilterComposer,
      $$MemoryEventsTableOrderingComposer,
      $$MemoryEventsTableAnnotationComposer,
      $$MemoryEventsTableCreateCompanionBuilder,
      $$MemoryEventsTableUpdateCompanionBuilder,
      (
        MemoryEvent,
        BaseReferences<_$AppDatabase, $MemoryEventsTable, MemoryEvent>,
      ),
      MemoryEvent,
      PrefetchHooks Function()
    >;
typedef $$MemoryPhotosTableCreateCompanionBuilder =
    MemoryPhotosCompanion Function({
      required String id,
      required String eventId,
      required String localPath,
      Value<String?> originalAssetId,
      required int capturedAt,
      Value<double?> latitude,
      Value<double?> longitude,
      required int width,
      required int height,
      Value<int> rowid,
    });
typedef $$MemoryPhotosTableUpdateCompanionBuilder =
    MemoryPhotosCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> localPath,
      Value<String?> originalAssetId,
      Value<int> capturedAt,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<int> width,
      Value<int> height,
      Value<int> rowid,
    });

class $$MemoryPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryPhotosTable> {
  $$MemoryPhotosTableFilterComposer({
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

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalAssetId => $composableBuilder(
    column: $table.originalAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemoryPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryPhotosTable> {
  $$MemoryPhotosTableOrderingComposer({
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

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalAssetId => $composableBuilder(
    column: $table.originalAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoryPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryPhotosTable> {
  $$MemoryPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get originalAssetId => $composableBuilder(
    column: $table.originalAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);
}

class $$MemoryPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryPhotosTable,
          MemoryPhoto,
          $$MemoryPhotosTableFilterComposer,
          $$MemoryPhotosTableOrderingComposer,
          $$MemoryPhotosTableAnnotationComposer,
          $$MemoryPhotosTableCreateCompanionBuilder,
          $$MemoryPhotosTableUpdateCompanionBuilder,
          (
            MemoryPhoto,
            BaseReferences<_$AppDatabase, $MemoryPhotosTable, MemoryPhoto>,
          ),
          MemoryPhoto,
          PrefetchHooks Function()
        > {
  $$MemoryPhotosTableTableManager(_$AppDatabase db, $MemoryPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> originalAssetId = const Value.absent(),
                Value<int> capturedAt = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryPhotosCompanion(
                id: id,
                eventId: eventId,
                localPath: localPath,
                originalAssetId: originalAssetId,
                capturedAt: capturedAt,
                latitude: latitude,
                longitude: longitude,
                width: width,
                height: height,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String localPath,
                Value<String?> originalAssetId = const Value.absent(),
                required int capturedAt,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                required int width,
                required int height,
                Value<int> rowid = const Value.absent(),
              }) => MemoryPhotosCompanion.insert(
                id: id,
                eventId: eventId,
                localPath: localPath,
                originalAssetId: originalAssetId,
                capturedAt: capturedAt,
                latitude: latitude,
                longitude: longitude,
                width: width,
                height: height,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoryPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryPhotosTable,
      MemoryPhoto,
      $$MemoryPhotosTableFilterComposer,
      $$MemoryPhotosTableOrderingComposer,
      $$MemoryPhotosTableAnnotationComposer,
      $$MemoryPhotosTableCreateCompanionBuilder,
      $$MemoryPhotosTableUpdateCompanionBuilder,
      (
        MemoryPhoto,
        BaseReferences<_$AppDatabase, $MemoryPhotosTable, MemoryPhoto>,
      ),
      MemoryPhoto,
      PrefetchHooks Function()
    >;
typedef $$MemoryConnectionsTableCreateCompanionBuilder =
    MemoryConnectionsCompanion Function({
      required String id,
      required String fromEventId,
      required String toEventId,
      required String label,
      Value<int> rowid,
    });
typedef $$MemoryConnectionsTableUpdateCompanionBuilder =
    MemoryConnectionsCompanion Function({
      Value<String> id,
      Value<String> fromEventId,
      Value<String> toEventId,
      Value<String> label,
      Value<int> rowid,
    });

class $$MemoryConnectionsTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryConnectionsTable> {
  $$MemoryConnectionsTableFilterComposer({
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

  ColumnFilters<String> get fromEventId => $composableBuilder(
    column: $table.fromEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toEventId => $composableBuilder(
    column: $table.toEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemoryConnectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryConnectionsTable> {
  $$MemoryConnectionsTableOrderingComposer({
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

  ColumnOrderings<String> get fromEventId => $composableBuilder(
    column: $table.fromEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toEventId => $composableBuilder(
    column: $table.toEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoryConnectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryConnectionsTable> {
  $$MemoryConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromEventId => $composableBuilder(
    column: $table.fromEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toEventId =>
      $composableBuilder(column: $table.toEventId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$MemoryConnectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryConnectionsTable,
          MemoryConnection,
          $$MemoryConnectionsTableFilterComposer,
          $$MemoryConnectionsTableOrderingComposer,
          $$MemoryConnectionsTableAnnotationComposer,
          $$MemoryConnectionsTableCreateCompanionBuilder,
          $$MemoryConnectionsTableUpdateCompanionBuilder,
          (
            MemoryConnection,
            BaseReferences<
              _$AppDatabase,
              $MemoryConnectionsTable,
              MemoryConnection
            >,
          ),
          MemoryConnection,
          PrefetchHooks Function()
        > {
  $$MemoryConnectionsTableTableManager(
    _$AppDatabase db,
    $MemoryConnectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryConnectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryConnectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryConnectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromEventId = const Value.absent(),
                Value<String> toEventId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryConnectionsCompanion(
                id: id,
                fromEventId: fromEventId,
                toEventId: toEventId,
                label: label,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromEventId,
                required String toEventId,
                required String label,
                Value<int> rowid = const Value.absent(),
              }) => MemoryConnectionsCompanion.insert(
                id: id,
                fromEventId: fromEventId,
                toEventId: toEventId,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoryConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryConnectionsTable,
      MemoryConnection,
      $$MemoryConnectionsTableFilterComposer,
      $$MemoryConnectionsTableOrderingComposer,
      $$MemoryConnectionsTableAnnotationComposer,
      $$MemoryConnectionsTableCreateCompanionBuilder,
      $$MemoryConnectionsTableUpdateCompanionBuilder,
      (
        MemoryConnection,
        BaseReferences<
          _$AppDatabase,
          $MemoryConnectionsTable,
          MemoryConnection
        >,
      ),
      MemoryConnection,
      PrefetchHooks Function()
    >;
typedef $$WallItemsTableCreateCompanionBuilder =
    WallItemsCompanion Function({
      required String id,
      required String type,
      required String content,
      required int createdAt,
      required double wallX,
      required double wallY,
      required int colorValue,
      Value<int> rowid,
    });
typedef $$WallItemsTableUpdateCompanionBuilder =
    WallItemsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> content,
      Value<int> createdAt,
      Value<double> wallX,
      Value<double> wallY,
      Value<int> colorValue,
      Value<int> rowid,
    });

class $$WallItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WallItemsTable> {
  $$WallItemsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wallX => $composableBuilder(
    column: $table.wallX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wallY => $composableBuilder(
    column: $table.wallY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WallItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WallItemsTable> {
  $$WallItemsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wallX => $composableBuilder(
    column: $table.wallX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wallY => $composableBuilder(
    column: $table.wallY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WallItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WallItemsTable> {
  $$WallItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get wallX =>
      $composableBuilder(column: $table.wallX, builder: (column) => column);

  GeneratedColumn<double> get wallY =>
      $composableBuilder(column: $table.wallY, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );
}

class $$WallItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WallItemsTable,
          WallItem,
          $$WallItemsTableFilterComposer,
          $$WallItemsTableOrderingComposer,
          $$WallItemsTableAnnotationComposer,
          $$WallItemsTableCreateCompanionBuilder,
          $$WallItemsTableUpdateCompanionBuilder,
          (WallItem, BaseReferences<_$AppDatabase, $WallItemsTable, WallItem>),
          WallItem,
          PrefetchHooks Function()
        > {
  $$WallItemsTableTableManager(_$AppDatabase db, $WallItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WallItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WallItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WallItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<double> wallX = const Value.absent(),
                Value<double> wallY = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WallItemsCompanion(
                id: id,
                type: type,
                content: content,
                createdAt: createdAt,
                wallX: wallX,
                wallY: wallY,
                colorValue: colorValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String content,
                required int createdAt,
                required double wallX,
                required double wallY,
                required int colorValue,
                Value<int> rowid = const Value.absent(),
              }) => WallItemsCompanion.insert(
                id: id,
                type: type,
                content: content,
                createdAt: createdAt,
                wallX: wallX,
                wallY: wallY,
                colorValue: colorValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WallItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WallItemsTable,
      WallItem,
      $$WallItemsTableFilterComposer,
      $$WallItemsTableOrderingComposer,
      $$WallItemsTableAnnotationComposer,
      $$WallItemsTableCreateCompanionBuilder,
      $$WallItemsTableUpdateCompanionBuilder,
      (WallItem, BaseReferences<_$AppDatabase, $WallItemsTable, WallItem>),
      WallItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MemoryEventsTableTableManager get memoryEvents =>
      $$MemoryEventsTableTableManager(_db, _db.memoryEvents);
  $$MemoryPhotosTableTableManager get memoryPhotos =>
      $$MemoryPhotosTableTableManager(_db, _db.memoryPhotos);
  $$MemoryConnectionsTableTableManager get memoryConnections =>
      $$MemoryConnectionsTableTableManager(_db, _db.memoryConnections);
  $$WallItemsTableTableManager get wallItems =>
      $$WallItemsTableTableManager(_db, _db.wallItems);
}
