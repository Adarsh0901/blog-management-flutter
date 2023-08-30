import 'package:blog_management/services/constants.dart';
import 'package:flutter/material.dart';

class BaseService{

  void openImagePreview(context, imageUrl, imageOptions method){
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: SizedBox(
            width: width * 0.8,
            child: method == imageOptions.network ? Image.network(
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


}