import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../model/habits.dart';
import '../../home/widget/habit_tile.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

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

  //edit habit
  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            //save
            MaterialButton(
                child: const Text("Update"),
                onPressed: () {
                  //get name
                  String newHabitName = textController.text;
                  //save to db
                  context
                      .read<HabitDatabase>()
                      .updateHabitName(habit.id, newHabitName);

                  //close
                  Navigator.pop(context);

                  //clear controller
                  textController.clear();
                }),

            //cancel btn
            MaterialButton(
                child: const Text("Clear"),
                onPressed: () {
                  Navigator.pop(context);
                  textController.clear();
                })
          ],
        ));
  }
  //delete habit
  void deleteHabitBox(Habit habit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Are you sure you want to delete?"),
          actions: [
            //save
            MaterialButton(
                child: const Text("delete"),
                onPressed: () {
                  //delete
                  context.read<HabitDatabase>().deleteHabit(habit.id);

                  //close
                  Navigator.pop(context);
                }),

            //cancel btn
            MaterialButton(
                child: const Text("Clear"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ));
  }


  void toggleHabit(bool? value, Habit habit) {
    //update habit completion
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }


  bool isHabitCompletedToday(List<DateTime> completedDays) {
    final today = DateTime.now();
    return completedDays.any((date) =>
    date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  Widget _buildHabitList() {
    final habitDb = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDb.currentHabit;

    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        //physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //get each habits
          final habit = currentHabits[index];

          //check if habits is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          //return habit title UI
          return HabitTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) => toggleHabit(value, habit),
            editHabit: (context) => editHabitBox(habit),
            deleteHabit: (context) => deleteHabitBox(habit),
          );
        });
  }


  void createHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Create New habit"),
          ),
          actions: [
            //save
            MaterialButton(
                child: const Text("Add"),
                onPressed: () {
                  //get name
                  String newHabitName = textController.text;
                  //save to db
                  context.read<HabitDatabase>().addHabit(newHabitName);

                  //close
                  Navigator.pop(context);

                  //clear controller
                  textController.clear();
                }),

            //cancel btn
            MaterialButton(
                child: const Text("Clear"),
                onPressed: () {
                  Navigator.pop(context);
                  textController.clear();
                })
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(

        children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 10),
          child: Text("Task List", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),),
        ),
        //HABIT
          Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 80),
            child: _buildHabitList(),
          ),
        Positioned(bottom: 90, right: 30,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: createHabit,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],),
    );

  }
}
