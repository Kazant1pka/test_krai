import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/task_overview_bloc/tasks_overview_bloc.dart';

enum TasksOverviewOption { comingDays, notSoon }

class TasksSort extends StatelessWidget {
  const TasksSort({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final todos = context.select((TasksOverviewBloc bloc) => bloc.state.tasks);
    final hasTodos = todos.isNotEmpty;
    // final completedTodosAmount =
    //     todos.where((element) => element.isCompleted).length;

    return PopupMenuButton<TasksOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.taskSortTooltip,
      onSelected: (value) {
        switch (value) {
          case TasksOverviewOption.comingDays:
          // context
          //     .read<TasksOverviewBloc>()
          //     .add();
          case TasksOverviewOption.notSoon:
          // context
          //     .read<TasksOverviewBloc>()
          //     .add();
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TasksOverviewOption.comingDays,
            enabled: hasTodos,
            child: Text(l10n.sortComingDays),
          ),
          PopupMenuItem(
            value: TasksOverviewOption.notSoon,
            child: Text(l10n.sortNotComingDays),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
