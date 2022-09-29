// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_screen.dart';
import 'package:todo_app/modules/done_screen.dart';
import 'package:todo_app/modules/new_task_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class TodoLayoutScreen extends StatefulWidget {
  const TodoLayoutScreen({super.key});

  @override
  State<TodoLayoutScreen> createState() => _TodoLayoutScreenState();
}

class _TodoLayoutScreenState extends State<TodoLayoutScreen> {
  int currentIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isOpen = false;
  List<Widget> currentScreen = const [
    NewTaskScreen(),
    DoneScreen(),
    ArchivedScreen()
  ];
  List<String> title = ['New Tasks', 'Done Tasks', 'Archived tasks'];
  late Database db;
  var taskTiltleContoller = TextEditingController();
  var taskInfoContoller = TextEditingController();
  var taskTimeContoller = TextEditingController();
  var taskDateContoller = TextEditingController();
  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title[currentIndex],
        ),
        backgroundColor: const Color.fromARGB(255, 18, 148, 63),
      ),
      body: tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : currentScreen[currentIndex],
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isOpen = !isOpen;
              if (!isOpen) {
                if (formKey.currentState!.validate()) {
                  insertToDatabase(
                          title: taskTiltleContoller.text,
                          info: taskInfoContoller.text,
                          date: taskDateContoller.text,
                          time: taskTimeContoller.text)
                      .then((value) {
                    Navigator.pop(context);
                    taskTiltleContoller.text = '';
                    taskTimeContoller.text = '';
                    taskInfoContoller.text = '';
                    taskDateContoller.text = '';
                  }).catchError((e) {
                    print(e.toString());
                  });
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet((context) {
                      return buildBottomSheet();
                    })
                    .closed
                    .then((value) {
                      setState(() {
                        isOpen = !isOpen;
                      });
                    });
              }
            });
          },
          backgroundColor: const Color.fromARGB(255, 16, 176, 53),
          child: isOpen
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
              icon: Icon(Icons.archive_outlined, size: 27), label: 'Archived'),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
      ),
    );
  }

  Widget buildBottomSheet() => SingleChildScrollView(
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

  void createDatabase() async {
    db = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,info TEXT,date TEXT,time TEXT,status text)')
            .then((value) {
          print('table created');
        }).catchError((e) {
          print(e.toString());
        });
      },
      onOpen: (db) {
        print('database opened');
        getDataFromDatabase(db).then((value) {
          setState(() {
            tasks = value;
            print(tasks);
          });
        });
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required String info,
    required String date,
    required String time,
  }) async {
    return await db.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title,info,date,time,status) VALUES("$title","$info","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((e) {
        print(e.toString());
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(Database db) async {
    return await db.rawQuery("SELECT * FROM tasks");
  }

  Future deleteDatabasee() async {
    return await deleteDatabase('todo.db').then((value) {
      print('delete');
    });
  }
}
