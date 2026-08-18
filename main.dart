import 'dart:io';

enum Priority { low, medium, high }

enum Status { pending, completed }

class Task {
  String title;
  String description;
  Priority priority;
  Status status;

  Task(this.title, this.description, this.priority,
      {this.status = Status.pending});

  void complete() {
    status = Status.completed;
  }

  String get priorityText {
    switch (priority) {
      case Priority.low:
        return 'Baixa';
      case Priority.medium:
        return 'Média';
      case Priority.high:
        return 'Alta';
    }
  }

  String get statusText =>
      status == Status.completed ? 'Concluída' : 'Pendente';

  @override
  String toString() {
    return '$title\n   Descrição: $description\n   Prioridade: $priorityText\n   Status: $statusText';
  }
}

class User {
  String name;
  int age;
  String email;
  bool isAdmin;

  User(this.name, this.age, this.email, this.isAdmin);

  String get classification {
    if (age < 12) {
      return 'Criança';
    } else if (age >= 12 && age <= 17) {
      return 'Adolescente';
    } else if (age >= 18 && age <= 59) {
      return 'Adulto';
    } else {
      return 'Idoso';
    }
  }

  @override
  String toString() {
    return 'Nome: $name\nIdade: $age\nE-mail: $email\nClassificação: $classification\nAdmin: ${isAdmin ? "Sim" : "Não"}';
  }
}

final List<Task> tasks = [];
User? currentUser;

void main() {
  int option = -1;

  while (option != 0) {
    displayMainMenu();
    option = readInt('Sua escolha: ');

    switch (option) {
      case 1:
        registerUser();
        break;
      case 2:
        taskMenu();
        break;
      case 0:
        print('Encerrando o programa...');
        break;
      default:
        print('Opção inválida!\n');
    }
  }
}


int readInt(String message) {
  while (true) {
    stdout.write(message);
    final input = stdin.readLineSync();
    final value = int.tryParse(input ?? '');
    if (value != null) return value;
    print('Valor inválido, digite um número inteiro.');
  }
}

String readText(String message) {
  stdout.write(message);
  return stdin.readLineSync() ?? '';
}


void registerUser() {
  final name = readText('Digite seu nome de usuário: ');
  final age = readInt('Digite sua idade: ');
  final email = readText('Digite seu e-mail: ');

  bool isAdmin;
  while (true) {
    final adminInput = readText('Você é administrador? (Y/N): ').toUpperCase();
    if (adminInput == 'Y') {
      isAdmin = true;
      break;
    } else if (adminInput == 'N') {
      isAdmin = false;
      break;
    } else {
      print('Valor inválido. Digite Y ou N.');
    }
  }

  currentUser = User(name, age, email, isAdmin);

  print('\n===== DADOS CADASTRADOS =====');
  print(currentUser);
  print('==============================\n');
}


void displayMainMenu() {
  print('\n===== MENU PRINCIPAL =====');
  print('1 - Cadastro Usuario');
  print('2 - Menu tarefas');
  print('0 - Sair');
}

void displayTaskMenu() {
  print('\n===== GERENCIADOR DE TAREFAS =====');
  print('1 - Cadastrar tarefa');
  print('2 - Listar tarefas');
  print('3 - Concluir tarefa');
  print('4 - Remover tarefa');
  print('5 - Estatísticas');
  print('6 - Filtrar por prioridade');
  print('0 - Sair');
}

void taskMenu() {
  int option = -1;

  while (option != 0) {
    displayTaskMenu();
    option = readInt('Sua escolha: ');

    switch (option) {
      case 1:
        addTask();
        break;
      case 2:
        listTasks();
        break;
      case 3:
        completeTask();
        break;
      case 4:
        removeTask();
        break;
      case 5:
        displayStatistics();
        break;
      case 6:
        filterByPriority();
        break;
      case 0:
        print('Voltando ao menu principal...');
        break;
      default:
        print('Opção inválida!\n');
    }
  }
}

void addTask() {
  final title = readText('Digite o título da tarefa: ');
  final description = readText('Digite a descrição da tarefa: ');

  Priority priority;
  while (true) {
    final input =
        readText('Digite a prioridade da tarefa (baixa, media, alta): ').toLowerCase();
    if (input == 'baixa') {
      priority = Priority.low;
      break;
    } else if (input == 'media') {
      priority = Priority.medium;
      break;
    } else if (input == 'alta') {
      priority = Priority.high;
      break;
    } else {
      print('Prioridade inválida. Digite novamente.');
    }
  }

  final task = Task(title, description, priority);
  tasks.add(task);

  print('Tarefa "$title" cadastrada com sucesso!\n');
}

void listTasks() {
  print('\n===== LISTA DE TAREFAS =====');
  if (tasks.isEmpty) {
    print('Nenhuma tarefa cadastrada.\n');
    return;
  }

  for (var i = 0; i < tasks.length; i++) {
    print('${i + 1} - ${tasks[i]}');
  }
  print('');
}

void completeTask() {
  if (tasks.isEmpty) {
    print('Não há tarefas cadastradas.\n');
    return;
  }

  listTasks();
  final number = readInt('Digite o número da tarefa: ');

  if (number < 1 || number > tasks.length) {
    print('Número de tarefa inexistente.\n');
    return;
  }

  final task = tasks[number - 1];

  if (task.status == Status.completed) {
    print('A tarefa "${task.title}" já está concluída.\n');
    return;
  }

  task.complete();
  print('Tarefa "${task.title}" concluída com sucesso!\n');
}


void removeTask() {
  if (tasks.isEmpty) {
    print('Não há tarefas cadastradas.\n');
    return;
  }

  listTasks();
  final number = readInt('Digite o número da tarefa a remover: ');

  if (number < 1 || number > tasks.length) {
    print('Número de tarefa inexistente.\n');
    return;
  }

  final removed = tasks.removeAt(number - 1);
  print('Tarefa "${removed.title}" removida com sucesso!\n');
}


void displayStatistics() {
  final total = tasks.length;
  final completedCount = tasks.where((t) => t.status == Status.completed).length;
  final pendingCount = total - completedCount;
  final double percentage = total == 0 ? 0.0 : (completedCount / total) * 100;

  print('\n===== ESTATÍSTICAS =====');
  print('Total de tarefas: $total');
  print('Tarefas concluídas: $completedCount');
  print('Tarefas pendentes: $pendingCount');
  print('Percentual concluído: ${percentage.toStringAsFixed(0)}%\n');
}


void filterByPriority() {
  if (tasks.isEmpty) {
    print('Não há tarefas cadastradas.\n');
    return;
  }

  print('\nEscolha a prioridade:');
  print('1 - Alta');
  print('2 - Média');
  print('3 - Baixa');

  final option = readInt('Sua escolha: ');
  Priority chosenPriority;

  switch (option) {
    case 1:
      chosenPriority = Priority.high;
      break;
    case 2:
      chosenPriority = Priority.medium;
      break;
    case 3:
      chosenPriority = Priority.low;
      break;
    default:
      print('Opção inválida.\n');
      return;
  }

  final filtered = tasks.where((t) => t.priority == chosenPriority).toList();

  print('\n===== TAREFAS - PRIORIDADE ${chosenPriority.name.toUpperCase()} =====');
  if (filtered.isEmpty) {
    print('Nenhuma tarefa encontrada com essa prioridade.\n');
    return;
  }

  for (var i = 0; i < filtered.length; i++) {
    print('${i + 1} - ${filtered[i]}');
  }
  print('');
}
