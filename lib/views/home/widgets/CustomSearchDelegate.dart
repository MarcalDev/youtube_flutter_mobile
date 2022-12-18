import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';

class CustomSearchDelegate extends SearchDelegate<String>{

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
      // IconButton(
      //   icon: Icon(Icons.done),
      //   onPressed: (){
      //   },
      // ),
    ];
  }

  // botão de voltar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, "");
      },
      );

  }

  // constrói os resultados
  @override
  Widget buildResults(BuildContext context) {
    close(context,query);
    return Container();
  }

  _returnSuggestions(String pesquisa) {
    Api api = Api();
    return api.carregarSugestoes(pesquisa);
  }

  // define sugestões de pesquisa
  @override
  Widget buildSuggestions(BuildContext context) {
    if( query.isNotEmpty){

      return FutureBuilder<List<String>>(
        future: _returnSuggestions(query),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              if(snapshot.hasData){
                List<String>? sugList = snapshot.data;
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: sugList?.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          onTap: (){
                            close(context, sugList![index]);
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

    } else{
    return Center(
      child: Text(""),
      );
    }



  }

}
