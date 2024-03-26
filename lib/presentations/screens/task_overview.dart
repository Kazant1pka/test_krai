import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:krainet/data/repository/storage_repository.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/auth_bloc/auth_bloc.dart';
import 'package:krainet/presentations/bloc/task_overview_bloc/tasks_overview_bloc.dart';
import 'package:krainet/presentations/navigation/navigation.dart';
import 'package:krainet/presentations/widgets/task_list.dart';
import 'package:krainet/presentations/widgets/tasks_filter.dart';
import 'package:krainet/presentations/widgets/tasks_sort.dart';

class TaskOverviewPage extends StatefulWidget {
  const TaskOverviewPage({super.key});

  @override
  State<TaskOverviewPage> createState() => _TaskOverviewPageState();
}

class _TaskOverviewPageState extends State<TaskOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => TasksOverviewBloc(
        storageRepository: context.read<StorageRepository>(),
      )..add(TasksRequested(context.read<AuthBloc>().state.user.id!)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: const [
            TasksFilter(),
            TasksSort(),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TasksOverviewBloc, TasksOverviewState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == TasksOverviewStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(l10n.error),
                      ),
                    );
                }
              },
            ),
          ],
          child: BlocBuilder<TasksOverviewBloc, TasksOverviewState>(
            builder: (context, state) {
              if (state.tasks.isEmpty) {
                if (state.status == TasksOverviewStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status != TasksOverviewStatus.success) {
                  return const SizedBox();
                } else {
                  return Center(
                    child: Text(
                      l10n.tasksEmptyText,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
              }
              return Scrollbar(
                child: ListView(
                  children: [
                    for (final task in state.filteredTasks)
                      TaskList(
                        task: task,
                        onToggleCompleted: (isCompleted) {
                          context.read<TasksOverviewBloc>().add(
                                TasksCompletionToggled(
                                  uid: context.read<AuthBloc>().state.user.id!,
                                  task: task,
                                  isCompleted: isCompleted,
                                ),
                              );
                        },
                        onDismissed: (_) {
                          context.read<TasksOverviewBloc>().add(
                                TaskDeleted(
                                  task,
                                  context.read<AuthBloc>().state.user.id!,
                                ),
                              );
                        },
                        onTap: () {
                          context.go(Routes.edit, extra: task);
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
