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
            Text('Age $age', style: const TextStyle(fontSize: 30)),
            Text('Fitness Level $fitnessLevel',
                style: const TextStyle(fontSize: 30)),
            Text('Sex ${sex.sex}', style: const TextStyle(fontSize: 30)),
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
