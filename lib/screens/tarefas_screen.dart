import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../themes/app_theme.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';
import 'detalhe_tarefa_screen.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final _firebaseService = FirebaseService();
  final _formatoData = DateFormat('dd/MM/yyyy');
  StreamSubscription<List<Tarefa>>? _listener;

  List<Tarefa> _tarefas = [];
  bool _carregando = true;
  String _filtro = 'Todas';

  @override
  void initState() {
    super.initState();
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

  List<Tarefa> get _tarefasFiltradas {
    if (_filtro == 'Pendentes') {
      return _tarefas.where((t) => !t.concluida).toList();
    }
    if (_filtro == 'Concluídas') {
      return _tarefas.where((t) => t.concluida).toList();
    }
    return _tarefas;
  }

  Future<void> _alterarSituacao(Tarefa tarefa) async {
    try {
      await _firebaseService.alterarSituacao(tarefa);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível alterar a situação.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      drawer: const DrawerMenu(telaAtual: 'tarefas'),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova tarefa',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroTarefaScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Todas', label: Text('Todas')),
                ButtonSegment(value: 'Pendentes', label: Text('Pendentes')),
                ButtonSegment(value: 'Concluídas', label: Text('Concluídas')),
              ],
              selected: {_filtro},
              onSelectionChanged: (selecao) {
                setState(() => _filtro = selecao.first);
              },
            ),
          ),
          Expanded(child: _montarLista()),
        ],
      ),
    );
  }

  Widget _montarLista() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    final lista = _tarefasFiltradas;

    if (lista.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 8),
            Text('Nenhuma tarefa encontrada'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final tarefa = lista[index];
        final cor = AppTheme.corPrioridade(tarefa.prioridade);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: cor.withValues(alpha: 0.15),
              child: Icon(AppTheme.iconePrioridade(tarefa.prioridade), color: cor),
            ),
            title: Text(
              tarefa.titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vence em ${_formatoData.format(tarefa.dataVencimento)}'
                  '${tarefa.atrasada ? ' (atrasada)' : ''}',
                  style: TextStyle(color: tarefa.atrasada ? Colors.red : null),
                ),
                Text(
                  'Prioridade ${tarefa.prioridade} • ${tarefa.situacao}',
                  style: TextStyle(
                    color: tarefa.concluida ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: Checkbox(
              value: tarefa.concluida,
              onChanged: (_) => _alterarSituacao(tarefa),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalheTarefaScreen(tarefaId: tarefa.id!),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
