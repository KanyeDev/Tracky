
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:tracky/core/screen_size/mediaQuery.dart';
 import '../../../database/database.dart';
import '../../../model/habits.dart';
import '../../tasks/widget/task_shimmer_loading.dart';
import '../widget/heatmap.dart';
import '../widget/pieChartView.dart';


class HeatMapPage extends StatefulWidget {
  const HeatMapPage({Key? key}) : super(key: key);

  @override
  State<HeatMapPage> createState() => _HeatMapPageState();
}

class _HeatMapPageState extends State<HeatMapPage> with SingleTickerProviderStateMixin{
  int touchedIndex = 0;

  DateTime? _selectedDate;
  List<Habit> _tasksForSelectedDate = [];

  late TabController _tabController;

  late String userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    userId = FirebaseAuth.instance.currentUser!.uid; // Example way to get the current userId
  }

@override
void dispose() {
  _tabController.dispose();
  super.dispose();
}

  Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
    final Map<DateTime, int> dataset = {};

    for (var habit in habits) {
      for (var date in habit.completedDays) {
        final normalizedDate = DateTime(date.year, date.month, date.day);
        if (dataset.containsKey(normalizedDate)) {
          dataset[normalizedDate] = dataset[normalizedDate]! + 1;
        } else {
          dataset[normalizedDate] = 1;
        }
      }
    }
    return dataset;
  }


  Widget _buildHeatMap(HabitDatabase habitDatabase) {
    return StreamBuilder<List<Habit>>(
      stream: habitDatabase.readHabits(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          final habits = snapshot.data!;
          return FutureBuilder<DateTime?>(
            future: habitDatabase.getFirstLaunchDate(),
            builder: (context, dateSnapshot) {
              if (dateSnapshot.hasData) {
                return MyHeatMap(

                  startDate: dateSnapshot.data!,
                  dataset: prepHeatMapDataset(habits), onClick: (date) => _onDateSelected(date),
                );
              } else {
                return subjectShimmerLoading(getHeight(context)/3.5, getWidth(context));
              }
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 0),
                child: subjectShimmerLoading(getHeight(context)/3, getWidth(context)),
              );

        }
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 0),
            child: subjectShimmerLoading(getHeight(context)/3, getWidth(context)),
          );
        }
      },
    );
  }

  void _onDateSelected(DateTime date) async {
    setState(() {
      _selectedDate = date;
    });

    // Fetch tasks for the selected date from Firestore
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('habits')
        .where('userID', isEqualTo: userId)
        .get();

    final tasksForDate = querySnapshot.docs
        .map((doc) => Habit.fromFirestore(doc))
        .where((habit) =>
        habit.completedDays.contains(DateTime(date.year, date.month, date.day)))
        .toList();

    setState(() {
      _tasksForSelectedDate = tasksForDate;
    });
  }



  @override
  Widget build(BuildContext context) {
    final habitDatabase = Provider.of<HabitDatabase>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Track, Improve, Succeed",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            const Gap(20),
            _buildHeatMap(habitDatabase),
            const Gap(20),

            TabBar(
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Daily Tasks'),
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
                Tab(text: 'Yearly'),
              ],
            ),
            Expanded(
              child: TabBarView(

                controller: _tabController,
                children: [
                  _buildTasksList(),
                  TaskPieChartView(userId: userId, period: 'Weekly'),
                  TaskPieChartView(userId: userId, period: 'Monthly'),
                  TaskPieChartView(userId: userId, period: 'Yearly'),
                ],
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    if (_selectedDate == null) {
      return const Center(
        child: Text('Select a date on the heatmap to see tasks.'),
      );
    }

    if (_tasksForSelectedDate.isEmpty) {
      return Center(
        child: Text('No tasks completed on ${_selectedDate!.toLocal().toString().split(' ')[0]}.'),
      );
    }

    return ListView.builder(
      itemCount: _tasksForSelectedDate.length,
      itemBuilder: (context, index) {
        final habit = _tasksForSelectedDate[index];
        return ListTile(
          title: Text(habit.name),
          subtitle: Text('Completed on ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
          leading: const Icon(Icons.check_circle, color: Colors.green),
        );
      },
    );
  }
}

