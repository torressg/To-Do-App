import 'package:flutter/material.dart';
import 'package:todo_app/model/tarefa.dart';
import 'package:todo_app/repositories/tarefa_repository.dart';

class TarefaPage extends StatefulWidget {
  const TarefaPage({super.key});

  @override
  State<TarefaPage> createState() => _TarefaPageState();
}

class _TarefaPageState extends State<TarefaPage> {
  var tarefaRepository = TarefaRepository();
  List<Tarefa> _tarefas = <Tarefa>[];
  TextEditingController descricaoController = TextEditingController();
  var apenasNaoConcluidos = false;

  @override
  void initState() {
    super.initState();
    obterTarefas();
  }

  void obterTarefas() async {
    if (apenasNaoConcluidos) {
      _tarefas = await tarefaRepository.listarTarefasNaoConcluida();
    } else {
      _tarefas = await tarefaRepository.listarTarefas();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          descricaoController.text = "";
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text("Adicione uma tarefa"),
                  content: TextField(
                    controller: descricaoController,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () async {
                          await tarefaRepository.adicionarTarefa(
                              Tarefa(descricaoController.text, false));
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text("Salvar"))
                  ],
                );
              });
        },
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Apenas não concluídos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Switch(
                    value: apenasNaoConcluidos,
                    onChanged: (bool value) {
                      apenasNaoConcluidos = value;
                      obterTarefas();
                      setState(() {});
                    }),
              ],
            ),
            const Column(
              children: [Divider()],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (BuildContext bc, int index) {
                    var tarefa = _tarefas[index];
                    return Dismissible(
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete_forever),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.amber[700],
                        child: const Icon(Icons.edit),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await tarefaRepository.excluirTarefa(tarefa.id);
                          obterTarefas();
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'A tarefa "${tarefa.descricao}" foi removida.'),
                            ),
                          );
                        } else if (direction == DismissDirection.endToStart) {
                          showDialog(
                              context: context,
                              builder: (BuildContext bc) {
                                return AlertDialog(
                                  title: const Text("Alterar tarefa"),
                                  content: TextField(
                                    controller: descricaoController,
                                    decoration: const InputDecoration(
                                        labelText: "Edite aqui:"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancelar")),
                                    TextButton(
                                        onPressed: () async {
                                          await tarefaRepository.alterarTarefa(
                                            tarefa.id,
                                            descricaoController.text,
                                          );
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text("Salvar"))
                                  ],
                                );
                              });
                        }
                      },
                      // onDismissed: (direction) async {
                      //   if (direction == DismissDirection.startToEnd) {
                      //     print("teste");
                      //     await tarefaRepository.excluirTarefa(tarefa.id);
                      //     obterTarefas();
                      //     setState(() {});
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text("Uma tarefa foi removida"),
                      //       ),
                      //     );
                      //   } else if (direction == DismissDirection.endToStart) {
                      //     showDialog(
                      //         context: context,
                      //         builder: (BuildContext bc) {
                      //           return AlertDialog(
                      //             title: const Text("Alterar tarefa"),
                      //             content: TextField(
                      //               controller: descricaoController,
                      //               decoration: InputDecoration(
                      //                   labelText: "Edite aqui."),
                      //             ),
                      //             actions: [
                      //               TextButton(
                      //                   onPressed: () {
                      //                     Navigator.pop(context);
                      //                   },
                      //                   child: const Text("Cancelar")),
                      //               TextButton(
                      //                   onPressed: () async {
                      //                     await tarefaRepository
                      //                         .adicionarTarefa(Tarefa(
                      //                             descricaoController.text,
                      //                             false));
                      //                     Navigator.pop(context);
                      //                     setState(() {});
                      //                   },
                      //                   child: const Text("Salvar"))
                      //             ],
                      //           );
                      //         });
                      //   }
                      // },
                      key: Key(tarefa.id),
                      child: ListTile(
                        title: Text(tarefa.descricao),
                        trailing: Switch(
                            value: tarefa.concluido,
                            onChanged: (bool value) async {
                              await tarefaRepository.finalizarTarefa(
                                  tarefa.id, value);
                              obterTarefas();
                            }),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
