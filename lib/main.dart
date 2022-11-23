import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notes_notes/screens/showlist.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShowList(),
    );
  }
}
