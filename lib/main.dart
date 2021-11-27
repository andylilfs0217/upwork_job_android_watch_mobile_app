import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home/edit_page.dart';
import 'home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
              return MaterialPageRoute(builder: (context) => HomePage());
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
}
