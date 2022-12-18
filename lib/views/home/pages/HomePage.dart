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
  Color _bottomBarIconColor = Colors.red;
  Color _appBarIconColor = Colors.grey;
  Color _unselectedBottomBarItemColor = Colors.grey;


  int _indiceAtual = 0;
  String _resultado = "";

  
  @override
  Widget build(BuildContext context) {

    bool _isDarkMode;
    final brightness = MediaQuery.of(context).platformBrightness;
    _isDarkMode = brightness == Brightness.dark;

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
        title: Image.asset( (_isDarkMode)?"images/pngs/youtube_dark_mode.png":"images/pngs/youtube.png",
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
