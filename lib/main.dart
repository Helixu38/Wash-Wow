import 'package:flutter/material.dart';
import 'package:wash_wow/src/splash/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.local");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(4, 90, 209, 1),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(4, 90, 209, 1),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
