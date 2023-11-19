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

  logWaterToFirestore(int millis) async {
    // save time the user drank water
    DateTime dateTime = DateTime.now();
    String docKey = "${dateTime.hour}:${dateTime.minute}";

    // add new value in firestore document with the key - time, and value - millis
    final docRef = db.collection("water_tracking").doc("jojo@mail.com");

    await docRef.update({
      docKey: millis.toString()
    });
  }

  Future<Map<String, dynamic>?> getWaterTrackingHistory() async {
    final docRef = db.collection("water_tracking").doc("jojo@mail.com");

    final doc  = await docRef.get();

    return doc.data();
  }
}