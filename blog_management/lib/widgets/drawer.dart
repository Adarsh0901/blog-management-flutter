import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            title: const Text('Blog Feed'),
          ),
          const ListTile(
            leading: Icon(Icons.account_box),
            title: Text('Your Blogs'),
          ),
         const  ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorite Blogs'),
          ),
          ListTile(
            onTap: (){
              FirebaseAuth.instance.signOut();
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout user'),
          ),
        ],
      ),
    );
  }
}
