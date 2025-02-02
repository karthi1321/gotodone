import 'package:flutter/material.dart';

RichText buildStyledText(String text) {
  List<String> words = text.split(' ');
  return RichText(
    text: TextSpan(
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      children: <TextSpan>[
        // Add all words except the last one with red color
        for (int i = 0; i < words.length - 1; i++)
          TextSpan(text: '${words[i]} ', style: const TextStyle(color: Colors.red)),
        // Add the last word with blue color
        if (words.isNotEmpty)
          TextSpan(text: words.last, style: const TextStyle(color: Colors.blue)),
      ],
    ),
  );
}
