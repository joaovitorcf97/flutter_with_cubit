import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_cubit/pages/home/cubits/todo_cubit.dart';
import 'package:flutter_with_cubit/pages/home/cubits/todos_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TodoCubit cubit;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TodoCubit>(context);
    cubit.stream.listen((state) {
      if (state is ErrorTodoState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit'),
      ),
      body: Stack(
        children: [
          BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              if (state is InitialTodoState) {
                return const Center(
                  child: Text('Nenhuma tarefa cadastrada'),
                );
              } else if (state is LoadingTodoState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoadedTodoState) {
                return _buildTodoList(state.todos);
              } else {
                return _buildTodoList(cubit.todos);
              }
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Digite um nome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (_nameController.text.isEmpty) return;
                        cubit.add(todo: _nameController.text);

                        _nameController.clear();
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTodoList(List<String> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Center(
              child: Text(todos[index][0]),
            ),
          ),
          title: Text(todos[index]),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              cubit.remove(index: index);
            },
          ),
        );
      },
    );
  }
}
