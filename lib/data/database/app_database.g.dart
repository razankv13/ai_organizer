// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    createdAt,
    updatedAt,
    isPinned,
    isArchived,
    isFavorite,
    folderId,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isArchived;
  final bool isFavorite;
  final String? folderId;
  final String? color;
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    required this.isArchived,
    required this.isFavorite,
    this.folderId,
    this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<String>(folderId);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isPinned: Value(isPinned),
      isArchived: Value(isArchived),
      isFavorite: Value(isFavorite),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      folderId: serializer.fromJson<String?>(json['folderId']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'folderId': serializer.toJson<String?>(folderId),
      'color': serializer.toJson<String?>(color),
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isArchived,
    bool? isFavorite,
    Value<String?> folderId = const Value.absent(),
    Value<String?> color = const Value.absent(),
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isPinned: isPinned ?? this.isPinned,
    isArchived: isArchived ?? this.isArchived,
    isFavorite: isFavorite ?? this.isFavorite,
    folderId: folderId.present ? folderId.value : this.folderId,
    color: color.present ? color.value : this.color,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('isArchived: $isArchived, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('folderId: $folderId, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    content,
    createdAt,
    updatedAt,
    isPinned,
    isArchived,
    isFavorite,
    folderId,
    color,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isPinned == this.isPinned &&
          other.isArchived == this.isArchived &&
          other.isFavorite == this.isFavorite &&
          other.folderId == this.folderId &&
          other.color == this.color);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isPinned;
  final Value<bool> isArchived;
  final Value<bool> isFavorite;
  final Value<String?> folderId;
  final Value<String?> color;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.folderId = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isPinned = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.folderId = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isPinned,
    Expression<bool>? isArchived,
    Expression<bool>? isFavorite,
    Expression<String>? folderId,
    Expression<String>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isArchived != null) 'is_archived': isArchived,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (folderId != null) 'folder_id': folderId,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isPinned,
    Value<bool>? isArchived,
    Value<bool>? isFavorite,
    Value<String?>? folderId,
    Value<String?>? color,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      folderId: folderId ?? this.folderId,
      color: color ?? this.color,
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
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
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
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isPinned: $isPinned, ')
          ..write('isArchived: $isArchived, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('folderId: $folderId, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#FF6B6B'),
  );
  static const VerificationMeta _useCountMeta = const VerificationMeta(
    'useCount',
  );
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
    'use_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    color,
    useCount,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('use_count')) {
      context.handle(
        _useCountMeta,
        useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      useCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_count'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final DateTime createdAt;
  final String color;
  final int useCount;
  final String? description;
  const Tag({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.color,
    required this.useCount,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['color'] = Variable<String>(color);
    map['use_count'] = Variable<int>(useCount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      color: Value(color),
      useCount: Value(useCount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      color: serializer.fromJson<String>(json['color']),
      useCount: serializer.fromJson<int>(json['useCount']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'color': serializer.toJson<String>(color),
      'useCount': serializer.toJson<int>(useCount),
      'description': serializer.toJson<String?>(description),
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? color,
    int? useCount,
    Value<String?> description = const Value.absent(),
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    color: color ?? this.color,
    useCount: useCount ?? this.useCount,
    description: description.present ? description.value : this.description,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      color: data.color.present ? data.color.value : this.color,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('color: $color, ')
          ..write('useCount: $useCount, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, createdAt, color, useCount, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.color == this.color &&
          other.useCount == this.useCount &&
          other.description == this.description);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<String> color;
  final Value<int> useCount;
  final Value<String?> description;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.color = const Value.absent(),
    this.useCount = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    this.color = const Value.absent(),
    this.useCount = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<String>? color,
    Expression<int>? useCount,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (color != null) 'color': color,
      if (useCount != null) 'use_count': useCount,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<String>? color,
    Value<int>? useCount,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      useCount: useCount ?? this.useCount,
      description: description ?? this.description,
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('color: $color, ')
          ..write('useCount: $useCount, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AttachmentType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AttachmentType>($AttachmentsTable.$convertertype);
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($AttachmentsTable.$convertermetadata);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteId,
    fileName,
    filePath,
    type,
    fileSize,
    createdAt,
    mimeType,
    thumbnailPath,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      ),
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      type: $AttachmentsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      metadata: $AttachmentsTable.$convertermetadata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metadata'],
        ),
      ),
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }

  static TypeConverter<AttachmentType, String> $convertertype =
      const AttachmentTypeConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $convertermetadata =
      const NullableMetadataConverter();
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> id;
  final Value<String?> noteId;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<AttachmentType> type;
  final Value<int> fileSize;
  final Value<DateTime> createdAt;
  final Value<String?> mimeType;
  final Value<String?> thumbnailPath;
  final Value<Map<String, dynamic>?> metadata;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.type = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    this.noteId = const Value.absent(),
    required String fileName,
    required String filePath,
    required AttachmentType type,
    required int fileSize,
    required DateTime createdAt,
    this.mimeType = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fileName = Value(fileName),
       filePath = Value(filePath),
       type = Value(type),
       fileSize = Value(fileSize),
       createdAt = Value(createdAt);
  static Insertable<Attachment> custom({
    Expression<String>? id,
    Expression<String>? noteId,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<String>? type,
    Expression<int>? fileSize,
    Expression<DateTime>? createdAt,
    Expression<String>? mimeType,
    Expression<String>? thumbnailPath,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (type != null) 'type': type,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
      if (mimeType != null) 'mime_type': mimeType,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String?>? noteId,
    Value<String>? fileName,
    Value<String>? filePath,
    Value<AttachmentType>? type,
    Value<int>? fileSize,
    Value<DateTime>? createdAt,
    Value<String?>? mimeType,
    Value<String?>? thumbnailPath,
    Value<Map<String, dynamic>?>? metadata,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      mimeType: mimeType ?? this.mimeType,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AttachmentsTable.$convertertype.toSql(type.value),
      );
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
        $AttachmentsTable.$convertermetadata.toSql(metadata.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('type: $type, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('mimeType: $mimeType, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    updatedAt,
    parentId,
    color,
    icon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Folder> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? parentId;
  final String? color;
  final String? icon;
  const Folder({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
    this.color,
    this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory Folder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'parentId': serializer.toJson<String?>(parentId),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  Folder copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> parentId = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
  }) => Folder(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    parentId: parentId.present ? parentId.value : this.parentId,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
  );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, createdAt, updatedAt, parentId, color, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.parentId == this.parentId &&
          other.color == this.color &&
          other.icon == this.icon);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> parentId;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.parentId = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.parentId = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Folder> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? parentId,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (parentId != null) 'parent_id': parentId,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? parentId,
    Value<String?>? color,
    Value<String?>? icon,
    Value<int>? rowid,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentId: parentId ?? this.parentId,
      color: color ?? this.color,
      icon: icon ?? this.icon,
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BacklinksTable extends Backlinks
    with TableInfo<$BacklinksTable, Backlink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BacklinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNoteIdMeta = const VerificationMeta(
    'sourceNoteId',
  );
  @override
  late final GeneratedColumn<String> sourceNoteId = GeneratedColumn<String>(
    'source_note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetNoteIdMeta = const VerificationMeta(
    'targetNoteId',
  );
  @override
  late final GeneratedColumn<String> targetNoteId = GeneratedColumn<String>(
    'target_note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetTextMeta = const VerificationMeta(
    'targetText',
  );
  @override
  late final GeneratedColumn<String> targetText = GeneratedColumn<String>(
    'target_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceNoteId,
    targetNoteId,
    targetText,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backlinks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Backlink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_note_id')) {
      context.handle(
        _sourceNoteIdMeta,
        sourceNoteId.isAcceptableOrUnknown(
          data['source_note_id']!,
          _sourceNoteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceNoteIdMeta);
    }
    if (data.containsKey('target_note_id')) {
      context.handle(
        _targetNoteIdMeta,
        targetNoteId.isAcceptableOrUnknown(
          data['target_note_id']!,
          _targetNoteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetNoteIdMeta);
    }
    if (data.containsKey('target_text')) {
      context.handle(
        _targetTextMeta,
        targetText.isAcceptableOrUnknown(data['target_text']!, _targetTextMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTextMeta);
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
  Backlink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Backlink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceNoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_note_id'],
      )!,
      targetNoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_note_id'],
      )!,
      targetText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BacklinksTable createAlias(String alias) {
    return $BacklinksTable(attachedDatabase, alias);
  }
}

class Backlink extends DataClass implements Insertable<Backlink> {
  final String id;
  final String sourceNoteId;
  final String targetNoteId;
  final String targetText;
  final DateTime createdAt;
  const Backlink({
    required this.id,
    required this.sourceNoteId,
    required this.targetNoteId,
    required this.targetText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_note_id'] = Variable<String>(sourceNoteId);
    map['target_note_id'] = Variable<String>(targetNoteId);
    map['target_text'] = Variable<String>(targetText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BacklinksCompanion toCompanion(bool nullToAbsent) {
    return BacklinksCompanion(
      id: Value(id),
      sourceNoteId: Value(sourceNoteId),
      targetNoteId: Value(targetNoteId),
      targetText: Value(targetText),
      createdAt: Value(createdAt),
    );
  }

  factory Backlink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Backlink(
      id: serializer.fromJson<String>(json['id']),
      sourceNoteId: serializer.fromJson<String>(json['sourceNoteId']),
      targetNoteId: serializer.fromJson<String>(json['targetNoteId']),
      targetText: serializer.fromJson<String>(json['targetText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceNoteId': serializer.toJson<String>(sourceNoteId),
      'targetNoteId': serializer.toJson<String>(targetNoteId),
      'targetText': serializer.toJson<String>(targetText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Backlink copyWith({
    String? id,
    String? sourceNoteId,
    String? targetNoteId,
    String? targetText,
    DateTime? createdAt,
  }) => Backlink(
    id: id ?? this.id,
    sourceNoteId: sourceNoteId ?? this.sourceNoteId,
    targetNoteId: targetNoteId ?? this.targetNoteId,
    targetText: targetText ?? this.targetText,
    createdAt: createdAt ?? this.createdAt,
  );
  Backlink copyWithCompanion(BacklinksCompanion data) {
    return Backlink(
      id: data.id.present ? data.id.value : this.id,
      sourceNoteId: data.sourceNoteId.present
          ? data.sourceNoteId.value
          : this.sourceNoteId,
      targetNoteId: data.targetNoteId.present
          ? data.targetNoteId.value
          : this.targetNoteId,
      targetText: data.targetText.present
          ? data.targetText.value
          : this.targetText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Backlink(')
          ..write('id: $id, ')
          ..write('sourceNoteId: $sourceNoteId, ')
          ..write('targetNoteId: $targetNoteId, ')
          ..write('targetText: $targetText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceNoteId, targetNoteId, targetText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Backlink &&
          other.id == this.id &&
          other.sourceNoteId == this.sourceNoteId &&
          other.targetNoteId == this.targetNoteId &&
          other.targetText == this.targetText &&
          other.createdAt == this.createdAt);
}

class BacklinksCompanion extends UpdateCompanion<Backlink> {
  final Value<String> id;
  final Value<String> sourceNoteId;
  final Value<String> targetNoteId;
  final Value<String> targetText;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BacklinksCompanion({
    this.id = const Value.absent(),
    this.sourceNoteId = const Value.absent(),
    this.targetNoteId = const Value.absent(),
    this.targetText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BacklinksCompanion.insert({
    required String id,
    required String sourceNoteId,
    required String targetNoteId,
    required String targetText,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceNoteId = Value(sourceNoteId),
       targetNoteId = Value(targetNoteId),
       targetText = Value(targetText),
       createdAt = Value(createdAt);
  static Insertable<Backlink> custom({
    Expression<String>? id,
    Expression<String>? sourceNoteId,
    Expression<String>? targetNoteId,
    Expression<String>? targetText,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceNoteId != null) 'source_note_id': sourceNoteId,
      if (targetNoteId != null) 'target_note_id': targetNoteId,
      if (targetText != null) 'target_text': targetText,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BacklinksCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceNoteId,
    Value<String>? targetNoteId,
    Value<String>? targetText,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BacklinksCompanion(
      id: id ?? this.id,
      sourceNoteId: sourceNoteId ?? this.sourceNoteId,
      targetNoteId: targetNoteId ?? this.targetNoteId,
      targetText: targetText ?? this.targetText,
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
    if (sourceNoteId.present) {
      map['source_note_id'] = Variable<String>(sourceNoteId.value);
    }
    if (targetNoteId.present) {
      map['target_note_id'] = Variable<String>(targetNoteId.value);
    }
    if (targetText.present) {
      map['target_text'] = Variable<String>(targetText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BacklinksCompanion(')
          ..write('id: $id, ')
          ..write('sourceNoteId: $sourceNoteId, ')
          ..write('targetNoteId: $targetNoteId, ')
          ..write('targetText: $targetText, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderDateMeta = const VerificationMeta(
    'reminderDate',
  );
  @override
  late final GeneratedColumn<DateTime> reminderDate = GeneratedColumn<DateTime>(
    'reminder_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasNotifiedMeta = const VerificationMeta(
    'hasNotified',
  );
  @override
  late final GeneratedColumn<bool> hasNotified = GeneratedColumn<bool>(
    'has_notified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_notified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteId,
    title,
    description,
    isCompleted,
    dueDate,
    reminderDate,
    createdAt,
    updatedAt,
    hasNotified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
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
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('reminder_date')) {
      context.handle(
        _reminderDateMeta,
        reminderDate.isAcceptableOrUnknown(
          data['reminder_date']!,
          _reminderDateMeta,
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('has_notified')) {
      context.handle(
        _hasNotifiedMeta,
        hasNotified.isAcceptableOrUnknown(
          data['has_notified']!,
          _hasNotifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      reminderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      hasNotified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_notified'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> noteId;
  final Value<String> title;
  final Value<String?> description;
  final Value<bool> isCompleted;
  final Value<DateTime?> dueDate;
  final Value<DateTime?> reminderDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> hasNotified;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.hasNotified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String noteId,
    required String title,
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.reminderDate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.hasNotified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       noteId = Value(noteId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? noteId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? reminderDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? hasNotified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (dueDate != null) 'due_date': dueDate,
      if (reminderDate != null) 'reminder_date': reminderDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (hasNotified != null) 'has_notified': hasNotified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? noteId,
    Value<String>? title,
    Value<String?>? description,
    Value<bool>? isCompleted,
    Value<DateTime?>? dueDate,
    Value<DateTime?>? reminderDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? hasNotified,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasNotified: hasNotified ?? this.hasNotified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (reminderDate.present) {
      map['reminder_date'] = Variable<DateTime>(reminderDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (hasNotified.present) {
      map['has_notified'] = Variable<bool>(hasNotified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('dueDate: $dueDate, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('hasNotified: $hasNotified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmailSettingsTableTable extends EmailSettingsTable
    with TableInfo<$EmailSettingsTableTable, EmailSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _uniqueEmailMeta = const VerificationMeta(
    'uniqueEmail',
  );
  @override
  late final GeneratedColumn<String> uniqueEmail = GeneratedColumn<String>(
    'unique_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _gmailConnectedMeta = const VerificationMeta(
    'gmailConnected',
  );
  @override
  late final GeneratedColumn<bool> gmailConnected = GeneratedColumn<bool>(
    'gmail_connected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gmail_connected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _gmailEmailMeta = const VerificationMeta(
    'gmailEmail',
  );
  @override
  late final GeneratedColumn<String> gmailEmail = GeneratedColumn<String>(
    'gmail_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gmailRefreshTokenMeta = const VerificationMeta(
    'gmailRefreshToken',
  );
  @override
  late final GeneratedColumn<String> gmailRefreshToken =
      GeneratedColumn<String>(
        'gmail_refresh_token',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastGmailSyncMeta = const VerificationMeta(
    'lastGmailSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastGmailSync =
      GeneratedColumn<DateTime>(
        'last_gmail_sync',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  preferences =
      GeneratedColumn<String>(
        'preferences',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, dynamic>?>(
        $EmailSettingsTableTable.$converterpreferences,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    uniqueEmail,
    createdAt,
    updatedAt,
    isEnabled,
    gmailConnected,
    gmailEmail,
    gmailRefreshToken,
    lastGmailSync,
    preferences,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('unique_email')) {
      context.handle(
        _uniqueEmailMeta,
        uniqueEmail.isAcceptableOrUnknown(
          data['unique_email']!,
          _uniqueEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_uniqueEmailMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('gmail_connected')) {
      context.handle(
        _gmailConnectedMeta,
        gmailConnected.isAcceptableOrUnknown(
          data['gmail_connected']!,
          _gmailConnectedMeta,
        ),
      );
    }
    if (data.containsKey('gmail_email')) {
      context.handle(
        _gmailEmailMeta,
        gmailEmail.isAcceptableOrUnknown(data['gmail_email']!, _gmailEmailMeta),
      );
    }
    if (data.containsKey('gmail_refresh_token')) {
      context.handle(
        _gmailRefreshTokenMeta,
        gmailRefreshToken.isAcceptableOrUnknown(
          data['gmail_refresh_token']!,
          _gmailRefreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('last_gmail_sync')) {
      context.handle(
        _lastGmailSyncMeta,
        lastGmailSync.isAcceptableOrUnknown(
          data['last_gmail_sync']!,
          _lastGmailSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      uniqueEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unique_email'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      gmailConnected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gmail_connected'],
      )!,
      gmailEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_email'],
      ),
      gmailRefreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_refresh_token'],
      ),
      lastGmailSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_gmail_sync'],
      ),
      preferences: $EmailSettingsTableTable.$converterpreferences.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}preferences'],
        ),
      ),
    );
  }

  @override
  $EmailSettingsTableTable createAlias(String alias) {
    return $EmailSettingsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>?, String?> $converterpreferences =
      const NullableMetadataConverter();
}

class EmailSettingsTableData extends DataClass
    implements Insertable<EmailSettingsTableData> {
  final String id;
  final String userId;
  final String uniqueEmail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEnabled;
  final bool gmailConnected;
  final String? gmailEmail;
  final String? gmailRefreshToken;
  final DateTime? lastGmailSync;
  final Map<String, dynamic>? preferences;
  const EmailSettingsTableData({
    required this.id,
    required this.userId,
    required this.uniqueEmail,
    required this.createdAt,
    required this.updatedAt,
    required this.isEnabled,
    required this.gmailConnected,
    this.gmailEmail,
    this.gmailRefreshToken,
    this.lastGmailSync,
    this.preferences,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['unique_email'] = Variable<String>(uniqueEmail);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['gmail_connected'] = Variable<bool>(gmailConnected);
    if (!nullToAbsent || gmailEmail != null) {
      map['gmail_email'] = Variable<String>(gmailEmail);
    }
    if (!nullToAbsent || gmailRefreshToken != null) {
      map['gmail_refresh_token'] = Variable<String>(gmailRefreshToken);
    }
    if (!nullToAbsent || lastGmailSync != null) {
      map['last_gmail_sync'] = Variable<DateTime>(lastGmailSync);
    }
    if (!nullToAbsent || preferences != null) {
      map['preferences'] = Variable<String>(
        $EmailSettingsTableTable.$converterpreferences.toSql(preferences),
      );
    }
    return map;
  }

  EmailSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return EmailSettingsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      uniqueEmail: Value(uniqueEmail),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isEnabled: Value(isEnabled),
      gmailConnected: Value(gmailConnected),
      gmailEmail: gmailEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(gmailEmail),
      gmailRefreshToken: gmailRefreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(gmailRefreshToken),
      lastGmailSync: lastGmailSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGmailSync),
      preferences: preferences == null && nullToAbsent
          ? const Value.absent()
          : Value(preferences),
    );
  }

  factory EmailSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      uniqueEmail: serializer.fromJson<String>(json['uniqueEmail']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      gmailConnected: serializer.fromJson<bool>(json['gmailConnected']),
      gmailEmail: serializer.fromJson<String?>(json['gmailEmail']),
      gmailRefreshToken: serializer.fromJson<String?>(
        json['gmailRefreshToken'],
      ),
      lastGmailSync: serializer.fromJson<DateTime?>(json['lastGmailSync']),
      preferences: serializer.fromJson<Map<String, dynamic>?>(
        json['preferences'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'uniqueEmail': serializer.toJson<String>(uniqueEmail),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'gmailConnected': serializer.toJson<bool>(gmailConnected),
      'gmailEmail': serializer.toJson<String?>(gmailEmail),
      'gmailRefreshToken': serializer.toJson<String?>(gmailRefreshToken),
      'lastGmailSync': serializer.toJson<DateTime?>(lastGmailSync),
      'preferences': serializer.toJson<Map<String, dynamic>?>(preferences),
    };
  }

  EmailSettingsTableData copyWith({
    String? id,
    String? userId,
    String? uniqueEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEnabled,
    bool? gmailConnected,
    Value<String?> gmailEmail = const Value.absent(),
    Value<String?> gmailRefreshToken = const Value.absent(),
    Value<DateTime?> lastGmailSync = const Value.absent(),
    Value<Map<String, dynamic>?> preferences = const Value.absent(),
  }) => EmailSettingsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    uniqueEmail: uniqueEmail ?? this.uniqueEmail,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isEnabled: isEnabled ?? this.isEnabled,
    gmailConnected: gmailConnected ?? this.gmailConnected,
    gmailEmail: gmailEmail.present ? gmailEmail.value : this.gmailEmail,
    gmailRefreshToken: gmailRefreshToken.present
        ? gmailRefreshToken.value
        : this.gmailRefreshToken,
    lastGmailSync: lastGmailSync.present
        ? lastGmailSync.value
        : this.lastGmailSync,
    preferences: preferences.present ? preferences.value : this.preferences,
  );
  EmailSettingsTableData copyWithCompanion(EmailSettingsTableCompanion data) {
    return EmailSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      uniqueEmail: data.uniqueEmail.present
          ? data.uniqueEmail.value
          : this.uniqueEmail,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      gmailConnected: data.gmailConnected.present
          ? data.gmailConnected.value
          : this.gmailConnected,
      gmailEmail: data.gmailEmail.present
          ? data.gmailEmail.value
          : this.gmailEmail,
      gmailRefreshToken: data.gmailRefreshToken.present
          ? data.gmailRefreshToken.value
          : this.gmailRefreshToken,
      lastGmailSync: data.lastGmailSync.present
          ? data.lastGmailSync.value
          : this.lastGmailSync,
      preferences: data.preferences.present
          ? data.preferences.value
          : this.preferences,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailSettingsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('uniqueEmail: $uniqueEmail, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('gmailConnected: $gmailConnected, ')
          ..write('gmailEmail: $gmailEmail, ')
          ..write('gmailRefreshToken: $gmailRefreshToken, ')
          ..write('lastGmailSync: $lastGmailSync, ')
          ..write('preferences: $preferences')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    uniqueEmail,
    createdAt,
    updatedAt,
    isEnabled,
    gmailConnected,
    gmailEmail,
    gmailRefreshToken,
    lastGmailSync,
    preferences,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailSettingsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.uniqueEmail == this.uniqueEmail &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isEnabled == this.isEnabled &&
          other.gmailConnected == this.gmailConnected &&
          other.gmailEmail == this.gmailEmail &&
          other.gmailRefreshToken == this.gmailRefreshToken &&
          other.lastGmailSync == this.lastGmailSync &&
          other.preferences == this.preferences);
}

class EmailSettingsTableCompanion
    extends UpdateCompanion<EmailSettingsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> uniqueEmail;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isEnabled;
  final Value<bool> gmailConnected;
  final Value<String?> gmailEmail;
  final Value<String?> gmailRefreshToken;
  final Value<DateTime?> lastGmailSync;
  final Value<Map<String, dynamic>?> preferences;
  final Value<int> rowid;
  const EmailSettingsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.uniqueEmail = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.gmailConnected = const Value.absent(),
    this.gmailEmail = const Value.absent(),
    this.gmailRefreshToken = const Value.absent(),
    this.lastGmailSync = const Value.absent(),
    this.preferences = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmailSettingsTableCompanion.insert({
    required String id,
    required String userId,
    required String uniqueEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isEnabled = const Value.absent(),
    this.gmailConnected = const Value.absent(),
    this.gmailEmail = const Value.absent(),
    this.gmailRefreshToken = const Value.absent(),
    this.lastGmailSync = const Value.absent(),
    this.preferences = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       uniqueEmail = Value(uniqueEmail),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EmailSettingsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? uniqueEmail,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isEnabled,
    Expression<bool>? gmailConnected,
    Expression<String>? gmailEmail,
    Expression<String>? gmailRefreshToken,
    Expression<DateTime>? lastGmailSync,
    Expression<String>? preferences,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (uniqueEmail != null) 'unique_email': uniqueEmail,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (gmailConnected != null) 'gmail_connected': gmailConnected,
      if (gmailEmail != null) 'gmail_email': gmailEmail,
      if (gmailRefreshToken != null) 'gmail_refresh_token': gmailRefreshToken,
      if (lastGmailSync != null) 'last_gmail_sync': lastGmailSync,
      if (preferences != null) 'preferences': preferences,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmailSettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? uniqueEmail,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isEnabled,
    Value<bool>? gmailConnected,
    Value<String?>? gmailEmail,
    Value<String?>? gmailRefreshToken,
    Value<DateTime?>? lastGmailSync,
    Value<Map<String, dynamic>?>? preferences,
    Value<int>? rowid,
  }) {
    return EmailSettingsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      uniqueEmail: uniqueEmail ?? this.uniqueEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEnabled: isEnabled ?? this.isEnabled,
      gmailConnected: gmailConnected ?? this.gmailConnected,
      gmailEmail: gmailEmail ?? this.gmailEmail,
      gmailRefreshToken: gmailRefreshToken ?? this.gmailRefreshToken,
      lastGmailSync: lastGmailSync ?? this.lastGmailSync,
      preferences: preferences ?? this.preferences,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (uniqueEmail.present) {
      map['unique_email'] = Variable<String>(uniqueEmail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (gmailConnected.present) {
      map['gmail_connected'] = Variable<bool>(gmailConnected.value);
    }
    if (gmailEmail.present) {
      map['gmail_email'] = Variable<String>(gmailEmail.value);
    }
    if (gmailRefreshToken.present) {
      map['gmail_refresh_token'] = Variable<String>(gmailRefreshToken.value);
    }
    if (lastGmailSync.present) {
      map['last_gmail_sync'] = Variable<DateTime>(lastGmailSync.value);
    }
    if (preferences.present) {
      map['preferences'] = Variable<String>(
        $EmailSettingsTableTable.$converterpreferences.toSql(preferences.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('uniqueEmail: $uniqueEmail, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('gmailConnected: $gmailConnected, ')
          ..write('gmailEmail: $gmailEmail, ')
          ..write('gmailRefreshToken: $gmailRefreshToken, ')
          ..write('lastGmailSync: $lastGmailSync, ')
          ..write('preferences: $preferences, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarSettingsTableTable extends CalendarSettingsTable
    with TableInfo<$CalendarSettingsTableTable, CalendarSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _isGoogleCalendarConnectedMeta =
      const VerificationMeta('isGoogleCalendarConnected');
  @override
  late final GeneratedColumn<bool> isGoogleCalendarConnected =
      GeneratedColumn<bool>(
        'is_google_calendar_connected',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_google_calendar_connected" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _googleAccountEmailMeta =
      const VerificationMeta('googleAccountEmail');
  @override
  late final GeneratedColumn<String> googleAccountEmail =
      GeneratedColumn<String>(
        'google_account_email',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _googleCalendarIdMeta = const VerificationMeta(
    'googleCalendarId',
  );
  @override
  late final GeneratedColumn<String> googleCalendarId = GeneratedColumn<String>(
    'google_calendar_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncTasksToCalendarMeta =
      const VerificationMeta('syncTasksToCalendar');
  @override
  late final GeneratedColumn<bool> syncTasksToCalendar = GeneratedColumn<bool>(
    'sync_tasks_to_calendar',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_tasks_to_calendar" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncEventsToNotesMeta = const VerificationMeta(
    'syncEventsToNotes',
  );
  @override
  late final GeneratedColumn<bool> syncEventsToNotes = GeneratedColumn<bool>(
    'sync_events_to_notes',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_events_to_notes" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncIntervalMinutesMeta =
      const VerificationMeta('syncIntervalMinutes');
  @override
  late final GeneratedColumn<int> syncIntervalMinutes = GeneratedColumn<int>(
    'sync_interval_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    isGoogleCalendarConnected,
    googleAccountEmail,
    googleCalendarId,
    syncTasksToCalendar,
    syncEventsToNotes,
    syncIntervalMinutes,
    lastSyncedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_google_calendar_connected')) {
      context.handle(
        _isGoogleCalendarConnectedMeta,
        isGoogleCalendarConnected.isAcceptableOrUnknown(
          data['is_google_calendar_connected']!,
          _isGoogleCalendarConnectedMeta,
        ),
      );
    }
    if (data.containsKey('google_account_email')) {
      context.handle(
        _googleAccountEmailMeta,
        googleAccountEmail.isAcceptableOrUnknown(
          data['google_account_email']!,
          _googleAccountEmailMeta,
        ),
      );
    }
    if (data.containsKey('google_calendar_id')) {
      context.handle(
        _googleCalendarIdMeta,
        googleCalendarId.isAcceptableOrUnknown(
          data['google_calendar_id']!,
          _googleCalendarIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_tasks_to_calendar')) {
      context.handle(
        _syncTasksToCalendarMeta,
        syncTasksToCalendar.isAcceptableOrUnknown(
          data['sync_tasks_to_calendar']!,
          _syncTasksToCalendarMeta,
        ),
      );
    }
    if (data.containsKey('sync_events_to_notes')) {
      context.handle(
        _syncEventsToNotesMeta,
        syncEventsToNotes.isAcceptableOrUnknown(
          data['sync_events_to_notes']!,
          _syncEventsToNotesMeta,
        ),
      );
    }
    if (data.containsKey('sync_interval_minutes')) {
      context.handle(
        _syncIntervalMinutesMeta,
        syncIntervalMinutes.isAcceptableOrUnknown(
          data['sync_interval_minutes']!,
          _syncIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarSettingsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      isGoogleCalendarConnected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_google_calendar_connected'],
      )!,
      googleAccountEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_account_email'],
      ),
      googleCalendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_calendar_id'],
      ),
      syncTasksToCalendar: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_tasks_to_calendar'],
      )!,
      syncEventsToNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_events_to_notes'],
      )!,
      syncIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_interval_minutes'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CalendarSettingsTableTable createAlias(String alias) {
    return $CalendarSettingsTableTable(attachedDatabase, alias);
  }
}

class CalendarSettingsTableData extends DataClass
    implements Insertable<CalendarSettingsTableData> {
  final String id;
  final String userId;
  final bool isGoogleCalendarConnected;
  final String? googleAccountEmail;
  final String? googleCalendarId;
  final bool syncTasksToCalendar;
  final bool syncEventsToNotes;
  final int syncIntervalMinutes;
  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CalendarSettingsTableData({
    required this.id,
    required this.userId,
    required this.isGoogleCalendarConnected,
    this.googleAccountEmail,
    this.googleCalendarId,
    required this.syncTasksToCalendar,
    required this.syncEventsToNotes,
    required this.syncIntervalMinutes,
    this.lastSyncedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['is_google_calendar_connected'] = Variable<bool>(
      isGoogleCalendarConnected,
    );
    if (!nullToAbsent || googleAccountEmail != null) {
      map['google_account_email'] = Variable<String>(googleAccountEmail);
    }
    if (!nullToAbsent || googleCalendarId != null) {
      map['google_calendar_id'] = Variable<String>(googleCalendarId);
    }
    map['sync_tasks_to_calendar'] = Variable<bool>(syncTasksToCalendar);
    map['sync_events_to_notes'] = Variable<bool>(syncEventsToNotes);
    map['sync_interval_minutes'] = Variable<int>(syncIntervalMinutes);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CalendarSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return CalendarSettingsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      isGoogleCalendarConnected: Value(isGoogleCalendarConnected),
      googleAccountEmail: googleAccountEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(googleAccountEmail),
      googleCalendarId: googleCalendarId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleCalendarId),
      syncTasksToCalendar: Value(syncTasksToCalendar),
      syncEventsToNotes: Value(syncEventsToNotes),
      syncIntervalMinutes: Value(syncIntervalMinutes),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalendarSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      isGoogleCalendarConnected: serializer.fromJson<bool>(
        json['isGoogleCalendarConnected'],
      ),
      googleAccountEmail: serializer.fromJson<String?>(
        json['googleAccountEmail'],
      ),
      googleCalendarId: serializer.fromJson<String?>(json['googleCalendarId']),
      syncTasksToCalendar: serializer.fromJson<bool>(
        json['syncTasksToCalendar'],
      ),
      syncEventsToNotes: serializer.fromJson<bool>(json['syncEventsToNotes']),
      syncIntervalMinutes: serializer.fromJson<int>(
        json['syncIntervalMinutes'],
      ),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'isGoogleCalendarConnected': serializer.toJson<bool>(
        isGoogleCalendarConnected,
      ),
      'googleAccountEmail': serializer.toJson<String?>(googleAccountEmail),
      'googleCalendarId': serializer.toJson<String?>(googleCalendarId),
      'syncTasksToCalendar': serializer.toJson<bool>(syncTasksToCalendar),
      'syncEventsToNotes': serializer.toJson<bool>(syncEventsToNotes),
      'syncIntervalMinutes': serializer.toJson<int>(syncIntervalMinutes),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalendarSettingsTableData copyWith({
    String? id,
    String? userId,
    bool? isGoogleCalendarConnected,
    Value<String?> googleAccountEmail = const Value.absent(),
    Value<String?> googleCalendarId = const Value.absent(),
    bool? syncTasksToCalendar,
    bool? syncEventsToNotes,
    int? syncIntervalMinutes,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CalendarSettingsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    isGoogleCalendarConnected:
        isGoogleCalendarConnected ?? this.isGoogleCalendarConnected,
    googleAccountEmail: googleAccountEmail.present
        ? googleAccountEmail.value
        : this.googleAccountEmail,
    googleCalendarId: googleCalendarId.present
        ? googleCalendarId.value
        : this.googleCalendarId,
    syncTasksToCalendar: syncTasksToCalendar ?? this.syncTasksToCalendar,
    syncEventsToNotes: syncEventsToNotes ?? this.syncEventsToNotes,
    syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalendarSettingsTableData copyWithCompanion(
    CalendarSettingsTableCompanion data,
  ) {
    return CalendarSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      isGoogleCalendarConnected: data.isGoogleCalendarConnected.present
          ? data.isGoogleCalendarConnected.value
          : this.isGoogleCalendarConnected,
      googleAccountEmail: data.googleAccountEmail.present
          ? data.googleAccountEmail.value
          : this.googleAccountEmail,
      googleCalendarId: data.googleCalendarId.present
          ? data.googleCalendarId.value
          : this.googleCalendarId,
      syncTasksToCalendar: data.syncTasksToCalendar.present
          ? data.syncTasksToCalendar.value
          : this.syncTasksToCalendar,
      syncEventsToNotes: data.syncEventsToNotes.present
          ? data.syncEventsToNotes.value
          : this.syncEventsToNotes,
      syncIntervalMinutes: data.syncIntervalMinutes.present
          ? data.syncIntervalMinutes.value
          : this.syncIntervalMinutes,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarSettingsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('isGoogleCalendarConnected: $isGoogleCalendarConnected, ')
          ..write('googleAccountEmail: $googleAccountEmail, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('syncTasksToCalendar: $syncTasksToCalendar, ')
          ..write('syncEventsToNotes: $syncEventsToNotes, ')
          ..write('syncIntervalMinutes: $syncIntervalMinutes, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    isGoogleCalendarConnected,
    googleAccountEmail,
    googleCalendarId,
    syncTasksToCalendar,
    syncEventsToNotes,
    syncIntervalMinutes,
    lastSyncedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarSettingsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.isGoogleCalendarConnected == this.isGoogleCalendarConnected &&
          other.googleAccountEmail == this.googleAccountEmail &&
          other.googleCalendarId == this.googleCalendarId &&
          other.syncTasksToCalendar == this.syncTasksToCalendar &&
          other.syncEventsToNotes == this.syncEventsToNotes &&
          other.syncIntervalMinutes == this.syncIntervalMinutes &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CalendarSettingsTableCompanion
    extends UpdateCompanion<CalendarSettingsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<bool> isGoogleCalendarConnected;
  final Value<String?> googleAccountEmail;
  final Value<String?> googleCalendarId;
  final Value<bool> syncTasksToCalendar;
  final Value<bool> syncEventsToNotes;
  final Value<int> syncIntervalMinutes;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CalendarSettingsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.isGoogleCalendarConnected = const Value.absent(),
    this.googleAccountEmail = const Value.absent(),
    this.googleCalendarId = const Value.absent(),
    this.syncTasksToCalendar = const Value.absent(),
    this.syncEventsToNotes = const Value.absent(),
    this.syncIntervalMinutes = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarSettingsTableCompanion.insert({
    required String id,
    required String userId,
    this.isGoogleCalendarConnected = const Value.absent(),
    this.googleAccountEmail = const Value.absent(),
    this.googleCalendarId = const Value.absent(),
    this.syncTasksToCalendar = const Value.absent(),
    this.syncEventsToNotes = const Value.absent(),
    this.syncIntervalMinutes = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CalendarSettingsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<bool>? isGoogleCalendarConnected,
    Expression<String>? googleAccountEmail,
    Expression<String>? googleCalendarId,
    Expression<bool>? syncTasksToCalendar,
    Expression<bool>? syncEventsToNotes,
    Expression<int>? syncIntervalMinutes,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (isGoogleCalendarConnected != null)
        'is_google_calendar_connected': isGoogleCalendarConnected,
      if (googleAccountEmail != null)
        'google_account_email': googleAccountEmail,
      if (googleCalendarId != null) 'google_calendar_id': googleCalendarId,
      if (syncTasksToCalendar != null)
        'sync_tasks_to_calendar': syncTasksToCalendar,
      if (syncEventsToNotes != null) 'sync_events_to_notes': syncEventsToNotes,
      if (syncIntervalMinutes != null)
        'sync_interval_minutes': syncIntervalMinutes,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarSettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<bool>? isGoogleCalendarConnected,
    Value<String?>? googleAccountEmail,
    Value<String?>? googleCalendarId,
    Value<bool>? syncTasksToCalendar,
    Value<bool>? syncEventsToNotes,
    Value<int>? syncIntervalMinutes,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CalendarSettingsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      isGoogleCalendarConnected:
          isGoogleCalendarConnected ?? this.isGoogleCalendarConnected,
      googleAccountEmail: googleAccountEmail ?? this.googleAccountEmail,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      syncTasksToCalendar: syncTasksToCalendar ?? this.syncTasksToCalendar,
      syncEventsToNotes: syncEventsToNotes ?? this.syncEventsToNotes,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isGoogleCalendarConnected.present) {
      map['is_google_calendar_connected'] = Variable<bool>(
        isGoogleCalendarConnected.value,
      );
    }
    if (googleAccountEmail.present) {
      map['google_account_email'] = Variable<String>(googleAccountEmail.value);
    }
    if (googleCalendarId.present) {
      map['google_calendar_id'] = Variable<String>(googleCalendarId.value);
    }
    if (syncTasksToCalendar.present) {
      map['sync_tasks_to_calendar'] = Variable<bool>(syncTasksToCalendar.value);
    }
    if (syncEventsToNotes.present) {
      map['sync_events_to_notes'] = Variable<bool>(syncEventsToNotes.value);
    }
    if (syncIntervalMinutes.present) {
      map['sync_interval_minutes'] = Variable<int>(syncIntervalMinutes.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('isGoogleCalendarConnected: $isGoogleCalendarConnected, ')
          ..write('googleAccountEmail: $googleAccountEmail, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('syncTasksToCalendar: $syncTasksToCalendar, ')
          ..write('syncEventsToNotes: $syncEventsToNotes, ')
          ..write('syncIntervalMinutes: $syncIntervalMinutes, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CloudStorageConnectionsTable extends CloudStorageConnections
    with TableInfo<$CloudStorageConnectionsTable, CloudStorageConnection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CloudStorageConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  late final GeneratedColumnWithTypeConverter<CloudStorageProvider, String>
  provider =
      GeneratedColumn<String>(
        'provider',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CloudStorageProvider>(
        $CloudStorageConnectionsTable.$converterprovider,
      );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tokenExpiryMeta = const VerificationMeta(
    'tokenExpiry',
  );
  @override
  late final GeneratedColumn<DateTime> tokenExpiry = GeneratedColumn<DateTime>(
    'token_expiry',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userEmailMeta = const VerificationMeta(
    'userEmail',
  );
  @override
  late final GeneratedColumn<String> userEmail = GeneratedColumn<String>(
    'user_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    provider,
    accessToken,
    refreshToken,
    tokenExpiry,
    userEmail,
    userName,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cloud_storage_connections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CloudStorageConnection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('token_expiry')) {
      context.handle(
        _tokenExpiryMeta,
        tokenExpiry.isAcceptableOrUnknown(
          data['token_expiry']!,
          _tokenExpiryMeta,
        ),
      );
    }
    if (data.containsKey('user_email')) {
      context.handle(
        _userEmailMeta,
        userEmail.isAcceptableOrUnknown(data['user_email']!, _userEmailMeta),
      );
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CloudStorageConnection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CloudStorageConnection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      provider: $CloudStorageConnectionsTable.$converterprovider.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}provider'],
        )!,
      ),
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      )!,
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      ),
      tokenExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}token_expiry'],
      ),
      userEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_email'],
      ),
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CloudStorageConnectionsTable createAlias(String alias) {
    return $CloudStorageConnectionsTable(attachedDatabase, alias);
  }

  static TypeConverter<CloudStorageProvider, String> $converterprovider =
      const CloudStorageProviderConverter();
}

class CloudStorageConnectionsCompanion
    extends UpdateCompanion<CloudStorageConnection> {
  final Value<String> id;
  final Value<String> userId;
  final Value<CloudStorageProvider> provider;
  final Value<String> accessToken;
  final Value<String?> refreshToken;
  final Value<DateTime?> tokenExpiry;
  final Value<String?> userEmail;
  final Value<String?> userName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CloudStorageConnectionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.provider = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenExpiry = const Value.absent(),
    this.userEmail = const Value.absent(),
    this.userName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CloudStorageConnectionsCompanion.insert({
    required String id,
    required String userId,
    required CloudStorageProvider provider,
    required String accessToken,
    this.refreshToken = const Value.absent(),
    this.tokenExpiry = const Value.absent(),
    this.userEmail = const Value.absent(),
    this.userName = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       provider = Value(provider),
       accessToken = Value(accessToken),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CloudStorageConnection> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? provider,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<DateTime>? tokenExpiry,
    Expression<String>? userEmail,
    Expression<String>? userName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (provider != null) 'provider': provider,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (tokenExpiry != null) 'token_expiry': tokenExpiry,
      if (userEmail != null) 'user_email': userEmail,
      if (userName != null) 'user_name': userName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CloudStorageConnectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<CloudStorageProvider>? provider,
    Value<String>? accessToken,
    Value<String?>? refreshToken,
    Value<DateTime?>? tokenExpiry,
    Value<String?>? userEmail,
    Value<String?>? userName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CloudStorageConnectionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(
        $CloudStorageConnectionsTable.$converterprovider.toSql(provider.value),
      );
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (tokenExpiry.present) {
      map['token_expiry'] = Variable<DateTime>(tokenExpiry.value);
    }
    if (userEmail.present) {
      map['user_email'] = Variable<String>(userEmail.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CloudStorageConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('provider: $provider, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenExpiry: $tokenExpiry, ')
          ..write('userEmail: $userEmail, ')
          ..write('userName: $userName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SharedNotesTable extends SharedNotes
    with TableInfo<$SharedNotesTable, model.SharedNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharedWithEmailMeta = const VerificationMeta(
    'sharedWithEmail',
  );
  @override
  late final GeneratedColumn<String> sharedWithEmail = GeneratedColumn<String>(
    'shared_with_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharedWithUserIdMeta = const VerificationMeta(
    'sharedWithUserId',
  );
  @override
  late final GeneratedColumn<String> sharedWithUserId = GeneratedColumn<String>(
    'shared_with_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SharePermission, String>
  permission = GeneratedColumn<String>(
    'permission',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SharePermission>($SharedNotesTable.$converterpermission);
  static const VerificationMeta _shareTokenMeta = const VerificationMeta(
    'shareToken',
  );
  @override
  late final GeneratedColumn<String> shareToken = GeneratedColumn<String>(
    'share_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteId,
    ownerId,
    sharedWithEmail,
    sharedWithUserId,
    permission,
    shareToken,
    createdAt,
    updatedAt,
    expiresAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<model.SharedNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('shared_with_email')) {
      context.handle(
        _sharedWithEmailMeta,
        sharedWithEmail.isAcceptableOrUnknown(
          data['shared_with_email']!,
          _sharedWithEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sharedWithEmailMeta);
    }
    if (data.containsKey('shared_with_user_id')) {
      context.handle(
        _sharedWithUserIdMeta,
        sharedWithUserId.isAcceptableOrUnknown(
          data['shared_with_user_id']!,
          _sharedWithUserIdMeta,
        ),
      );
    }
    if (data.containsKey('share_token')) {
      context.handle(
        _shareTokenMeta,
        shareToken.isAcceptableOrUnknown(data['share_token']!, _shareTokenMeta),
      );
    } else if (isInserting) {
      context.missing(_shareTokenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  model.SharedNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return model.SharedNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      sharedWithEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_with_email'],
      )!,
      sharedWithUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_with_user_id'],
      ),
      permission: $SharedNotesTable.$converterpermission.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}permission'],
        )!,
      ),
      shareToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_token'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SharedNotesTable createAlias(String alias) {
    return $SharedNotesTable(attachedDatabase, alias);
  }

  static TypeConverter<SharePermission, String> $converterpermission =
      const SharePermissionConverter();
}

class SharedNotesCompanion extends UpdateCompanion<model.SharedNote> {
  final Value<String> id;
  final Value<String> noteId;
  final Value<String> ownerId;
  final Value<String> sharedWithEmail;
  final Value<String?> sharedWithUserId;
  final Value<SharePermission> permission;
  final Value<String> shareToken;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> expiresAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SharedNotesCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWithEmail = const Value.absent(),
    this.sharedWithUserId = const Value.absent(),
    this.permission = const Value.absent(),
    this.shareToken = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SharedNotesCompanion.insert({
    required String id,
    required String noteId,
    required String ownerId,
    required String sharedWithEmail,
    this.sharedWithUserId = const Value.absent(),
    required SharePermission permission,
    required String shareToken,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.expiresAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       noteId = Value(noteId),
       ownerId = Value(ownerId),
       sharedWithEmail = Value(sharedWithEmail),
       permission = Value(permission),
       shareToken = Value(shareToken),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<model.SharedNote> custom({
    Expression<String>? id,
    Expression<String>? noteId,
    Expression<String>? ownerId,
    Expression<String>? sharedWithEmail,
    Expression<String>? sharedWithUserId,
    Expression<String>? permission,
    Expression<String>? shareToken,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? expiresAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (ownerId != null) 'owner_id': ownerId,
      if (sharedWithEmail != null) 'shared_with_email': sharedWithEmail,
      if (sharedWithUserId != null) 'shared_with_user_id': sharedWithUserId,
      if (permission != null) 'permission': permission,
      if (shareToken != null) 'share_token': shareToken,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SharedNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? noteId,
    Value<String>? ownerId,
    Value<String>? sharedWithEmail,
    Value<String?>? sharedWithUserId,
    Value<SharePermission>? permission,
    Value<String>? shareToken,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? expiresAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SharedNotesCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      ownerId: ownerId ?? this.ownerId,
      sharedWithEmail: sharedWithEmail ?? this.sharedWithEmail,
      sharedWithUserId: sharedWithUserId ?? this.sharedWithUserId,
      permission: permission ?? this.permission,
      shareToken: shareToken ?? this.shareToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sharedWithEmail.present) {
      map['shared_with_email'] = Variable<String>(sharedWithEmail.value);
    }
    if (sharedWithUserId.present) {
      map['shared_with_user_id'] = Variable<String>(sharedWithUserId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(
        $SharedNotesTable.$converterpermission.toSql(permission.value),
      );
    }
    if (shareToken.present) {
      map['share_token'] = Variable<String>(shareToken.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedNotesCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWithEmail: $sharedWithEmail, ')
          ..write('sharedWithUserId: $sharedWithUserId, ')
          ..write('permission: $permission, ')
          ..write('shareToken: $shareToken, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteTagsTable extends NoteTags with TableInfo<$NoteTagsTable, NoteTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [noteId, tagId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {noteId, tagId};
  @override
  NoteTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteTag(
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NoteTagsTable createAlias(String alias) {
    return $NoteTagsTable(attachedDatabase, alias);
  }
}

class NoteTag extends DataClass implements Insertable<NoteTag> {
  final String noteId;
  final String tagId;
  final DateTime createdAt;
  const NoteTag({
    required this.noteId,
    required this.tagId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['tag_id'] = Variable<String>(tagId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NoteTagsCompanion toCompanion(bool nullToAbsent) {
    return NoteTagsCompanion(
      noteId: Value(noteId),
      tagId: Value(tagId),
      createdAt: Value(createdAt),
    );
  }

  factory NoteTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteTag(
      noteId: serializer.fromJson<String>(json['noteId']),
      tagId: serializer.fromJson<String>(json['tagId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'tagId': serializer.toJson<String>(tagId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NoteTag copyWith({String? noteId, String? tagId, DateTime? createdAt}) =>
      NoteTag(
        noteId: noteId ?? this.noteId,
        tagId: tagId ?? this.tagId,
        createdAt: createdAt ?? this.createdAt,
      );
  NoteTag copyWithCompanion(NoteTagsCompanion data) {
    return NoteTag(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteTag(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, tagId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteTag &&
          other.noteId == this.noteId &&
          other.tagId == this.tagId &&
          other.createdAt == this.createdAt);
}

class NoteTagsCompanion extends UpdateCompanion<NoteTag> {
  final Value<String> noteId;
  final Value<String> tagId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NoteTagsCompanion({
    this.noteId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteTagsCompanion.insert({
    required String noteId,
    required String tagId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : noteId = Value(noteId),
       tagId = Value(tagId),
       createdAt = Value(createdAt);
  static Insertable<NoteTag> custom({
    Expression<String>? noteId,
    Expression<String>? tagId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (tagId != null) 'tag_id': tagId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteTagsCompanion copyWith({
    Value<String>? noteId,
    Value<String>? tagId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NoteTagsCompanion(
      noteId: noteId ?? this.noteId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteTagsCompanion(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $BacklinksTable backlinks = $BacklinksTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $EmailSettingsTableTable emailSettingsTable =
      $EmailSettingsTableTable(this);
  late final $CalendarSettingsTableTable calendarSettingsTable =
      $CalendarSettingsTableTable(this);
  late final $CloudStorageConnectionsTable cloudStorageConnections =
      $CloudStorageConnectionsTable(this);
  late final $SharedNotesTable sharedNotes = $SharedNotesTable(this);
  late final $NoteTagsTable noteTags = $NoteTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    notes,
    tags,
    attachments,
    folders,
    backlinks,
    tasks,
    emailSettingsTable,
    calendarSettingsTable,
    cloudStorageConnections,
    sharedNotes,
    noteTags,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('backlinks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('backlinks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shared_notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('note_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('note_tags', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      required String id,
      required String title,
      required String content,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isPinned,
      Value<bool> isArchived,
      Value<bool> isFavorite,
      Value<String?> folderId,
      Value<String?> color,
      Value<int> rowid,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isPinned,
      Value<bool> isArchived,
      Value<bool> isFavorite,
      Value<String?> folderId,
      Value<String?> color,
      Value<int> rowid,
    });

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, Note> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttachmentsTable, List<Attachment>>
  _attachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attachments,
    aliasName: $_aliasNameGenerator(db.notes.id, db.attachments.noteId),
  );

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: $_aliasNameGenerator(db.notes.id, db.tasks.noteId),
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SharedNotesTable, List<model.SharedNote>>
  _sharedNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sharedNotes,
    aliasName: $_aliasNameGenerator(db.notes.id, db.sharedNotes.noteId),
  );

  $$SharedNotesTableProcessedTableManager get sharedNotesRefs {
    final manager = $$SharedNotesTableTableManager(
      $_db,
      $_db.sharedNotes,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sharedNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NoteTagsTable, List<NoteTag>> _noteTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.noteTags,
    aliasName: $_aliasNameGenerator(db.notes.id, db.noteTags.noteId),
  );

  $$NoteTagsTableProcessedTableManager get noteTagsRefs {
    final manager = $$NoteTagsTableTableManager(
      $_db,
      $_db.noteTags,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> attachmentsRefs(
    Expression<bool> Function($$AttachmentsTableFilterComposer f) f,
  ) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sharedNotesRefs(
    Expression<bool> Function($$SharedNotesTableFilterComposer f) f,
  ) {
    final $$SharedNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sharedNotes,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SharedNotesTableFilterComposer(
            $db: $db,
            $table: $db.sharedNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> noteTagsRefs(
    Expression<bool> Function($$NoteTagsTableFilterComposer f) f,
  ) {
    final $$NoteTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTags,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagsTableFilterComposer(
            $db: $db,
            $table: $db.noteTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
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

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get folderId =>
      $composableBuilder(column: $table.folderId, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> attachmentsRefs<T extends Object>(
    Expression<T> Function($$AttachmentsTableAnnotationComposer a) f,
  ) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sharedNotesRefs<T extends Object>(
    Expression<T> Function($$SharedNotesTableAnnotationComposer a) f,
  ) {
    final $$SharedNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sharedNotes,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SharedNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.sharedNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> noteTagsRefs<T extends Object>(
    Expression<T> Function($$NoteTagsTableAnnotationComposer a) f,
  ) {
    final $$NoteTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTags,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.noteTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, $$NotesTableReferences),
          Note,
          PrefetchHooks Function({
            bool attachmentsRefs,
            bool tasksRefs,
            bool sharedNotesRefs,
            bool noteTagsRefs,
          })
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> folderId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isPinned: isPinned,
                isArchived: isArchived,
                isFavorite: isFavorite,
                folderId: folderId,
                color: color,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String content,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> folderId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isPinned: isPinned,
                isArchived: isArchived,
                isFavorite: isFavorite,
                folderId: folderId,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                attachmentsRefs = false,
                tasksRefs = false,
                sharedNotesRefs = false,
                noteTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (attachmentsRefs) db.attachments,
                    if (tasksRefs) db.tasks,
                    if (sharedNotesRefs) db.sharedNotes,
                    if (noteTagsRefs) db.noteTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (attachmentsRefs)
                        await $_getPrefetchedData<
                          Note,
                          $NotesTable,
                          Attachment
                        >(
                          currentTable: table,
                          referencedTable: $$NotesTableReferences
                              ._attachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotesTableReferences(
                                db,
                                table,
                                p0,
                              ).attachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<Note, $NotesTable, Task>(
                          currentTable: table,
                          referencedTable: $$NotesTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotesTableReferences(db, table, p0).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sharedNotesRefs)
                        await $_getPrefetchedData<
                          Note,
                          $NotesTable,
                          model.SharedNote
                        >(
                          currentTable: table,
                          referencedTable: $$NotesTableReferences
                              ._sharedNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotesTableReferences(
                                db,
                                table,
                                p0,
                              ).sharedNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (noteTagsRefs)
                        await $_getPrefetchedData<Note, $NotesTable, NoteTag>(
                          currentTable: table,
                          referencedTable: $$NotesTableReferences
                              ._noteTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotesTableReferences(
                                db,
                                table,
                                p0,
                              ).noteTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
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

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, $$NotesTableReferences),
      Note,
      PrefetchHooks Function({
        bool attachmentsRefs,
        bool tasksRefs,
        bool sharedNotesRefs,
        bool noteTagsRefs,
      })
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String name,
      required DateTime createdAt,
      Value<String> color,
      Value<int> useCount,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<String> color,
      Value<int> useCount,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NoteTagsTable, List<NoteTag>> _noteTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.noteTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.noteTags.tagId),
  );

  $$NoteTagsTableProcessedTableManager get noteTagsRefs {
    final manager = $$NoteTagsTableTableManager(
      $_db,
      $_db.noteTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> noteTagsRefs(
    Expression<bool> Function($$NoteTagsTableFilterComposer f) f,
  ) {
    final $$NoteTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagsTableFilterComposer(
            $db: $db,
            $table: $db.noteTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> noteTagsRefs<T extends Object>(
    Expression<T> Function($$NoteTagsTableAnnotationComposer a) f,
  ) {
    final $$NoteTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.noteTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool noteTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<int> useCount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                color: color,
                useCount: useCount,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                Value<String> color = const Value.absent(),
                Value<int> useCount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                color: color,
                useCount: useCount,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({noteTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (noteTagsRefs) db.noteTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (noteTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, NoteTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._noteTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).noteTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool noteTagsRefs})
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      required String id,
      Value<String?> noteId,
      required String fileName,
      required String filePath,
      required AttachmentType type,
      required int fileSize,
      required DateTime createdAt,
      Value<String?> mimeType,
      Value<String?> thumbnailPath,
      Value<Map<String, dynamic>?> metadata,
      Value<int> rowid,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<String> id,
      Value<String?> noteId,
      Value<String> fileName,
      Value<String> filePath,
      Value<AttachmentType> type,
      Value<int> fileSize,
      Value<DateTime> createdAt,
      Value<String?> mimeType,
      Value<String?> thumbnailPath,
      Value<Map<String, dynamic>?> metadata,
      Value<int> rowid,
    });

final class $$AttachmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment> {
  $$AttachmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) => db.notes.createAlias(
    $_aliasNameGenerator(db.attachments.noteId, db.notes.id),
  );

  $$NotesTableProcessedTableManager? get noteId {
    final $_column = $_itemColumn<String>('note_id');
    if ($_column == null) return null;
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
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

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AttachmentType, AttachmentType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
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

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AttachmentType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (Attachment, $$AttachmentsTableReferences),
          Attachment,
          PrefetchHooks Function({bool noteId})
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> noteId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<AttachmentType> type = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<Map<String, dynamic>?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                noteId: noteId,
                fileName: fileName,
                filePath: filePath,
                type: type,
                fileSize: fileSize,
                createdAt: createdAt,
                mimeType: mimeType,
                thumbnailPath: thumbnailPath,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> noteId = const Value.absent(),
                required String fileName,
                required String filePath,
                required AttachmentType type,
                required int fileSize,
                required DateTime createdAt,
                Value<String?> mimeType = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<Map<String, dynamic>?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                noteId: noteId,
                fileName: fileName,
                filePath: filePath,
                type: type,
                fileSize: fileSize,
                createdAt: createdAt,
                mimeType: mimeType,
                thumbnailPath: thumbnailPath,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
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
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$AttachmentsTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$AttachmentsTableReferences
                                    ._noteIdTable(db)
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

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (Attachment, $$AttachmentsTableReferences),
      Attachment,
      PrefetchHooks Function({bool noteId})
    >;
typedef $$FoldersTableCreateCompanionBuilder =
    FoldersCompanion Function({
      required String id,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> parentId,
      Value<String?> color,
      Value<String?> icon,
      Value<int> rowid,
    });
typedef $$FoldersTableUpdateCompanionBuilder =
    FoldersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> parentId,
      Value<String?> color,
      Value<String?> icon,
      Value<int> rowid,
    });

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          Folder,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
          Folder,
          PrefetchHooks Function()
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                parentId: parentId,
                color: color,
                icon: icon,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> parentId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                parentId: parentId,
                color: color,
                icon: icon,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      Folder,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
      Folder,
      PrefetchHooks Function()
    >;
typedef $$BacklinksTableCreateCompanionBuilder =
    BacklinksCompanion Function({
      required String id,
      required String sourceNoteId,
      required String targetNoteId,
      required String targetText,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BacklinksTableUpdateCompanionBuilder =
    BacklinksCompanion Function({
      Value<String> id,
      Value<String> sourceNoteId,
      Value<String> targetNoteId,
      Value<String> targetText,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BacklinksTableReferences
    extends BaseReferences<_$AppDatabase, $BacklinksTable, Backlink> {
  $$BacklinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _sourceNoteIdTable(_$AppDatabase db) =>
      db.notes.createAlias(
        $_aliasNameGenerator(db.backlinks.sourceNoteId, db.notes.id),
      );

  $$NotesTableProcessedTableManager get sourceNoteId {
    final $_column = $_itemColumn<String>('source_note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceNoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $NotesTable _targetNoteIdTable(_$AppDatabase db) =>
      db.notes.createAlias(
        $_aliasNameGenerator(db.backlinks.targetNoteId, db.notes.id),
      );

  $$NotesTableProcessedTableManager get targetNoteId {
    final $_column = $_itemColumn<String>('target_note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetNoteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BacklinksTableFilterComposer
    extends Composer<_$AppDatabase, $BacklinksTable> {
  $$BacklinksTableFilterComposer({
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

  ColumnFilters<String> get targetText => $composableBuilder(
    column: $table.targetText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get sourceNoteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNoteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NotesTableFilterComposer get targetNoteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNoteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BacklinksTableOrderingComposer
    extends Composer<_$AppDatabase, $BacklinksTable> {
  $$BacklinksTableOrderingComposer({
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

  ColumnOrderings<String> get targetText => $composableBuilder(
    column: $table.targetText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get sourceNoteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNoteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NotesTableOrderingComposer get targetNoteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNoteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BacklinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BacklinksTable> {
  $$BacklinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetText => $composableBuilder(
    column: $table.targetText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$NotesTableAnnotationComposer get sourceNoteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNoteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NotesTableAnnotationComposer get targetNoteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNoteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BacklinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BacklinksTable,
          Backlink,
          $$BacklinksTableFilterComposer,
          $$BacklinksTableOrderingComposer,
          $$BacklinksTableAnnotationComposer,
          $$BacklinksTableCreateCompanionBuilder,
          $$BacklinksTableUpdateCompanionBuilder,
          (Backlink, $$BacklinksTableReferences),
          Backlink,
          PrefetchHooks Function({bool sourceNoteId, bool targetNoteId})
        > {
  $$BacklinksTableTableManager(_$AppDatabase db, $BacklinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BacklinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BacklinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BacklinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceNoteId = const Value.absent(),
                Value<String> targetNoteId = const Value.absent(),
                Value<String> targetText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BacklinksCompanion(
                id: id,
                sourceNoteId: sourceNoteId,
                targetNoteId: targetNoteId,
                targetText: targetText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceNoteId,
                required String targetNoteId,
                required String targetText,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BacklinksCompanion.insert(
                id: id,
                sourceNoteId: sourceNoteId,
                targetNoteId: targetNoteId,
                targetText: targetText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BacklinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceNoteId = false, targetNoteId = false}) {
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
                        if (sourceNoteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceNoteId,
                                    referencedTable: $$BacklinksTableReferences
                                        ._sourceNoteIdTable(db),
                                    referencedColumn: $$BacklinksTableReferences
                                        ._sourceNoteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (targetNoteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.targetNoteId,
                                    referencedTable: $$BacklinksTableReferences
                                        ._targetNoteIdTable(db),
                                    referencedColumn: $$BacklinksTableReferences
                                        ._targetNoteIdTable(db)
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

typedef $$BacklinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BacklinksTable,
      Backlink,
      $$BacklinksTableFilterComposer,
      $$BacklinksTableOrderingComposer,
      $$BacklinksTableAnnotationComposer,
      $$BacklinksTableCreateCompanionBuilder,
      $$BacklinksTableUpdateCompanionBuilder,
      (Backlink, $$BacklinksTableReferences),
      Backlink,
      PrefetchHooks Function({bool sourceNoteId, bool targetNoteId})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String noteId,
      required String title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<DateTime?> dueDate,
      Value<DateTime?> reminderDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> hasNotified,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> noteId,
      Value<String> title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<DateTime?> dueDate,
      Value<DateTime?> reminderDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> hasNotified,
      Value<int> rowid,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) =>
      db.notes.createAlias($_aliasNameGenerator(db.tasks.noteId, db.notes.id));

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasNotified => $composableBuilder(
    column: $table.hasNotified,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasNotified => $composableBuilder(
    column: $table.hasNotified,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
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

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get hasNotified => $composableBuilder(
    column: $table.hasNotified,
    builder: (column) => column,
  );

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({bool noteId})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> noteId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime?> reminderDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> hasNotified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                noteId: noteId,
                title: title,
                description: description,
                isCompleted: isCompleted,
                dueDate: dueDate,
                reminderDate: reminderDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                hasNotified: hasNotified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String noteId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime?> reminderDate = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> hasNotified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                noteId: noteId,
                title: title,
                description: description,
                isCompleted: isCompleted,
                dueDate: dueDate,
                reminderDate: reminderDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                hasNotified: hasNotified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
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
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$TasksTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$TasksTableReferences
                                    ._noteIdTable(db)
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

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({bool noteId})
    >;
typedef $$EmailSettingsTableTableCreateCompanionBuilder =
    EmailSettingsTableCompanion Function({
      required String id,
      required String userId,
      required String uniqueEmail,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isEnabled,
      Value<bool> gmailConnected,
      Value<String?> gmailEmail,
      Value<String?> gmailRefreshToken,
      Value<DateTime?> lastGmailSync,
      Value<Map<String, dynamic>?> preferences,
      Value<int> rowid,
    });
typedef $$EmailSettingsTableTableUpdateCompanionBuilder =
    EmailSettingsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> uniqueEmail,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isEnabled,
      Value<bool> gmailConnected,
      Value<String?> gmailEmail,
      Value<String?> gmailRefreshToken,
      Value<DateTime?> lastGmailSync,
      Value<Map<String, dynamic>?> preferences,
      Value<int> rowid,
    });

class $$EmailSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmailSettingsTableTable> {
  $$EmailSettingsTableTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uniqueEmail => $composableBuilder(
    column: $table.uniqueEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gmailConnected => $composableBuilder(
    column: $table.gmailConnected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailEmail => $composableBuilder(
    column: $table.gmailEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailRefreshToken => $composableBuilder(
    column: $table.gmailRefreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastGmailSync => $composableBuilder(
    column: $table.lastGmailSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get preferences => $composableBuilder(
    column: $table.preferences,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$EmailSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailSettingsTableTable> {
  $$EmailSettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uniqueEmail => $composableBuilder(
    column: $table.uniqueEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gmailConnected => $composableBuilder(
    column: $table.gmailConnected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailEmail => $composableBuilder(
    column: $table.gmailEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailRefreshToken => $composableBuilder(
    column: $table.gmailRefreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastGmailSync => $composableBuilder(
    column: $table.lastGmailSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferences => $composableBuilder(
    column: $table.preferences,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailSettingsTableTable> {
  $$EmailSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get uniqueEmail => $composableBuilder(
    column: $table.uniqueEmail,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get gmailConnected => $composableBuilder(
    column: $table.gmailConnected,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gmailEmail => $composableBuilder(
    column: $table.gmailEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gmailRefreshToken => $composableBuilder(
    column: $table.gmailRefreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastGmailSync => $composableBuilder(
    column: $table.lastGmailSync,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  get preferences => $composableBuilder(
    column: $table.preferences,
    builder: (column) => column,
  );
}

class $$EmailSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailSettingsTableTable,
          EmailSettingsTableData,
          $$EmailSettingsTableTableFilterComposer,
          $$EmailSettingsTableTableOrderingComposer,
          $$EmailSettingsTableTableAnnotationComposer,
          $$EmailSettingsTableTableCreateCompanionBuilder,
          $$EmailSettingsTableTableUpdateCompanionBuilder,
          (
            EmailSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $EmailSettingsTableTable,
              EmailSettingsTableData
            >,
          ),
          EmailSettingsTableData,
          PrefetchHooks Function()
        > {
  $$EmailSettingsTableTableTableManager(
    _$AppDatabase db,
    $EmailSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> uniqueEmail = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> gmailConnected = const Value.absent(),
                Value<String?> gmailEmail = const Value.absent(),
                Value<String?> gmailRefreshToken = const Value.absent(),
                Value<DateTime?> lastGmailSync = const Value.absent(),
                Value<Map<String, dynamic>?> preferences = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmailSettingsTableCompanion(
                id: id,
                userId: userId,
                uniqueEmail: uniqueEmail,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isEnabled: isEnabled,
                gmailConnected: gmailConnected,
                gmailEmail: gmailEmail,
                gmailRefreshToken: gmailRefreshToken,
                lastGmailSync: lastGmailSync,
                preferences: preferences,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String uniqueEmail,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> gmailConnected = const Value.absent(),
                Value<String?> gmailEmail = const Value.absent(),
                Value<String?> gmailRefreshToken = const Value.absent(),
                Value<DateTime?> lastGmailSync = const Value.absent(),
                Value<Map<String, dynamic>?> preferences = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmailSettingsTableCompanion.insert(
                id: id,
                userId: userId,
                uniqueEmail: uniqueEmail,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isEnabled: isEnabled,
                gmailConnected: gmailConnected,
                gmailEmail: gmailEmail,
                gmailRefreshToken: gmailRefreshToken,
                lastGmailSync: lastGmailSync,
                preferences: preferences,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmailSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailSettingsTableTable,
      EmailSettingsTableData,
      $$EmailSettingsTableTableFilterComposer,
      $$EmailSettingsTableTableOrderingComposer,
      $$EmailSettingsTableTableAnnotationComposer,
      $$EmailSettingsTableTableCreateCompanionBuilder,
      $$EmailSettingsTableTableUpdateCompanionBuilder,
      (
        EmailSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $EmailSettingsTableTable,
          EmailSettingsTableData
        >,
      ),
      EmailSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$CalendarSettingsTableTableCreateCompanionBuilder =
    CalendarSettingsTableCompanion Function({
      required String id,
      required String userId,
      Value<bool> isGoogleCalendarConnected,
      Value<String?> googleAccountEmail,
      Value<String?> googleCalendarId,
      Value<bool> syncTasksToCalendar,
      Value<bool> syncEventsToNotes,
      Value<int> syncIntervalMinutes,
      Value<DateTime?> lastSyncedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CalendarSettingsTableTableUpdateCompanionBuilder =
    CalendarSettingsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<bool> isGoogleCalendarConnected,
      Value<String?> googleAccountEmail,
      Value<String?> googleCalendarId,
      Value<bool> syncTasksToCalendar,
      Value<bool> syncEventsToNotes,
      Value<int> syncIntervalMinutes,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CalendarSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarSettingsTableTable> {
  $$CalendarSettingsTableTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGoogleCalendarConnected => $composableBuilder(
    column: $table.isGoogleCalendarConnected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleAccountEmail => $composableBuilder(
    column: $table.googleAccountEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncTasksToCalendar => $composableBuilder(
    column: $table.syncTasksToCalendar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncEventsToNotes => $composableBuilder(
    column: $table.syncEventsToNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntervalMinutes => $composableBuilder(
    column: $table.syncIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarSettingsTableTable> {
  $$CalendarSettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGoogleCalendarConnected => $composableBuilder(
    column: $table.isGoogleCalendarConnected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleAccountEmail => $composableBuilder(
    column: $table.googleAccountEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncTasksToCalendar => $composableBuilder(
    column: $table.syncTasksToCalendar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncEventsToNotes => $composableBuilder(
    column: $table.syncEventsToNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntervalMinutes => $composableBuilder(
    column: $table.syncIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarSettingsTableTable> {
  $$CalendarSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get isGoogleCalendarConnected => $composableBuilder(
    column: $table.isGoogleCalendarConnected,
    builder: (column) => column,
  );

  GeneratedColumn<String> get googleAccountEmail => $composableBuilder(
    column: $table.googleAccountEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncTasksToCalendar => $composableBuilder(
    column: $table.syncTasksToCalendar,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncEventsToNotes => $composableBuilder(
    column: $table.syncEventsToNotes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncIntervalMinutes => $composableBuilder(
    column: $table.syncIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CalendarSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarSettingsTableTable,
          CalendarSettingsTableData,
          $$CalendarSettingsTableTableFilterComposer,
          $$CalendarSettingsTableTableOrderingComposer,
          $$CalendarSettingsTableTableAnnotationComposer,
          $$CalendarSettingsTableTableCreateCompanionBuilder,
          $$CalendarSettingsTableTableUpdateCompanionBuilder,
          (
            CalendarSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $CalendarSettingsTableTable,
              CalendarSettingsTableData
            >,
          ),
          CalendarSettingsTableData,
          PrefetchHooks Function()
        > {
  $$CalendarSettingsTableTableTableManager(
    _$AppDatabase db,
    $CalendarSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarSettingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CalendarSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalendarSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<bool> isGoogleCalendarConnected = const Value.absent(),
                Value<String?> googleAccountEmail = const Value.absent(),
                Value<String?> googleCalendarId = const Value.absent(),
                Value<bool> syncTasksToCalendar = const Value.absent(),
                Value<bool> syncEventsToNotes = const Value.absent(),
                Value<int> syncIntervalMinutes = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarSettingsTableCompanion(
                id: id,
                userId: userId,
                isGoogleCalendarConnected: isGoogleCalendarConnected,
                googleAccountEmail: googleAccountEmail,
                googleCalendarId: googleCalendarId,
                syncTasksToCalendar: syncTasksToCalendar,
                syncEventsToNotes: syncEventsToNotes,
                syncIntervalMinutes: syncIntervalMinutes,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<bool> isGoogleCalendarConnected = const Value.absent(),
                Value<String?> googleAccountEmail = const Value.absent(),
                Value<String?> googleCalendarId = const Value.absent(),
                Value<bool> syncTasksToCalendar = const Value.absent(),
                Value<bool> syncEventsToNotes = const Value.absent(),
                Value<int> syncIntervalMinutes = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CalendarSettingsTableCompanion.insert(
                id: id,
                userId: userId,
                isGoogleCalendarConnected: isGoogleCalendarConnected,
                googleAccountEmail: googleAccountEmail,
                googleCalendarId: googleCalendarId,
                syncTasksToCalendar: syncTasksToCalendar,
                syncEventsToNotes: syncEventsToNotes,
                syncIntervalMinutes: syncIntervalMinutes,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarSettingsTableTable,
      CalendarSettingsTableData,
      $$CalendarSettingsTableTableFilterComposer,
      $$CalendarSettingsTableTableOrderingComposer,
      $$CalendarSettingsTableTableAnnotationComposer,
      $$CalendarSettingsTableTableCreateCompanionBuilder,
      $$CalendarSettingsTableTableUpdateCompanionBuilder,
      (
        CalendarSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $CalendarSettingsTableTable,
          CalendarSettingsTableData
        >,
      ),
      CalendarSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$CloudStorageConnectionsTableCreateCompanionBuilder =
    CloudStorageConnectionsCompanion Function({
      required String id,
      required String userId,
      required CloudStorageProvider provider,
      required String accessToken,
      Value<String?> refreshToken,
      Value<DateTime?> tokenExpiry,
      Value<String?> userEmail,
      Value<String?> userName,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CloudStorageConnectionsTableUpdateCompanionBuilder =
    CloudStorageConnectionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<CloudStorageProvider> provider,
      Value<String> accessToken,
      Value<String?> refreshToken,
      Value<DateTime?> tokenExpiry,
      Value<String?> userEmail,
      Value<String?> userName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CloudStorageConnectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CloudStorageConnectionsTable> {
  $$CloudStorageConnectionsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    CloudStorageProvider,
    CloudStorageProvider,
    String
  >
  get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tokenExpiry => $composableBuilder(
    column: $table.tokenExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userEmail => $composableBuilder(
    column: $table.userEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CloudStorageConnectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CloudStorageConnectionsTable> {
  $$CloudStorageConnectionsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tokenExpiry => $composableBuilder(
    column: $table.tokenExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userEmail => $composableBuilder(
    column: $table.userEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CloudStorageConnectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CloudStorageConnectionsTable> {
  $$CloudStorageConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CloudStorageProvider, String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tokenExpiry => $composableBuilder(
    column: $table.tokenExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userEmail =>
      $composableBuilder(column: $table.userEmail, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CloudStorageConnectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CloudStorageConnectionsTable,
          CloudStorageConnection,
          $$CloudStorageConnectionsTableFilterComposer,
          $$CloudStorageConnectionsTableOrderingComposer,
          $$CloudStorageConnectionsTableAnnotationComposer,
          $$CloudStorageConnectionsTableCreateCompanionBuilder,
          $$CloudStorageConnectionsTableUpdateCompanionBuilder,
          (
            CloudStorageConnection,
            BaseReferences<
              _$AppDatabase,
              $CloudStorageConnectionsTable,
              CloudStorageConnection
            >,
          ),
          CloudStorageConnection,
          PrefetchHooks Function()
        > {
  $$CloudStorageConnectionsTableTableManager(
    _$AppDatabase db,
    $CloudStorageConnectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CloudStorageConnectionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CloudStorageConnectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CloudStorageConnectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<CloudStorageProvider> provider = const Value.absent(),
                Value<String> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<DateTime?> tokenExpiry = const Value.absent(),
                Value<String?> userEmail = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CloudStorageConnectionsCompanion(
                id: id,
                userId: userId,
                provider: provider,
                accessToken: accessToken,
                refreshToken: refreshToken,
                tokenExpiry: tokenExpiry,
                userEmail: userEmail,
                userName: userName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required CloudStorageProvider provider,
                required String accessToken,
                Value<String?> refreshToken = const Value.absent(),
                Value<DateTime?> tokenExpiry = const Value.absent(),
                Value<String?> userEmail = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CloudStorageConnectionsCompanion.insert(
                id: id,
                userId: userId,
                provider: provider,
                accessToken: accessToken,
                refreshToken: refreshToken,
                tokenExpiry: tokenExpiry,
                userEmail: userEmail,
                userName: userName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CloudStorageConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CloudStorageConnectionsTable,
      CloudStorageConnection,
      $$CloudStorageConnectionsTableFilterComposer,
      $$CloudStorageConnectionsTableOrderingComposer,
      $$CloudStorageConnectionsTableAnnotationComposer,
      $$CloudStorageConnectionsTableCreateCompanionBuilder,
      $$CloudStorageConnectionsTableUpdateCompanionBuilder,
      (
        CloudStorageConnection,
        BaseReferences<
          _$AppDatabase,
          $CloudStorageConnectionsTable,
          CloudStorageConnection
        >,
      ),
      CloudStorageConnection,
      PrefetchHooks Function()
    >;
typedef $$SharedNotesTableCreateCompanionBuilder =
    SharedNotesCompanion Function({
      required String id,
      required String noteId,
      required String ownerId,
      required String sharedWithEmail,
      Value<String?> sharedWithUserId,
      required SharePermission permission,
      required String shareToken,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> expiresAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$SharedNotesTableUpdateCompanionBuilder =
    SharedNotesCompanion Function({
      Value<String> id,
      Value<String> noteId,
      Value<String> ownerId,
      Value<String> sharedWithEmail,
      Value<String?> sharedWithUserId,
      Value<SharePermission> permission,
      Value<String> shareToken,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> expiresAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$SharedNotesTableReferences
    extends BaseReferences<_$AppDatabase, $SharedNotesTable, model.SharedNote> {
  $$SharedNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) => db.notes.createAlias(
    $_aliasNameGenerator(db.sharedNotes.noteId, db.notes.id),
  );

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SharedNotesTableFilterComposer
    extends Composer<_$AppDatabase, $SharedNotesTable> {
  $$SharedNotesTableFilterComposer({
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

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedWithEmail => $composableBuilder(
    column: $table.sharedWithEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedWithUserId => $composableBuilder(
    column: $table.sharedWithUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SharePermission, SharePermission, String>
  get permission => $composableBuilder(
    column: $table.permission,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get shareToken => $composableBuilder(
    column: $table.shareToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SharedNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedNotesTable> {
  $$SharedNotesTableOrderingComposer({
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

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedWithEmail => $composableBuilder(
    column: $table.sharedWithEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedWithUserId => $composableBuilder(
    column: $table.sharedWithUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permission => $composableBuilder(
    column: $table.permission,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareToken => $composableBuilder(
    column: $table.shareToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SharedNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedNotesTable> {
  $$SharedNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get sharedWithEmail => $composableBuilder(
    column: $table.sharedWithEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sharedWithUserId => $composableBuilder(
    column: $table.sharedWithUserId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SharePermission, String> get permission =>
      $composableBuilder(
        column: $table.permission,
        builder: (column) => column,
      );

  GeneratedColumn<String> get shareToken => $composableBuilder(
    column: $table.shareToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SharedNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SharedNotesTable,
          model.SharedNote,
          $$SharedNotesTableFilterComposer,
          $$SharedNotesTableOrderingComposer,
          $$SharedNotesTableAnnotationComposer,
          $$SharedNotesTableCreateCompanionBuilder,
          $$SharedNotesTableUpdateCompanionBuilder,
          (model.SharedNote, $$SharedNotesTableReferences),
          model.SharedNote,
          PrefetchHooks Function({bool noteId})
        > {
  $$SharedNotesTableTableManager(_$AppDatabase db, $SharedNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SharedNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SharedNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SharedNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> noteId = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> sharedWithEmail = const Value.absent(),
                Value<String?> sharedWithUserId = const Value.absent(),
                Value<SharePermission> permission = const Value.absent(),
                Value<String> shareToken = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SharedNotesCompanion(
                id: id,
                noteId: noteId,
                ownerId: ownerId,
                sharedWithEmail: sharedWithEmail,
                sharedWithUserId: sharedWithUserId,
                permission: permission,
                shareToken: shareToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
                expiresAt: expiresAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String noteId,
                required String ownerId,
                required String sharedWithEmail,
                Value<String?> sharedWithUserId = const Value.absent(),
                required SharePermission permission,
                required String shareToken,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SharedNotesCompanion.insert(
                id: id,
                noteId: noteId,
                ownerId: ownerId,
                sharedWithEmail: sharedWithEmail,
                sharedWithUserId: sharedWithUserId,
                permission: permission,
                shareToken: shareToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
                expiresAt: expiresAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SharedNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
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
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$SharedNotesTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$SharedNotesTableReferences
                                    ._noteIdTable(db)
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

typedef $$SharedNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SharedNotesTable,
      model.SharedNote,
      $$SharedNotesTableFilterComposer,
      $$SharedNotesTableOrderingComposer,
      $$SharedNotesTableAnnotationComposer,
      $$SharedNotesTableCreateCompanionBuilder,
      $$SharedNotesTableUpdateCompanionBuilder,
      (model.SharedNote, $$SharedNotesTableReferences),
      model.SharedNote,
      PrefetchHooks Function({bool noteId})
    >;
typedef $$NoteTagsTableCreateCompanionBuilder =
    NoteTagsCompanion Function({
      required String noteId,
      required String tagId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$NoteTagsTableUpdateCompanionBuilder =
    NoteTagsCompanion Function({
      Value<String> noteId,
      Value<String> tagId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$NoteTagsTableReferences
    extends BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTag> {
  $$NoteTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) => db.notes.createAlias(
    $_aliasNameGenerator(db.noteTags.noteId, db.notes.id),
  );

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias($_aliasNameGenerator(db.noteTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NoteTagsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteTagsTable,
          NoteTag,
          $$NoteTagsTableFilterComposer,
          $$NoteTagsTableOrderingComposer,
          $$NoteTagsTableAnnotationComposer,
          $$NoteTagsTableCreateCompanionBuilder,
          $$NoteTagsTableUpdateCompanionBuilder,
          (NoteTag, $$NoteTagsTableReferences),
          NoteTag,
          PrefetchHooks Function({bool noteId, bool tagId})
        > {
  $$NoteTagsTableTableManager(_$AppDatabase db, $NoteTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> noteId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteTagsCompanion(
                noteId: noteId,
                tagId: tagId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String noteId,
                required String tagId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => NoteTagsCompanion.insert(
                noteId: noteId,
                tagId: tagId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NoteTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false, tagId = false}) {
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
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$NoteTagsTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$NoteTagsTableReferences
                                    ._noteIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$NoteTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$NoteTagsTableReferences
                                    ._tagIdTable(db)
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

typedef $$NoteTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteTagsTable,
      NoteTag,
      $$NoteTagsTableFilterComposer,
      $$NoteTagsTableOrderingComposer,
      $$NoteTagsTableAnnotationComposer,
      $$NoteTagsTableCreateCompanionBuilder,
      $$NoteTagsTableUpdateCompanionBuilder,
      (NoteTag, $$NoteTagsTableReferences),
      NoteTag,
      PrefetchHooks Function({bool noteId, bool tagId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$BacklinksTableTableManager get backlinks =>
      $$BacklinksTableTableManager(_db, _db.backlinks);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$EmailSettingsTableTableTableManager get emailSettingsTable =>
      $$EmailSettingsTableTableTableManager(_db, _db.emailSettingsTable);
  $$CalendarSettingsTableTableTableManager get calendarSettingsTable =>
      $$CalendarSettingsTableTableTableManager(_db, _db.calendarSettingsTable);
  $$CloudStorageConnectionsTableTableManager get cloudStorageConnections =>
      $$CloudStorageConnectionsTableTableManager(
        _db,
        _db.cloudStorageConnections,
      );
  $$SharedNotesTableTableManager get sharedNotes =>
      $$SharedNotesTableTableManager(_db, _db.sharedNotes);
  $$NoteTagsTableTableManager get noteTags =>
      $$NoteTagsTableTableManager(_db, _db.noteTags);
}
