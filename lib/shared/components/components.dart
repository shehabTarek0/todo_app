import 'package:flutter/material.dart';

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
