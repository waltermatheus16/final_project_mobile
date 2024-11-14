class Receita {
  int? id;
  String nome;
  String descricao;
  String preparo;
  String imagemUrl;

  Receita({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preparo,
    required this.imagemUrl,
  });

  // Método para converter um objeto Receita em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preparo': preparo,
      'imagemUrl': imagemUrl,
    };
  }

  // Método para criar uma instância de Receita a partir de um mapa (de um banco de dados)
  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      preparo: map['preparo'],
      imagemUrl: map['imagemUrl'],
    );
  }

  // Método para criar uma instância de Receita a partir de um JSON (da API)
  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: null,  // A API não retorna o ID, então será null
      nome: json['strMeal'],
      descricao: json['strCategory'] ?? '',  // Se não houver descrição, coloca uma string vazia
      preparo: json['strInstructions'] ?? '',
      imagemUrl: json['strMealThumb'] ?? '',  // Caso não tenha imagem, coloca uma string vazia
    );
  }
}
