import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // new string state var
  String _message = '';

  void _addDotToMessage() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _message += '.';
    });
  }

  void _addDashToMessage() {
    setState(() {
      _message += '-';
    });
  }

  Timer? timer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        timer = Timer(
          const Duration(milliseconds: 300),
          () {
            // Call onLongPress if the button was pressed longer than 300 milliseconds
            onLongPress();
            // Reset the timer to prevent calling onShortPress
            timer = null;
          },
        );
      },
      onTapUp: (_) {
        if (timer != null) {
          // Timer is still active, indicating a short press
          timer!.cancel();
          onShortPress();
        }
      },
      child: Container(
        width: 200,
        height: 50,
        color: Colors.green,
        // add to the child a Text widget that displays the string state
        child: Stack(
          children: [
            Center(
              child: Text(
                _message,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const Center(child: Text('Click here')),
          ],
        ),
      ),
    );
  }

  void onShortPress() {
    _addDotToMessage();
    // run a method to add a . to the string state
  }

  void onLongPress() async {
    // check if device has vibrator
    bool? canVibrate = await Vibration.hasVibrator();
    if (canVibrate != null && canVibrate) {
      Vibration.vibrate(
        pattern: [500],
      );
      Vibration.cancel();
    }
    _addDashToMessage();
  }
}
