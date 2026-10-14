import 'package:flutter/material.dart';
import '../presenters/course_presenter.dart';
import '../widgets/add_fab.dart';
import '../widgets/filter_fab.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CoursePresenter presenter = CoursePresenter();
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async{
    await presenter.loadCourses();
    setState(() => _isLoading = false);
  }

  void _showAddCourseDialog() {
    String name = '';
    String? description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Course name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                onChanged: (value) => description = value,
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
                if (name.trim().isNotEmpty) {
                  await presenter.addCourse(name.trim(), description);
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

    void _showFilterCourseDialog() {
    String name = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Course name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Filter'),
                onChanged: (value) => name = value,
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
                if (name.trim().isNotEmpty) {
                  await presenter.filterCourse(name);
                  setState(() {});
                  Navigator.pop(context); //Close dialog
                }
              },
              child: const Text('Filter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = presenter.courses;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: .8),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        centerTitle: true,
        title: const Text('Courses'),
      ),

      backgroundColor: Colors.blue[300],
      body: 
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return ListTile(
                    title: Text(course.name),
                    subtitle: course.description != null
                    ? Text(course.description!) 
                    : null,
                        );
                      },
                    ),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilterFAB(onPressed: _showFilterCourseDialog),
                AddFAB(onPressed: _showAddCourseDialog),
              ]
            ),
    );
  }
}