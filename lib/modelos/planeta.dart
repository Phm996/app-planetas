class Planeta {
  int? id; // Identificador único do planeta (pode ser nulo para novos planetas)
  String nome; // Nome do planeta
  double tamanho; // Tamanho do planeta (em quilômetros)
  double distancia; // Distância do planeta (em quilômetros)
  String? apelido; // Apelido do planeta (opcional)

  // Construtor principal da classe Planeta
  Planeta({
    this.id, // ID pode ser nulo porque é gerado automaticamente no banco de dados
    required this.nome, // Nome obrigatório
    required this.tamanho, // Tamanho obrigatório
    required this.distancia, // Distância obrigatória
    this.apelido, // Apelido opcional
  });

  // Construtor alternativo que cria um objeto Planeta vazio
  Planeta.vazio()
      : nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        apelido = '';

  // Método factory que cria um objeto Planeta a partir de um mapa (usado ao recuperar dados do banco)
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'], // Obtém o ID do mapa
      nome: map['nome'], // Obtém o nome do mapa
      tamanho: map['tamanho'], // Obtém o tamanho do mapa
      distancia: map['distancia'], // Obtém a distância do mapa
      apelido: map['apelido'], // Obtém o apelido do mapa (pode ser nulo)
    );
  }

  // Método que converte um objeto Planeta para um mapa (usado para armazenar dados no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // ID do planeta
      'nome': nome, // Nome do planeta
      'tamanho': tamanho, // Tamanho do planeta
      'distancia': distancia, // Distância do planeta
      'apelido': apelido, // Apelido do planeta (pode ser nulo)
    };
  }
}
