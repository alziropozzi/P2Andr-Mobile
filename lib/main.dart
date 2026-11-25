import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'screens/cadastro_usuario_screen.dart';
import 'screens/configuracoes_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tarefas_screen.dart';
import 'services/auth_service.dart';
import 'services/preferences_service.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // carrega o tema salvo antes de abrir o app
  final temaEscuro = await PreferencesService().carregarTemaEscuro();
  AppTheme.modoTema.value = temaEscuro ? ThemeMode.dark : ThemeMode.light;

  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.modoTema,
      builder: (context, modo, _) {
        return MaterialApp(
          title: 'Gerenciador de Tarefas',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: modo,
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // o firebase guarda a sessao, entao se o usuario ja estava
          // logado ele cai direto na Home
          home: StreamBuilder<User?>(
            stream: AuthService().usuarioLogado,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                return const HomeScreen();
              }
              return const LoginScreen();
            },
          ),
          routes: {
            '/cadastro-usuario': (_) => const CadastroUsuarioScreen(),
            '/tarefas': (_) => const TarefasScreen(),
            '/configuracoes': (_) => const ConfiguracoesScreen(),
          },
        );
      },
    );
  }
}
