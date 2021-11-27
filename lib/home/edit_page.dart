import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

class EditPageArguments {
  final num age;
  final num fitnessLevel;
  final SexType sex;
  EditPageArguments(this.age, this.fitnessLevel, this.sex);
}

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  num age;
  num fitnessLevel;
  SexType sex;
  EditPage(
      {Key? key,
      required this.age,
      required this.fitnessLevel,
      required this.sex})
      : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController ageController = TextEditingController();

  final fitnessLevelList = <num>[0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
  final sexList = ['M', 'F'];

  @override
  Widget build(BuildContext context) {
    ageController.text = widget.age.toString();

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text('Age', style: TextStyle(fontSize: 30))),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      controller: ageController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 5,
                    child:
                        Text('Fitness Level', style: TextStyle(fontSize: 30)),
                  ),
                  DropdownButton<num>(
                    isExpanded: false,
                    value: widget.fitnessLevel,
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
                          widget.fitnessLevel = newValue;
                        }
                      });
                    },
                    items: fitnessLevelList
                        .map<DropdownMenuItem<num>>((num value) {
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
                  const Expanded(
                      flex: 5,
                      child: Text('Sex', style: TextStyle(fontSize: 30))),
                  DropdownButton<String>(
                    isExpanded: false,
                    value: widget.sex.sex,
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
                            widget.sex = SexType.male;
                          } else {
                            widget.sex = SexType.female;
                          }
                        }
                      });
                    },
                    items:
                        sexList.map<DropdownMenuItem<String>>((String value) {
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
                    widget.age = int.parse(ageController.text);
                    Navigator.pushNamed(context, '/',
                        arguments: HomePageArguments(
                            widget.age, widget.fitnessLevel, widget.sex));
                  },
                  child: const Text('Save', style: TextStyle(fontSize: 30)))
            ],
          ),
        ),
      ),
    );
  }
}
