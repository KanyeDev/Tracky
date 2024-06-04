import 'package:cloud_firestore/cloud_firestore.dart';

class AppSettings {
  // Since Firestore doesn't support auto-increment IDs, we don't need an ID field here.

  DateTime? firstLaunchData;

  // Constructor for creating an AppSettings instance from Firestore document snapshot
  AppSettings.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    firstLaunchData = (snapshot['firstLaunchData'] as Timestamp?)?.toDate();
  }

  // Method to convert AppSettings instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'firstLaunchData': firstLaunchData != null ? Timestamp.fromDate(firstLaunchData!) : null,
    };
  }
}
