import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../themes/app_theme.dart';
import '../widgets/drawer_menu.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().usuarioAtual;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      drawer: const DrawerMenu(telaAtual: 'configuracoes'),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Aparência',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.modoTema,
            builder: (context, modo, _) {
              return SwitchListTile(
                secondary: Icon(
                  modo == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                ),
                title: const Text('Tema escuro'),
                subtitle: const Text('A preferência fica salva no aparelho'),
                value: modo == ThemeMode.dark,
                onChanged: (valor) => AppTheme.alterarTema(valor),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Conta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(usuario?.nome ?? ''),
            subtitle: Text(usuario?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair da conta'),
            onTap: () async {
              Navigator.popUntil(context, (route) => route.isFirst);
              await AuthService().logout();
            },
          ),
        ],
      ),
    );
  }
}
