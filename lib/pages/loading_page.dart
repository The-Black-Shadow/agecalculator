import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifechrono/pages/home_page.dart'; // Import your home page file

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // Add a delay of 1 second and then navigate to the home page
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HomePage()), // Replace with your home page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey,
              Colors.orange
            ], // Replace with your gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Age Calc',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: GoogleFonts.audiowide().fontFamily)),
              const SizedBox(height: 20),
              const Icon(Icons.timer, color: Colors.white, size: 100),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
