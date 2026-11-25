class Tarefa {
  String? id;
  String titulo;
  String descricao;
  DateTime dataVencimento;
  String prioridade;
  bool concluida;

  static const List<String> prioridades = ['Baixa', 'Média', 'Alta'];

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    this.prioridade = 'Média',
    this.concluida = false,
  });

  String get situacao => concluida ? 'Concluída' : 'Pendente';

  // tarefa pendente com data de vencimento anterior a hoje
  bool get atrasada {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    return !concluida && dataVencimento.isBefore(hoje);
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento.millisecondsSinceEpoch,
      'prioridade': prioridade,
      'concluida': concluida,
    };
  }

  factory Tarefa.fromMap(String id, Map<dynamic, dynamic> map) {
    return Tarefa(
      id: id,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      dataVencimento: DateTime.fromMillisecondsSinceEpoch(
        map['dataVencimento'] ?? 0,
      ),
      prioridade: map['prioridade'] ?? 'Média',
      concluida: map['concluida'] ?? false,
    );
  }
}
