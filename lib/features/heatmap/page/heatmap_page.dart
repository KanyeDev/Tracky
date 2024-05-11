import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../model/habits.dart';
import '../widget/heatmap.dart';

class HeatMapPage extends StatefulWidget {
  const HeatMapPage({super.key});

  @override
  State<HeatMapPage> createState() => _HeatMapPageState();
}

class _HeatMapPageState extends State<HeatMapPage> {

  //TODO: change the pie chart to a place to display the data of a particular day whenever
  // TODO: the day is clicked, it will be a screen for extra data information

  //TODO: Change the functions to firebase

  int touchedIndex = 0;

  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
          (i) {
        final isTouched = i == touchedIndex;
        const color0 = Colors.blue;
        const color1 = Colors.yellow;
        const color2 = Colors.pink;
        const color3 = Colors.green;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 25,
              title: '',
              radius: 80,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : BorderSide(
                  color: Colors.white.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 25,
              title: '',
              radius: 65,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : BorderSide(
                  color: Colors.white.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 25,
              title: '',
              radius: 60,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : BorderSide(
                  color: Colors.white.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: 25,
              title: '',
              radius: 70,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : BorderSide(
                  color: Colors.white.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }


  Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
    Map<DateTime, int> dataset = {};

    for (var habit in habits) {
      for (var date in habit.completedDays) {
        //normalize date to avoid time mismatch
        final normalizedDate = DateTime(date.year, date.month, date.day);

        if (dataset.containsKey(normalizedDate)) {
          dataset[normalizedDate] = dataset[normalizedDate]! + 1;
        } else {
          //else initialize it with a count of 1
          dataset[normalizedDate] = 1;
        }
      }
    }
    return dataset;
  }

  Widget _buildHeatMap() {
    //habit database
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabit;

    //return heat map ui

    return FutureBuilder(
        future: habitDatabase.getFirstLauncDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHeatMap(
                startDate: snapshot.data!,
                dataset: prepHeatMapDataset(currentHabits));
          } else {
            return Container();
          }
        });
  }

  Widget _buildPieChart(){
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex = pieTouchResponse
                      .touchedSection!.touchedSectionIndex;
                });
              },
            ),
            startDegreeOffset: 180,
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 1,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        
        _buildHeatMap(),
        _buildPieChart()
      ],),
    );
  }
}
