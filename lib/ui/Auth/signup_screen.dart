import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasepractice/ui/Auth/login_screen.dart';
import 'package:firebasepractice/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void register() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage("Register successfully!");
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Sign up",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          // helperText: 'enter email e.g abc@xyz.com',
                          prefixIcon: Icon(Icons.alternate_email)),
                      validator: (input) =>
                          input!.isEmpty ? "Enter email" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Password',
                            // helperText: 'enter email e.g abc@xyz.com',
                            prefixIcon: Icon(Icons.password)),
                        validator: (input) =>
                            input!.isEmpty ? "Enter Password" : null),
                  ],
                )),
            const SizedBox(height: 50),
            RoundButton(
              title: 'Sign up',
              loading: loading,
              onTap: () {
                if (_formkey.currentState!.validate()) {
                  register();
                }
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text("Login"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
