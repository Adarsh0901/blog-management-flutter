import 'dart:convert';
import 'package:blog_management/model/blog_model.dart';
import 'package:blog_management/services/api_services.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/add_review.dart';
import 'package:blog_management/widgets/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

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
      print(err);
    }
  }

  void _addReview()async {
    await showModalBottomSheet(
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return AddReview(id: _blogDetail!.id,reviews: _blogDetail!.reviews!,);
        });
    _loadData();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (_blogDetail != null) {
      content = SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: ()async{_loadData();},
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('Posted By: '),
                          Expanded(child: Text(_blogDetail!.author)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('Posted on: '),
                          Expanded(
                              child: Text(_commonService.formatDate
                                  .format(_blogDetail!.timeStamp))),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Rating(
                          isDisable: true,
                          rating: _blogDetail!.rate,
                        )),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Comments:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _addReview,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Comments'),
                        ),
                      ),
                    ),
                    if (_blogDetail!.reviews != null)
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
                                    child: Text(_blogDetail!.reviews![index]['rTitle'][0]),
                                    ),
                                ),
                                title: Text(
                                  _blogDetail!.reviews![index]['rTitle'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        _blogDetail!.reviews![index]['rDescription']),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        _commonService.formatDate.format(DateTime.parse(_blogDetail!.reviews![index]['rTimeStamp']))),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Rating(
                                      isDisable: true,
                                      rating: _blogDetail!.reviews![index]['rating'],
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
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
