import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/tarefa.dart';
import '../models/usuario.dart';

// Estrutura no Realtime Database:
// usuarios/{uid}            -> dados do usuario
// tarefas/{uid}/{idTarefa}  -> tarefas do usuario logado
class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference get _tarefasRef => _database.ref('tarefas/$_uid');

  Future<void> salvarUsuario(Usuario usuario) async {
    await _database.ref('usuarios/${usuario.uid}').set(usuario.toMap());
  }

  // listener que devolve a lista atualizada sempre que algo muda no banco
  Stream<List<Tarefa>> ouvirTarefas() {
    return _tarefasRef.onValue.map((event) {
      final List<Tarefa> tarefas = [];
      final dados = event.snapshot.value;

      if (dados is Map) {
        dados.forEach((chave, valor) {
          tarefas.add(Tarefa.fromMap(chave.toString(), valor as Map));
        });
      }

      tarefas.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      return tarefas;
    });
  }

  // listener de uma tarefa so (usado na tela de detalhes)
  Stream<Tarefa?> ouvirTarefa(String id) {
    return _tarefasRef.child(id).onValue.map((event) {
      final dados = event.snapshot.value;
      if (dados is Map) {
        return Tarefa.fromMap(id, dados);
      }
      return null;
    });
  }

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    final novaRef = _tarefasRef.push();
    tarefa.id = novaRef.key;
    await novaRef.set(tarefa.toMap());
  }

  Future<void> atualizarTarefa(Tarefa tarefa) async {
    await _tarefasRef.child(tarefa.id!).update(tarefa.toMap());
  }

  Future<void> alterarSituacao(Tarefa tarefa) async {
    await _tarefasRef.child(tarefa.id!).update({'concluida': !tarefa.concluida});
  }

  Future<void> excluirTarefa(String id) async {
    await _tarefasRef.child(id).remove();
  }
}
