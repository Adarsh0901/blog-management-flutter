import 'package:blog_management/services/api_services.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/rating_star.dart';
import 'package:flutter/material.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key, required this.id, required this.reviews});
  final String id;
  final List reviews;

  @override
  State<AddReview> createState() {
    return _AddReview();
  }
}

class _AddReview extends State<AddReview> {
  final _apiService = ApiService();
  final _commonService = CommonServices();
  final _reviewFormKey = GlobalKey<FormState>();
  String _name = '';
  String _review = '';
  double _rate = 0.0;
  bool _isSaving = false;

  void _saveItem() async {
    if (_reviewFormKey.currentState!.validate()) {
      _reviewFormKey.currentState!.save();
      try {
        setState(() {
          _isSaving = true;
        });
        var review = {
          'rTitle': _name,
          'rDescription': _review,
          'rTimeStamp': DateTime.now().toString(),
          'rating': _rate
        };

        widget.reviews.add(review);
        Map reviewData = {'reviews': widget.reviews};
        var response =
            await _apiService.patchCall(reviewData, '$blogs/${widget.id}');
        _updateRating();
        if (response['rTitle'] != null) {
          setState(() {
            _isSaving = false;
          });

          if (context.mounted) {
            _commonService.showMessage(context, 'Review Added', Colors.green);
            Navigator.of(context).pop({'isAdded': true});
          }
        }
      } catch (err) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _updateRating() async {
    try {
      double averageRating = _commonService.calculateRating(widget.reviews);
      Map rateData = {'rate': averageRating};
      await _apiService.patchCall(rateData, '$blogs/${widget.id}');
    } catch (err) {
      if (context.mounted) {
        _commonService.showMessage(context, err.toString(), Colors.red);
      }
    }
  }

  void _resetFields() {
    _reviewFormKey.currentState!.reset();
    setState(() {
      _rate = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 10,
            left: 10,
            right: 10),
        child: Form(
          key: _reviewFormKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Add Review',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    final pattern = RegExp(r'^[a-zA-Z ]+$');
                    if (value == null || value.isEmpty) {
                      return 'Name must not be empty';
                    } else if (!pattern.hasMatch(value)) {
                      return 'Name should only be alphabetical';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Review',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Review must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _review = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Rating(
                  isDisable: false,
                  rating: _rate,
                  size: 26,
                  onRatingChanged: (value) {
                    setState(() {
                      _rate = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving ? null : _resetFields,
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
                          : const Text('Add'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
