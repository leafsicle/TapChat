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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TapChat'),
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
  String _message = '';
  @override
  void dispose() {
    timer?.cancel();
    mainTimer?.cancel();
    super.dispose();
  }

  void _restartMainTimer() {
    if (mainTimer != null && mainTimer!.isActive) {
      mainTimer!.cancel();
    }
    mainTimer = Timer(const Duration(seconds: 2), () {
      // Timer callback: Perform the check after 3 seconds of no input
      _checkMessageContents();
    });
  }

  void _clearMessage() {
    setState(() {
      _message = '';
    });
  }

  void _checkMessageContents() {
    if (_isMessageComplete()) {
      print('Message is complete');
      final result = checkMessage();
      print('Result: $result');
    }
  }

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

  void onShortPress() {
    _addDotToMessage();
    _restartMainTimer();
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
    _restartMainTimer();
  }

  // create a bool method that will look at the length of the message state
  // and return false if the length == 5
  bool _isMessageComplete() {
    if (_message.length > 1) {
      return true;
    } else {
      return false;
    }
  }

  // create a method that will check the value of the message state
  // and compare it to the dictionary
  String checkMessage() {
    // create a dictionary
    final morseCode = {
      '.-': 'A',
      '-...': 'B',
      '-.-.': 'C',
      '-..': 'D',
      '.': 'E',
      '..-.': 'F',
      '--.': 'G',
      '....': 'H',
      '..': 'I',
      '.---': 'J',
      '-.-': 'K',
      '.-..': 'L',
      '--': 'M',
      '-.': 'N',
      '---': 'O',
      '.--.': 'P',
      '--.-': 'Q',
      '.-.': 'R',
      '...': 'S',
      '-': 'T',
      '..-': 'U',
      '...-': 'V',
      '.--': 'W',
      '-..-': 'X',
      '-.--': 'Y',
      '--..': 'Z',
    };
    return morseCode[_message] ?? '?';
  }

  Timer? timer = Timer(Duration.zero, () {});
  Timer? mainTimer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) {
    const kTempTextStyle = TextStyle(
      fontFamily: 'Spartan MB',
      fontSize: 100.0,
      decoration: null,
      color: Colors.black,
    );
    const otherTextStyle = TextStyle(
      fontFamily: 'Spartan MB',
      fontSize: 20.0,
      decoration: null,
      color: Colors.black,
    );
    double? gap = 10;
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
        // new var to catch bool method
        bool isComplete = _isMessageComplete();
        if (isComplete) {
          print('Message is complete');
          // check the value of message and compare it to the dictionary
          // if the message is in the dictionary, display the corresponding letter
          // if the message is not in the dictionary, display a ?
          checkMessage();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 450),
        width: 200,
        height: 50,
        color: Color.fromARGB(255, 98, 113, 229),
        // add to the child a Text widget that displays the string state
        child: Column(
          children: [
            SizedBox(height: gap),
            const Center(
              child: Text('Click here', style: otherTextStyle),
            ),
            Center(
              child: Text(_message, style: kTempTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
