import 'package:blog_management/model/blog_model.dart';
import 'package:blog_management/screens/blog_details.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/rating_star.dart';
import 'package:flutter/material.dart';


// This is Stateless widget used just to show individual blog
class BlogItem extends StatelessWidget {
  const BlogItem({
    super.key,
    required this.data,
    required this.option,
    required this.getUpdatedData,
  });
  final Blog data;
  final FilterOptions option;
  final void Function(FilterOptions option) getUpdatedData;

  @override
  Widget build(BuildContext context) {
    final commonService = CommonServices();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        isThreeLine: true,

        // This method is called to when user long press an individual blog
        onLongPress: () {
          Widget widget = Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      data.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('Add to Favorite'),
                  ),
                ],
              ),
            ),
          );
          commonService.openBottomModalSheet(context, widget);
        },

        // This method is called and user is redirected to the detail page after user tap on the blog
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => BlogDetails(id: data.id, title: data.title),
            ),
          );
          getUpdatedData(option);
        },

        // leading is used to show the image of the blog
        leading: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.15,
          child: GestureDetector(
            // This method is used to display the preview of the image once user tap on the image
            onTap: () {
              if (data.imageUrl.trim().isNotEmpty) {
                commonService.openImagePreview(
                    context, data.imageUrl, ImageOptions.network);
              }
            },
            child: CircleAvatar(
              foregroundImage: data.imageUrl.trim().isNotEmpty
                  ? NetworkImage(data.imageUrl)
                  : null,
              radius: 40,
              child: Text(data.title[0].toUpperCase()),
            ),
          ),
        ),

        // Title of the Blog
        title: Text(data.title),

        // Subtitle and date of the blog published
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.author),
            Row(
              children: [
                Expanded(
                  child: Text(commonService.formatDate.format(data.timeStamp)),
                ),
                Expanded(
                  child: Rating(
                    isDisable: true,
                    rating: data.rate,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
