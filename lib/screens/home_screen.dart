import 'dart:async';

import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firebaseService = FirebaseService();
  StreamSubscription<List<Tarefa>>? _listener;

  List<Tarefa> _tarefas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    // fica escutando as tarefas pra atualizar os contadores em tempo real
    _listener = _firebaseService.ouvirTarefas().listen(
      (tarefas) {
        setState(() {
          _tarefas = tarefas;
          _carregando = false;
        });
      },
      onError: (erro) {
        debugPrint('Erro ao carregar tarefas: $erro');
        setState(() => _carregando = false);
      },
    );
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().usuarioAtual;
    final nome = (usuario?.nome.isNotEmpty ?? false) ? usuario!.nome : 'Usuário';

    final total = _tarefas.length;
    final concluidas = _tarefas.where((t) => t.concluida).length;
    final pendentes = total - concluidas;

    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: const DrawerMenu(telaAtual: 'inicio'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroTarefaScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Olá, $nome!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Aqui está o resumo das suas tarefas.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          if (_carregando)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                _cardResumo('Cadastradas', total, Icons.list_alt, Colors.blue),
                _cardResumo('Pendentes', pendentes, Icons.schedule, Colors.cyan),
                _cardResumo('Concluídas', concluidas, Icons.check_circle, Colors.grey),
              ],
            ),
          const SizedBox(height: 24),
          Text('Acesso rápido', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Minhas tarefas'),
              subtitle: const Text('Ver, editar e concluir tarefas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/tarefas'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add_task),
              title: const Text('Cadastrar tarefa'),
              subtitle: const Text('Adicionar uma nova tarefa'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CadastroTarefaScreen(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              subtitle: const Text('Tema claro ou escuro'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/configuracoes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardResumo(String titulo, int quantidade, IconData icone, Color cor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icone, color: cor, size: 30),
              const SizedBox(height: 8),
              Text(
                '$quantidade',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(titulo, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
