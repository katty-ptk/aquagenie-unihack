import 'package:bluetooth_classic_example/providers/auth.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class UserProvider extends ChangeNotifier {
  AuthProvider authProvider;
  String? userEmail;
  bool? userProfileExists;

  bool _showEnterProfileData = false;

  bool get showEnterProfileData => _showEnterProfileData;

  UserProvider(this.authProvider) {
    userEmail = authProvider.user?.email;
  }

  setShowEnterProfileData(bool value) {
    _showEnterProfileData = value;
    notifyListeners();
  }
}