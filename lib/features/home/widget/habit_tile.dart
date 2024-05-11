import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  const HabitTile(
      {super.key,
      required this.isCompleted,
      required this.text,
      required this.onChanged,
      required this.editHabit,
      required this.deleteHabit});

  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            //edit
            SlidableAction(
              borderRadius: BorderRadius.circular(10),
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
            ),

            //delete
            SlidableAction(
              borderRadius: BorderRadius.circular(10),
              onPressed: deleteHabit,
              backgroundColor: Colors.red,
              icon: Icons.delete,
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          child: Card(
            elevation: 5,
            color: isCompleted
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.primary,
            child: SizedBox(height: MediaQuery.of(context).size.height/13,
              child: Center(
                child: ListTile(
                  title: Text(
                    text,
                    style: TextStyle(
                        color: isCompleted
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.surface),
                  ),
                  leading: Checkbox(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary, width: 2.5),
                    activeColor: Theme.of(context).colorScheme.inversePrimary,
                    value: isCompleted,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
