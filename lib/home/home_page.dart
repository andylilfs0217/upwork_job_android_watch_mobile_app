import 'package:flutter/material.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data
  int age = 20;
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
    return Padding(
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
                  Text('Sex: ${sex.sex}', style: const TextStyle(fontSize: 30)),
                  const Text('Fit = 1, Unfit = 0.5',
                      style: const TextStyle(fontSize: 30))
                ],
              ),
              Center(
                  child: TextButton(
                child: const Text('Edit', style: TextStyle(fontSize: 30)),
                onPressed: () => {
                  // TODO: edit information
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
    );
  }
}
