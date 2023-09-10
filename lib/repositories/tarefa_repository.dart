import 'package:todo_app/model/tarefa.dart';

class TarefaRepository {
  final List<Tarefa> _tarefas = [];

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tarefas.add(tarefa);
  }

  Future<void> alterarTarefa(String id, bool concluido) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tarefas
        .where((tarefa) => tarefa.getId() == id)
        .first
        .setConcluido(concluido);
  }

  Future<List<Tarefa>> listarTarefas() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _tarefas;
  }

  Future<List<Tarefa>> listarTarefasNaoConcluida() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _tarefas.where((tarefa) => !tarefa.getConcluido()).toList();
  }

  Future<void> excluirTarefa(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tarefas.remove(_tarefas.where((tarefa) => tarefa.getId() == id).first);
  }
}
