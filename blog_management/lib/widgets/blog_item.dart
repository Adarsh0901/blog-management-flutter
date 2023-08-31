import 'package:blog_management/model/blog_model.dart';
import 'package:blog_management/screens/blog_details.dart';
// import 'package:blog_management/screens/blog_details.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/rating_star.dart';
import 'package:flutter/material.dart';

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
    final GlobalKey tileKey = GlobalKey();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        key: tileKey,
        isThreeLine: true,
        onLongPress: () {
          showModalBottomSheet(
            enableDrag: true,
              context: context,
              builder: (ctx) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
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
              });
        },
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => BlogDetails(id: data.id, title: data.title),
            ),
          );
          getUpdatedData(option);
        },
        leading: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.15,
          child: GestureDetector(
            onTap: () {
              if (data.imageUrl.trim().isNotEmpty) {
                commonService.openImagePreview(
                    context, data.imageUrl, imageOptions.network);
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
        title: Text(data.title),
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
