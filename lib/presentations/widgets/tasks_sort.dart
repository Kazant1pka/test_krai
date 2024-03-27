import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet/domain/tasks_sort.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/task_overview_bloc/tasks_overview_bloc.dart';

//Отображения способов сортировки списка задач
class TasksSort extends StatelessWidget {
  const TasksSort({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    //Получения способа сортировки
    final activeSort =
        context.select((TasksOverviewBloc bloc) => bloc.state.sort);

    return PopupMenuButton<TasksViewSort>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeSort,
      tooltip: l10n.taskSortTooltip,
      onSelected: (value) {
        context.read<TasksOverviewBloc>().add(TasksSortChanged(value));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TasksViewSort.comingDays,
            child: Text(l10n.sortComingDays),
          ),
          PopupMenuItem(
            value: TasksViewSort.notSoon,
            child: Text(l10n.sortNotComingDays),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
