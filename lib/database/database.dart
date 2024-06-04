import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracky/utility/toast.dart';
import '../model/habits.dart';

class HabitDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get habitsCollection => _firestore.collection('habits');

  Stream<List<Habit>> readHabits() {
    final userID = _auth.currentUser?.uid;
    if (userID == null) {
      return Stream.value([]);
    }

    return habitsCollection
        .where('userID', isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList());
  }

  Future<void> addHabit(String habitName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Convert the new habit name to lowercase
      final habitNameLowercase = habitName.toLowerCase();

      // Check if the habit with the same name already exists for the current user
      final existingHabit = await _firestore
          .collection('habits')
          .where('userID', isEqualTo: user.uid)
          .get();

      // Check if any of the existing habits has the same name (case-insensitive)
      final habitExists = existingHabit.docs.any((doc) {
        final name = (doc.data())['name'] as String;
        return name.toLowerCase() == habitNameLowercase;
      });

      if (!habitExists) {
        // Habit with the same name does not exist, so add the new habit
        await _firestore.collection('habits').add({
          'userID': user.uid,
          'name': habitName,
          'completedDays': [],
        });
      } else {
        // Habit with the same name already exists, alert the user
        Utility().toastMessage('The task "$habitName" already exists.');
      }
    }
  }


  Future<void> updateHabitName(String id, String newName) async {
    await habitsCollection.doc(id).update({'name': newName});
  }

  Future<void> deleteHabit(String id) async {
    await habitsCollection.doc(id).delete();
  }

  void toggleHabit(Habit habit) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (habit.completedDays.any((date) =>
      date.year == todayDate.year &&
          date.month == todayDate.month &&
          date.day == todayDate.day)) {
        // Remove today's date (mark as undone)
        habit.completedDays.removeWhere((date) =>
        date.year == todayDate.year &&
            date.month == todayDate.month &&
            date.day == todayDate.day);
      } else {
        // Add today's date (mark as done)
        habit.completedDays.add(todayDate);
      }

      // Update the habit in Firestore
      await _firestore.collection('habits').doc(habit.id).update({
        'completedDays': habit.completedDays.map((date) => Timestamp.fromDate(date)).toList(),
      });
    }
  }


  Future<DateTime?> getFirstLaunchDate() async {
    final settingsDoc = await _firestore.collection("Users").doc(_auth.currentUser!.uid).get();
    if (settingsDoc.exists) {
      final data = settingsDoc.data() as Map<String, dynamic>;
      return (data['firstLaunchDate'] as Timestamp).toDate();
    }
    return null;
  }
}
