import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lab_2/pages/homePage.dart';

class UserController{

  static User? user = FirebaseAuth.instance.currentUser;

  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;

    //signing in with firebase auth
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  static Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,

        title: const Text("Login page"),
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
              onPressed: () async {

                try {
                  final user = await UserController.loginWithGoogle();
                  if(user != null && mounted){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  }
                }
                on FirebaseAuthException catch(error){
                  print(error.message);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        error.message ?? "Something went wrong",
                      )
                    )
                  );
                }
                catch (e){
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        e.toString(),
                      )
                  )
                  );
                }



              },
              child: const Text("Continue with Google", style: TextStyle(fontSize: 18))
          ),
        ],
      ),
    );
  }
}