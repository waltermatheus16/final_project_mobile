import 'package:flutter/material.dart';
import 'package:projeto_victor/database/database_helper.dart';
import 'package:projeto_victor/model/receita.dart';

class ReceitaDetailScreen extends StatefulWidget {
  final Receita receita;

  const ReceitaDetailScreen({Key? key, required this.receita}) : super(key: key);

  @override
  _ReceitaDetailScreenState createState() => _ReceitaDetailScreenState();
}

class _ReceitaDetailScreenState extends State<ReceitaDetailScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Verifica se a receita está nos favoritos ao iniciar
  }

  // Verifica se a receita já está favoritada
  Future<void> _checkIfFavorite() async {
    final favoritos = await dbHelper.getFavoritos();
    setState(() {
      isFavorite = favoritos.any((receita) => receita.id == widget.receita.id);
    });
  }

  // Função para adicionar ou remover da lista de favoritos
  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      // Se já for favorito, remove
      await dbHelper.removeFavorito(widget.receita.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receita removida dos favoritos!')),
      );
    } else {
      // Caso contrário, adiciona aos favoritos
      await dbHelper.addFavorito(widget.receita);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receita adicionada aos favoritos!')),
      );
    }

    // Atualiza o estado após a ação
    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita.nome), // Exibe o nome da receita
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border, // Muda o ícone dependendo do estado
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite, // Chama a função para favoritar/desfavoritar
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.receita.imagemUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.receita.nome,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.receita.descricao,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Modo de Preparo:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.receita.preparo,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
