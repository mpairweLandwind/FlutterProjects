import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaloni_dental_hub/login_page.dart';
import 'package:zaloni_dental_hub/main_screen.dart';
import 'package:zaloni_dental_hub/models/cart_model.dart';
import 'package:zaloni_dental_hub/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zaloni_dental_hub/screens/account_screen.dart';
import 'package:zaloni_dental_hub/screens/cart_screen.dart';
import 'package:zaloni_dental_hub/screens/product_screen.dart';
import 'firebase_options.dart';
import 'package:zaloni_dental_hub/providers/product_provider.dart'; // Import ProductProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()), // Cart provider
        ChangeNotifierProvider( create: (context) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/loginScreen': (context) => const LoginScreen(),
        '/registerScreen': (context) => const Register_Screen(),
        '/Dashboard': (context) => const MainScreen(),
        '/productScreen': (context) => const ProductScreen(),
        '/CartScreen': (context) => CartScreen(cartItems: const [], cartTotal: 0, cart: Cart()),
        '/accontScreen': (context) => const AccountScreen(cartItems: [], cartTotal: 0.0),
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
  void initState() {
    super.initState();
    // Add a delay of 4 seconds before navigating to MainScreen
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // Ensure the widget is still mounted before using BuildContext
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    });
  }

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
}
