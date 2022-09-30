// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';

// ignore: must_be_immutable
class TodoLayoutScreen extends StatelessWidget {
  TodoLayoutScreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var taskTiltleContoller = TextEditingController();
  var taskInfoContoller = TextEditingController();
  var taskTimeContoller = TextEditingController();
  var taskDateContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                AppCubit.get(context).title[AppCubit.get(context).currentIndex],
              ),
              backgroundColor: const Color.fromARGB(255, 18, 148, 63),
            ),
            body: AppCubit.get(context)
                .currentScreen[AppCubit.get(context).currentIndex],
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (AppCubit.get(context).isOpen) {
                    if (formKey.currentState!.validate()) {
                      AppCubit.get(context)
                          .insertToDatabase(
                              title: taskTiltleContoller.text,
                              info: taskInfoContoller.text,
                              date: taskDateContoller.text,
                              time: taskTimeContoller.text)
                          .then((value) {
                        taskTiltleContoller.text = '';
                        taskInfoContoller.text = '';
                        taskDateContoller.text = '';
                        taskTimeContoller.text = '';
                      });
                    }
                  } else {
                    AppCubit.get(context).changeBottomSheet();
                    scaffoldKey.currentState!
                        .showBottomSheet((context) {
                          return buildBottomSheet(context);
                        })
                        .closed
                        .then((value) {
                          AppCubit.get(context).changeBottomSheet();
                          taskTiltleContoller.text = '';
                          taskInfoContoller.text = '';
                          taskDateContoller.text = '';
                          taskTimeContoller.text = '';
                        });
                  }
                },
                backgroundColor: const Color.fromARGB(255, 16, 176, 53),
                child: AppCubit.get(context).isOpen
                    ? const Icon(Icons.add)
                    : const Icon(Icons.edit_note_rounded)),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: const Color.fromARGB(255, 18, 148, 63),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu_rounded, size: 27), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_all, size: 27), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined, size: 27),
                    label: 'Archived'),
              ],
              onTap: (index) {
                AppCubit.get(context).changeBottom(index);
              },
              currentIndex: AppCubit.get(context).currentIndex,
            ),
          );
        },
        listener: (context, state) {
          if (state is AppDatabaseInstertedState) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget buildBottomSheet(context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.grey[200],
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                defaultTextFormField(
                    labelText: 'Task Tiltle',
                    controller: taskTiltleContoller,
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter the Task Title';
                      }
                      return null;
                    },
                    prefix: const Icon(Icons.title_outlined),
                    border: const OutlineInputBorder()),
                const SizedBox(
                  height: 20,
                ),
                defaultTextFormField(
                    labelText: 'Task Info',
                    controller: taskInfoContoller,
                    inputType: TextInputType.text,
                    numOfLines: 3,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter the Task Info';
                      }
                      return null;
                    },
                    prefix: const Icon(Icons.info_outline_rounded),
                    border: const OutlineInputBorder()),
                const SizedBox(
                  height: 20,
                ),
                defaultTextFormField(
                    labelText: 'Task Time',
                    controller: taskTimeContoller,
                    inputType: TextInputType.datetime,
                    tap: () {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((value) {
                        taskTimeContoller.text =
                            value!.format(context).toString();
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter the Task Time';
                      }
                      return null;
                    },
                    prefix: const Icon(Icons.watch_later_outlined),
                    border: const OutlineInputBorder()),
                const SizedBox(
                  height: 20,
                ),
                defaultTextFormField(
                    labelText: 'Task Date',
                    controller: taskDateContoller,
                    inputType: TextInputType.datetime,
                    tap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2023-12-31'))
                          .then((value) {
                        taskDateContoller.text =
                            DateFormat.yMMMd().format(value!);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter the Task Date';
                      }
                      return null;
                    },
                    prefix: const Icon(Icons.edit_calendar_outlined),
                    border: const OutlineInputBorder()),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
}
