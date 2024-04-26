import 'package:flutter/material.dart';

class ColorConfig {
  static final List<Color> moodColors = [
    Color(0xFFDC4040), // Mood 1: very light red
    Color(0xFFE15252), // Mood 2
    Color(0xFFD75454), // Mood 3
    Color(0xFFCC6969), // Mood 4
    Color(0xFF83A3B4), // Mood 5: corrected color for a clearer progression
    Color(0xFFA6E7A6), // Mood 6
    Color(0xFFA0EFA0), // Mood 7
    Color(0xFF81D581), // Mood 8
    Color(0xFF78D978), // Mood 9
    Color(0xFF65E757), // Mood 10: light green
  ];

  static Color getMoodColor(int mood) {
    int index = (mood - 1).clamp(0, moodColors.length - 1);
    Color color = moodColors[index];
    print("Mood: $mood, Color: $color");  // Log the mood-color mapping
    return color;
  }

}