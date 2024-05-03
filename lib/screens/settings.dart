import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'animated_background.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onUpdate;

  SettingsScreen({this.onUpdate});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final email = FirebaseAuth.instance.currentUser?.email;

    setState(() {
      _name = prefs.getString('userName') ?? 'No Name Set';
      _email = email ?? 'No Email Set';
    });
  }

  Future<void> _changeName() async {
    final TextEditingController _nameController = TextEditingController(text: _name);
    final bool shouldUpdate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Name', style: GoogleFonts.mukta(color: Colors.black)),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldUpdate) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      setState(() {
        _name = _nameController.text;
      });
      widget.onUpdate?.call();
    }
  }

  Future<void> _signOut() async {
    final bool confirmSignOut = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out', style: GoogleFonts.mukta(color: Colors.black)),
          content: Text('Are you sure you want to sign out?', style: GoogleFonts.mukta(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Dismiss the dialog first
                FirebaseAuth.instance.signOut(); // Sign out from Firebase
                // Clear any data saved in SharedPreferences or other local storage
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                // Redirect to SignInScreen and remove all routes that were opened before
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => SignInScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }



  Future<void> _deleteAccount() async {
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account', style: GoogleFonts.mukta(color: Colors.black)),
          content: Text('Are you sure you want to delete your account and all data?', style: GoogleFonts.mukta(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context). pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => _confirmDelete(),
              child: Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<void> _confirmDelete() async {
    try {
      Navigator.of(context).pop(); // Close the dialog
      final user = FirebaseAuth.instance.currentUser;
      await user?.delete(); // Delete the Firebase user
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all SharedPreferences data
      Navigator.of(context).pushAndRemoveUntil( // Redirect user
        MaterialPageRoute(builder: (_) => SignInScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle errors, e.g., show a dialog or a snackbar
      _showErrorDialog('Failed to delete account. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(), // Dynamic animated background
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Name: $_name', style: GoogleFonts.mukta(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 20),
                  Text('Email: $_email', style: GoogleFonts.mukta(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changeName,
                    child: Text('Change Name'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Sign Out'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _deleteAccount, // Call the delete account function
                    child: Text('Delete Account'),
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
}
