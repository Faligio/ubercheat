import 'package:flutter/material.dart';

class FloatingLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingLocationButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.green, 
      child: const Icon(
        Icons.nature, 
        color: Colors.black, 
      ),
    );
  }
}
