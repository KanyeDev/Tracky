import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';



class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key,required this.visit, required this.onTap, required this.items});


  final int visit;
  final VoidCallback? Function(int value) onTap;
  final List<TabItem<dynamic>> items;




  @override
  Widget build(BuildContext context) {
    return Container(width: MediaQuery.of(context).size.width -40,
      padding: const EdgeInsets.only(top: 1),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset:
            const Offset(0.8, 2), // changes position of shadow
          ),
        ],
      ),
      child: BottomBarFloating(
        blur: 2,
        enableShadow: true,
        borderRadius: BorderRadius.circular(50),
          items: items,
          backgroundColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.surface,
          colorSelected: Theme.of(context).colorScheme.tertiary,
          indexSelected: visit,
          paddingVertical: 10,
          pad: 2,
          onTap: onTap),
    );
  }
}
