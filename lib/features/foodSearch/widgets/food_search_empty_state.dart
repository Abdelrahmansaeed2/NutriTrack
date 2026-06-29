import 'package:flutter/material.dart';

class FoodSearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isError;

  const FoodSearchEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            size: 48, 
            color: isError ? Colors.red : Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}