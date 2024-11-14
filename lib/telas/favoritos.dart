import 'package:flutter/material.dart';
import 'package:projeto_victor/database/database_helper.dart';
import 'package:projeto_victor/model/receita.dart';
import 'package:projeto_victor/telas/receita_detalhe.dart'; // Para abrir detalhes da receita

class FavoritosScreen extends StatefulWidget {
  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Receita>> _favoritos;

  @override
  void initState() {
    super.initState();
    _loadFavoritos();
  }

  // Função para carregar os favoritos
  _loadFavoritos() {
    setState(() {
      _favoritos = dbHelper.getFavoritos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<Receita>>(
        future: _favoritos, // Utiliza o Future carregado para exibir os favoritos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar favoritos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma receita favorita.'));
          } else {
            final receitas = snapshot.data!;
            return ListView.builder(
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      receitas[index].nome,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      receitas[index].descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        receitas[index].imagemUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await dbHelper.removeFavorito(receitas[index].id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Receita removida dos favoritos!')),
                        );
                        _loadFavoritos(); // Atualiza a lista de favoritos
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceitaDetailScreen(receita: receitas[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
