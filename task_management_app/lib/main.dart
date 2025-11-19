import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const MyApp());
}

// ---------------- Notification Service ----------------
class NotificationService {
  static final FlutterLocalNotificationsPlugin _flnp =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> init() async {
    tz.initializeTimeZones();

    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: androidSettings);

    await _flnp.initialize(settings);
  }

  // Schedule one-time notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledTime, tz.local);

    final androidDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        channelDescription: 'Reminders for tasks',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    // One-time notification
   await _flnp.zonedSchedule(
  id,
  title,
  body,
  tzDate,
  androidDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // optional exact scheduling
  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
);
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _flnp.cancel(id);
  }
}
  
// ---------------- User Authentication ----------------
String hashPassword(String password) =>
    sha256.convert(utf8.encode(password)).toString();

// ---------------- MyApp ----------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginPage(),
    );
  }
}

// ---------------- Login Page ----------------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  onSaved: (val) => email = val!,
                  validator: (val) => val!.isEmpty ? "Enter email" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onSaved: (val) => password = val!,
                  validator: (val) => val!.isEmpty ? "Enter password" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final db = await openDatabase(
                            join(await getDatabasesPath(), 'users.db'),
                            onCreate: (db, version) {
                          return db.execute(
                              'CREATE TABLE users(email TEXT PRIMARY KEY, password TEXT)');
                        }, version: 1);

                        final user = await db.query('users',
                            where: 'email = ? AND password = ?',
                            whereArgs: [email, hashPassword(password)]);
                        if (user.isNotEmpty) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid credentials")));
                        }
                      }
                    },
                    child: const Text("Login")),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignupPage()));
                    },
                    child: const Text("Sign Up"))
              ],
            )),
      ),
    );
  }
}

// ---------------- Signup Page ----------------
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onSaved: (val) => email = val!,
                validator: (val) => val!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                onSaved: (val) => password = val!,
                validator: (val) => val!.isEmpty ? "Enter password" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final db = await openDatabase(
                          join(await getDatabasesPath(), 'users.db'),
                          onCreate: (db, version) {
                        return db.execute(
                            'CREATE TABLE users(email TEXT PRIMARY KEY, password TEXT)');
                      }, version: 1);

                      await db.insert('users',
                          {'email': email, 'password': hashPassword(password)},
                          conflictAlgorithm: ConflictAlgorithm.replace);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Sign Up"))
            ])),
      ),
    );
  }
}

// ---------------- Task Model ----------------
class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool repeatDaily;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.repeatDaily = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'repeatDaily': repeatDaily ? 1 : 0,
      };
}

// ---------------- Home Page ----------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Database db;
  List<Task> tasks = [];
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  bool _repeatDaily = false;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    db = await openDatabase(join(await getDatabasesPath(), 'tasks.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, dueDate TEXT, repeatDaily INTEGER)');
    }, version: 1);
    loadTasks();
  }

  Future<void> loadTasks() async {
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    setState(() {
      tasks = List.generate(
        maps.length,
        (i) => Task(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          dueDate: DateTime.parse(maps[i]['dueDate']),
          repeatDaily: maps[i]['repeatDaily'] == 1,
        ),
      );
    });
  }

Future<void> addTask(BuildContext context) async {
  if (_titleController.text.isEmpty) return;

  final task = Task(
    title: _titleController.text,
    description: _descController.text,
    dueDate: _dueDate,
  );

  final id = await db.insert('tasks', task.toMap());

  // Schedule one-time notification
  await NotificationService.scheduleNotification(
    id: id,
    title: task.title,
    body: 'Task due now!',
    scheduledTime: task.dueDate,
  );

  _titleController.clear();
  _descController.clear();
  loadTasks();

  // Now Navigator.pop works fine
  if (context.mounted) {
    Navigator.pop(context);
  }
}

  Future<void> deleteTask(int id) async {
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    await NotificationService.cancelNotification(id);
    loadTasks();
  }
Future<void> exportPDF(List<Task> tasks) async {
  final pdf = pw.Document();

  // Add a page with task list
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Task List', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            ...tasks.map((t) => pw.Text(
                '${t.title} - ${t.description} - ${DateFormat('yyyy-MM-dd HH:mm').format(t.dueDate)}')),
          ],
        );
      },
    ),
  );

  // Save PDF to device
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/tasks.pdf');
  await file.writeAsBytes(await pdf.save());

  // Share the PDF file
  await Share.shareXFiles([XFile(file.path)], text: 'My Task List');
}

 // Make sure your Task model has these fields: title, description, dueDate, repeatDaily
Future<void> exportCSV(List<Task> tasks) async {
  final header = ['Title', 'Description', 'Due Date', 'Repeat Daily'];

  // Convert tasks to rows
  final rows = tasks.map((t) => [
        t.title,
        t.description,
        DateFormat('yyyy-MM-dd HH:mm').format(t.dueDate),
        t.repeatDaily ? 'Yes' : 'No',
      ]);

  // Convert to CSV string
  final csvString = const ListToCsvConverter().convert([header, ...rows]);

  // Save CSV file to device
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/tasks.csv');
  await file.writeAsString(csvString);

  // Share the CSV file
  await Share.shareXFiles([XFile(file.path)], text: 'My Task List CSV');
}
  Future<void> _pickDateTime(BuildContext context) async {
  if (!mounted) return;

  final date = await showDatePicker(
    context: context,
    initialDate: _dueDate,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
  );
  if (date == null) return;

  if (!mounted) return;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(_dueDate),
  );
  if (time == null) return;

  if (!mounted) return;

  setState(() {
    _dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Task Manager"),
      actions: [
        IconButton(
  icon: const Icon(Icons.picture_as_pdf),
  onPressed: () async {
    await exportPDF(tasks); // pass the task list
  },
),
IconButton(
  icon: const Icon(Icons.grid_on),
  onPressed: () async {
    await exportCSV(tasks); // pass the task list
  },
),

      ],
    ),

    body: ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        final t = tasks[index];
        return ListTile(
          title: Text(t.title),
          subtitle: Text(
              '${t.description} - ${DateFormat('yyyy-MM-dd HH:mm').format(t.dueDate)}'),
          trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteTask(t.id!)),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: (){
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("New Task"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: "Title"),
                        ),
                        TextField(
                          controller: _descController,
                          decoration:
                              const InputDecoration(labelText: "Description"),
                        ),
                        Row(
                          children: [
                            Text(
                                'Due: ${DateFormat('yyyy-MM-dd HH:mm').format(_dueDate)}'),
                            IconButton(
  icon: const Icon(Icons.calendar_today),
  onPressed: () => _pickDateTime(context), // pass context here
),

                          ],
                        ),
                        Row(
                          children: [
                            const Text("Repeat Daily"),
                            Switch(
                                value: _repeatDaily,
                                onChanged: (val) =>
                                    setState(() => _repeatDaily = val))
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel")),
                      ElevatedButton(
  onPressed: () => addTask(context),
  child: Text("Add Task"),
)

                    ],
                  ));
        },
      ),
    );
  }
}