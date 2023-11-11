import 'package:flutter/material.dart';
import './storage.dart';
import './models/data.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youfone',
      theme: _buildThemeData(),
      home: _buildHome(),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      primarySwatch: youfoneMaterialColor,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: youfoneColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildHome() {
    return FutureBuilder(
      future: _getLoginStatusAndData(),
      builder: (BuildContext context, AsyncSnapshot<Data?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          return snapshot.data == null
              ? const LoginScreen()
              : DashboardScreen(youfoneData: snapshot.data!);
        }
      },
    );
  }

  Future<Data?> _getLoginStatusAndData() async {
    //await storageDeleteAll();
    String? username = await storageRead(key: 'username');
    if (username == null) {
      // User has not logged in before, show the login screen.
      return null;
    }

    bool keyExpired = await securitykeyExpired();
    if (!keyExpired) {
      return await getYoufoneData();
    }

    bool loginSuccessful = await youfoneLoginFromSecureStorage();
    if (!loginSuccessful) {
      // Login was not successful, remove credentials from secure storage and show the login screen.
      // TODO: Show a message to the user that the login was not successful. (Snackbar)
      await storageDelete(key: 'username');
      await storageDelete(key: 'password');
      return null;
    }

    return await getYoufoneData();
  }
}
