import 'package:blog_management/model/blog_model.dart';
// import 'package:blog_management/screens/blog_details.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/rating_star.dart';
import 'package:flutter/material.dart';

class BlogItem extends StatelessWidget {
  const BlogItem(
      {super.key,
        required this.data,
        });
  final Blog data;
  // final FilterOption option;
  // final void Function(FilterOption option) getUpdatedData;

  @override
  Widget build(BuildContext context) {
    final commonService = CommonServices();
    final GlobalKey tileKey = GlobalKey();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        key: tileKey,
        isThreeLine: true,
        // onLongPress: () {
        //   List<PopupMenuEntry> options = [
        //     PopupMenuItem(
        //         onTap: () {
        //         },
        //         child:const Text('Add to favorite')
        //     ),
        //   ];
        //   commonService.showOptions(tileKey, context, options);
        // },
        onTap: () async {
          // await Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (ctx) => BlogDetails(id: data.id, title: data.title),
          //   ),
          // );
          // getUpdatedData(option);
        },
        leading: SizedBox(
          height: 60,
          width: 60,
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
              backgroundColor: Colors.grey,
              radius: 40,
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