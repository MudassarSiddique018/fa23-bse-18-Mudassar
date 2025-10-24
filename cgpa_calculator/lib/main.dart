import 'package:flutter/material.dart';

void main() {
  runApp(const CGPASubjectWiseApp());
}

class CGPASubjectWiseApp extends StatelessWidget {
  const CGPASubjectWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subject-wise CGPA Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CGPACalculatorPage(),
    );
  }
}

class CGPACalculatorPage extends StatefulWidget {
  const CGPACalculatorPage({super.key});

  @override
  State<CGPACalculatorPage> createState() => _CGPACalculatorPageState();
}

class _CGPACalculatorPageState extends State<CGPACalculatorPage> {
  final List<Semester> semesters = [];
  double overallCGPA = 0.0;

  void _addSemester() {
    setState(() {
      semesters.add(Semester());
    });
  }

  void _calculateOverallCGPA() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var sem in semesters) {
      sem.calculateSemesterGPA();
      totalPoints += sem.totalPoints;
      totalCredits += sem.totalCredits;
    }

    setState(() {
      overallCGPA = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
    });
  }

  void _clearAll() {
    setState(() {
      semesters.clear();
      overallCGPA = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subject-wise CGPA Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(semesters.length, (index) {
              return SemesterWidget(
                semester: semesters[index],
                semesterNumber: index + 1,
                onSemesterUpdated: _calculateOverallCGPA,
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _addSemester,
              icon: const Icon(Icons.add),
              label: const Text("Add Semester"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _calculateOverallCGPA,
              icon: const Icon(Icons.calculate),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              label: const Text("Calculate Overall CGPA"),
            ),
            const SizedBox(height: 20),
            Text(
              "Overall CGPA: ${overallCGPA.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _clearAll,
              icon: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              label: const Text("Clear All"),
            ),
          ],
        ),
      ),
    );
  }
}

class Semester {
  List<Subject> subjects = [];
  double gpa = 0.0;
  double totalPoints = 0.0;
  double totalCredits = 0.0;

  void calculateSemesterGPA() {
    totalPoints = 0;
    totalCredits = 0;

    for (var sub in subjects) {
      totalPoints += sub.gpa * sub.credit;
      totalCredits += sub.credit;
    }

    gpa = totalCredits > 0 ? totalPoints / totalCredits : 0;
  }
}

class Subject {
  double gpa;
  double credit;
  Subject({required this.gpa, required this.credit});
}

class SemesterWidget extends StatefulWidget {
  final Semester semester;
  final int semesterNumber;
  final VoidCallback onSemesterUpdated;

  const SemesterWidget({
    super.key,
    required this.semester,
    required this.semesterNumber,
    required this.onSemesterUpdated,
  });

  @override
  State<SemesterWidget> createState() => _SemesterWidgetState();
}

class _SemesterWidgetState extends State<SemesterWidget> {
  void _addSubject() {
    setState(() {
      widget.semester.subjects.add(Subject(gpa: 0, credit: 0));
    });
  }

  void _calculateSemesterGPA() {
    setState(() {
      widget.semester.calculateSemesterGPA();
    });
    widget.onSemesterUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Semester ${widget.semesterNumber}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(widget.semester.subjects.length, (index) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Subject ${index + 1} GPA",
                      ),
                      onChanged: (val) {
                        widget.semester.subjects[index].gpa =
                            double.tryParse(val) ?? 0;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Credit Hours",
                      ),
                      onChanged: (val) {
                        widget.semester.subjects[index].credit =
                            double.tryParse(val) ?? 0;
                      },
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _addSubject,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Subject"),
                ),
                ElevatedButton.icon(
                  onPressed: _calculateSemesterGPA,
                  icon: const Icon(Icons.calculate),
                  label: const Text("Calculate Semester GPA"),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Semester ${widget.semesterNumber} GPA: ${widget.semester.gpa.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
