import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_project/screens/welcome_screen.dart';
import 'package:record/record.dart'; // Import the record package
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:io'; // For handling file paths
import 'dart:convert'; // For JSON encoding/decoding

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder(); // Use AudioRecorder
  bool _isRecording = false; // Track recording state
  String? _audioPath; // Store the path of the recorded audio file
  String _emotion = ""; // Store the detected emotion
  String _suggestion = ""; // Store the generated suggestion

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out the user
      await FirebaseAuth.instance.signOut();

      // Navigate to WelcomeScreen and replace the HomeScreen in the stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: ${e.toString()}')),
      );
    }
  }

  Future<void> _startRecording() async {
    try {
      // Check for microphone permissions
      if (await _audioRecorder.hasPermission()) {
        // Define the output path for the recording
        final String path = '/path/to/save/recording.wav'; // Replace with your desired path

        // Start recording
        await _audioRecorder.start(
          RecordConfig(), // Use default recording configuration
          path: path, // Provide the output path
        );
        setState(() {
          _isRecording = true;
        });
      } else {
        // Handle the case where permission is denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
    } catch (e) {
      print('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting recording: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      // Stop recording and get the file path
      String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
      });
      print('Recording saved to: $_audioPath');

      // Send the audio file to the Flask API
      if (_audioPath != null) {
        await _sendAudioToAPI(_audioPath!);
      }
    } catch (e) {
      print('Error stopping recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping recording: $e')),
      );
    }
  }

  Future<void> _sendAudioToAPI(String audioPath) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://<your-ngrok-url>/detect-emotion'), // Replace with your Flask API URL
      );

      // Attach the audio file
      request.files.add(await http.MultipartFile.fromPath('file', audioPath));

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        setState(() {
          _emotion = jsonResponse['emotion'];
          _suggestion = jsonResponse['response'];
        });
      } else {
        print("Failed to detect emotion: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending audio to API: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'), // Replace with your app bar title
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to the Home Screen!',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
                      if (_emotion.isNotEmpty)
                        Text(
                          'Detected Emotion: $_emotion',
                          style: TextStyle(color: Colors.white),
                        ),
                      if (_suggestion.isNotEmpty)
                        Text(
                          'Suggestion: $_suggestion',
                          style: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ),
              if (_audioPath != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Recording saved to: $_audioPath',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 28, // Center horizontally
            bottom: MediaQuery.of(context).size.height / 4, // Place at 3/4th from the top
            child: FloatingActionButton(
              onPressed: () {
                if (_isRecording) {
                  _stopRecording(); // Stop recording if already recording
                } else {
                  _startRecording(); // Start recording if not recording
                }
              },
              child: Icon(_isRecording ? Icons.stop : Icons.mic), // Change icon based on recording state
            ),
          ),
        ],
      ),
    );
  }
}