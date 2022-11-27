import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:calender/main.dart';

final ifEnableSaveProvider = StateProvider((ref) => false);
final StateProvider<bool> ifAllDayProvider = StateProvider((ref) =>
    (ref.watch(todoProvider).isEmpty) ? false : ref.watch(todoProvider)[3]);
final StateProvider<DateTime> startDateProvider = StateProvider((ref) {
  if (ref.watch(todoProvider).isEmpty) {
    return ref.watch(selectedDateProvider);
  } else {
    if (ref.watch(ifAllDayProvider) == true) {
      return ref.watch(todoProvider)[4];
    } else {
      return ref.watch(todoProvider)[4];
    }
  }
});
final StateProvider<DateTime> endDateProvider = StateProvider((ref) {
  if (ref.watch(todoProvider).isEmpty) {
    return ref.watch(selectedDateProvider);
  } else {
    if (ref.watch(ifAllDayProvider) == true) {
      return ref.watch(todoProvider)[5];
    } else {
      return ref.watch(todoProvider)[5];
    }
  }
});
final StateProvider<DateTime> startDateTimeProvider = StateProvider((ref) {
  if (ref.watch(todoProvider).isEmpty) {
    return DateTime(
      ref.watch(selectedDateProvider).year,
      ref.watch(selectedDateProvider).month,
      ref.watch(selectedDateProvider).day,
      DateTime.now().hour,
      DateTime.now().minute,
    ).add(Duration(minutes: 15 - DateTime.now().minute % 15));
  } else {
      return DateTime(
        ref.watch(todoProvider)[4]!.year,
        ref.watch(todoProvider)[4]!.month,
        ref.watch(todoProvider)[4]!.day,
        DateTime.now().hour,
        DateTime.now().minute,
      ).add(Duration(minutes: 15 - DateTime.now().minute % 15));
  }
});
final StateProvider<DateTime> endDateTimeProvider = StateProvider((ref) {
  if (ref.watch(todoProvider).isEmpty) {
    return DateTime(
      ref.watch(selectedDateProvider).year,
      ref.watch(selectedDateProvider).month,
      ref.watch(selectedDateProvider).day,
      DateTime.now().hour,
      DateTime.now().minute,
    )
        .add(Duration(minutes: 15 - DateTime.now().minute % 15))
        .add(const Duration(hours: 1));
  } else {
      return DateTime(
        ref.watch(todoProvider)[5]!.year,
        ref.watch(todoProvider)[5]!.month,
        ref.watch(todoProvider)[5]!.day,
        DateTime.now().hour,
        DateTime.now().minute,
      )
          .add(Duration(minutes: 15 - DateTime.now().minute % 15))
          .add(const Duration(hours: 1));
  }
});
final titleControllerProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(
      text:
          (ref.watch(todoProvider).isEmpty) ? "" : ref.watch(todoProvider)[1]);
});
final commentControllerProvider = StateProvider.autoDispose((ref) {
  return TextEditingController(
      text:
          (ref.watch(todoProvider).isEmpty) ? "" : ref.watch(todoProvider)[2]);
});

class AddEditTodoPage extends ConsumerWidget {
  AddEditTodoPage({Key? key}) : super(key: key);
  DateTime? newStartDateTime;
  DateTime? newStartDate;
  DateTime? newEndDateTime;
  DateTime? newEndDate;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void validateSave() {
      if ((ref.watch(todoProvider).isEmpty &&
              ref.watch(titleControllerProvider).text != "" &&
              ref.watch(commentControllerProvider).text != "") ||
          (ref.watch(todoProvider).isNotEmpty &&
              (ref.watch(titleControllerProvider).text !=
                      ref.watch(todoProvider)[1] ||
                  ref.watch(commentControllerProvider).text !=
                      ref.watch(todoProvider)[2] ||
                  ref.watch(ifAllDayProvider) != ref.watch(todoProvider)[3] ||
                  (ref.watch(todoProvider)[3] == true &&
                      ref.watch(startDateProvider) !=
                          ref.watch(todoProvider)[4]) ||
                  (ref.watch(todoProvider)[3] == true &&
                      ref.watch(endDateProvider) !=
                          ref.watch(todoProvider)[5]) ||
                  (ref.watch(todoProvider)[3] == false &&
                      ref.watch(startDateTimeProvider) !=
                          ref.watch(todoProvider)[4]) ||
                  (ref.watch(todoProvider)[3] == false &&
                      ref.watch(endDateTimeProvider) !=
                          ref.watch(todoProvider)[5])))) {
        ref.read(ifEnableSaveProvider.notifier).state = true;
      } else {
        ref.read(ifEnableSaveProvider.notifier).state = false;
      }
    }

    void showDatePicker(context, ifStart) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CupertinoButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                          child: const Text('キャンセル'),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            if (ifStart == true) {
                              ref.read(startDateProvider.notifier).state =
                                  newStartDate!;
                              if (ref
                                      .watch(startDateProvider)
                                      .isAfter(ref.watch(endDateProvider)) ==
                                  true) {
                                ref.read(endDateProvider.notifier).state =
                                    ref.watch(startDateProvider);
                                // ref.read(endDateProvider.notifier) = ref.watch(startDateProvider);
                              }
                            } else {
                              ref.read(endDateProvider.notifier).state =
                                  newEndDate!;
                              if (ref
                                      .watch(startDateProvider)
                                      .isAfter(ref.watch(endDateProvider)) ==
                                  true) {
                                ref.read(startDateProvider.notifier).state =
                                    ref.watch(endDateProvider);
                              }
                            }
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                          child: const Text('完了'),
                        )
                      ],
                    ),
                  ),
                  _bottomPicker(
                    CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: (ifStart == true)
                          ? ref.watch(startDateTimeProvider)
                          : ref.watch(endDateTimeProvider),
                      onDateTimeChanged: (DateTime newDateTime) {
                        if (ifStart == true) {
                          newStartDate = newDateTime;
                        } else {
                          newEndDate = newDateTime;
                        }
                      },
                    ),
                  )
                ]);
          });
    }

    void showDateTimePicker(context, ifStart) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CupertinoButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                          child: const Text('キャンセル'),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            if (ifStart == true) {
                              ref.read(startDateTimeProvider.notifier).state =
                                  newStartDateTime!;
                              if (ref.watch(startDateTimeProvider).isAfter(
                                      ref.watch(endDateTimeProvider)) ==
                                  true) {
                                ref.read(endDateTimeProvider.notifier).state =
                                    ref.watch(startDateTimeProvider).add(const Duration(hours: 1));
                              }
                            } else {
                              ref.read(endDateTimeProvider.notifier).state =
                                  newEndDateTime!;
                              if (ref.watch(startDateTimeProvider).isAfter(
                                      ref.watch(endDateTimeProvider)) ==
                                  true) {
                                ref.read(startDateTimeProvider.notifier).state =
                                    ref.watch(endDateTimeProvider).add(const Duration(hours: -1));
                              }
                            }
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                          child: const Text('完了'),
                        )
                      ],
                    ),
                  ),
                  _bottomPicker(
                    CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      initialDateTime: (ifStart == true)
                          ? ref.watch(startDateTimeProvider)
                          : ref.watch(endDateTimeProvider),
                      minuteInterval: 15,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDateTime) {
                        if (ifStart == true) {
                          newStartDateTime = newDateTime;
                        } else {
                          newEndDateTime = newDateTime;
                        }
                      },
                    ),
                  )
                ]);
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.close_outlined),
                onPressed: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      actions: <CupertinoActionSheetAction>[
                        CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('編集を破棄'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('キャンセル'),
                        ),
                      ],
                    ),
                  );
                }),
            Text((ref.watch(todoProvider).isEmpty) ? '予定の追加' : '予定の編集'),
            TextButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '保存',
                    style: TextStyle(
                      color: (ref.watch(ifEnableSaveProvider) == true)
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
                onPressed: () async {
                  if (ref.watch(ifEnableSaveProvider) == true) {
                    if (ref.watch(todoProvider).isEmpty) {
                      await ref.watch(databaseProvider).addTodo(
                            title: ref.watch(titleControllerProvider).text,
                            comment: ref.watch(commentControllerProvider).text,
                            ifAllDay: ref.watch(ifAllDayProvider),
                            startDateTime: (ref.watch(ifAllDayProvider) == true)
                                ? ref.watch(startDateProvider)
                                : ref.watch(startDateTimeProvider),
                            endDateTime: (ref.watch(ifAllDayProvider) == true)
                                ? ref.watch(endDateProvider)
                                : ref.watch(endDateTimeProvider),
                          );
                    } else {
                      await ref.watch(databaseProvider).updateTodo(
                            id: ref.watch(todoProvider)[0]!,
                            title: ref.watch(titleControllerProvider).text,
                            comment: ref.watch(commentControllerProvider).text,
                            ifAllDay: ref.watch(ifAllDayProvider),
                            startDateTime: (ref.watch(ifAllDayProvider) == true)
                                ? ref.watch(startDateProvider)
                                : ref.watch(startDateTimeProvider),
                            endDateTime: (ref.watch(ifAllDayProvider) == true)
                                ? ref.watch(endDateProvider)
                                : ref.watch(endDateTimeProvider),
                          );
                    }
                    Navigator.of(context).pop();
                  }
                }),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.grey.withOpacity(0.18),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    controller: ref.watch(titleControllerProvider),
                    autofocus: true,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: 'タイトルを入力してください',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
                      contentPadding: const EdgeInsets.all(24),
                    ),
                    onChanged: (text) {
                      validateSave();
                    },
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('終日'),
                        SizedBox(
                          height: 45,
                          width: 100,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SwitchListTile(
                              title: const Text(''),
                              value: ref.watch(ifAllDayProvider),
                              onChanged: (value) {
                                ref.read(ifAllDayProvider.notifier).state =
                                    !ref.watch(ifAllDayProvider);
                                validateSave();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('開始'),
                        GestureDetector(
                          onTap: () {
                            if (ref.watch(ifAllDayProvider) == true) {
                              showDatePicker(context, true);
                            } else {
                              showDateTimePicker(context, true);
                            }
                          },
                          child: Text(
                            (ref.watch(ifAllDayProvider) == true)
                                ? dateFormat
                                    .format(ref.watch(startDateProvider))
                                : dateTimeFormat
                                    .format(ref.watch(startDateTimeProvider)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('終了'),
                        GestureDetector(
                          onTap: () {
                            if (ref.watch(ifAllDayProvider) == true) {
                              showDatePicker(context, false);
                            } else {
                              showDateTimePicker(context, false);
                            }
                          },
                          child: Text(
                            (ref.watch(ifAllDayProvider) == true)
                                ? dateFormat.format(ref.watch(endDateProvider))
                                : dateTimeFormat
                                    .format(ref.watch(endDateTimeProvider)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    controller: ref.watch(commentControllerProvider),
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: 'コメントを入力してください',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
                      contentPadding: const EdgeInsets.all(24),
                    ),
                    onChanged: (text) {
                      validateSave();
                    },
                    minLines: 5,
                    maxLines: null,
                  ),
                ),
                (ref.watch(todoProvider).isEmpty)
                    ? Container()
                    : const SizedBox(height: 30),
                (ref.watch(todoProvider).isEmpty)
                    ? Container()
                    : GestureDetector(
                        onTap: () async {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('予定の削除'),
                                content: const Text('本当にこの予定を削除しますか？'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('キャンセル'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('削除'),
                                    onPressed: () async {
                                      await ref
                                          .watch(databaseProvider)
                                          .deleteTodo(
                                              ref.watch(todoProvider)[0]);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 45,
                          width: 1000,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'この予定を削除',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomPicker(Widget picker) {
    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
