import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return buildTaskItem(tasks[index]);
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget buildTaskItem(Map task) => Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 145, 211, 210),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${task["title"]}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 33, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${task["info"]}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(66, 66, 66, 1),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${task["time"]}',
                      style: const TextStyle(
                          fontSize: 20, color: Color.fromRGBO(66, 66, 66, 1)),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 202, 51, 51),
                      radius: 25,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete, size: 30),
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${task["date"]}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(66, 66, 66, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
