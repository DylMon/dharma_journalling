import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'animated_background.dart';

class CompletionScreen extends StatelessWidget {
  final int reflectionCount;

  CompletionScreen({Key? key, required this.reflectionCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    if (reflectionCount == 1) {
      message = "Good job on reflecting today. Come back whenever you like.";
    } else {
      message = "Well done, this is your ${ordinal(reflectionCount)} time today. Well done.";
    }

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(), // This is the dynamic background
          Center( // Centers the content on top of the background
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  message,
                  style: GoogleFonts.mukta(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Setting text color to white
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false,
                  ),
                  child: Text('Back to Home'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String ordinal(int number) {
    if (!(number >= 1 && number <= 100)) return "$number";
    if (number >= 11 && number <= 13) {
      return "${number}th";
    }
    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }
}
