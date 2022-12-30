import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'package:MannaGo/splash.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
          child: Container(
        height: 300,
        child: Column(
          children: [
            Text(
              'alarm page stageholder',
            ),
            ElevatedButton(onPressed: () => logout(), child: Text("logout"))
          ],
        ),
      )),
    );
  }

  void logout() {
    Backendless.userService.logout().then((response) {
      // user has been logged out.
    });
    print("user has been loged out");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    });
  }
}
