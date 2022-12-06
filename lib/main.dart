import 'package:flutter/material.dart';

import 'views/home/pages/HomePage.dart';

void main() => runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark(),
      // darkTheme: ThemeData(
      //   primaryColor: Colors.black87,
      //   backgroundColor: const Color(0xff303030),
      // ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
));
