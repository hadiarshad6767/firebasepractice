import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasepractice/ui/Auth/verify_code_screen.dart';
import 'package:firebasepractice/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class LoginPhnScreen extends StatefulWidget {
  const LoginPhnScreen({super.key});

  @override
  State<LoginPhnScreen> createState() => _LoginPhnScreenState();
}

class _LoginPhnScreenState extends State<LoginPhnScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(hintText: "+92 338167679"),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(
            height: 50,
          ),
          RoundButton(
              title: 'Login',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                _auth.verifyPhoneNumber(
                    phoneNumber: _phoneNumberController.text.toString(),
                    verificationCompleted: (_) {},
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificatiodId, int? token) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyCodeScreen(
                                    verificationId: verificatiodId,
                                  )));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    });
              })
        ]),
      ),
    );
  }
}
