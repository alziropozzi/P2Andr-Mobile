import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../themes/app_theme.dart';
import 'cadastro_tarefa_screen.dart';

class DetalheTarefaScreen extends StatelessWidget {
  final String tarefaId;

  const DetalheTarefaScreen({super.key, required this.tarefaId});

  Future<void> _confirmarExclusao(BuildContext context, Tarefa tarefa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja realmente excluir a tarefa "${tarefa.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmou != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    await FirebaseService().excluirTarefa(tarefa.id!);
    messenger.showSnackBar(
      const SnackBar(content: Text('Tarefa excluída.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Tarefa?>(
      stream: FirebaseService().ouvirTarefa(tarefaId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final tarefa = snapshot.data;
        if (tarefa == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes')),
            body: const Center(child: Text('Tarefa não encontrada.')),
          );
        }

        final cor = AppTheme.corPrioridade(tarefa.prioridade);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes'),
            actions: [
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CadastroTarefaScreen(tarefa: tarefa),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Excluir',
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmarExclusao(context, tarefa),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                tarefa.titulo,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Descrição'),
                      subtitle: Text(
                        tarefa.descricao.isEmpty ? 'Sem descrição' : tarefa.descricao,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: const Text('Data de vencimento'),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(tarefa.dataVencimento) +
                            (tarefa.atrasada ? ' (atrasada)' : ''),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.flag, color: cor),
                      title: const Text('Prioridade'),
                      subtitle: Text(
                        tarefa.prioridade,
                        style: TextStyle(color: cor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        tarefa.concluida ? Icons.check_circle : Icons.schedule,
                        color: tarefa.concluida ? Colors.green : Colors.orange,
                      ),
                      title: const Text('Situação'),
                      subtitle: Text(tarefa.situacao),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => FirebaseService().alterarSituacao(tarefa),
                icon: Icon(tarefa.concluida ? Icons.undo : Icons.check),
                label: Text(
                  tarefa.concluida
                      ? 'Marcar como pendente'
                      : 'Marcar como concluída',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
