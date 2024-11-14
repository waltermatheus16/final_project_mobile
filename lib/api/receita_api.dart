import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_victor/model/receita.dart'; // Certifique-se de que o caminho está correto

class ReceitaApi {
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  // Método para buscar as receitas da API
  Future<List<Receita>> fetchReceitas() async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=')); // URL para pegar as receitas

    if (response.statusCode == 200) {
      // Se a requisição for bem-sucedida, decodifica os dados
      final List<dynamic> data = json.decode(response.body)['meals'] ?? []; // Pode ser vazio se não encontrar receitas
      return data.map((json) => Receita.fromJson(json)).toList(); // Converte os dados para a lista de objetos Receita
    } else {
      throw Exception('Falha ao carregar receitas');
    }
  }
}
