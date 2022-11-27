import 'dart:io'; //追加

import 'package:drift/drift.dart';
import 'package:drift/native.dart'; //追加
import 'package:path/path.dart' as p; //追加
import 'package:path_provider/path_provider.dart';
part 'todos.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get comment => text()();
  DateTimeColumn get startDateTime => dateTime()();
  DateTimeColumn get endDateTime => dateTime()();
  BoolColumn get ifAllDay => boolean()();
}

@DriftDatabase(tables: [Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Todo>> watchTodos() {
    return (select(todos)
          ..where((t) => t.startDateTime.isSmallerThanValue(
                DateTime.now().add(const Duration(days: 70)),
              ))
          ..where((t) => t.endDateTime.isBiggerOrEqualValue(
                DateTime.now().add(const Duration(days: -70)),
              )))
        .watch();
  }

  Future<int> addTodo(
      {String? title,
      String? comment,
      bool? ifAllDay,
      DateTime? startDateTime,
      DateTime? endDateTime}) {
    return into(todos).insert(
      TodosCompanion(
        title: Value(title!),
        comment: Value(comment!),
        ifAllDay: Value(ifAllDay!),
        startDateTime: Value(startDateTime!),
        endDateTime: Value(endDateTime!),
      ),
    );
  }

  Future<int> updateTodo(
      {int? id,
      String? title,
      String? comment,
      bool? ifAllDay,
      DateTime? startDateTime,
      DateTime? endDateTime}) {
    return (update(todos)..where((tbl) => tbl.id.equals(id))).write(
      TodosCompanion(
        title: Value(title!),
        comment: Value(comment!),
        ifAllDay: Value(ifAllDay!),
        startDateTime: Value(startDateTime!),
        endDateTime: Value(endDateTime!),
      ),
    );
  }

  Future<void> deleteTodo(int id) {
    return (delete(todos)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
