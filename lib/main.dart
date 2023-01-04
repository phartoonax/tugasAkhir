import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:MannaGo/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'color_schemes.g.dart';

void main() {
  runApp(const MyApp());
}

// ColorScheme defaultColorScheme = ColorScheme(
//   primary: Color(0xff16182b),
//   secondary: Color(0xff1D2739),

//   surface: Color(0xff181818),
//   background: Color.fromARGB(255, 23, 31, 70),
//   error: Color(0xffCF6679),
//   onPrimary: Color.fromARGB(255, 158, 158, 158), //font for button dll
//   onSecondary: Color.fromARGB(255, 89, 98, 150),
//   onSurface: Color.fromARGB(255, 80, 73, 73), //border,dll
//   onBackground: Color.fromARGB(255, 128, 14, 14), //??
//   onError: Color(0xff000000),
//   brightness: Brightness.light,
// );

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
    // Backendless.userService.getUserToken().then((userToken) {
    //   print("API RES IN MAIN | " + userToken.toString());
    //   if (userToken != null && userToken.isNotEmpty) {}
    // });
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    registerForPushNotifications();
  }

  Future<dynamic> registerForPushNotifications() async {
    List<String> channels = [];
    channels.add("default");

    try {
      return await Backendless.messaging.registerDevice(channels, null);
    } catch (ex) {
      return ex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp(
              title: 'Manna Go',
              debugShowCheckedModeBanner: false,
              theme:
                  ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
              darkTheme:
                  ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
              themeMode: ThemeMode.light,
              home: child);
        },
        child: const SplashScreen());
  }
}
