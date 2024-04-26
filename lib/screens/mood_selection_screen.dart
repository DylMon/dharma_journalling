import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reflection_screen.dart';
import 'animated_background.dart';

class MoodSelectionScreen extends StatefulWidget {
  @override
  _MoodSelectionScreenState createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  double _currentSliderValue = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'At this moment, what would you rate your own state of mind?',
                      style: GoogleFonts.mukta(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Ensuring text is white
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.black, // Black color for the floating label text
                        ),
                        valueIndicatorColor: Colors.white, // White background color for the label
                      ),
                      child: Slider(
                        value: _currentSliderValue,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white54, // Slightly less bright for contrast
                        thumbColor: Colors.white,
                      ),
                    ),
                    Text(
                      _currentSliderValue <= 1 ? 'Very Sad' : _currentSliderValue >= 10 ? 'Very Happy' : '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // Ensuring text is white
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReflectionScreen(mood: _currentSliderValue.toInt()),
                          ),
                        );
                      },
                      child: Text('Proceed to Reflect'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
