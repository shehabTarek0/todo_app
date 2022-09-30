// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/modules/archived_screen.dart';
import 'package:todo_app/modules/done_screen.dart';
import 'package:todo_app/modules/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> currentScreen = const [
    NewTaskScreen(),
    DoneScreen(),
    ArchivedScreen()
  ];
  List<String> title = ['New Tasks', 'Done Tasks', 'Archived tasks'];
  bool isOpen = false;

  late Database db;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  void changeBottom(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  void changeBottomSheet() {
    isOpen = !isOpen;
    print(isOpen);
    emit(AppChangeBottomState());
  }

  void createDatabase() {
    openDatabase(
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
        getDataFromDatabase(db);
      },
    ).then((value) {
      db = value;
      emit(AppDatabaseCreatedState());
    });
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
        emit(AppDatabaseInstertedState());
        getDataFromDatabase(db);
      }).catchError((e) {
        print(e.toString());
      });
    });
  }

  void getDataFromDatabase(Database db) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    db.rawQuery("SELECT * FROM tasks").then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          newtasks.add(element);
          // print(newtasks);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
          print(donetasks);
        } else {
          archivedtasks.add(element);
        }
      }
      emit(AppDatabaseGetState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) {
    db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then(
        (value) {
      emit(AppDatabaseUpdatedState());
      getDataFromDatabase(db);
    });
  }

  void deleteFromDatabasee({required int id}) {
    db.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDatabaseDeletedState());
      getDataFromDatabase(db);
    });
  }
}
