import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_tarefas/models/tarefa.dart';
import 'package:gerenciador_tarefas/models/usuario.dart';

void main() {
  test('Tarefa converte para Map e volta igual', () {
    final tarefa = Tarefa(
      titulo: 'Estudar Flutter',
      descricao: 'Revisar Firebase',
      dataVencimento: DateTime(2026, 12, 1),
      prioridade: 'Alta',
    );

    final copia = Tarefa.fromMap('abc123', tarefa.toMap());

    expect(copia.id, 'abc123');
    expect(copia.titulo, 'Estudar Flutter');
    expect(copia.dataVencimento, DateTime(2026, 12, 1));
    expect(copia.prioridade, 'Alta');
    expect(copia.concluida, false);
    expect(copia.situacao, 'Pendente');
  });

  test('Usuario converte para Map', () {
    final usuario = Usuario(uid: '1', nome: 'Maria', email: 'maria@email.com');
    final map = usuario.toMap();

    expect(map['nome'], 'Maria');
    expect(Usuario.fromMap('1', map).email, 'maria@email.com');
  });
}
