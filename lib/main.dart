import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home/edit_page.dart';
import 'home/home_page.dart';
import 'utils/error_page.dart';
import 'utils/loading_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
                title: 'Android Watch App',
                theme: ThemeData(primarySwatch: Colors.blue),
                debugShowCheckedModeBanner: false,
                home: const ErrorPage());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Android Watch App',
              theme: ThemeData(primarySwatch: Colors.blue),
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/':
                    if (settings.arguments != null) {
                      final args = settings.arguments as HomePageArguments;
                      return MaterialPageRoute(
                          builder: (context) => HomePage(
                              age: args.age,
                              fitnessLevel: args.fitnessLevel,
                              sex: args.sex));
                    } else {
                      return MaterialPageRoute(
                          builder: (context) => HomePage());
                    }
                  case '/edit':
                    final args = settings.arguments as EditPageArguments;
                    return MaterialPageRoute(
                        builder: (context) => EditPage(
                            age: args.age,
                            fitnessLevel: args.fitnessLevel,
                            sex: args.sex));
                  default:
                    break;
                }
              },
            );
          }
          return MaterialApp(
              title: 'Android Watch App',
              theme: ThemeData(primarySwatch: Colors.blue),
              debugShowCheckedModeBanner: false,
              home: const LoadingPage());
        });
  }
}
