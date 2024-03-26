import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:krainet/data/repository/storage_repository.dart';
import 'package:krainet/domain/task.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/auth_bloc/auth_bloc.dart';
import 'package:krainet/presentations/bloc/edit_bloc/edit_task_bloc.dart';
import 'package:krainet/presentations/navigation/navigation.dart';
import 'package:krainet/presentations/widgets/input_field.dart';
import 'package:krainet/utils/colors.dart';

class CreateOrEditTask extends StatefulWidget {
  const CreateOrEditTask({this.initialTask, super.key});

  final Task? initialTask;

  @override
  State<CreateOrEditTask> createState() => _CreateOrEditTaskState();
}

class _CreateOrEditTaskState extends State<CreateOrEditTask> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTaskBloc(
        storageRepository: context.read<StorageRepository>(),
        initialTask: widget.initialTask,
      ),
      child: BlocListener<EditTaskBloc, EditTaskState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditTaskStatus.success,
        listener: (context, state) => context.go(Routes.home),
        child: BlocBuilder<EditTaskBloc, EditTaskState>(
          builder: (context, state) {
            final l10n = context.l10n;
            final status =
                context.select((EditTaskBloc bloc) => bloc.state.status);
            final isNewTodo =
                context.select((EditTaskBloc bloc) => bloc.state.isNewTask);
            final currentState = context.watch<EditTaskBloc>().state;
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.lightBackground,
                  ),
                  onPressed: () {
                    context.go(Routes.home);
                  },
                ),
                title: Text(
                  isNewTodo ? l10n.newTask : l10n.editTask,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                tooltip: l10n.saveTask,
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                onPressed: status.isLoadingOrSuccess
                    ? null
                    : () {
                        context.read<EditTaskBloc>().add(
                              EditTaskSubmitted(
                                context.read<AuthBloc>().state.user.id!,
                              ),
                            );
                        context.go(Routes.home);
                      },
                child: status.isLoadingOrSuccess
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.check_rounded),
              ),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InputField(
                          icon: Icons.task,
                          initialValue: currentState.title,
                          labelText: l10n.editTitleLabel,
                          isEnabled: !currentState.status.isLoadingOrSuccess,
                          onChanged: (value) {
                            context
                                .read<EditTaskBloc>()
                                .add(EditTitleChanged(value));
                            return null;
                          },
                          hintText: currentState.initialTask?.title ?? '',
                          formatter: [
                            LengthLimitingTextInputFormatter(50),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9\s]'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InputField(
                          icon: Icons.design_services_outlined,
                          initialValue: currentState.description,
                          labelText: l10n.editDescriptionLabel,
                          isEnabled: !currentState.status.isLoadingOrSuccess,
                          onChanged: (value) {
                            context
                                .read<EditTaskBloc>()
                                .add(EditDescriptionChanged(value));
                            return null;
                          },
                          hintText: currentState.initialTask?.description ?? '',
                          maxLines: 5,
                          formatter: [LengthLimitingTextInputFormatter(300)],
                        ),
                        const SizedBox(height: 16),
                        const _DateField(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DateField extends StatefulWidget {
  const _DateField();

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTaskBloc>().state;
    var currentDate = state.endsTask;
    String getDate() => DateFormat('dd/MM/yyyy HH:mm').format(currentDate);
    final dateController = TextEditingController(
      text: getDate(),
    );

    Future<DateTime> selectDate(BuildContext context) async {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: state.initialTask?.endsTask ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
      );

      if (!context.mounted) return currentDate;
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: currentDate.hour,
          minute: currentDate.minute,
        ),
      );

      if (selectedDate != null &&
          selectedTime != null &&
          selectedDate != currentDate) {
        setState(() {
          currentDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          context.read<EditTaskBloc>().add(EditDateChanged(currentDate));
          dateController.text = getDate();
        });
      }
      return currentDate;
    }

    return TextFormField(
      controller: dateController,
      onTap: () => selectDate(context),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editDateLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
      keyboardType: TextInputType.datetime,
    );
  }
}
