import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../presenters/assignment_presenter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

  class _HomeScreenState extends State<HomeScreen> {
    final AssignmentPresenter _presenter = AssignmentPresenter();
    bool _loading = true;

    @override
    void initState() {
      super.initState();
      _loadAssignments();
    }

    Future<void> _loadAssignments() async {
      await _presenter.loadAssignments();
      if (mounted) {
        setState(() =>  _loading = false);
      }
    }

    @override
    Widget build(BuildContext context) {
      final percent = _presenter.completionRate;
      
      return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          centerTitle: true,
          title: const Text('Homework Tracker'),
        ),
        backgroundColor: Colors.blue,
        body: 
          _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 14.0,
                        percent: percent,
                        center: Text(
                          '${(percent * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                      ),
                      progressColor: progressBarColor(percent),
                      backgroundColor: Colors.grey.shade300,
                      animation: true,
                      animationDuration: 800,
                      footer: const Padding(
                        padding:EdgeInsets.only(top: 16.0),
                        child: Text('Assignments Completed'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    child: ListTile(
                      title: const Text('Total Assignments'),
                      trailing: Text('${_presenter.totalAssignments}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Completed Assignments'),
                      trailing: Text('${_presenter.completedAssignments}'),
                    ),
                  ),
                ],
              ),
            ),
      );
    }

    Color progressBarColor(double percent) {
      if (percent < 0.5) {
        return Colors.red;
      } else if (percent < 0.8) {
        return Colors.orange.shade400;
      } else {
        return Colors.green;
      }
    }
  }