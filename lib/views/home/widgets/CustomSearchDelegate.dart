import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';
import 'package:youtube_flutter_mobile/views/home/widgets/SearchedVideosListWidget.dart';

class CustomSearchDelegate extends SearchDelegate<String>{
  CustomSearchDelegate({
    required this.searchText,
    required this.showVideoList,
    //required this.showSuggestedList,
  });
  String searchText;
  bool showVideoList;
  //bool showSuggestedList;

  // botão de limpeza de texto
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query = "";
          },
      ),
    ];
  }

  // botão de voltar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, "Android");
      },
    );

  }

  // constrói os resultados
  @override
  Widget buildResults(BuildContext context) {
    //close(context,query);
    return Container();
  }

  _returnSuggestions(String pesquisa) {
    Api api = Api();
    return api.carregarSugestoes(pesquisa);
  }

  @override void showResults(BuildContext context) {
    showVideoList = true;
  }
  // define sugestões de pesquisa
  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isNotEmpty  && !showVideoList){
      return FutureBuilder<List<String>>(
        future: _returnSuggestions(query),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              if(snapshot.hasData){
                List<String>? sugList = snapshot.data;
                return Container(
                    color: Theme.of(context).primaryColor,
                    child: ListView.builder(
                        itemCount: sugList?.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            focusColor: Colors.white,
                            hoverColor: Colors.white,
                            onTap: () async{
                              //close(context, sugList![index]);
                              //_showVideosList(sugList);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => CustomSearchDelegate()
                              //await showSearch(context: context, delegate: CustomSearchDelegate(searchText: sugList![index], showVideoList: true));
                              showVideoList = true;
                              //searchText = sugList![index];
                              query = sugList![index];
                            },
                            title: Text(sugList![index]),
                          );
                        }
                    )
                );
              }
              else{
                return Center(
                  child: Text("Nenhum dado a ser exibido"),
                );
              }
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return Center();
            case ConnectionState.none:
              return Center();
          }
        },
      );
    }
    else if(showVideoList){
      showVideoList = false;
      //query = searchText;
      FocusManager.instance.primaryFocus?.unfocus();
      //return Container(child: Text("Video List"));
      return SearchedVideosListWidget(searchText: query);
    } else{
      return Container();
    }
  }
}
