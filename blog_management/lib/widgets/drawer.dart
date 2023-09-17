import 'package:blog_management/screens/create_blog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Drawers extends StatefulWidget {
  const Drawers({super.key});

  @override
  State<Drawers> createState() {
    return _DrawersState();
  }
}

class _DrawersState extends State<Drawers> {
  late final userDetail;
  @override
  void initState() {
    super.initState();
    userDetail = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: UserAccountsDrawerHeader(
              accountName: const Text('Adarsh Shukla'),
              accountEmail: Text(userDetail.email),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.blogFeed),
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const CreateBlogScreen()));
            },
            leading: const Icon(Icons.add),
            title: Text(AppLocalizations.of(context)!.addNewBlog),
          ),
          ListTile(
            onTap: (){
              FirebaseAuth.instance.signOut();
            },
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }
}
