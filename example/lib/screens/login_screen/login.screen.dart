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
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                        initialValue: authProvider.emailText,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Colors.greenAccent), //<-- SEE HERE
                          ),
                          label: Text("email"),
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
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Colors.greenAccent), //<-- SEE HERE
                        ),
                        label: Text("password"),
                        hintText: "******",
                      ),
                      obscureText: true,
                      onChanged: (value) =>
                          authProvider.onPasswordTextChanged(value),
                    ),

                    const SizedBox(height: 30,),

                    TextButton(
                      onPressed: () async {
                        await authProvider.signIn();

                        if ( authProvider.userSignedIn ) {
                          Navigator.pushNamed(context, '/bottomNavBar');
                        }
                      },
                      child: Text("sign in"),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }
}
