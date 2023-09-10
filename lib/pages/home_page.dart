import 'package:flutter/material.dart';
import 'package:todo_app/pages/tarefa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller = PageController(initialPage: 0);
  int posicaoPagina = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("To Do List")),
        body: PageView(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              posicaoPagina = value;
            });
          },
          children: const [TarefaPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              controller.jumpToPage(value);
            },
            currentIndex: posicaoPagina,
            items: const [
              BottomNavigationBarItem(
                  label: "Artigos", icon: Icon(Icons.article_outlined)),
              BottomNavigationBarItem(
                  label: "Account", icon: Icon(Icons.person)),
            ]),
      ),
    );
  }
}
