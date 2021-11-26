import 'package:flutter/material.dart';

import 'edit_page.dart';

enum SexType { male, female }

extension SexTypeExtension on SexType {
  String? get sex {
    switch (this) {
      case SexType.male:
        return 'M';
      case SexType.female:
        return 'F';
      default:
        return null;
    }
  }
}

class HomePageArguments {
  final num age;
  final num fitnessLevel;
  final SexType sex;
  HomePageArguments(this.age, this.fitnessLevel, this.sex);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data
  num age = 20;
  num fitnessLevel = 0.5;
  SexType sex = SexType.male;
  num heartRate = 65;

  num getAnaerobicThreshold() {
    num adjustedAge = age;
    if (sex == SexType.female) {
      adjustedAge *= 0.88;
    }
    num at = (220 - adjustedAge) * fitnessLevel;
    return at;
  }

  @override
  Widget build(BuildContext context) {
    HomePageArguments? args;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      args = ModalRoute.of(context)!.settings.arguments as HomePageArguments;
      age = args.age;
      fitnessLevel = args.fitnessLevel;
      sex = args.sex;
    } else {
      // TODO: Get data from database
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Age: $age', style: const TextStyle(fontSize: 30)),
                    Text('Fitness Level: $fitnessLevel',
                        style: const TextStyle(fontSize: 30))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Sex: ${sex.sex}',
                        style: const TextStyle(fontSize: 30)),
                    const Text('Fit = 1, Unfit = 0.5',
                        style: TextStyle(fontSize: 30))
                  ],
                ),
                Center(
                    child: TextButton(
                  child: const Text('Edit', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    // Edit information
                    Navigator.pushNamed(context, '/edit',
                        arguments: EditPageArguments(age, fitnessLevel, sex));
                  },
                ))
              ],
            ),
            Column(
              children: [
                Text('Heart Rate: $heartRate',
                    style: const TextStyle(fontSize: 40)),
                Text('Anaerobic Threshold: ${getAnaerobicThreshold().toInt()}',
                    style: const TextStyle(fontSize: 40)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
