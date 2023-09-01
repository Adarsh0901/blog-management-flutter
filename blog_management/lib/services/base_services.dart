import 'package:blog_management/services/constants.dart';
import 'package:flutter/material.dart';

class BaseService{
  void showMessage(context,String msg, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        showCloseIcon: true,
        content: Text(msg),
      ),
    );
  }

  void openImagePreview(context, imageUrl, ImageOptions method){
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: SizedBox(
            width: width < 300 ? width*0.8 : 300,
            child: method == ImageOptions.network ? Image.network(
              imageUrl,
              fit: BoxFit.fill,
            ) : Image.file(imageUrl, fit: BoxFit.fill,),
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  Future openDialog(context, String title, String content) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes")),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> openDatePicker(context) async {
    final now = DateTime.now();
    final initialDate = DateTime(2001);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: initialDate,
        lastDate: now);


    return pickedDate;
  }

  Future openBottomModalSheet(context, Widget widget)async {
    return await showModalBottomSheet(
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return widget;
        });
  }

  double calculateRating(List reviews){
    double rate = 0.0;
    for(var i=0;i<reviews.length;i++){
      rate += reviews[i]['rating'];
    }
    return rate/reviews.length;
  }


}