import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'loginpage.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

const String SERVER_URL = "https://eu-api.backendless.com";
const String APPLICATION_ID = "A5B771C1-B135-1146-FFC2-204701E95500";
const String ANDROID_API_KEY = "0CCFCDB3-0974-43B5-BD23-61FA6745C4A3";
const String IOS_API_KEY = "140898C0-D6DC-459E-A62E-20FF3A644653";
const String JS_API_KEY = "D4EF9175-2546-4B17-9038-14A77F5186F5";
bool isLogin = false;
bool loaded = false;

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    splashDelay();
  }

  void splashDelay() async {
    await Backendless.userService.getUserToken().then((userToken) {
      if (userToken != null && userToken.isNotEmpty) {
        Backendless.userService.isValidLogin().then((value) {
          isLogin = value!;
          print("API RES IN SPLASH | " + isLogin.toString());
          nav(isLogin);
        });

        setState(() {});
      } else {
        nav(isLogin);
      }
    });
    // print("the login data is outside check splash|" + isLogin.toString());
  }

  void nav(bool logs) {
    if (logs == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage(title: "Login UI")),
        );
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/play_store_512.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
      ),
    );
  }
}
