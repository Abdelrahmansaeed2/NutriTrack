import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String bio;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(children: [
            const CircleAvatar(
              radius: 64,
              backgroundImage: AssetImage('assets/images/avatar.jpeg'),
            ),
            Positioned(
                right: 2,
                bottom: 1,
                child: IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 38, 107, 41)),
                    icon: const Icon(
                      Icons.mode_edit_outline,
                      color: Colors.white,
                    )))
          ]),
          const SizedBox(
            height: 16,
          ),
          Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 28),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            bio.isNotEmpty ? bio : 'Dedicated to achieving peak performance through precise nutrition.',
            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
