//TODO ここまでで18hくらい
//TODO 諸々iosでチェックしてgithubに

import 'package:calender/src/drift/todos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'src/drift/todos.dart';
import 'package:calender/addEditTodoPage.dart';
import 'package:calender/consts.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = StateProvider((ref) => MyDatabase());
final selectedDateProvider = StateProvider((ref) => DateTime.now());
final focusedDateProvider = StateProvider((ref) => DateTime.now());
final todoProvider = StateProvider((ref) => []);
final StateProvider<Map<DateTime, List>> allTodosMapProvider =
    StateProvider((ref) => {});
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final StateProvider<LinkedHashMap<DateTime, List>>
    allTodosListLinkedHashMapProvider =
    StateProvider((ref) => LinkedHashMap<DateTime, List>(
          equals: isSameDay,
          hashCode: getHashCode,
        )..addAll(ref.watch(allTodosMapProvider)));

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
      ],
      locale: const Locale('ja'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key}) : super(key: key);
  DateFormat timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void showDatePick({context}) async {
      final DateTime? picked = await showDatePicker(
        locale: const Locale("ja"),
        context: context,
        initialDate: ref.watch(focusedDateProvider),
        firstDate: firstDate,
        lastDate: endDate,
      );
      if (picked != null) {
        ref.read(selectedDateProvider.notifier).state = picked;
        ref.read(focusedDateProvider.notifier).state = picked;
      }
    }

    List getTodo(DateTime day) {
      return ref.watch(allTodosListLinkedHashMapProvider)[day] ?? [];
    }

    void showTodo() {
      showDialog(
        context: context,
        builder: (_) {
          return Consumer(builder: (context, ref, _) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              content: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 1000,
                      color: Colors.transparent,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 600,
                      width: 500,
                      child: PageView.builder(
                        controller: PageController(
                          initialPage: ref
                              .watch(focusedDateProvider)
                              .difference(firstDate)
                              .inDays,
                          viewportFraction: 0.9,
                        ),
                        onPageChanged: (index) {
                          ref.read(focusedDateProvider.notifier).state =
                              firstDate.add(Duration(days: index));
                          ref.read(selectedDateProvider.notifier).state =
                              firstDate.add(Duration(days: index));
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${ref.watch(focusedDateProvider).year.toString()}/${ref.watch(focusedDateProvider).month.toString()}/${ref.watch(focusedDateProvider).day.toString()}",
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              "（${_weekDayNumberToText(ref.watch(focusedDateProvider).weekday)}）",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: (ref
                                                              .watch(
                                                                  focusedDateProvider)
                                                              .weekday ==
                                                          7)
                                                      ? Colors.red
                                                      : (ref
                                                                  .watch(
                                                                      focusedDateProvider)
                                                                  .weekday ==
                                                              6)
                                                          ? Colors.blue
                                                          : Colors.black),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(todoProvider.notifier)
                                                .state = [];
                                            ref
                                                .read(ifEnableSaveProvider
                                                    .notifier)
                                                .state = false;
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return AddEditTodoPage();
                                                },
                                              ),
                                            );
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: (ref
                                              .watch(allTodosListLinkedHashMapProvider)[
                                                  ref.watch(
                                                      selectedDateProvider)]!
                                              .isEmpty)
                                          ? const Center(
                                              child: Text("予定がありません。"),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: ref
                                                  .watch(allTodosListLinkedHashMapProvider)[
                                                      ref.watch(
                                                          selectedDateProvider)]!
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var todo = ref.watch(
                                                        allTodosListLinkedHashMapProvider)[
                                                    ref.watch(
                                                        selectedDateProvider)]![index];
                                                return Column(
                                                  children: [
                                                    const Divider(
                                                        color: Colors.grey),
                                                    GestureDetector(
                                                      onTap: () {
                                                        ref
                                                            .read(todoProvider
                                                                .notifier)
                                                            .state = todo;
                                                        ref
                                                            .read(
                                                                ifEnableSaveProvider
                                                                    .notifier)
                                                            .state = false;
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return AddEditTodoPage();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        color: Colors.white,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 60,
                                                              child: Center(
                                                                child: (todo[
                                                                            3] ==
                                                                        true)
                                                                    ? const Text(
                                                                        '終日',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                      )
                                                                    : (todo[4].isBefore(ref.watch(focusedDateProvider)) &&
                                                                            (todo[5].isAfter(ref.watch(focusedDateProvider).add(const Duration(days: 1)).add(const Duration(milliseconds: 1)))))
                                                                        ? const Text(
                                                                            '終日',
                                                                            style:
                                                                                TextStyle(fontSize: 13),
                                                                          )
                                                                        : Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              (todo[4].isBefore(ref.watch(focusedDateProvider)))
                                                                                  ? const Text("00:00", style: TextStyle(fontSize: 13))
                                                                                  : Text(
                                                                                      timeFormat.format(todo[4]),
                                                                                      style: const TextStyle(fontSize: 13),
                                                                                    ),
                                                                              (todo[5].isAfter(ref.watch(focusedDateProvider).add(const Duration(days: 1)).add(const Duration(milliseconds: 1))))
                                                                                  ? const Text("24:00", style: TextStyle(fontSize: 13))
                                                                                  : Text(
                                                                                      timeFormat.format(todo[5]),
                                                                                      style: const TextStyle(fontSize: 13),
                                                                                    ),
                                                                            ],
                                                                          ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 5,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            const SizedBox(
                                                                width: 15),
                                                            Expanded(
                                                              child: Text(
                                                                todo[1]
                                                                    .toString(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('カレンダー')),
        ),
        body: Column(children: [
          StreamBuilder(
            stream: ref.watch(databaseProvider).watchTodos(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              for (int i = -70; i < 70; i++) {
                DateTime selectedDate =
                    ref.watch(focusedDateProvider).add(Duration(days: i));
                List dailyTodosList = [];
                if (snapshot.data != null) {
                  for (int j = 0; j < snapshot.data!.length; j++) {
                    if (snapshot.data![j].startDateTime.isBefore(DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            24,
                            00,
                            00)) &&
                        snapshot.data![j].endDateTime.isAfter(DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day - 1,
                            23,
                            59,
                            59))) {
                      dailyTodosList.add([
                        snapshot.data![j].id,
                        snapshot.data![j].title,
                        snapshot.data![j].comment,
                        snapshot.data![j].ifAllDay,
                        snapshot.data![j].startDateTime,
                        snapshot.data![j].endDateTime,
                      ]);
                    }
                  }
                }
                ref.read(allTodosMapProvider.notifier).state[DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day)] = dailyTodosList;
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(allTodosListLinkedHashMapProvider.notifier).state =
                    LinkedHashMap<DateTime, List>(
                  equals: isSameDay,
                  hashCode: getHashCode,
                )..addAll(ref.watch(allTodosMapProvider));
              });

              return TableCalendar(
                firstDay: firstDate,
                lastDay: endDate,
                eventLoader: getTodo,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  return isSameDay(ref.watch(selectedDateProvider), day);
                },
                rowHeight: 60,
                daysOfWeekHeight: 32,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                locale: 'ja',
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue),
                    ),
                  todayTextStyle: TextStyle(color: _textColor(DateTime.now())),
                ),
                calendarBuilders: CalendarBuilders(defaultBuilder:
                    (BuildContext context, DateTime day, DateTime focusedDay) {
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: _textColor(day),
                      ),
                    ),
                  );
                }, selectedBuilder:
                    (BuildContext context, DateTime day, DateTime focusedDay) {
                  return GestureDetector(
                    onTap: () {
                      showTodo();
                    },
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }, dowBuilder: (context, day) {
                  return Container(
                    color: Colors.grey.withOpacity(0.12),
                    child: Center(
                      child: Text(
                        _weekDayNumberToText(day.weekday),
                        style: TextStyle(
                          color: _textColor(day),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }, headerTitleBuilder: (context, day) {
                  return Row(
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          ref.read(focusedDateProvider.notifier).state =
                              DateTime.now();
                          ref.read(selectedDateProvider.notifier).state =
                              DateTime.now();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text('今日'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                      GestureDetector(
                        onTap: () {
                          showDatePick(context: context);
                        },
                        child: Row(
                          children: [
                            Text(
                              "${day.year}年${day.month}月",
                              style: const TextStyle(
                                fontSize: 21,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 33,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                onPageChanged: (focused) {
                  ref.read(focusedDateProvider.notifier).state = focused;
                },
                onDaySelected: (selected, focused) {
                  if (!isSameDay(ref.watch(selectedDateProvider), selected)) {
                    ref.read(selectedDateProvider.notifier).state = selected;
                    ref.read(focusedDateProvider.notifier).state = focused;
                  }
                  showTodo();
                },
                focusedDay: ref.watch(focusedDateProvider),
              );
            },
          ),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.18),
            ),
          ),
        ]));
  }

  Color _textColor(DateTime day) {
    const defaultTextColor = Colors.black87;
    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue;
    }
    return defaultTextColor;
  }

  String _weekDayNumberToText(int weekday) {
    if (weekday == 1) {
      return '月';
    } else if (weekday == 2) {
      return '火';
    } else if (weekday == 3) {
      return '水';
    } else if (weekday == 4) {
      return '木';
    } else if (weekday == 5) {
      return '金';
    } else if (weekday == 6) {
      return '土';
    } else if (weekday == 7) {
      return '日';
    } else {
      return '';
    }
  }
}
