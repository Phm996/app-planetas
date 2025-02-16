import 'package:myapp/modelos/planeta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Classe responsável pelo controle do banco de dados dos planetas
class ControlePlaneta {
  static Database? _bd; // Instância do banco de dados

  // Getter assíncrono que retorna a instância do banco de dados, inicializando se necessário
  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db'); // Inicializa o banco de dados
    return _bd!;
  }

  // Método para inicializar o banco de dados SQLite
  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath(); // Obtém o caminho do banco de dados no dispositivo
    final caminho = join(caminhoBD, localArquivo); // Define o caminho do arquivo do banco de dados

    return await openDatabase(
      caminho,
      version: 1, // Define a versão do banco de dados
      onCreate: _criarBD, // Chama o método que cria a estrutura do banco de dados
    );
  }

  // Método chamado ao criar o banco de dados, define a estrutura da tabela "planetas"
  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
    CREATE TABLE planetas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      tamanho REAL NOT NULL,
      distancia REAL NOT NULL,
      apelido TEXT
    );
    ''';

    await bd.execute(sql); // Executa o comando SQL para criar a tabela
  }

  // Método para ler todos os planetas cadastrados no banco de dados
  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd; // Obtém a instância do banco de dados
    final resultado = await db.query('planetas'); // Consulta todos os registros da tabela "planetas"

    // Converte os resultados do banco em uma lista de objetos do tipo Planeta
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  // Método para inserir um novo planeta no banco de dados
  Future<int> inserirPlaneta({required Planeta planeta}) async {
    final bd = await ControlePlaneta().bd; // Obtém a instância do banco de dados
    return await bd.insert('planetas', planeta.toMap()); // Insere o planeta e retorna o ID gerado
  }

  // Método para alterar os dados de um planeta existente
  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd; // Obtém a instância do banco de dados
    return await db.update(
      'planetas',
      planeta.toMap(), // Converte o objeto para um mapa e atualiza no banco
      where: 'id = ?', // Define a condição de atualização pelo ID
      whereArgs: [planeta.id], // Passa o ID como argumento para evitar SQL injection
    );
  }

  // Método para excluir um planeta pelo ID
  Future<int> excluirPlaneta(int id) async {
    final db = await bd; // Obtém a instância do banco de dados
    return await db.delete(
      'planetas',
      where: 'id = ?', // Define a condição de exclusão pelo ID
      whereArgs: [id], // Passa o ID como argumento para evitar SQL injection
    );
  }
}
