import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskAddCard extends StatelessWidget {
  TaskAddCard({super.key, required this.date});

  final DateTime date;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _numOfQuestionsController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("새 Task 추가"),
      content: Column(
        children: [
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: "과목",
            ),
          ),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: "내용",
            ),
          ),
          TextField(
            controller: _numOfQuestionsController,
            decoration: const InputDecoration(
              labelText: "문항 수",
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () async {
            // upload to firebase
            // students/uid/days/date/tasks
            // subject, content, numOfQuestions
            if (_subjectController.text.isEmpty ||
                _contentController.text.isEmpty ||
                _numOfQuestionsController.text.isEmpty) {
              return;
            }
            final DatabaseReference _dbRef = FirebaseDatabase.instance
                .ref("students/${FirebaseAuth.instance.currentUser!.uid}/days");
            final DatabaseReference _taskRef =
                _dbRef.child(date.toString().split(" ")[0]);
            // Append task to the list
            final task = {
              "subject": _subjectController.text,
              "content": _contentController.text,
              "numOfQuestions": _numOfQuestionsController.text,
              "done": false,
              "imageUrl": "",
            };
            _taskRef.push().set(task);
            Navigator.pop(context);
            GoRouter.of(context).refresh();
          },
          child: const Text("추가"),
        ),
      ],
    );
  }
}
