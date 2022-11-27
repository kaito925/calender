// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final String title;
  final String comment;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool ifAllDay;
  Todo(
      {required this.id,
      required this.title,
      required this.comment,
      required this.startDateTime,
      required this.endDateTime,
      required this.ifAllDay});
  factory Todo.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Todo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      comment: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}comment'])!,
      startDateTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start_date_time'])!,
      endDateTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}end_date_time'])!,
      ifAllDay: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}if_all_day'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['comment'] = Variable<String>(comment);
    map['start_date_time'] = Variable<DateTime>(startDateTime);
    map['end_date_time'] = Variable<DateTime>(endDateTime);
    map['if_all_day'] = Variable<bool>(ifAllDay);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      comment: Value(comment),
      startDateTime: Value(startDateTime),
      endDateTime: Value(endDateTime),
      ifAllDay: Value(ifAllDay),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      comment: serializer.fromJson<String>(json['comment']),
      startDateTime: serializer.fromJson<DateTime>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime>(json['endDateTime']),
      ifAllDay: serializer.fromJson<bool>(json['ifAllDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'comment': serializer.toJson<String>(comment),
      'startDateTime': serializer.toJson<DateTime>(startDateTime),
      'endDateTime': serializer.toJson<DateTime>(endDateTime),
      'ifAllDay': serializer.toJson<bool>(ifAllDay),
    };
  }

  Todo copyWith(
          {int? id,
          String? title,
          String? comment,
          DateTime? startDateTime,
          DateTime? endDateTime,
          bool? ifAllDay}) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        comment: comment ?? this.comment,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        ifAllDay: ifAllDay ?? this.ifAllDay,
      );
  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('comment: $comment, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('ifAllDay: $ifAllDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, comment, startDateTime, endDateTime, ifAllDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.comment == this.comment &&
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
          other.ifAllDay == this.ifAllDay);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> comment;
  final Value<DateTime> startDateTime;
  final Value<DateTime> endDateTime;
  final Value<bool> ifAllDay;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.comment = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.ifAllDay = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String comment,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required bool ifAllDay,
  })  : title = Value(title),
        comment = Value(comment),
        startDateTime = Value(startDateTime),
        endDateTime = Value(endDateTime),
        ifAllDay = Value(ifAllDay);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? comment,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<bool>? ifAllDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (comment != null) 'comment': comment,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (ifAllDay != null) 'if_all_day': ifAllDay,
    });
  }

  TodosCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? comment,
      Value<DateTime>? startDateTime,
      Value<DateTime>? endDateTime,
      Value<bool>? ifAllDay}) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      ifAllDay: ifAllDay ?? this.ifAllDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (startDateTime.present) {
      map['start_date_time'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (ifAllDay.present) {
      map['if_all_day'] = Variable<bool>(ifAllDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('comment: $comment, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('ifAllDay: $ifAllDay')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String?> comment = GeneratedColumn<String?>(
      'comment', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _startDateTimeMeta =
      const VerificationMeta('startDateTime');
  @override
  late final GeneratedColumn<DateTime?> startDateTime =
      GeneratedColumn<DateTime?>('start_date_time', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _endDateTimeMeta =
      const VerificationMeta('endDateTime');
  @override
  late final GeneratedColumn<DateTime?> endDateTime =
      GeneratedColumn<DateTime?>('end_date_time', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _ifAllDayMeta = const VerificationMeta('ifAllDay');
  @override
  late final GeneratedColumn<bool?> ifAllDay = GeneratedColumn<bool?>(
      'if_all_day', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (if_all_day IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, comment, startDateTime, endDateTime, ifAllDay];
  @override
  String get aliasedName => _alias ?? 'todos';
  @override
  String get actualTableName => 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<Todo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
          _startDateTimeMeta,
          startDateTime.isAcceptableOrUnknown(
              data['start_date_time']!, _startDateTimeMeta));
    } else if (isInserting) {
      context.missing(_startDateTimeMeta);
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
          _endDateTimeMeta,
          endDateTime.isAcceptableOrUnknown(
              data['end_date_time']!, _endDateTimeMeta));
    } else if (isInserting) {
      context.missing(_endDateTimeMeta);
    }
    if (data.containsKey('if_all_day')) {
      context.handle(_ifAllDayMeta,
          ifAllDay.isAcceptableOrUnknown(data['if_all_day']!, _ifAllDayMeta));
    } else if (isInserting) {
      context.missing(_ifAllDayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Todo.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TodosTable todos = $TodosTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todos];
}
