import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krainet/domain/task.dart';

//Виджет отображения списка задач
class TaskList extends StatelessWidget {
  const TaskList({
    required this.task,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
    super.key,
  });

  final Task task;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      key: Key('todoListTile_${task.id}'),
      //Удаление задачи
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        //Редактирование задачи
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: !task.isCompleted
                  ? const TextStyle(fontSize: 24)
                  : TextStyle(
                      fontSize: 24,
                      color: captionColor,
                      decoration: TextDecoration.lineThrough,
                    ),
            ),
            Text(
              DateFormat('dd-MM-yyyy HH:mm').format(task.endsTask),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: !task.isCompleted
                  ? const TextStyle(fontSize: 12)
                  : TextStyle(
                      fontSize: 12,
                      color: captionColor,
                      decoration: TextDecoration.lineThrough,
                    ),
            ),
          ],
        ),
        subtitle: Text(
          task.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: !task.isCompleted
              ? const TextStyle(fontSize: 14)
              : TextStyle(
                  fontSize: 14,
                  color: captionColor,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        leading: Checkbox(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          value: task.isCompleted,
          onChanged: onToggleCompleted == null
              ? null
              : (value) => onToggleCompleted!(value!),
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}
