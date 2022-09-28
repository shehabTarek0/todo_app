// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_screen.dart';
import 'package:todo_app/modules/done_screen.dart';
import 'package:todo_app/modules/new_task_screen.dart';

class TodoLayoutScreen extends StatefulWidget {
  const TodoLayoutScreen({super.key});

  @override
  State<TodoLayoutScreen> createState() => _TodoLayoutScreenState();
}

class _TodoLayoutScreenState extends State<TodoLayoutScreen> {
  int currentIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOpen = false;
  List<Widget> currentScreen = const [
    NewTaskScreen(),
    DoneScreen(),
    ArchivedScreen()
  ];
  List<String> title = ['New Tasks', 'Done Tasks', 'Archived tasks'];
  late Database db;
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
      body: currentScreen[currentIndex],
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isOpen = !isOpen;
              if (!isOpen) {
                Navigator.pop(context);
              } else {
                scaffoldKey.currentState!.showBottomSheet((context) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    color: const Color.fromARGB(255, 43, 109, 90),
                  );
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

  void createDatabase() async {
    // ignore: unused_local_variable
    db = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status text)')
            .then((value) {
          print('table created');
        }).catchError((e) {
          print(e.toString());
        });
      },
      onOpen: (db) {
        print('database opened');
      },
    );
  }

  void insertToDatabase() {
    db.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES("GYM","15/2","5 pm","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((e) {
        print(e.toString());
      });
    });
  }
}
