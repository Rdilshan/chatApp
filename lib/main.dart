import 'dart:convert';

import 'package:chatapp/model/notificationcontroller.dart';
import 'package:chatapp/page/splash.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;


void main() async{

    WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basci_chanel",
      channelName: "basic channel",
      channelDescription: "Test notification",
    )
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "basic_channel_group", channelGroupName: "basic group")
  ]);
  bool isAllowedtosendnotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedtosendnotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "scheduled_notifications",
    "scheduled_notifications_task",
  );



  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Splashscreen(),
      ),
    );
  }
}

// @pragma('vm:entry-point') 
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: 1,
//           channelKey: "basci_chanel",
//           title: "Hello World",
//           body: "Yehh, It's working",
//         ),
//       );
//     } catch (e) {
//       print('Error fetching messages: $e');
//     }
//     return Future.value(true);
//   });
// }

@pragma('vm:entry-point') 
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
    
      String? idnumber = prefs.getString('idnumber');
      String? mobilenumber = prefs.getString('mobilenumber');
      if(idnumber != null || mobilenumber != null){
          var url = Uri.https('asiald.lk', '/internal-projects/pos/FormobileAPK/getnotification.php');
          var response = await http.post(url,
          body: {'idnumber': idnumber, 'mobilenumber': mobilenumber});
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');

          var jsonResponse = json.decode(response.body);

          var first_shopname = jsonResponse[0]['shopname'];
          var first_msg = jsonResponse[0]['msg'];

          await AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: 1,
                channelKey: "basci_chanel",
                title: "$first_shopname",
                body: "$first_msg",
              ),
            );
      }

    } catch (e) {
      print('Error fetching messages: $e');
    }
    return Future.value(true);
  });
}