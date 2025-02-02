import 'package:flutter/material.dart';

class FavoriteTaskButton extends StatelessWidget {
  final bool isFav;
  final VoidCallback onTap;

  const FavoriteTaskButton({required this.isFav, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isFav ? Icon(Icons.star, color: const Color.fromARGB(255, 187, 7, 7)) : Icon(Icons.star_border),
      onPressed: onTap,
      tooltip: isFav ? 'Remove from Favorites' : 'Add to Favorites',
    );
  }
}
