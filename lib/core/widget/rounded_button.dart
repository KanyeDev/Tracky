import 'package:flutter/material.dart';

import '../screen_size/mediaQuery.dart';


class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.borderColor,
    required this.fillColor,
    required this.child,
    required this.onTap, required this.isLoading,
  });

  final Color borderColor, fillColor;
  final Widget child;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: getWidth(context) - 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            color: fillColor),
        child: Center(
          child: isLoading? CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,) : child,
        ),
      ),
    );
  }
}
