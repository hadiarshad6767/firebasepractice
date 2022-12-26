import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasepractice/ui/Auth/login_phn_screen.dart';
import 'package:firebasepractice/ui/Auth/signup_screen.dart';
import 'package:firebasepractice/ui/posts/post_screen.dart';
import 'package:firebasepractice/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
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

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              "Login",
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
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    login();
                  }
                },
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: const Text("Sign up"))
                ],
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPhnScreen()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black)),
                  child: const Center(child: Text("Login with phone")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
