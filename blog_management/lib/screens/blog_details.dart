import 'dart:convert';
import 'package:blog_management/model/blog_model.dart';
import 'package:blog_management/services/api_services.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/add_review.dart';
import 'package:blog_management/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlogDetails extends StatefulWidget {
  const BlogDetails({super.key, required this.id, required this.title});
  final String id;
  final String title;

  @override
  State<BlogDetails> createState() {
    return _BlogDetailsState();
  }
}

class _BlogDetailsState extends State<BlogDetails> {
  final _apiService = ApiService();
  final _commonService = CommonServices();
  Blog? _blogDetail;
  QuillController _controller = QuillController.basic();

  // This function is used to load data of single blog once app is redirected to this screen
  void _loadData() async {
    try {
      Map response = await _apiService.getCall('$blogs/${widget.id}');
      setState(() {
        _blogDetail = Blog(
          id: widget.id,
          title: response['title'],
          description: response['description'],
          author: response['author'],
          imageUrl: response['imageUrl'],
          timeStamp: DateTime.parse(response['timeStamp']),
          reviews: response['reviews'] ?? [],
          rate: response['rate'] ?? 0.0,
        );
        _controller = QuillController(
          document: Document.fromJson(json.decode(_blogDetail!.description)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    } catch (err) {
      if (context.mounted) {
        _commonService.showMessage(context, err.toString(), Colors.red);
      }
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // A loader is shown until data is loaded from firebase
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (_blogDetail != null) {
      content = SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadData();
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // To show the title of the blog
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        _blogDetail!.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // To show the Image of the image
                  SizedBox(
                    height: 200,
                    child: Center(
                        child: _blogDetail!.imageUrl.trim().isNotEmpty
                            ? Image.network(_blogDetail!.imageUrl)
                            : const Text('No Image Found')),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // To show the description of the blog in QuillEditor readonly mode
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QuillEditor.basic(
                      controller: _controller,
                      readOnly: true,
                      autoFocus: false,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // To show the author of the blog
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.postedBy),
                        Expanded(child: Text(_blogDetail!.author)),
                      ],
                    ),
                  ),

                  // To show the published date of the blog
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.postedOn),
                        Expanded(
                            child: Text(_commonService.formatDate
                                .format(_blogDetail!.timeStamp))),
                      ],
                    ),
                  ),

                  // To show the rating of the Blog making use of custom Rating widget
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Rating(
                        isDisable: true,
                        rating: _blogDetail!.rate,
                      )),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.commentsHeading,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),

                  // Button to add comments to the blog
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await _commonService.openBottomModalSheet(
                              context,
                              AddReview(
                                id: _blogDetail!.id,
                                reviews: _blogDetail!.reviews!,
                              ));
                          _loadData();
                        },
                        icon: const Icon(Icons.add),
                        label: Text(AppLocalizations.of(context)!.addComments),
                      ),
                    ),
                  ),

                  // List of comments is shown when blog has comments
                  if (_blogDetail!.reviews != null)...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _blogDetail!.reviews!.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            isThreeLine: true,
                            leading: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.13,
                              width: MediaQuery.of(context).size.width * 0.13,
                              child: CircleAvatar(
                                radius: 40,
                                child: Text(
                                    _blogDetail!.reviews![index]['rTitle'][0]),
                              ),
                            ),
                            title: Text(
                              _blogDetail!.reviews![index]['rTitle'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_blogDetail!.reviews![index]
                                    ['rDescription']),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(_commonService.formatDate.format(
                                    DateTime.parse(_blogDetail!.reviews![index]
                                        ['rTimeStamp']))),
                                const SizedBox(
                                  height: 8,
                                ),
                                Rating(
                                  isDisable: true,
                                  rating: _blogDetail!.reviews![index]
                                      ['rating'],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(widget.title),
        ),
        body: content);
  }
}
