import 'package:balink_mobile/authentication/login.dart';
import 'package:balink_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

void main() {
  if (kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) =>
        developer.log(message ?? '', name: 'debug');
  }

  runApp(
    Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balink',
      theme: djangoTheme,
      home: LoginPage(),
    );
  }
}
