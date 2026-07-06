import 'package:flutter/material.dart';

void main() {
  runApp(const ZenithApp());
}

// --- APP THEME & ENTRY POINT ---
class ZenithApp extends StatelessWidget {
  const ZenithApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenith',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      home: const ZenithDashboard(),
    );
  }
}

// --- DATA MODEL ---
class Task {
  String id;
  String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});
}

// --- MAIN DASHBOARD SCREEN ---
class ZenithDashboard extends StatefulWidget {
  const ZenithDashboard({Key? key}) : super(key: key);

  @override
  State<ZenithDashboard> createState() => _ZenithDashboardState();
}

class _ZenithDashboardState extends State<ZenithDashboard> {
  DateTime _selectedDate = DateTime.now();
  
  // This Map acts as our temporary database linking Dates to Tasks
  final Map<DateTime, List<Task>> _tasks = {};

  // Helper to get only the Year-Month-Day to avoid time zone mismatches
  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Task> _getTasksForSelectedDate() {
    return _tasks[_stripTime(_selectedDate)] ?? [];
  }

  void _addTask(String title) {
    if (title.isEmpty) return;
    
    setState(() {
      final dateKey = _stripTime(_selectedDate);
      if (_tasks[dateKey] == null) {
        _tasks[dateKey] = [];
      }
      _tasks[dateKey]!.add(
        Task(id: DateTime.now().toString(), title: title),
      );
    });
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks[_stripTime(_selectedDate)]?.removeWhere((t) => t.id == task.id);
    });
  }

  // --- UI: ADD TASK DIALOG ---
  void _showAddTaskDialog() {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Task"),
        content: TextField(
          controller: taskController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "What needs to be done?"),
          onSubmitted: (value) {
            _addTask(value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask(taskController.text);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = _getTasksForSelectedDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Z E N I T H',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. The Calendar Widget
          Container(
            color: const Color(0xFF1E1E1E),
            child: CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateChanged: (newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),
          ),
          
          const Divider(height: 1, color: Colors.grey),
          
          // 2. Task List Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tasks for ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
            ),
          ),

          // 3. The To-Do List
          Expanded(
            child: activeTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks for this day. Enjoy your free time!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: activeTasks.length,
                    itemBuilder: (context, index) {
                      final task = activeTasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        direction: DismissibleDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteTask(task),
                        child: CheckboxListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: task.isCompleted ? Colors.grey : Colors.white,
                            ),
                          ),
                          value: task.isCompleted,
                          onChanged: (_) => _toggleTaskCompletion(task),
                          activeColor: Colors.deepPurpleAccent,
                          checkColor: Colors.white,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // 4. Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
