import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasepractice/ui/Auth/login_screen.dart';
import 'package:firebasepractice/utils/utils.dart';
import 'package:flutter/material.dart';

import 'add_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Post "),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          // Expanded(
          //     child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //     return ListView.builder(
          //         itemCount: snapshot.data!.snapshot.children.length,
          //         itemBuilder: ((context, index) {
          //           return ListTile(title: Text("Hadi"));
          //         }));
          //   },
          // )),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title,
                                      snapshot.child('id').value.toString());
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text("Edit"),
                              )),
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref
                                      .child(
                                          snapshot.child('id').value.toString())
                                      .remove()
                                      .then((value) {
                                    Utils().toastMessage('Post deleted');
                                  }).onError((error, stackTrace) {
                                    Utils().toastMessage(error.toString());
                                  });
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text("Delete"),
                              ))
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(hintText: 'Edit'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      "title": editController.text.toString(),
                    }).then((value) {
                      Utils().toastMessage("Post Updated");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}
