
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Row buildTextWidget(
    BuildContext context, String text, IconData icon, String text2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(icon),
          const Gap(10),
          Text(
            text,
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.surface),
          ),
        ],
      ),
      Text(
        text2,
        style: TextStyle(
            fontSize: 16, color: Theme.of(context).colorScheme.surface),
      ),
    ],
  );
}

