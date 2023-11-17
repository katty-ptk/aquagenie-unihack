import 'package:bluetooth_classic_example/providers/auth.provider.dart';
import 'package:bluetooth_classic_example/utils/get_it.util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<AuthProvider>(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildPresentation(),

                  const SizedBox(height: 20,),

                  buildSignInForm(authProvider),
                ],
              ),
            )
          );
        }
      )
    );
  }

  Widget buildPresentation() {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(35),
              bottomLeft: Radius.circular(35),
          )
      ),
      
      child: Image.asset('lib/assets/images/cute_robot_face.png'),
    );
  }

  Widget buildSignInForm(AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
              initialValue: authProvider.emailText,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                label: const Text("email"),
                hintText: "example@mail.com",
              ),
              onChanged: (value) =>
                  authProvider.onEmailTextChanged(value)
          ),

          const SizedBox(
            height: 30,
          ),

          TextFormField(
            initialValue: authProvider.passwordText,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              label: const Text("password"),
              hintText: "******",
            ),
            obscureText: true,
            onChanged: (value) =>
                authProvider.onPasswordTextChanged(value),
          ),

          const SizedBox(height: 30,),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
              // side: BorderSide(color: Colors.yellow, width: 5),
              textStyle: const TextStyle(
                  color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: () async {
              await authProvider.signIn();

              if ( authProvider.userSignedIn ) {
                Navigator.pushNamed(context, '/bottomNavBar');
              }
            },
            child: const Text("sign in"),
          )
        ],
      ),
    );
  }
}
