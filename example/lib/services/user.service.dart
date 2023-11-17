import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileData {
  String email;
  String activity_level;
  int age;
  String height;
  int required_water_intake;
  String username;
  String weight;
  String gender;

  UserProfileData(
      this.email,
      this.username,
      this.gender,
      this.age,
      this.weight,
      this.height,
      this.activity_level,
      this.required_water_intake
  );
}

class UserService {
  /// CHECK IF LOGGED IN USER HAS DATA ENTERED IN FIRESTORE
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDataFromFirestore(User userToCheck) async {

    final db = FirebaseFirestore.instance;

    var docRef = db.collection("users").doc(userToCheck.email);
    DocumentSnapshot<Map<String, dynamic>>? document;

    document = await docRef.get();

    return document;
  }

  createUserProfileInFirestore(UserProfileData userProfileData) async {
    final db = FirebaseFirestore.instance;

    final data = {
      "email": userProfileData.email,
      "username": userProfileData.username,
      "gender": userProfileData.gender,
      "age": userProfileData.age,
      "weight": userProfileData.weight,
      "height": userProfileData.height,
      "activity_level": userProfileData.activity_level,
      "required_water_intake": userProfileData.required_water_intake
    };

    var docRef = await db
                  .collection("users")
                  .doc(userProfileData.email)
                  .set(data);

    return docRef;
  }
}