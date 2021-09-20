import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/AddActivity.dart';
import 'package:family_app/AddMembers.dart';
import 'package:family_app/FullActivity.dart';
import 'package:family_app/FullReport.dart';
import 'package:family_app/ReportsBrief.dart';
import 'package:family_app/ResetPassword.dart';
import 'package:family_app/Wrapper.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/database/MyDocument.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:family_app/FullSignIn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    "weekly_check_reports", "weekly_check_reports", "weekly_check_reports",
    importance: Importance.max, icon: "kids");
var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert: true, presentBadge: true, presentSound: true);
var platfromChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  var initializationSettingsAndroid = AndroidInitializationSettings('kids');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  print(_nextInstanceOfFridayElevenAM());
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Hello there!👋",
      'Checkout if you have any new reports!🤩',
      _nextInstanceOfFridayElevenAM(),
      platfromChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    print('handling foreground message');
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(notification.hashCode,
          notification.title, notification.body, platfromChannelSpecifics);
    }
  });
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(MyApp());
}

Future<void> _backgroundMessageHandler(message) async {
  print('handling background message');
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    flutterLocalNotificationsPlugin.show(notification.hashCode,
        notification.title, notification.body, platfromChannelSpecifics);
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

tz.TZDateTime _nextInstanceOfElevenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  print(now);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime _nextInstanceOfFridayElevenAM() {
  tz.TZDateTime scheduledDate = _nextInstanceOfElevenAM();
  while (scheduledDate.weekday != DateTime.friday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (_) => Auth()),
        Provider<MyDocument>(
          create: (_) => MyDocument(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            ActivityBrief.routeName: (context) => ActivityBrief(),
            FullActivity.routeName: (context) => FullActivity(),
            AddActivity.routeName: (context) => AddActivity(),
            AddMembersWrapper.routeName: (context) => AddMembersWrapper(),
            ReportsBrief.routeName: (context) => ReportsBrief(),
            FullReport.routeName: (context) => FullReport(),
            ResetPassword.routeName: (context) => ResetPassword()
          },
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(
                  bodyText2: GoogleFonts.patrickHand(
                      textStyle: TextStyle(
                          color: Color(0xffF7A440),
                          fontWeight: FontWeight.w800)),
                  bodyText1: GoogleFonts.patrickHand(
                      textStyle: TextStyle(
                          color: Color(0xffF7A440),
                          fontWeight: FontWeight.w800)),
                  subtitle1: GoogleFonts.patrickHand(
                      textStyle: TextStyle(color: Color(0xffF7A440)),
                      fontWeight: FontWeight.w800))),
          title: 'FamilyApp',
          home: Wrapper()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
