import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mood_selection_screen.dart';
import 'calendar_screen.dart';
import 'settings.dart';
import 'animated_background.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onUpdate;

  HomeScreen({this.onUpdate});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = '';
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    widget.onUpdate?.call();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    if (userName == null || userName.isEmpty) {
      _promptForName();
    } else {
      setState(() {
        _name = userName;
      });
    }
  }

  Future<void> _promptForName() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome', style: GoogleFonts.mukta()),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'What should I call you?', hintStyle: GoogleFonts.mukta()),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await _saveName(_nameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit', style: GoogleFonts.mukta()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    setState(() {
      _name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(), // This is the dynamic animated background
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Welcome to Dharma, $_name',
                      style: GoogleFonts.mukta(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MoodSelectionScreen())),
                      child: Text('Make an Entry', style: GoogleFonts.mukta()),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen())),
                      child: Text('View Calendar', style: GoogleFonts.mukta()),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(onUpdate: _loadUserName))),
                      child: Text('Settings', style: GoogleFonts.mukta()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
