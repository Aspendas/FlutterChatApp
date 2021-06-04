import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final Function(File pickedImage) imagePickFn;


  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File _pickedImage;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.getImage(source: ImageSource.camera, imageQuality: 50,); // change to gallery is opened gallery
    setState(() {
      if(pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      }
    });
    widget.imagePickFn(_pickedImage);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
            backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Profile Image"),
        ),
      ],
    );
  }
}
