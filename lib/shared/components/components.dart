import 'package:flutter/material.dart';
import 'package:todo_app/layout/cubit/cubit.dart';

Widget defaultButton(
        {double width = double.infinity,
        Color backgroundColor = Colors.blue,
        required String text,
        required VoidCallback onPress,
        FontWeight fontw = FontWeight.w400,
        double height = 50,
        double radius = 0,
        bool toUpperCase = true}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
          onPressed: onPress,
          child: Text(
            toUpperCase ? text.toUpperCase() : text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: fontw,
                letterSpacing: 1.7),
          )),
    );

Widget defaultTextFormField(
        {required TextEditingController controller,
        required TextInputType inputType,
        required FormFieldValidator validator,
        String? text,
        String? labelText,
        GestureTapCallback? tap,
        int? numOfLines,
        InputBorder? border,
        Icon? prefix,
        Icon? suffix,
        VoidCallback? onPressedSuffix,
        bool enabel = true,
        ValueChanged? submit,
        bool isPassword = false}) =>
    TextFormField(
        onFieldSubmitted: submit,
        onTap: tap,
        enabled: enabel,
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        obscureText: isPassword,
        maxLines: numOfLines,
        decoration: InputDecoration(
            hintText: text,
            labelText: labelText,
            suffixIcon: suffix != null
                ? IconButton(onPressed: onPressedSuffix, icon: suffix)
                : null,
            prefixIcon: prefix,
            border: border));

Widget buildTaskItem(context, Map task) => Dismissible(
      key: Key(task['id'].toString()),
      direction: DismissDirection.horizontal,
      background: Container(
          alignment: Alignment.centerLeft,
          color: const Color.fromARGB(255, 223, 58, 58),
          child: const Icon(
            Icons.delete,
            size: 40,
            color: Color.fromARGB(255, 232, 231, 231),
          )),
      onDismissed: (direction) {
        AppCubit.get(context).deleteFromDatabasee(id: task['id']);
      },
      child: Padding(
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
                    IconButton(
                      onPressed: () {
                        AppCubit.get(context)
                            .updateDatabase(status: 'done', id: task['id']);
                      },
                      icon: const Icon(
                        Icons.check_box,
                        color: Color.fromARGB(255, 16, 170, 21),
                      ),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        AppCubit.get(context)
                            .updateDatabase(status: 'archived', id: task['id']);
                      },
                      icon: const Icon(Icons.archive_outlined, size: 30),
                      color: Colors.black54,
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
      ),
    );
