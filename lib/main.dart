import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:tugas_akhir/splash.dart';
import 'dart:developer' as dev;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

ColorScheme defaultColorScheme = ColorScheme(
  primary: Color(0xffBB86FC),
  secondary: Color(0xff03DAC6),

  surface: Color(0xff181818),
  background: Color(0xffffffff),
  error: Color(0xffCF6679),
  onPrimary: Color(0xffffffff), //font for button dll
  onSecondary: Color(0xff000000),
  onSurface: Color(0xffebebeb), //border,dll
  onBackground: Color(0xfff1f1f1), //??
  onError: Color(0xff000000),
  brightness: Brightness.light,
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

const String SERVER_URL = "https://eu-api.backendless.com";
const String APPLICATION_ID = "A5B771C1-B135-1146-FFC2-204701E95500";
const String ANDROID_API_KEY = "0CCFCDB3-0974-43B5-BD23-61FA6745C4A3";
const String IOS_API_KEY = "140898C0-D6DC-459E-A62E-20FF3A644653";
const String JS_API_KEY = "D4EF9175-2546-4B17-9038-14A77F5186F5";

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    await Backendless.initApp(
      applicationId: APPLICATION_ID,
      androidApiKey: ANDROID_API_KEY,
      iosApiKey: IOS_API_KEY,
      jsApiKey: JS_API_KEY,
    );
    await Backendless.setUrl(SERVER_URL);
    Backendless.userService.getUserToken().then((userToken) {
      print("API RES IN MAIN | " + userToken.toString());
      if (userToken != null && userToken.isNotEmpty) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: defaultColorScheme,
          fontFamily: 'Inter',
          visualDensity: VisualDensity.compact,
        ),
        home: const SplashScreen());
  }
}
