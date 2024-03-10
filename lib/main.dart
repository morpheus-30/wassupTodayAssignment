import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:json_cache/json_cache.dart';
import 'package:provider/provider.dart';
// import 'package:wassuptoday/Screens/HomeScreaen.dart';
import 'package:wassuptoday/Screens/LoginScreen.dart';
import 'package:wassuptoday/provider/themeAndHeadlines.dart';
import 'firebase_options.dart';

void main() async {
  


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // print('Firebase initialized');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeAndHeadlineProvider(),
      child: Consumer<ThemeAndHeadlineProvider>(
        builder: (context, ThemeAndHeadlineProvider, child) {
          return MaterialApp(
            theme: ThemeAndHeadlineProvider.lightTheme,
            darkTheme: ThemeAndHeadlineProvider.darkTheme,
            themeMode: ThemeMode.system,
            home: const SignInScreen(),
          );
        },
      ),
    );
  }
}
