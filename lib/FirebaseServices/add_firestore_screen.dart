import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasepractice/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AddFireStoreScreen extends StatefulWidget {
  const AddFireStoreScreen({super.key});

  @override
  State<AddFireStoreScreen> createState() => _AddFireStoreScreenState();
}

class _AddFireStoreScreenState extends State<AddFireStoreScreen> {
  final firestore = FirebaseFirestore.instance.collection('users');
  bool loading = false;
  final postController = TextEditingController();
  final databseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add FireStore Data")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            maxLines: 4,
            controller: postController,
            decoration: const InputDecoration(
                hintText: "What is in your mind?",
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
              title: "Add",
              loading: loading,
              onTap: () {
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                setState(() {
                  loading = true;
                });
                firestore.doc(id).set({
                  'title': postController.text.toString(),
                  'id': id
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage("Post Data Added");
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              })
        ]),
      ),
    );
  }
}
