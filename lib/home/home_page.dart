import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:upwork_android_watch/utils/loading_page.dart';
import 'dart:async';

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

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  num age;
  num fitnessLevel;
  SexType sex;
  HomePage(
      {Key? key,
      this.age = 20,
      this.fitnessLevel = 0.5,
      this.sex = SexType.male})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? identifier;
  // Firebase realtime database
  final database = FirebaseDatabase.instance.reference();
  // Firebase notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Data
  // TODO: fetching heartrate
  ValueNotifier<num> heartRate = ValueNotifier<num>(135);

  static const platform = MethodChannel('samples.flutter.dev/heartRate');

  num getAnaerobicThreshold() {
    num adjustedAge = widget.age;
    if (widget.sex == SexType.female) {
      adjustedAge *= 0.88;
    }
    num at = (220 - adjustedAge) * widget.fitnessLevel;
    return at;
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

  Future<void> _getHeartRateLevel() async {
    final int result = await platform.invokeMethod('getHeartRate');
    print('Heart rate: $result');
    heartRate = ValueNotifier<num>(result);
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    // TODO
    _getHeartRateLevel();
    getDeviceDetails().then((value) {
      setState(() {});
    });
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "Be aware!",
        "Your heart rate exceeds anaerobic threshold!",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  Widget build(BuildContext context) {
    if (identifier == null) {
      return const LoadingPage();
    }

    final healthRef = database.child('health_data_$identifier');
    final _future = healthRef.once();

    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var value = snapshot.data.value;
              if (value != null) {
                widget.age = value['age'];
                widget.fitnessLevel = value['fitnessLevel'];
                switch (value['sex']) {
                  case 'M':
                    widget.sex = SexType.male;
                    break;
                  case 'F':
                    widget.sex = SexType.female;
                    break;
                  default:
                    break;
                }
              } else {
                healthRef.update({
                  'age': widget.age,
                  'fitnessLevel': widget.fitnessLevel,
                  'sex': widget.sex.sex,
                });
              }
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
                          child: const Text('Edit',
                              style: TextStyle(fontSize: 30)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPage(
                                    age: widget.age,
                                    fitnessLevel: widget.fitnessLevel,
                                    sex: widget.sex,
                                  ),
                                ));
                          },
                        )),
                        // TODO: Remove
                        Center(
                            child: TextButton(
                          child: const Text('Update Heart Rate',
                              style: TextStyle(fontSize: 30)),
                          onPressed: () {
                            _getHeartRateLevel();
                          },
                        ))
                      ],
                    ),
                    ValueListenableBuilder<num>(
                      valueListenable: heartRate,
                      builder:
                          (BuildContext context, num value, Widget? child) {
                        // Send notification if heart rate exceeds the limit
                        var at = getAnaerobicThreshold().toInt();
                        if (value > at) {
                          showNotification();
                        }
                        return Column(
                          children: [
                            Text('Heart Rate: $value',
                                style: const TextStyle(fontSize: 40)),
                            Text('Anaerobic Threshold: $at',
                                style: const TextStyle(fontSize: 40)),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
