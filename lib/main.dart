import 'package:balink_mobile/authentication/login.dart';
import 'package:balink_mobile/main_navbar.dart';
import 'package:balink_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final request = CookieRequest();

    try {
      // Attempt to validate login status
      final response =
          await request.get('https://nevin-thang-balink.pbp.cs.ui.ac.id/auth/check_login/');

      // Check if the backend confirms login status
      setState(() {
        _isLoggedIn = response['is_logged_in'] == true;
      });
    } catch (e) {
      // If backend check fails, fall back to checking local storage
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');

      setState(() {
        _isLoggedIn = storedUsername != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Balink',
        theme: djangoTheme,
        home: FutureBuilder<bool>(
          future: _checkLoginStatusFuture(), // Create this method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading indicator
            }

            return snapshot.data == true
                ? MainNavigationScaffold(isLoggedIn: _isLoggedIn, startingPage: 0,)
                : LoginPage(
                    onLoginSuccess: () {
                      setState(() {
                        _isLoggedIn = true;
                      });
                    },
                  );
          },
        ),
      ),
    );
  }

  Future<bool> _checkLoginStatusFuture() async {
    final request = CookieRequest();

    try {
      final response =
          await request.get('https://nevin-thang-balink.pbp.cs.ui.ac.id/auth/check_login/');
      return response['is_logged_in'] == true;
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('username') != null;
    }
  }
}
