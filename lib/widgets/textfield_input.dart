import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({Key? key, required this.textEditingController, required this.hintText, this.isPassword = false, required this.textInputType}) : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final bool isPassword;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {

    final inputborder  = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        border: inputborder,
        labelText: hintText,
        focusedBorder: inputborder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
