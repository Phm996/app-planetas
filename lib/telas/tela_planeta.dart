import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart';
import 'package:myapp/modelos/planeta.dart';

// Tela de cadastro/edição de um planeta
class TelaPlaneta extends StatefulWidget {
  final bool isIncluir; // Indica se a tela está sendo usada para inclusão (true) ou edição (false)
  final Planeta planeta; // Objeto do planeta que será cadastrado ou editado
  final Function() onFinalizado; // Função chamada quando a ação for concluída

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

// Estado da tela de cadastro/edição do planeta
class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>(); 

  // Controladores para os campos de entrada de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta(); 

  late Planeta _planeta; // Variável para armazenar o planeta sendo editado

  @override
  void initState() {
    super.initState();
    _planeta = widget.planeta;
    
    // Inicializa os controladores apenas se os valores existirem
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho > 0 ? _planeta.tamanho.toString() : '';
    _distanciaController.text = _planeta.distancia > 0 ? _planeta.distancia.toString() : '';
    _apelidoController.text = _planeta.apelido ?? '';
  }

  @override
  void dispose() {
    // Libera os controladores ao sair da tela para evitar vazamento de memória
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  // Método para inserir um novo planeta no banco de dados
  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(planeta: _planeta);
  }

  // Método para alterar os dados de um planeta já existente
  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  // Valida e envia o formulário
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Salva os valores do formulário no objeto Planeta

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Dados do planeta ${widget.isIncluir ? 'incluídos' : 'alterados'} com sucesso!'),
        ),
      );

      Navigator.of(context).pop(); // Fecha a tela após salvar os dados
      widget.onFinalizado(); // Chama a função de atualização da tela principal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'), // Título da tela
        elevation: 3, 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
        child: Form(
          key: _formKey, 
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo para inserir o nome do planeta
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Por favor, insira o nome do planeta (3 ou mais caracteres)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),
                const SizedBox(height: 40),

                // Campo para inserir o tamanho do planeta
                TextFormField(
                  controller: _tamanhoController,
                  decoration: InputDecoration(
                    labelText: 'Tamanho (em Km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  keyboardType: TextInputType.number, // Aceita apenas números
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Garante que apenas números possam ser digitados
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tamanho do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
                const SizedBox(height: 40),

                // Campo para inserir a distância do planeta
                TextFormField(
                  controller: _distanciaController,
                  decoration: InputDecoration(
                    labelText: 'Distância (em Km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  keyboardType: TextInputType.number, // Aceita apenas números
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Garante entrada numérica
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a distância do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.tryParse(value ?? '0') ?? 0.0;
                  },
                ),
                const SizedBox(height: 40),

                // Campo para inserir o apelido do planeta
                TextFormField(
                  controller: _apelidoController,
                  decoration: InputDecoration(
                    labelText: 'Apelido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um apelido para o planeta';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.apelido = value!;
                  },
                ),
                const SizedBox(height: 60.0),

                // Botões de ação (Cancelar e Confirmar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(), // Fecha a tela sem salvar
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm, // Salva os dados e fecha a tela
                      child: const Text('Confirmar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
