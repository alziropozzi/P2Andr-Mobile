import 'package:firebase_auth/firebase_auth.dart';

import '../models/usuario.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // userChanges tambem avisa quando o nome (displayName) e atualizado
  Stream<User?> get usuarioLogado => _auth.userChanges();

  Usuario? get usuarioAtual {
    final user = _auth.currentUser;
    if (user == null) return null;

    return Usuario(
      uid: user.uid,
      nome: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  // retorna null se deu certo, senao retorna a mensagem de erro
  Future<String?> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _tratarErro(e.code);
    } catch (e) {
      return 'Erro inesperado ao fazer login.';
    }
  }

  Future<String?> cadastrar(String nome, String email, String senha) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final user = credencial.user!;
      await user.updateDisplayName(nome.trim());

      final usuario = Usuario(
        uid: user.uid,
        nome: nome.trim(),
        email: email.trim(),
      );
      await FirebaseService().salvarUsuario(usuario);

      await user.reload();
      return null;
    } on FirebaseAuthException catch (e) {
      return _tratarErro(e.code);
    } catch (e) {
      return 'Erro inesperado ao cadastrar usuário.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _tratarErro(String codigo) {
    switch (codigo) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Este usuário foi desativado.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro de autenticação ($codigo).';
    }
  }
}
