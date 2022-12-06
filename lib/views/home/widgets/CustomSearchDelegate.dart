import 'package:flutter/material.dart';

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

  // define sugestões de pesquisa
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionsList;

    if( query.isNotEmpty){
      suggestionsList = [
        "Android", "Android Navegação", "IOS", "Jogos"
      ].where(
          (texto) => texto.toLowerCase().startsWith( query.toLowerCase() )
      ).toList();

      return ListView.builder(
          itemCount: suggestionsList.length,
          itemBuilder: (context, index){
            return ListTile(
              onTap: (){
                close(context, suggestionsList[index]);
              },
              title: Text(suggestionsList[index]),
            );
          }
      );
    } else{
      return Center(
        child: Text("Nenhum resultado para a pesquisa"),
      );
    }

  }

}
