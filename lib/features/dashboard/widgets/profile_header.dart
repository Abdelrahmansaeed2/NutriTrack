import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(children: [
            const CircleAvatar(
              radius: 64,
              backgroundImage: AssetImage('assets/images/user.jpg'),
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
          const Text(
            'Salah Amer',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
              'Dedicated to achieving peak performance through precise nutrition and consistent daily habits.')
        ],
      ),
    );
  }
}
