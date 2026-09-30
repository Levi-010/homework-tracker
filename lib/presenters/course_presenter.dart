import '../models/course_model.dart';

class CoursePresenter {
  final List<Course> _courses = [];

  List<Course> get courses => _courses;

  Future<void> loadCourses() async {
    final fetched = await Course.fetchCourses();
    _courses
      ..clear()
      ..addAll(fetched);
  }

  Future<void> addCourse(String name, String? description) async {
    await Course.addCourse(name, description);
    _courses.add(Course(name: name, description: description));
  }

  Future<void> filterCourse(String name) async {
    final fCourses = await Course.filterCourses(name);
    _courses
      ..clear()
      ..addAll(fCourses);
  }
}