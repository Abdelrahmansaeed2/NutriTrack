import 'package:flutter/material.dart';

class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 52, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              )
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.track_changes),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '15',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Badges Earned',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black45),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 52, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              )
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.track_changes),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '15',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Badges Earned',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black45),
              )
            ],
          ),
        ),
      ],
    );
  }
}
