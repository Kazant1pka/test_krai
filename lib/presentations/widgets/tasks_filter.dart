import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet/domain/tasks_filter.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/task_overview_bloc/tasks_overview_bloc.dart';

class TasksFilter extends StatelessWidget {
  const TasksFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter =
        context.select((TasksOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TasksViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: l10n.taskFilterTooltip,
      onSelected: (filter) {
        context.read<TasksOverviewBloc>().add(TasksFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TasksViewFilter.all,
            child: Text(l10n.filterAllTasks),
          ),
          PopupMenuItem(
            value: TasksViewFilter.activeonly,
            child: Text(l10n.filterActiveTasks),
          ),
          PopupMenuItem(
            value: TasksViewFilter.completedOnle,
            child: Text(l10n.filterCompletedTasks),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
