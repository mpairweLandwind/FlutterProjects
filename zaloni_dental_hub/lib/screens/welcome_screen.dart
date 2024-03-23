import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue.shade300,
                Colors.blueAccent.shade700,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Flexible(
                flex: 2,
                child: Image.asset(
                  'assets/zaloni_logo.png', // Replace with your logo asset
                  height: 120.0,
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Welcome to Zaloni Dental Hub',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Complete dental care at your fingertips.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the next screen, perhaps a sign-in or registration page.
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent.shade700, backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
  // appBar: AppBar(       
  //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //       title: Text(widget.title),
  //     ),
  //     body: Container(
  //       decoration: backgroundDecoration,
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             const Text('Sign In',
  //                 style: TextStyle(fontSize: 24)),
  //             const SizedBox(height: 50), // Spacing between text and buttons
  //             ElevatedButton(                
  //               onPressed: () {
  //                 // Navigate to login screen
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) =>  const LoginScreen()),
  //                 );
  //               },
  //               child: const Text('Login'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // Navigate to register screen
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => const Register_Screen()),
  //                 );
  //               },
  //               child: const Text('Register'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
}