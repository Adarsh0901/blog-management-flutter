import 'dart:convert';
import 'dart:io';
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
  final _createFormKey = GlobalKey<FormState>();
  QuillController _controller = QuillController.basic();
  String _title = '';
  String _author = '';
  DateTime? _selectedDate;
  File? _selectedImage;
  bool _isSaving = false;

  // Function to save item to the firebase
  void _saveItem() async {
    if (_createFormKey.currentState!.validate()) {
      _createFormKey.currentState!.save();
      _selectedDate ??= DateTime.now();

      if (_selectedImage == null) {
        _commonService.showMessage(
            context, 'Upload Image First', Colors.orange);
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        final imageUrl =
            await _apiService.uploadImages(_selectedImage!, _title, _author);
        Map data = {
          'title': _title,
          'description': json.encode(_controller.document.toDelta().toJson()),
          'imageUrl': imageUrl,
          'author': _author,
          'timeStamp': _selectedDate!.toString(),
          'rate': 0.0
        };
        var res = await _apiService.postCall(data, blogs);
        if (res != null) {
          setState(() {
            _isSaving = false;
          });

          if (context.mounted) {
            _commonService.showMessage(context,
                'Successfully added blog $_title to the list', Colors.green);

            Navigator.of(context).pop({'IsAdded': true});
          }
        }
      } catch (err) {
        if (context.mounted) {
          _commonService.showMessage(context, err.toString(), Colors.red);
        }
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Function to reset form Fields
  void _resetFormField() {
    _createFormKey.currentState!.reset();
    setState(() {
      _selectedDate = null;
      _controller = QuillController.basic();
      _selectedImage = null;
    });
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _createFormKey,
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
                        labelText: 'Author',
                      ),
                      validator: (value) {
                        final pattern = RegExp(r'^[a-zA-Z ]+$');
                        if (value == null || value.isEmpty) {
                          return 'Author name must not be empty';
                        } else if (!pattern.hasMatch(value)) {
                          return 'Author name should only be alphabetical';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _author = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                          ),
                          child: QuillToolbar.basic(
                            controller: _controller,
                            showAlignmentButtons: true,
                            showSearchButton: false,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
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
                          onPressed: () async {
                            var pickedDate =
                                await _commonService.openDatePicker(context);
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          },
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
                          onPressed: _isSaving ? null : _resetFormField,
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
      ),
    );
  }
}
