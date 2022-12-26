import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasepractice/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../FirebaseServices/add_firestore_screen.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();
  final ref = FirebaseFirestore.instance.collection('users');

  final editController = TextEditingController();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("FireStore Data "),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text("Some Error");
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              // ref
                              //     .doc(snapshot.data!.docs[index]['id']
                              //         .toString())
                              //     .update({'title': "HADI"}).then((value) {
                              //   Utils().toastMessage("Data is updated");
                              // }).onError((error, stackTrace) {
                              //   Utils().toastMessage(error.toString());
                              // });
                              ref
                                  .doc(snapshot.data!.docs[index]['id']
                                      .toString())
                                  .delete()
                                  .then((value) {
                                Utils().toastMessage("Data is Deleted");
                              }).onError((error, stackTrace) {
                                Utils().toastMessage(error.toString());
                              });
                            },
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                          );
                        }),
                  );
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFireStoreScreen()));
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
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}
