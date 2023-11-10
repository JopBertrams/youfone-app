import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './login_screen/login_screen.dart';
import './loading_screen/loading_screen.dart';
import './loading_screen/youfone_data.dart';
import './loading_screen/youfone_login.dart';
import './dashboard_screen/dashboard_screen.dart';
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
        future: checkForUserCredentials(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else {
            if (snapshot.hasData && snapshot.data!['loginSuccessful'] == true) {
              // User has already logged in, show the dashboard
              return const DashboardScreen();
            } else {
              // User has not logged in, show the login screen
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> checkForUserCredentials() async {
    String? username = await _storage.read(key: 'username');

    if (username == null) {
      // User has not logged in before, show the login screen.
      return {'loginSuccessful': false};
    }

    bool keyExpired = await securitykeyExpired();

    if (!keyExpired) {
      // TODO: Retrieve data from Youfone API and show the dashboard screen.
      return {'loginSuccessful': true};
    }

    Map<String, dynamic> loginResult = await youfoneLoginFromSecureStorage();

    if (loginResult['loginSuccessful'] == false) {
      // Login was not successful, show the login screen.
      // TODO: Show a message to the user that the login was not successful. (Snackbar)
      return {'loginSuccessful': false};
    }

    // TODO: Retrieve data from Youfone API and show the dashboard screen.
    return {'loginSuccessful': true};
  }
}
