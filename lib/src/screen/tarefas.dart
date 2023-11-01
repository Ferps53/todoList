import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/model/tarefa_list.dart';
import 'package:todo_list/src/utils/router.dart';
import 'package:todo_list/src/widgets/app_drawer.dart';
import 'package:todo_list/src/widgets/tarefa_tile.dart';

class TarefaScreen extends StatefulWidget {
  const TarefaScreen({super.key});

  @override
  State<TarefaScreen> createState() => _TarefaScreenState();
}

class _TarefaScreenState extends State<TarefaScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<TarefaList>(context, listen: false).loadTarefas().then((value) {
      setState(() => _isLoading = false);
    });
    super.initState();
  }

  Future<void> _refreshTarefas(BuildContext context) {
    return Provider.of<TarefaList>(
      context,
      listen: false,
    ).loadTarefas();
  }

  @override
  Widget build(BuildContext context) {
    TarefaList tarefasList = Provider.of(context);
    return Scaffold(
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRouter.FORM_TAREFAS,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Tarefas"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshTarefas(context),
              child: SizedBox(
                height: double.infinity,
                child: tarefasList.quantidadeTarefas == 0
                    ? const Center(
                        child: Card(
                          color: Colors.lightBlue,
                          elevation: 8,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Sem Tarefas",
                              style:
                                  TextStyle(fontSize: 48, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tarefasList.quantidadeTarefas,
                        itemBuilder: (context, index) =>
                            ChangeNotifierProvider.value(
                                value: tarefasList.tarefas[index],
                                child: const TarefaTile()),
                      ),
              ),
            ),
    );
  }
}
