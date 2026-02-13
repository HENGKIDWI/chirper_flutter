import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 5, 198, 255),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
