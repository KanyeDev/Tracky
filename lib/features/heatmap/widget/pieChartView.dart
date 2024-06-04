import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gap/gap.dart';

import '../../../database/database.dart';
import '../../../model/habits.dart';


class TaskPieChartView extends StatefulWidget {
  final String userId;
  final String period;

  const TaskPieChartView({super.key, required this.userId, required this.period});

  @override
  _TaskPieChartViewState createState() => _TaskPieChartViewState();
}

class _TaskPieChartViewState extends State<TaskPieChartView> {
  String selectedTask = '';
  int selectedCount = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Habit>>(
      stream: HabitDatabase().readHabits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final habits = snapshot.data!;
        final now = DateTime.now();
        DateTime startOfPeriod;

        switch (widget.period) {
          case 'Weekly':
            startOfPeriod = now.subtract(Duration(days: now.weekday));
            break;
          case 'Monthly':
            startOfPeriod = DateTime(now.year, now.month);
            break;
          case 'Yearly':
            startOfPeriod = DateTime(now.year);
            break;
          default:
            startOfPeriod = now;
        }

        final taskData = getTaskCountForPeriod(habits, startOfPeriod, now);

        if (taskData.isEmpty) {
          return Center(child: Text('No data available for ${widget.period}'));
        }

        final series = [
          charts.Series<MapEntry<String, int>, String>(
            id: widget.period,
            domainFn: (MapEntry<String, int> entry, _) => entry.key,
            measureFn: (MapEntry<String, int> entry, _) => entry.value,
            data: taskData.entries.toList(),
            labelAccessorFn: (MapEntry<String, int> entry, _) => '${entry.key}: ${entry.value}',
          )
        ];

        return Column(
          children: [
            const Gap(20),
            Expanded(
              child: charts.PieChart<String>(
                series,
                animate: true,
                behaviors: [
                  charts.DatumLegend(
                    position: charts.BehaviorPosition.top,
                    outsideJustification: charts.OutsideJustification.middleDrawArea,
                    horizontalFirst: false,
                    desiredMaxRows: 2,
                    cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: const charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                      fontFamily: 'Georgia',
                      fontSize: 11,
                    ),
                  ),
                ],
                defaultRenderer: charts.ArcRendererConfig<String>(
                  arcWidth: 60,
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.inside,
                    )
                  ],
                ),
                selectionModels: [
                  charts.SelectionModelConfig<String>(
                    type: charts.SelectionModelType.info,
                    changedListener: _onSelectionChanged,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    selectedTask,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  selectedCount == 0? const Text(
                    'Select an item to view',
                    style: TextStyle(fontSize: 16),
                  ) :Text(
                    '$selectedCount times',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onSelectionChanged(charts.SelectionModel<String> model) {
    final selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      final datum = selectedDatum.first.datum;
      setState(() {
        selectedTask = datum.key;
        selectedCount = datum.value;
      });
    }
  }

  Map<String, int> getTaskCountForPeriod(List<Habit> habits, DateTime start, DateTime end) {
    final Map<String, int> taskCounts = {};

    for (var habit in habits) {
      for (var date in habit.completedDays) {
        if (date.isAfter(start) && date.isBefore(end)) {
          if (taskCounts.containsKey(habit.name)) {
            taskCounts[habit.name] = taskCounts[habit.name]! + 1;
          } else {
            taskCounts[habit.name] = 1;
          }
        }
      }
    }

    return taskCounts;
  }
}

