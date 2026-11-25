# Gerenciador de Tarefas - P2 Programação Mobile

Aplicativo mobile feito em **Flutter** para gerenciamento de tarefas pessoais, usando **Firebase Authentication** (login por e-mail e senha) e **Firebase Realtime Database** para guardar as tarefas na nuvem. Cada usuário vê e altera somente as suas próprias tarefas.

## Vídeo de demonstração




## Funcionalidades

- Cadastro de usuário (nome, e-mail e senha), login e logout
- Validação dos campos e mensagens de erro de autenticação em português
- Sessão mantida ao fechar e abrir o app (gerenciada pelo Firebase)
- Tela inicial com o nome do usuário e a quantidade de tarefas cadastradas, pendentes e concluídas
- Menu lateral (Drawer) com Início, Minhas tarefas, Configurações, Sobre o aplicativo e Sair, mostrando nome e e-mail do usuário
- Cadastro de tarefas com título, descrição, data de vencimento, prioridade (Baixa, Média, Alta) e situação (Pendente, Concluída)
- Listagem em `ListView` com cores/ícones por prioridade e filtro (Todas, Pendentes, Concluídas)
- Tela de detalhes da tarefa, edição, exclusão e alteração de situação (pendente ⇄ concluída)
- Atualização em tempo real usando listeners do Realtime Database (`onValue`)
- Tema claro e escuro salvo com `SharedPreferences` e carregado ao abrir o app

## Tecnologias

| Recurso | Uso |
| --- | --- |
| Flutter / Dart | Desenvolvimento do aplicativo |
| Drawer | Menu lateral de navegação |
| ListView | Listagem das tarefas |
| Firebase Authentication | Cadastro e login por e-mail |
| Firebase Realtime Database | Persistência das tarefas |
| SharedPreferences | Preferência de tema |
| ThemeData / ThemeMode | Temas claro e escuro |
| Models | Classes `Usuario` e `Tarefa` |

## Estrutura do projeto

```
lib/
 ├── main.dart
 ├── firebase_options.dart
 ├── models/
 │   ├── usuario.dart
 │   └── tarefa.dart
 ├── screens/
 │   ├── login_screen.dart
 │   ├── cadastro_usuario_screen.dart
 │   ├── home_screen.dart
 │   ├── tarefas_screen.dart
 │   ├── detalhe_tarefa_screen.dart
 │   ├── cadastro_tarefa_screen.dart
 │   └── configuracoes_screen.dart
 ├── services/
 │   ├── auth_service.dart
 │   ├── firebase_service.dart
 │   └── preferences_service.dart
 ├── widgets/
 │   └── drawer_menu.dart
 └── themes/
     └── app_theme.dart
```

## Estrutura dos dados no Realtime Database


```
usuarios/
  {uid}/
    nome: "Maria"
    email: "maria@email.com"
tarefas/
  {uid}/
    {idTarefa}/
      titulo: "Estudar Flutter"
      descricao: "Revisar Firebase"
      dataVencimento: 1764547200000
      prioridade: "Alta"
      concluida: false
```

As tarefas ficam dentro do `uid` do usuário logado, e as regras do banco (`database.rules.json`) só deixam cada usuário ler e escrever no próprio nó.

## Como configurar o Firebase

1. Acesse o [Firebase Console](https://console.firebase.google.com/) e crie um projeto.
2. Em **Authentication > Método de login**, ative **E-mail/senha**.
3. Em **Realtime Database**, clique em **Criar banco de dados** (pode iniciar no modo bloqueado).
4. Na aba **Regras** do Realtime Database, cole o conteúdo do arquivo `database.rules.json` e publique.
5. Instale as ferramentas (se ainda não tiver):
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
6. Faça login e configure o projeto Flutter (isso gera o `lib/firebase_options.dart` e o `google-services.json`):
   ```bash
   firebase login
   flutterfire configure
   ```
   Selecione o projeto criado e as plataformas Android e iOS.

> Importante: crie o Realtime Database **antes** de rodar o `flutterfire configure`, assim o `databaseURL` já vem preenchido no `firebase_options.dart`.

## Como executar

Pré-requisitos: Flutter SDK instalado e um emulador ou celular conectado.

```bash
flutter pub get
flutter run
```

Para rodar os testes dos models:

```bash
flutter test
```

## Capturas de tela

| Login | Cadastro | Início |
| --- | --- | --- |
| ![Login]() | ![Cadastro]() | ![Início]() |

| Minhas tarefas | Nova tarefa | Detalhes |
| --- | --- | --- |
| ![Minhas tarefas]() | ![Nova tarefa]() | ![Detalhes]() |

| Tema escuro | Realtime Database |
| --- | --- |
| ![Tema escuro]() | ![Realtime Database]() |
