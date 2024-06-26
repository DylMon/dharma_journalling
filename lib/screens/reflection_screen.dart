import 'package:flutter/material.dart';
import 'package:dharma_00_01/screens/completion_screen.dart';
import 'data_manager.dart';
import 'animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth

class ReflectionScreen extends StatefulWidget {
  final int mood;
  ReflectionScreen({Key? key, required this.mood}) : super(key: key);

  @override
  _ReflectionScreenState createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  TextEditingController _textController = TextEditingController();
  String? userId;  // Variable to store the current user's ID

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;  // Get the current user's ID
  }

  void _saveEntryAndNavigate() async {
    if (userId == null) return;  // Ensure user ID is not null

    MoodEntry entry = MoodEntry(date: DateTime.now(), mood: widget.mood, journalEntry: _textController.text, userId: userId!);
    await DataManager().addMoodEntry(entry);
    int reflectionCount = await DataManager().countReflections(DateTime.now(), userId!);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CompletionScreen(reflectionCount: reflectionCount))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(), // Dynamic animated background
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Take a moment to reflect on your state of mind. This will be for you to refer back to in the future, so be as brief or detailed as you like.",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _textController,
                    maxLines: null,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Type your reflections here...",
                      hintStyle: TextStyle(color: Colors.white60),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      counterText: "",
                    ),
                    maxLength: 500,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveEntryAndNavigate,
                    child: Text('Complete', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
