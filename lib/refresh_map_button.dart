import 'package:flutter/material.dart';

class ShowDeliveryPersonsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShowDeliveryPersonsButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.delivery_dining),
      backgroundColor: Colors.grey,
    );
  }
}
