import 'package:flutter/material.dart';

class FilterFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const FilterFAB({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.filter_list),
    );
  }
}