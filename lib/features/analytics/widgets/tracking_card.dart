import 'package:flutter/material.dart';

class TrackingCard extends StatelessWidget {
  const TrackingCard(
      {super.key,
      required this.title,
      required this.iconVal,
      required this.iconColor,
      required this.gainedValue,
      required this.correspondingValue,
      required this.bottomWidget});

  final String title;
  final IconData iconVal;
  final Color iconColor;
  final double gainedValue;
  final String correspondingValue;
  final Widget bottomWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                Icon(
                  iconVal,
                  color: iconColor,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  gainedValue.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.green),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 16),
                    correspondingValue)
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            bottomWidget
          ],
        ),
      ),
    );
  }
}
