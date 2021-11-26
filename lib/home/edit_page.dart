import 'package:flutter/material.dart';

import 'home_page.dart';

class EditPageArguments {
  final num age;
  final num fitnessLevel;
  final SexType sex;
  EditPageArguments(this.age, this.fitnessLevel, this.sex);
}

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late num age;
  late num fitnessLevel;
  late SexType sex;

  final fitnessLevelList = <num>[0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
  final sexList = ['M', 'F'];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EditPageArguments;
    age = args.age;
    fitnessLevel = args.fitnessLevel;
    sex = args.sex;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: const Text('Age', style: TextStyle(fontSize: 30))),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text('Fitness Level',
                      style: const TextStyle(fontSize: 30)),
                ),
                DropdownButton<num>(
                  isExpanded: false,
                  value: fitnessLevel,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (num? newValue) {
                    setState(() {
                      if (newValue != null) {
                        fitnessLevel = newValue;
                      }
                    });
                  },
                  items:
                      fitnessLevelList.map<DropdownMenuItem<num>>((num value) {
                    return DropdownMenuItem<num>(
                      value: value,
                      child: Text(value.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20)),
                    );
                  }).toList(),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Text('Sex ${sex.sex}',
                        style: const TextStyle(fontSize: 30))),
                DropdownButton<String>(
                  isExpanded: false,
                  value: sex.sex,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        if (newValue == 'M') {
                          sex = SexType.male;
                        } else {
                          sex = SexType.female;
                        }
                      }
                    });
                  },
                  items: sexList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20)),
                    );
                  }).toList(),
                )
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/',
                      arguments: HomePageArguments(age, fitnessLevel, sex));
                },
                child: const Text('Save', style: TextStyle(fontSize: 30)))
          ],
        ),
      ),
    );
  }
}
