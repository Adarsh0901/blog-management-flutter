import 'package:blog_management/main.dart';
import 'package:blog_management/services/constants.dart';
import 'package:flutter/material.dart';

class BaseService{
  // Function to show Success/Failure Msg
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

  // Function to open Image preview
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

  //Function to open confirmation dialog
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

  //Function to open Date picker
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

  // Function to open bottom Modal and show content sent in widget parameter
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

  //Function to calculate average rate from list of reviews
  double calculateRating(List reviews){
    double rate = 0.0;
    for(var i=0;i<reviews.length;i++){
      rate += reviews[i]['rating'];
    }
    return rate/reviews.length;
  }

  List<DropdownMenuItem> supportedLanguageList(){
    return const [
      DropdownMenuItem(value: 'en',child: Text('English')),
      DropdownMenuItem(value: 'hi',child: Text('Hindi')),
    ];
  }

  Widget dropdownButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButton(
        underline: const SizedBox(),
        items: supportedLanguageList(),
        onChanged: (value) {
          if(value != null){
            MyApp.setLocale(context, Locale(value));
          }
        },
        icon: Icon(Icons.language,color: Theme.of(context).colorScheme.onPrimary,),
      ),
    );
  }


}