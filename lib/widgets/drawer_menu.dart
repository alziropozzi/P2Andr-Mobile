import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  // usado pra marcar qual opcao esta selecionada: inicio, tarefas ou configuracoes
  final String telaAtual;

  const DrawerMenu({super.key, required this.telaAtual});

  void _abrirTela(BuildContext context, String rota) {
    final navigator = Navigator.of(context);
    navigator.pop(); // fecha o drawer

    if (rota == telaAtual) return;

    // volta pra Home (primeira tela) e abre a tela escolhida por cima
    navigator.popUntil((route) => route.isFirst);
    if (rota != 'inicio') {
      navigator.pushNamed('/$rota');
    }
  }

  void _mostrarSobre(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Gerenciador de Tarefas',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.task_alt, size: 40),
      children: const [
        Text(
          'Aplicativo desenvolvido para a P2 da disciplina de Programação '
          'Mobile. Permite cadastrar e gerenciar tarefas pessoais, com os '
          'dados salvos no Firebase Realtime Database.',
        ),
      ],
    );
  }

  Future<void> _sair(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.popUntil((route) => route.isFirst);
    await AuthService().logout();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().usuarioAtual;
    final nome = (usuario?.nome.isNotEmpty ?? false) ? usuario!.nome : 'Usuário';
    final email = usuario?.email ?? '';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(nome),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                nome[0].toUpperCase(),
                style: const TextStyle(fontSize: 28),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            selected: telaAtual == 'inicio',
            onTap: () => _abrirTela(context, 'inicio'),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Minhas tarefas'),
            selected: telaAtual == 'tarefas',
            onTap: () => _abrirTela(context, 'tarefas'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            selected: telaAtual == 'configuracoes',
            onTap: () => _abrirTela(context, 'configuracoes'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o aplicativo'),
            onTap: () => _mostrarSobre(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () => _sair(context),
          ),
        ],
      ),
    );
  }
}
