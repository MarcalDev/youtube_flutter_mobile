import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey
        ),
        backgroundColor: Colors.white,
        title: Image.asset(
          "images/pngs/youtube.png",
          width: 98,
          height: 22,),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                print("acao: videocam");
              },
              icon: Icon(Icons.videocam)
          ),
          IconButton(
              onPressed: (){
                print("acao: videocam");
              },
              icon: Icon(Icons.search)
          ),
          IconButton(
              onPressed: (){
                print("acao: videocam");
              },
              icon: Icon(Icons.account_circle)
          ),
        ],
      ),
      body: Container(),
    );
  }
}
