import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';
import '../presenters/course_presenter.dart';
import '../widgets/add_fab.dart';
import '../widgets/filter_fab.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _assignmentPresenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();
  
  bool _isLoading = true;
  String? _selectedCourseFilter;
  String? _newAssignmentCourse;
  List<String> _courseNames = [];

  @override
  void initState(){
    super.initState();
      _loadData();
      }

  Future<void> _loadData() async {
    await _coursePresenter.loadCourses();
    await _assignmentPresenter.loadAssignments();

    setState(() {
      _isLoading = false;
      _courseNames = _coursePresenter.courses.map((c) => c.name).toList();
    });
  }

  Future<void> _loadAssignments() async {
    await _assignmentPresenter.loadAssignments();
    setState(() => _isLoading = false);
  }

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;

    showDialog(

      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Assignment'),


          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Enter assignment title'),
                onChanged: (value) {
                  newAssignmentTitle = value;
                },
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: _newAssignmentCourse,
                items: _courseNames.map((name) {
                  return DropdownMenuItem(value: name, child: Text(name));
                }).toList(),
                onChanged: (value) => setState(() => _newAssignmentCourse = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), //Cancel button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newAssignmentTitle.trim().isNotEmpty && 
                  _newAssignmentCourse != null) {
                await _assignmentPresenter.addAssignment(
                  newAssignmentTitle.trim(),
                  _newAssignmentCourse!,
                );
                  setState(() {});
                  Navigator.pop(context); //Close dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final assignments = _assignmentPresenter.assignments;
    final displayAssignments = 
      _selectedCourseFilter == null
        ? assignments
        : assignments
        .where((a) => a.courseName == _selectedCourseFilter)
        .toList();

    return Scaffold(
      appBar: AppBar(
            shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: .8),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),

        title: const Text('Assignments'),
      actions: [
          if (_courseNames.isNotEmpty)
            DropdownButton<String>(
              hint: const Text(
                'Filter by Course',
                style: TextStyle(color: Colors.white),
                ),
                dropdownColor: Colors.blue[100],
                value: _selectedCourseFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedCourseFilter = value;
                  });
                },
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Courses'),
                ),
                ..._courseNames.map(
                  (name) => DropdownMenuItem(value: name, child: Text(name)),
                ),
              ],
            ),
        ],
      ),

      backgroundColor: Colors.blue[300],
      body: 
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              :ListView.builder(
                itemCount: displayAssignments.length,
                itemBuilder: (context, index) {
                  final assignment = displayAssignments[index];
                  return CheckboxListTile(
                    activeColor: Colors.grey.shade900,
                    title: Text(assignment.title),
                    subtitle: Text('Course: ${assignment.courseName}'),
                    value: assignment.isCompleted,
                        onChanged: (_) async {
                          await _assignmentPresenter.toggleCompleted(index);
                          setState(() {});
                        },
                      );
                    },
                  ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilterFAB(onPressed: _showFilterAssignmentDialog),
          AddFAB(onPressed: _showAddAssignmentDialog),
        ],
      ),
    );
  }

    void _showFilterAssignmentDialog() {
    String assignmentTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Find Assignment'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter assignment title'),
            onChanged: (value) {
                  assignmentTitle = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), //Cancel button
                    child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (assignmentTitle.trim().isNotEmpty) {
                      await _assignmentPresenter.filterAssignment(assignmentTitle);
                      setState(() {});
                    }
                    Navigator.pop(context); //Close dialong
                  },
                  child: const Text('Find'),
                ),
              ],
        );
      },
    );
  }
}