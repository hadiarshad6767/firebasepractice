import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasepractice/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(hintText: "6 digit code"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 50,
          ),
          RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: _phoneNumberController.text.toString());
                try {
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PostScreen()));
                } catch (e) {
                  Utils().toastMessage(e.toString());
                }
              })
        ]),
      ),
    );
  }
}
