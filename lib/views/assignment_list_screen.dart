import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter assignment title'),
            onChanged: (value) {
                  newAssignmentTitle = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), //Cancel button
                    child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (newAssignmentTitle.trim().isNotEmpty) {
                      setState(() {
                        _presenter.addAssignment(newAssignmentTitle.trim());
                      });
                    }
                    Navigator.pop(context); //Close dialong
                  },
                  child: const Text('Add'),
                ),
              ],
        );
      },
    );
  }

  void _showEditAssignmentDialog(int index) {
    String newAssignmentTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Assignment Name'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new assignment title'),
            onChanged: (value) {
                  newAssignmentTitle = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), //Cancel button
                    child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (newAssignmentTitle.trim().isNotEmpty) {
                      setState(() {
                        _presenter.editAssignment(index, newAssignmentTitle);
                      });
                    }
                    Navigator.pop(context); //Close dialong
                  },
                  child: const Text('Edit'),
                ),
              ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _presenter.assignments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CheckboxListTile(
                title: Text(assignment.title),
                value: assignment.isCompleted,
                onChanged: (value) {
                  setState(() {
                    _presenter.toggleCompleted(index);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showEditAssignmentDialog(index);
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssignmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}