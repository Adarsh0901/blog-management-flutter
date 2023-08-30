import 'dart:convert';
import 'dart:io';
import 'package:blog_management/model/blog_model.dart';
import 'package:blog_management/services/api_services.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final _apiService = ApiService();
  final _commonService = CommonServices();
  final _formKey = GlobalKey<FormState>();
  QuillController _controller = QuillController.basic();
  var _title = '';
  var _developedBy = '';
  var _isSaving = false;
  DateTime? _selectedDate;
  File? _selectedImage;

  void _openDatePicker() async {
    final now = DateTime.now();
    final initialDate = DateTime(2001);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: initialDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _selectedDate ??= DateTime.now();

      if (_selectedImage == null) {
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        // final imageUrl = await _apiService.uploadImage(_selectedImage!, _title, _developedBy, 'post');
        Map data = {
          'title': _title,
          'description': json.encode(_controller.document.toDelta().toJson()),
          'imageUrl': '',
          'author': _developedBy,
          'timeStamp': _selectedDate!.toString(),
          'rate': 0.0
        };
        var res = await _apiService.postCall(data, blogs);
        if (res['name'] != null) {
          _commonService.showMessage(context,
              'Successfully added blog $_title to the list', Colors.green);

          setState(() {
            _isSaving = false;
          });

          Navigator.of(context).pop(Blog(
              id: res['name'].toString(),
              title: _title,
              imageUrl: '',
              description: json.encode(_controller.document.toDelta().toJson()),
              author: _developedBy,
              timeStamp: _selectedDate!));
        }
      } catch (err) {
        _commonService.showMessage(context, err.toString(), Colors.red);
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Add a new blog'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                UserImagePicker(
                  onImagePicked: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      final pattern = RegExp(r'^[a-zA-Z ]+$');
                      if (value == null || value.isEmpty) {
                        return 'Title must not be empty';
                      } else if (!pattern.hasMatch(value)) {
                        return 'Title should only be alphabetical';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Developed By',
                    ),
                    validator: (value) {
                      final pattern = RegExp(r'^[a-zA-Z ]+$');
                      if (value == null || value.isEmpty) {
                        return 'Developed by must not be empty';
                      } else if (!pattern.hasMatch(value)) {
                        return 'Developed by should only be alphabetical';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _developedBy = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      QuillToolbar.basic(
                        controller: _controller,
                        showAlignmentButtons: true,
                        showSearchButton: false,
                      ),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: QuillEditor.basic(
                          padding: const EdgeInsets.all(10),
                          expands: true,
                          autoFocus: false,
                          controller: _controller,
                          readOnly: false, // true for view only mode
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(_selectedDate == null
                          ? 'No Date Selected'
                          : _commonService.formatDate.format(_selectedDate!)),
                      IconButton(
                        onPressed: _openDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                          _formKey.currentState!.reset();
                          setState(() {
                            _selectedDate = null;
                            _controller = QuillController.basic();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: _isSaving
                            ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(),
                        )
                            : const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}