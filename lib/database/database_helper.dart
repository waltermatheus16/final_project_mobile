import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projeto_victor/model/receita.dart';

class DatabaseHelper {
  static Database? _database;

  // Inicializa o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Criação do banco de dados
  _initDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'favoritos.db');  // Nome do banco de dados
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Criação da tabela de favoritos
  _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE favoritos(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        nome TEXT, 
        descricao TEXT, 
        imagemUrl TEXT, 
        preparo TEXT)''',
    );
  }

  // Adicionar receita aos favoritos
  Future<void> addFavorito(Receita receita) async {
    final db = await database;
    
    // Verifica se a receita já existe no banco
    final List<Map<String, dynamic>> existingReceitas = await db.query(
      'favoritos',
      where: 'nome = ? AND descricao = ?',
      whereArgs: [receita.nome, receita.descricao],
    );
    
    // Se não existe, insere no banco
    if (existingReceitas.isEmpty) {
      await db.insert(
        'favoritos',
        receita.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Substitui se já existir
      );
    } else {
      print("Receita já está nos favoritos.");
    }
  }

  // Remover receita dos favoritos
  Future<void> removeFavorito(int id) async {
    final db = await database;
    await db.delete(
      'favoritos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Recuperar todas as receitas favoritas
  Future<List<Receita>> getFavoritos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favoritos');
    
    // Converte os dados de Map para a lista de objetos Receita
    return List.generate(maps.length, (i) {
      return Receita.fromMap(maps[i]);  // Usando o fromMap para converter o mapa em uma Receita
    });
  }
}
