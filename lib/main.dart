import 'package:flutter/material.dart';
import 'package:myapp/modelos/planeta.dart';
import 'package:myapp/telas/tela_planeta.dart';
import 'controles/controle_planeta.dart';

// Função principal que inicia o aplicativo Flutter
void main() {
  runApp(const MyApp());
}

// Classe principal do aplicativo que configura o tema e define a tela inicial
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planetas', // Título do aplicativo
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent), 
        useMaterial3: true, 
      ),
      home: const MyHomePage(
        title: 'App Planetas', // Define a tela inicial
      ),
    );
  }
}

// Tela inicial do aplicativo (StatefulWidget permite mudanças de estado)
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title, 
  });

  final String title; 

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Classe de estado da tela inicial
class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta(); 
  List<Planeta> _planetas = []; 

// Chama a função para carregar os planetas ao iniciar a tela
  @override
  void initState() {
    super.initState();
    _atualizarPlanetas(); 
  }

  // Função assíncrona para carregar os planetas da base de dados
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado; // Atualiza a lista de planetas na interface
    });
  }

  // Abre a tela para incluir um novo planeta
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true, 
          planeta: Planeta.vazio(), 
          onFinalizado: () {
            _atualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Abre a tela para editar um planeta existente
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false, 
          planeta: planeta, 
          onFinalizado: () {
            _atualizarPlanetas(); 
          },
        ),
      ),
    );
  }

  // Exclui um planeta pelo ID e atualiza a lista
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _atualizarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true, 
        title: Text(widget.title), 
      ),
      body: ListView.builder(
        itemCount: _planetas.length, 
        itemBuilder: (context, index) {
          final planeta = _planetas[index]; 
          return ListTile(
            title: Text(planeta.nome), 
            subtitle: Text(planeta.apelido!), 
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit), 
                  onPressed: () => _alterarPlaneta(context, planeta), 
                ),
                IconButton(
                  icon: const Icon(Icons.delete), 
                  onPressed: () => _excluirPlaneta(planeta.id!), 
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context); 
        },
        tooltip: 'Adicionar Planeta', 
        child: const Icon(Icons.add), 
      ),
    );
  }
}
