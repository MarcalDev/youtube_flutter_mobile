import 'package:flutter/material.dart';

class BibliotecaPage extends StatefulWidget {
  const BibliotecaPage({Key? key}) : super(key: key);

  @override
  State<BibliotecaPage> createState() => _BibliotecaPageState();
}

class _BibliotecaPageState extends State<BibliotecaPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Biblioteca"
      ),
    );
  }
}
