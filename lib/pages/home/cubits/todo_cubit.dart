import 'package:bloc/bloc.dart';
import 'package:flutter_with_cubit/pages/home/cubits/todos_states.dart';

class TodoCubit extends Cubit<TodoState> {
  final List<String> _todos = [];
  List<String> get todos => _todos;

  TodoCubit() : super(InitialTodoState());

  Future<void> add({required String todo}) async {
    emit(LoadingTodoState());

    await Future.delayed(const Duration(seconds: 1));

    if (_todos.contains(todo)) {
      emit(ErrorTodoState('Tarefa já cadastrada'));
    } else {
      _todos.add(todo);
      emit(LoadedTodoState(_todos));
    }
  }

  Future<void> remove({required int index}) async {
    emit(LoadingTodoState());

    await Future.delayed(const Duration(seconds: 1));

    _todos.removeAt(index);
    emit(LoadedTodoState(_todos));
  }
}
