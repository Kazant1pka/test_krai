import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krainet/domain/task.dart';
import 'package:krainet/presentations/widgets/task_list.dart';

void main() {
  const description = 'description';
  const title = 'title';
  final task = Task(
    title: title,
    userId: 'userId',
    description: description,
  );
  group('TaskList test:', () {
    testWidgets(
        'Should have texts, should be draggable, shoud have tap & checkbox',
        (tester) async {
      var isDismissed = false;
      var isTapped = false;
      var completed = false;
      void onTap() => isTapped = true;
      // ignore: avoid_positional_boolean_parameters
      void toggleCompleted(bool isCompleted) => completed = isCompleted;
      void onDismiss(DismissDirection direction) => isDismissed = true;

      await tester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TaskList(
              onDismissed: onDismiss,
              onToggleCompleted: toggleCompleted,
              onTap: onTap,
              task: task,
            ),
          ),
        ),
      );

      final titleFinder = find.text(title);
      final descriptionFinder = find.text(description);

      expect(titleFinder, findsOneWidget);
      expect(descriptionFinder, findsOneWidget);

      await tester.tap(find.byType(ListTile));

      expect(isTapped, isTrue);

      final iconFinder = find.byIcon(Icons.chevron_right);
      expect(iconFinder, findsOneWidget);

      final checkboxFinder = find.byType(Checkbox);
      await tester.tap(checkboxFinder);

      expect(completed, isTrue);

      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(isDismissed, isTrue);

      /// golden test
      await expectLater(find.byType(TaskList), matchesGoldenFile('main.png'));
    });
  });
}
