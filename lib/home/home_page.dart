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
  final num age;
  final num fitnessLevel;
  final SexType sex;
  const HomePage(
      {Key? key,
      this.age = 20,
      this.fitnessLevel = 0.5,
      this.sex = SexType.male})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data
  num heartRate = 65;

  num getAnaerobicThreshold() {
    num adjustedAge = widget.age;
    if (widget.sex == SexType.female) {
      adjustedAge *= 0.88;
    }
    num at = (220 - adjustedAge) * widget.fitnessLevel;
    return at;
  }

  @override
  Widget build(BuildContext context) {
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
                    Text('Age: ${widget.age}',
                        style: const TextStyle(fontSize: 30)),
                    Text('Fitness Level: ${widget.fitnessLevel}',
                        style: const TextStyle(fontSize: 30))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Sex: ${widget.sex.sex}',
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
                        arguments: EditPageArguments(
                            widget.age, widget.fitnessLevel, widget.sex));
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
