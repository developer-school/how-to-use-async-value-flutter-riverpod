import 'dart:convert';

import 'package:ds_async_value/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final todosProvider = FutureProvider<List<Todo>>((ref) async {
  final res = await Future.delayed(const Duration(seconds: 3), () {
    return get(
      Uri.parse('http://localhost:3000/todos'),
    );
  });

  final asJson = jsonDecode(res.body);

  return asJson.map<Todo>((json) => Todo.fromJson(json)).toList();
});

final todosState = StateProvider<AsyncValue<List<Todo>>>(
  (ref) => const AsyncValue.loading(),
);

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Todo>> _todos = ref.watch(todosState);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                final todos = await ref.read(todosProvider.future);
                ref.read(todosState.notifier).state = AsyncValue.data(todos);
              } catch (e) {
                ref.read(todosState.notifier).state = AsyncValue.error(e);
              }
            },
          ),
        ],
      ),
      body: _todos.when(
        data: (data) => ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].title),
                )),
        error: (e, s) => const Center(
          child: Text('Uh oh. Something went wrong!'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
