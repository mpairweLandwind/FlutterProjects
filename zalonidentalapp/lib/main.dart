
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:zaloni_dental_hub/dashboard.dart';
import 'package:zalonidentalapp/login_page.dart';
import 'package:zalonidentalapp/main_screen.dart';
import 'package:zalonidentalapp/models/cart_model.dart';
import 'package:zalonidentalapp/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zalonidentalapp/screens/account_screen.dart';
import 'package:zalonidentalapp/screens/cart_screen.dart';
import 'package:zalonidentalapp/screens/product_screen.dart';
import 'firebase_options.dart';

// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart'hide EmailAuthProvider;
// ignore: unused_import
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

// import 'package:firebase_auth/firebase_auth.dart';


void main() async {
      WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
     ChangeNotifierProvider(
      create: (context) => Cart(),
      child: const MyApp(),
    ),
    
   );
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       routes: {
    '/loginScreen': (context) =>  const LoginScreen(), // Replace with your login screen widget
    // Define other routes as necessary
    '/registerScreen':(context) => const Register_Screen(),
    '/Dashboard':(context) => const MainScreen(),
    '/productScreen':(context) => const ProductScreen(),
    '/CartScreen':(context) =>  CartScreen(cartItems: const [], cartTotal: 0, cart: Cart(),),
    '/accontScreen':(context) => const AccountScreen(cartItems: [], cartTotal: 0.0,),
   // '/homeScreen':(context) => const HomeScreen(),
    
  },
      title: 'Zaloni Dental Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Zaloni Dental Hub'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // BoxDecoration backgroundDecoration = const BoxDecoration(
    //   color: Colors.blue, // Choose your desired color
    // );

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
                  // Navigate to the next screen, perhaps a sign-in or dashboard.
                 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
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
}
