import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {

  final db = FirebaseFirestore.instance;

  Future<bool> checkIfUserExists(String userEmail) async {
    final docRef = db.collection("users").doc(userEmail);

    docRef.get().then((doc) {
      if (doc.exists) return true;
    }
    );

    return false;
  }
}