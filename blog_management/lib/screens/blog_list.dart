import 'dart:async';
import 'package:blog_management/model/blog_model.dart';
import 'package:blog_management/screens/create_blog.dart';
import 'package:blog_management/services/api_services.dart';
import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:blog_management/widgets/blog_item.dart';
import 'package:blog_management/widgets/drawer.dart';
import 'package:flutter/material.dart';

class BlogList extends StatefulWidget {
  const BlogList({super.key});
  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  late StreamController<List<Blog>> _blogStream;
  final _apiService = ApiService();
  final _commonService = CommonServices();
  FilterOptions option = FilterOptions.none;

  Future<List<Blog>> _getData() async {
    List<Blog> blogData = [];
    try {
      Map response = await _apiService.getCall(blogs);
      for (var item in response.entries) {
        blogData.add(
          Blog(
              id: item.key,
              title: item.value['title'],
              description: item.value['description'],
              author: item.value['author'],
              imageUrl: item.value['imageUrl'],
              timeStamp: DateTime.parse(item.value['timeStamp']),
              rate: item.value['rate'] ?? 0.0),
        );
      }
    } catch (err) {
      print(err);
    }
    return blogData;
  }

  void _initializeData() async {
    _blogStream.add(await _getData());
  }

  List<PopupMenuEntry> _openFilterMenu() {
    List<PopupMenuEntry> items = [
      PopupMenuItem(
        onTap: () {
          option = FilterOptions.ascending;
          _applyFilter(option);
        },
        value: FilterOptions.ascending,
        child: const Text("A-Z alphabetically"),
      ),
      PopupMenuItem(
        onTap: () {
          option = FilterOptions.descending;
          _applyFilter(option);
        },
        value: FilterOptions.descending,
        child: const Text("Z-A Alphabetically"),
      ),
      PopupMenuItem(
        onTap: () {
          option = FilterOptions.date;
          _applyFilter(option);
        },
        value: FilterOptions.date,
        child: const Text("Date"),
      ),
    ];

    return items;
  }

  void _applyFilter(FilterOptions option) async {
    List<Blog> data = await _getData();
    if (option == FilterOptions.ascending) {
      data.sort((a, b) => a.title.compareTo(b.title));
    } else if (option == FilterOptions.descending) {
      data.sort((a, b) => b.title.compareTo(a.title));
    } else if (option == FilterOptions.date) {
      data.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    }
    _blogStream.add(data);
  }

  void _removeBlog(Blog data) async {
    try{
      await _apiService.deleteImages(data.title, data.author);
      await _apiService.deleteCall('$blogs/${data.id}');
      _blogStream.add(await _getData());
    }catch(err){}
  }

  @override
  void initState() {
    _blogStream = StreamController();
    _initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text(appTitle),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.filter_alt),
              itemBuilder: (ctx) {
                return _openFilterMenu();
              }),
          IconButton(onPressed: () async  {
            final  data = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => CreateBlogScreen()));
            if(data != null){
              _initializeData();
            }
          }, icon: const Icon(Icons.add))
        ],
      ),
      drawer: const Drawers(),
      body: StreamBuilder(
        stream: _blogStream.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No Blogs Found'));
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong'));
          }

          return RefreshIndicator(
            onRefresh: ()async {_initializeData();},
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data?.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: Key('item ${snapshot.data![index]}'),
                  background: Container(
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text('Move to bin',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  onDismissed: (direction){
                    _removeBlog(snapshot.data![index]);
                  },
                  confirmDismiss: (DismissDirection direction) async {
                    return await _commonService.openDialog(context, 'Remove Blog',
                        'Delete Blog ${snapshot.data![index].title} from list');
                  },
                  child: BlogItem(data: snapshot.data![index], option: option, getUpdatedData: _applyFilter,),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
