import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_flutter_mobile/views/home/pages/BibliotecaPage.dart';
import 'package:youtube_flutter_mobile/views/home/pages/InscricoesPage.dart';
import 'package:youtube_flutter_mobile/views/home/widgets/CustomSearchDelegate.dart';

import 'EmAltaPage.dart';
import 'InicioPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //cores para modo escuro/claro
  bool _lightThemeOn = true;
  Color _bottomBarIconColor = Colors.red;
  Color _appBarIconColor = Colors.grey;
  Color _appBarBackgroundColor = Colors.white;
  Color _bottomBarBackgroundColor = Colors.white;
  Color _unselectedBottomBarItemColor = Colors.grey;
  Color _selectedBottomBarItemColor = Colors.red;
  Color _pageBackgroundColor = Colors.white;

  _changeTheme(){
    if(_lightThemeOn){
      setState(() {
        _bottomBarIconColor = Colors.white;
        _appBarIconColor = Colors.white;
        _appBarBackgroundColor = Colors.black87;
        _bottomBarBackgroundColor = Colors.black87;
        _unselectedBottomBarItemColor = Colors.white60;
        _selectedBottomBarItemColor = Colors.white;
        _pageBackgroundColor = Colors.black54;
        _lightThemeOn = false;
      });
    }else{
      setState(() {
        _bottomBarIconColor = Colors.red;
        _appBarIconColor = Colors.grey;
        _appBarBackgroundColor = Colors.white;
        _bottomBarBackgroundColor = Colors.white;
        _unselectedBottomBarItemColor = Colors.grey;
        _selectedBottomBarItemColor = Colors.red;
        _pageBackgroundColor = Colors.white;
        _lightThemeOn = true;
      });
    }

  }

  int _indiceAtual = 0;
  String _resultado = "";
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    List<Widget> screens = [
      InicioPage(_resultado),
      EmAltaPage(),
      InscricoesPage(),
      BibliotecaPage()
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: _appBarIconColor
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Image.asset(
          "images/pngs/youtube.png",
          width: 98,
          height: 22,),
        actions: <Widget>[
          IconButton(
              onPressed: () async{
                String? res = await showSearch(context: context, delegate: CustomSearchDelegate());
                setState(() {
                  _resultado = res.toString();
                });
              },
              icon: Icon(Icons.search)
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        child: screens[_indiceAtual],
      ),
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _indiceAtual,
        onTap: (indice){
          setState(() {
            _indiceAtual = indice;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: _bottomBarIconColor,
        unselectedItemColor: _unselectedBottomBarItemColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            label: "Em alta",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: "Inscrições",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Biblioteca",
          ),
        ]
      ),
    );
  }
}
