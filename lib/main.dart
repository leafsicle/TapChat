import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_beep/flutter_beep.dart';

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
  String _secretMesage = '';
  String _message = '';
  String _result = '';
  Timer? timer = Timer(Duration.zero, () {});
  Timer? mainTimer = Timer(Duration.zero, () {});
  Timer? clearMessageTimer = Timer(Duration.zero, () {});
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
    mainTimer = Timer(const Duration(milliseconds: 800), () {
      // Timer callback: Perform the check after 3 seconds of no input
      _checkMessageContents();
    });
    // create anothe timer to clear the secret message after 5 seconds without activity
    if (clearMessageTimer != null && clearMessageTimer!.isActive) {
      clearMessageTimer!.cancel();
    }
    clearMessageTimer = Timer(const Duration(seconds: 3), () {
      // Timer callback: Perform the check after 3 seconds of no input
      _clearSecretMessage();
    });
  }

  void _vibrate() {
    FlutterBeep.playSysSound(iOSSoundIDs.Vibrate);
  }

  // play the beep noise!
  void _playBeep() {
    FlutterBeep.playSysSound(iOSSoundIDs.AudioTonePathAcknowledge);
    _vibrate();
  }

  void _playLongTone() {
    FlutterBeep.playSysSound(iOSSoundIDs.AudioToneBusy);
    _vibrate();
  }

  void _clearMessage() {
    setState(() {
      _message = '';
      _restartMainTimer();
    });
  }

  void _clearSecretMessage() {
    setState(() {
      _secretMesage = '';
      _restartMainTimer();
    });
  }

  void _setResult(String result) {
    setState(() {
      _result = result;
      _secretMesage += result;
    });
  }

  void _checkMessageContents() {
    if (_message.isNotEmpty) {
      final result = checkMessage();
      _setResult(result);
      _clearMessage();
    }
  }

  void _addDotToMessage() {
    setState(() {
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
    _playBeep();
    _restartMainTimer();
  }

  void onLongPress() {
    _addDashToMessage();
    _playLongTone();
    _restartMainTimer();
  }

  @override
  Widget build(BuildContext context) {
    const otherTextStyle = TextStyle(
      fontFamily: 'Spartan MB',
      fontSize: 20.0,
      decoration: null,
      color: Colors.black,
    );
    const secretTextStyle = TextStyle(
      fontFamily: 'Spartan MB',
      fontSize: 100.0,
      decoration: null,
      color: Color.fromARGB(255, 0, 0, 0),
    );
    double? gap = 20;

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

        if (_message.isNotEmpty) {
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
        color: const Color.fromARGB(255, 255, 137, 41),
        // add to the child a Text widget that displays the string state
        child: Column(
          children: [
            Center(
              child: Text(_message, style: otherTextStyle),
            ),
            SizedBox(height: gap),
            if (_secretMesage.isNotEmpty) ...[
              Center(
                child: Text(_secretMesage, style: secretTextStyle),
              ),
            ],
            SizedBox(height: gap),
            // add a button to clear the message
          ],
        ),
      ),
    );
  }
}
