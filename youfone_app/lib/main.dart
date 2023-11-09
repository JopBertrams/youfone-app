import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './login_screen/login_screen.dart';
import 'styles/colors.dart';

void main() {
  runApp(const MyApp());
}

// TODO: Add localization support for English and Dutch

class MyApp extends StatelessWidget {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youfone',
      theme: ThemeData(
          primarySwatch: youfoneMaterialColor,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: youfoneColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          )),
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO: Add a loading screen
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              // User has already logged in, show the dashboard
              // TODO: Add the dashboard screen
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Dashboard",
                    style:
                        TextStyle(color: youfoneColor, fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            } else {
              // User has not logged in, show the login screen
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    // Check if the user is already logged in.
    String? token = await _storage.read(key: 'token');
    return token != null;
  }
}
