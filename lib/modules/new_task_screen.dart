import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        if (AppCubit.get(context).newtasks.isNotEmpty) {
          return ListView.builder(
            itemCount: AppCubit.get(context).newtasks.length,
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItem(
                  context, AppCubit.get(context).newtasks[index]);
            },
            physics: const BouncingScrollPhysics(),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu_outlined,
                  color: Colors.black45,
                  size: 70,
                ),
                Text(
                  'No Tasks Yet, Please Add Some Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          );
        }
      },
      listener: (context, state) {},
    );
  }
}
