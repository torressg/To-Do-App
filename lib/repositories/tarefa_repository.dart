import 'package:todo_app/model/tarefa.dart';

class TarefaRepository {
  final List<Tarefa> _tarefas = [];

  void adicionarTarefa(Tarefa tarefa) async {
    await Future.delayed(const Duration(seconds: 2));
    _tarefas.add(tarefa);
  }

  void alterarTarefa(String id, bool concluido) async {
    await Future.delayed(const Duration(seconds: 2));
    _tarefas
        .where((tarefa) => tarefa.getId() == id)
        .first
        .setConcluido(concluido);
  }

  Future<List<Tarefa>> listarTarefas() async {
    await Future.delayed(const Duration(seconds: 2));
    return _tarefas;
  }
}
