import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  const MyHeatMap({super.key, required this.startDate, required this.dataset});
  final DateTime startDate;
  final Map<DateTime, int> dataset;

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      showColorTip: false,
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: dataset,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      textColor: Theme.of(context).colorScheme.surface,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
        1: Colors.green.shade200,
        2: Colors.green.shade300,
        3: Colors.green.shade400,
        4: Colors.green.shade500,
        5: Colors.green.shade600,
        6: Colors.green.shade700,
        7: Colors.green.shade800

      },


    );
  }
}
