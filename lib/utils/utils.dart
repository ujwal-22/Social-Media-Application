import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {

  final ImagePicker _imagePicker =  ImagePicker();

  // THIS WILL GET THE SELECTED FILE FROM THE DEVICE
  XFile? _file = await _imagePicker.pickImage(source: imageSource);
  if(_file != null){
    return _file.readAsBytes();
  }
  print("No image selected");

}

showSnackBar({required String content, required BuildContext context}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
      ),
    )
  );
}