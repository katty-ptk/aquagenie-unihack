import 'package:bluetooth_classic_example/services/auth.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class AuthProvider extends ChangeNotifier {
  bool _userSignedIn = false;
  bool get userSignedIn => _userSignedIn;
  setUserSignedIn( bool newValue ) {
    _userSignedIn = newValue;
    notifyListeners();
  }

  User? user;

  String emailText = "jojo@mail.com";
  onEmailTextChanged( String newEmailText ) {
    emailText = newEmailText;
    notifyListeners();
  }

  String passwordText = "as23df45";
  onPasswordTextChanged( String newPasswordText ) {
    passwordText = newPasswordText;
    notifyListeners();
  }

  bool userProfileExists = false;
  bool showEnterProfileData = false;
  setShowEnterProfileData(bool value) {
    showEnterProfileData = value;
  }

  String dateOfBirth = "";
  setDateOfBirth(String value) => dateOfBirth = value;

  String selectedWeight = "";
  setSelectedWeight(String value) => selectedWeight = value;

  bool showWeightPicker = false;
  setShowWeightPicker(bool value) => showWeightPicker = value;

  signIn() async {
    User? loginResponse = await AuthService().login(emailText, passwordText);
    if ( loginResponse != null) {
      // we have user logged in
      print("user signed in successfuly");
      user = loginResponse;
      setUserSignedIn(true);
    } else {
      User? registerResponse = await AuthService().register(emailText, passwordText);

      if ( registerResponse != null ) {
        // we have created a new user
        print("user registered successfuly");
        user = registerResponse;
        setUserSignedIn(true);
      } else {
        print("user could not sign in");
        user = null;
        setUserSignedIn(false);
      }
    }

    notifyListeners();
  }

  signOut() async {
    await AuthService().signOut();

    user = null;
    setUserSignedIn(false);
    emailText = "";
    passwordText = "";
    notifyListeners();
  }
}