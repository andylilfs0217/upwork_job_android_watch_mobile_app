import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upwork_job_android_watch_mobile_app/utils/loading_page.dart';

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
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? identifier;
  // Firebase realtime database
  final database = FirebaseDatabase.instance.reference();
  TextEditingController ageController = TextEditingController();

  final fitnessLevelList = <num>[0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
  final sexList = ['M', 'F'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: _buildBody());
  }

  Future<void> getDeviceDetails() async {
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  @override
  void initState() {
    super.initState();
    ageController.text = widget.age.toString();
    getDeviceDetails().then((value) {
      setState(() {});
    });
  }

  Widget _buildBody() {
    if (identifier == null) {
      return const LoadingPage();
    }
    final healthRef = database.child('/health_data_$identifier');
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
                    // Update data to firebase
                    healthRef.update({
                      'age': widget.age,
                      'fitnessLevel': widget.fitnessLevel,
                      'sex': widget.sex.sex,
                    });
                    // Go to home page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  age: widget.age,
                                  fitnessLevel: widget.fitnessLevel,
                                  sex: widget.sex,
                                )));
                  },
                  child: const Text('Save', style: TextStyle(fontSize: 30)))
            ],
          ),
        ),
      ),
    );
  }
}
