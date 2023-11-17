import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<User?> login(String emailText, String passwordText) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailText,
          password: passwordText
      );

      if ( credential.user != null ) {
        return credential.user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      return null;
    } catch(e) {
      print(e);

      return null;
    }
    return null;
  }

  Future<User?> register(String emailText, String passwordText) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailText,
        password: passwordText,
      );

      if ( credential.user != null ) return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

      return null;
    } catch (e) {
      print(e);

      return null;
    }
    return null;
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}