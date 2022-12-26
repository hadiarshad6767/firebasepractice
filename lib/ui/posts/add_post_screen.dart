import 'package:firebase_database/firebase_database.dart';
import 'package:firebasepractice/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final databseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Post")),
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
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                databseRef.child(id).set({
                  'title': postController.text.toString(),
                  'id': id
                }).then((value) {
                  Utils().toastMessage('Post added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              })
        ]),
      ),
    );
  }
}
