import 'package:bluetooth_classic_example/providers/user.provider.dart';
import 'package:bluetooth_classic_example/services/user.service.dart';
import 'package:bluetooth_classic_example/utils/calculations.util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton()
class ProfileScreenProvider extends ChangeNotifier {
  UserProvider userProvider;

  bool showEnterProfileInfo = false;
  bool userExists = false;
  String userEmail = "";
  UserProfileData? userProfileData;

  bool loading = true;

  late int required_water_intake;

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

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("required_water_intake", userFromFirestore["required_water_intake"].toString());
      required_water_intake = userFromFirestore["required_water_intake"];
    }

    // calculate the amount of water the user should drink
    print("THIS USER SHOULD DRINK: ${CalculationUtil().calculateAmountOfWater(Gender().female, 89, ActivityLevel().active)}");
    
    loading = false;
    notifyListeners();
  }

  setUserExists(bool value) {
    userExists = value;
    notifyListeners();
  }

  double calculateAmountOfWater() {
    int gender;
    int weight;
    double activity_level;

    if ( this.gender == "F" ) {
      gender = Gender().female;
    } else if ( this.gender == "M" ) {
      gender = Gender().male;
    } else {
      gender = Gender().other;
    }

    weight = int.parse(this.weight);

    if ( this.activity_level == "not active" ) {
      activity_level = ActivityLevel().not_active;
    } else if ( this.activity_level == "active" ) {
      activity_level = ActivityLevel().active;
    } else {
      activity_level = ActivityLevel().extremely_active;
    }

    return gender * weight * activity_level;
  }

  createProfileForUser(
        String email,
        String username,
        String gender,
        int age,
        String weight,
        String height,
        String activity_level
  ) async {
    int required_water_intale = calculateAmountOfWater().round();

    final userToBeCreated = UserProfileData(
        email,
        username,
        gender,
        age,
        weight,
        height,
        activity_level,
        required_water_intale
    );

    var result = await UserService().createUserProfileInFirestore(userToBeCreated);
    setUserExists(true);

    print("added user: $result");
  }
}