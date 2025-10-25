import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gym_fitness_app/screens/login_screen.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],
                ),
                child: Icon(Icons.fitness_center,
                    size: 60, color: Color(0xFF9B59B6)),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'GYM',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text: ' & ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Fitness',
                      style: TextStyle(color: Color(0xFF9B59B6)),
                    ),
                    TextSpan(
                      text: ' App',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(
                '(Plans & Calendar)',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Color(0xFF9B59B6)),
            ],
          ),
        ),
      ),
    );
  }
}
