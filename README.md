

# App Gerenciador de Tarefas

Feito em **Flutter** que faz gerenciamento de tarefas, usando **Firebase Authentication** e **Firebase Realtime Database**. 

## Funcionalidades

- Autenticação e controle de acesso: Cadastro de usuário, login e logout
- Painel inicial (Dashboard):Gaveta de navegação contendo os dados do perfil (nome e e-mail) e atalhos para as telas de Início, Minhas Tarefas, Configurações, Sobre o App e encerramento de sessão.
- Navegação por menu lateral (Drawer): com Início, Minhas tarefas, Configurações, Sobre o aplicativo e Sair, mostrando nome e e-mail do usuário
- Registro de novas atividades: Cadastro de tarefas com título, descrição, data de vencimento, prioridade (Baixa, Média, Alta) e situação (Pendente, Concluída)
- Visualização e filtragem: Listagem em ListView com cores/ícones por prioridade e filtro (Todas, Pendentes, Concluídas)
- Gerenciamento individual de tarefas: Tela de detalhes da tarefa, edição, exclusão e alteração de situação
- Sincronização instantânea: Atualização em tempo real usando listeners do Realtime Database 
- Personalização visual: Tema claro e escuro salvo com SharedPreferences e carregado ao abrir o app

## Vídeo MVP

Não consegui subir aqui por causa do tamanho


## Capturas de tela

| Login | Cadastro | Início |
| --- | --- | --- |
| ![Login](docs\screenshots\login.png) | ![Cadastro](docs\screenshots\cadastro.png) | ![Início](docs\screenshots\login.png) |

| Minhas tarefas | Nova tarefa | Detalhes |
| --- | --- | --- |
| ![Minhas tarefas](docs\screenshots\tarefas.png) | ![Nova tarefa](docs\screenshots\novaTarefa.png) | ![Detalhes](docs\screenshots\detalhes.png) |

| Tema escuro | Realtime Database |
| --- | --- |
| ![Tema escuro](docs\screenshots\tema.png) | ![Realtime Database](docs\screenshots\database.png) |


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
| Models | Classes Usuario e Tarefa |


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
