import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../themes/app_theme.dart';

// mesma tela serve pra cadastrar e pra editar (quando recebe uma tarefa)
class CadastroTarefaScreen extends StatefulWidget {
  final Tarefa? tarefa;

  const CadastroTarefaScreen({super.key, this.tarefa});

  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _firebaseService = FirebaseService();
  final _formatoData = DateFormat('dd/MM/yyyy');

  DateTime? _dataVencimento;
  String _prioridade = 'Média';
  bool _concluida = false;
  bool _salvando = false;

  bool get _editando => widget.tarefa != null;

  @override
  void initState() {
    super.initState();
    if (_editando) {
      final tarefa = widget.tarefa!;
      _tituloController.text = tarefa.titulo;
      _descricaoController.text = tarefa.descricao;
      _dataVencimento = tarefa.dataVencimento;
      _dataController.text = _formatoData.format(tarefa.dataVencimento);
      _prioridade = tarefa.prioridade;
      _concluida = tarefa.concluida;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _dataVencimento ?? hoje,
      firstDate: DateTime(hoje.year - 1),
      lastDate: DateTime(hoje.year + 5),
    );

    if (data != null) {
      setState(() {
        _dataVencimento = data;
        _dataController.text = _formatoData.format(data);
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final tarefa = Tarefa(
      id: widget.tarefa?.id,
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      dataVencimento: _dataVencimento!,
      prioridade: _prioridade,
      concluida: _concluida,
    );

    try {
      if (_editando) {
        await _firebaseService.atualizarTarefa(tarefa);
      } else {
        await _firebaseService.adicionarTarefa(tarefa);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editando ? 'Tarefa atualizada!' : 'Tarefa cadastrada!'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar a tarefa.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o título da tarefa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataController,
                readOnly: true,
                onTap: _selecionarData,
                decoration: const InputDecoration(
                  labelText: 'Data de vencimento',
                  prefixIcon: Icon(Icons.event),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                validator: (_) {
                  if (_dataVencimento == null) {
                    return 'Selecione a data de vencimento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _prioridade,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: Tarefa.prioridades.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 14, color: AppTheme.corPrioridade(p)),
                        const SizedBox(width: 8),
                        Text(p),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() => _prioridade = valor!);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                initialValue: _concluida,
                decoration: const InputDecoration(
                  labelText: 'Situação',
                  prefixIcon: Icon(Icons.task_alt),
                ),
                items: const [
                  DropdownMenuItem(value: false, child: Text('Pendente')),
                  DropdownMenuItem(value: true, child: Text('Concluída')),
                ],
                onChanged: (valor) {
                  setState(() => _concluida = valor!);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _salvando ? null : _salvar,
                  icon: const Icon(Icons.save),
                  label: Text(_salvando ? 'Salvando...' : 'Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
