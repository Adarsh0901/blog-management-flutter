import 'dart:io';

import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onImagePicked});
  final void Function(File pickedImage) onImagePicked;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final _commonService = CommonServices();
  File? _pickedImage;

  List<PopupMenuEntry> _showOptions() {
    List<PopupMenuEntry> item = [
      PopupMenuItem(
        onTap: () {
          _pickImage(ImageSource.gallery);
        },
        child: const Text("From Gallery"),
      ),
      PopupMenuItem(
        onTap: () {
          _pickImage(ImageSource.camera);
        },
        child: const Text("From Camera"),
      ),
    ];

    return item;
  }

  void _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker()
        .pickImage(source: source, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    widget.onImagePicked(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            if(_pickedImage != null){
              _commonService.openImagePreview(context, _pickedImage, imageOptions.file);
            }
          },
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            foregroundImage:
                _pickedImage != null ? FileImage(_pickedImage!) : null,
          ),
        ),
        PopupMenuButton(
            child: TextButton.icon(onPressed: null, icon: Icon(Icons.image), label: Text('Add Image')),
            itemBuilder: (ctx) {
              return _showOptions();
            })
      ],
    );
  }
}
