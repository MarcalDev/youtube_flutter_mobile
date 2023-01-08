import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_flutter_mobile/views/home/pages/HomePage.dart';
import 'package:youtube_flutter_mobile/views/home/pages/LibraryPage.dart';
import 'package:youtube_flutter_mobile/views/home/pages/SubscripitionsPage.dart';
import 'package:youtube_flutter_mobile/views/home/pages/TrendingPage.dart';
import 'package:youtube_flutter_mobile/views/home/widgets/CustomSearchDelegate.dart';


class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);

  @override
  State<TabViewPage> createState() => _TabViewPageState();

}

class _TabViewPageState extends State<TabViewPage> {
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
      HomePage((_resultado.isNotEmpty)? _resultado : "Android"),
      TrendingPage(),
      SubscripitionsPage(),
      LibraryPage()
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
            if(indice == 0){
              setState((){
                _resultado = "";
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: _bottomBarIconColor,
          unselectedItemColor: _unselectedBottomBarItemColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
              label: "Trending",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions),
              label: "Subscriptions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: "Library",
            ),
          ]
      ),
    );
  }
}
