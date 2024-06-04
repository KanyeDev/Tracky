import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracky/core/screen_size/mediaQuery.dart';

import '../../../database/database.dart';
import '../../../model/habits.dart';
import '../../home/widget/habit_tile.dart';
import '../widget/task_shimmer_loading.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }




  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            child: const Text("Update"),
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
          ),
          MaterialButton(
            child: const Text("Clear"),
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
          ),
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
            child: const Text("Delete"),
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
      await FirebaseFirestore.instance.collection('habits').doc(habit.id).update({
        'completedDays': habit.completedDays.map((date) => Timestamp.fromDate(date)).toList(),
      });
    }
  }

  void createHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create New Habit"),
        ),
        actions: [
          MaterialButton(
            child: const Text("Add"),
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().addHabit(newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
          ),
          MaterialButton(
            child: const Text("Clear"),
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDb = context.watch<HabitDatabase>();
    return StreamBuilder<List<Habit>>(
      stream: habitDb.readHabits(), // Assuming readHabits() returns a stream of habits
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final habits = snapshot.data!;
          return ListView.builder(
            itemCount: habits.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final habit = habits[index];
              final isCompletedToday = habit.completedDays.any((date) {
                final today = DateTime.now();
                return date.year == today.year && date.month == today.month && date.day == today.day;
              });

              return HabitTile(
                isCompleted: isCompletedToday,
                text: habit.name,
                onChanged: (value) => toggleHabit(habit),
                editHabit: (context) => editHabitBox(habit),
                deleteHabit: (context) => deleteHabitBox(habit),
              );
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();


          //   ListView.builder(
          //   itemCount: 8,
          //   scrollDirection: Axis.vertical,
          //   itemBuilder: (context, index) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25),
          //       child: subjectShimmerLoading(70, MediaQuery.of(context).size.width -30),
          //     );
          //   },
          // );
        }
        else if (!snapshot.hasData) {
          return Text('Add Tasks to start tracking');
        }
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(height: getHeight(context), width: getWidth(context),
        child: Stack(
          children: [
            //Task List Text
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 10),
              child: Text(
                "Task List",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            //Build habit widget
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: _buildHabitList(),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
               shape: const CircleBorder(),
               onPressed: createHabit,
               elevation: 0,
               backgroundColor: Theme.of(context).colorScheme.secondary,
               child:  Icon(Icons.add, color: Theme.of(context).colorScheme.surface,),
                              ),
            ),
          ],
        ),
      ),
    );
  }
}
