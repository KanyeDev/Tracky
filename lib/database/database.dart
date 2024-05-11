import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tracky/model/app_settings.dart';
import 'package:tracky/model/habits.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*
  SETUP
   */

//INITIALIZE DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationCacheDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

//save first date of app starting
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchData = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

//get first date of app staring
  Future<DateTime?> getFirstLauncDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchData;
  }

/*
CRUDE OPERATIONS
 */

//List of habits
  final List<Habit> currentHabit = [];

//Create Habit
  Future<void> addHabit(String habitName) async {
    //create new habit
    final newHabit = Habit()..name = habitName;

    //save to db

    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-read from db
    readHabits();
  }

//Read Habits
  Future<void> readHabits() async {
    //fetch all habit from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //feed to current habits
    currentHabit.clear();
    currentHabit.addAll(fetchedHabits);

    //update ui
    notifyListeners();
  }

//Update habit
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find specif habit
    final habit = await isar.habits.get(id);
    //update the completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        //if habit is completed , add the current date to completed date list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          //add current date if not already in the list
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }
        //if not completed, remove current date from the list
        else {
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }

        //save the updated habit
        await isar.habits.put(habit);
      });
    }
    //re-read from db
    readHabits();
  }

//Edit Habit name
  Future<void> updateHabitName(int id, String newName) async {
    //find the name
    final habit = await isar.habits.get(id);

    //update the name
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;

        //save updated habit back to the db
        await isar.habits.put(habit);
      });
    }

    //re-read
    readHabits();
  }

//Delete Habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    //re-read

    readHabits();
  }
}
