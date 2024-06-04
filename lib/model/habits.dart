import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String id = '';
  late String name;
  List<DateTime> completedDays = [];
  late String userID;

  Habit({required this.id, required this.name, required this.completedDays, required this.userID});

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: data['name'] ?? '',
      completedDays: (data['completedDays'] as List<dynamic>?)
          ?.map((e) => (e as Timestamp).toDate())
          .toList() ?? [],
      userID: data['userID'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'completedDays': completedDays.map((date) => Timestamp.fromDate(date)).toList(),
      'userID': userID,
    };
  }
}
