import 'package:flutter/material.dart';
import 'package:projeto_victor/api/receita_api.dart';  // Certifique-se de que o caminho está correto
import 'package:projeto_victor/model/receita.dart';
import 'package:projeto_victor/telas/receita_detalhe.dart'; // Importa a tela de detalhes da receita

class HomeScreen extends StatelessWidget {
  final ReceitaApi receitaApi = ReceitaApi(); // Instância da API para buscar as receitas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        backgroundColor: Colors.orangeAccent,  // Cor de fundo do AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favoritos');  // Navegação para a tela de favoritos
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Receita>>(
        future: receitaApi.fetchReceitas(), // Chama a função para buscar as receitas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Exibe o carregamento enquanto busca as receitas
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar receitas'));  // Mensagem de erro
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma receita encontrada.'));
          } else {
            final receitas = snapshot.data!;
            return ListView.builder(
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      receitas[index].nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      receitas[index].descricao,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    onTap: () {
                      // Navegar para a tela de detalhes da receita
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceitaDetailScreen(receita: receitas[index]), // Passando a receita para a tela de detalhes
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
