import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_screen.dart';
import 'animated_background.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstLaunchScreen extends StatefulWidget {
  @override
  _FirstLaunchScreenState createState() => _FirstLaunchScreenState();
}

class _FirstLaunchScreenState extends State<FirstLaunchScreen> {
  TextEditingController _nameController = TextEditingController();
  double _welcomeOpacity = 1.0;
  bool _showWelcome = true;
  bool _showIntermediateScreen = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _welcomeOpacity = 0.0);
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _showWelcome = false;
          _showIntermediateScreen = true;
        });
      });
    });
  }

  _saveNameAndProceed(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setBool('isFirstLaunch', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(), // Dynamic animated background
          Center(
            child: _showWelcome
                ? AnimatedOpacity(
              opacity: _welcomeOpacity,
              duration: Duration(seconds: 2),
              child: Text('Welcome', style: GoogleFonts.mukta(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            )
                : _showIntermediateScreen
                ? _buildIntermediateScreen()
                : _buildNamePromptScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildIntermediateScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'This is Dharma, a tool aimed to help you practice mindfulness, and offer insights into your emotional well-being through journaling.',
            textAlign: TextAlign.center,
            style: GoogleFonts.mukta(fontSize: 24, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _showIntermediateScreen = false),
          child: Text('Continue', style: GoogleFonts.mukta()),
        ),
      ],
    );
  }

  Widget _buildNamePromptScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Now, what should I call you?', style: GoogleFonts.mukta(fontSize: 20, color: Colors.white)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Enter your name', hintStyle: GoogleFonts.mukta(color: Colors.white)),
          ),
        ),
        ElevatedButton(
          onPressed: () => _saveNameAndProceed(_nameController.text),
          child: Text('Continue', style: GoogleFonts.mukta()),
        ),
      ],
    );
  }
}
