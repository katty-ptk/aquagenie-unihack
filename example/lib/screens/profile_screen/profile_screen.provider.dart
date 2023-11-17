import 'package:bluetooth_classic_example/providers/user.provider.dart';
import 'package:bluetooth_classic_example/services/user.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProfileScreenProvider extends ChangeNotifier {
  UserProvider userProvider;

  bool showEnterProfileInfo = false;
  bool userExists = false;
  String userEmail = "";
  UserProfileData? userProfileData;

  bool loading = true;

  // user data
  String username = "";
  onUsernameChanged(String newUsername) {
    username = newUsername;
    notifyListeners();
  }

  String gender = "F";
  onGenderChanged(String newGender) {
    gender = newGender;
    notifyListeners();
  }

  DateTime dateOfBirth = DateTime.now();
  int age = 0;
  onDateOfBirthChanged(DateTime newDateOfBirth) {
    dateOfBirth = newDateOfBirth;
    age = calculateAge(dateOfBirth);
    print("age is: $age");
    notifyListeners();
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String weight = "";
  onWeightChanged(String newWeight) {
    weight = newWeight;
    notifyListeners();
  }

  String height = "";
  onHeightChanged(String newHeight){
    height = newHeight;
    notifyListeners();
  }

  String activity_level = "not active";
  onActivityLevelChanged(String newActivityLevel) {
    activity_level = newActivityLevel;
    notifyListeners();
  }

  ProfileScreenProvider(
      this.userProvider
  ) {
    initProvider();
  }

  setShowEnterProfileInfo(bool value) {
    showEnterProfileInfo = value;
    notifyListeners();
  }

  initProvider() async {
    userEmail = userProvider.authProvider.user!.email!;

    DocumentSnapshot<Map<String, dynamic>>? userFromFirestore = await UserService().getUserDataFromFirestore(userProvider.authProvider.user!);
    if ( userFromFirestore != null && userFromFirestore.exists ) {
      userExists = true;

      userProfileData = UserProfileData(
          userFromFirestore["email"],
          userFromFirestore["username"],
          userFromFirestore["gender"],
          userFromFirestore["age"],
          userFromFirestore["weight"],
          userFromFirestore["height"],
          userFromFirestore["activity_level"],
          userFromFirestore["required_water_intake"]
      );
    }
    
    loading = false;
    notifyListeners();
  }

  setUserExists(bool value) {
    userExists = value;
    notifyListeners();
  }

  createProfileForUser(
        String email,
        String username,
        String gender,
        int age,
        String weight,
        String height,
        String activity_level,
        int required_water_intake
  ) async {
    final userToBeCreated = UserProfileData(
        email,
        username,
        gender,
        age,
        weight,
        height,
        activity_level,
        required_water_intake
    );

    var result = await UserService().createUserProfileInFirestore(userToBeCreated);
    setUserExists(true);
    print("added user: $result");
  }
}