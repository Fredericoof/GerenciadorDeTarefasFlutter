
import 'package:material_ui/material_ui.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class TasksScreen extends StatefulWidget {
  final DateTime selectedDate;
  final TaskService taskService;

  const TasksScreen({
    super.key,
    required this.selectedDate,
    required this.taskService,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _taskController =
      TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome da tarefa.'),
        ),
      );
      return;
    }

    setState(() {
      widget.taskService.addTask(
        title,
        widget.selectedDate,
      );
    });

    _taskController.clear();
    FocusScope.of(context).unfocus();
  }

  void _toggleTask(Task task) {
    setState(() {
      widget.taskService.toggleTaskCompletion(task);
    });
  }

  void _removeTask(Task task) {
    setState(() {
      widget.taskService.removeTask(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskService.getTasksForDate(
      widget.selectedDate,
    );

    final pendingCount =
        tasks.where((task) => !task.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text(
          'Minhas tarefas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6C4AB6),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.selectedDate.day.toString().padLeft(2, '0')}/'
                '${widget.selectedDate.month.toString().padLeft(2, '0')}/'
                '${widget.selectedDate.year}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6C4AB6),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '$pendingCount tarefa(s) pendente(s)',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF29213D),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Digite uma nova tarefa',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4AB6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_note,
                              size: 64,
                              color: Color(0xFFB7A8D9),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Nenhuma tarefa para este dia.',
                              style: TextStyle(
                                color: Color(0xFF756B89),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                activeColor: const Color(0xFF6C4AB6),
                                onChanged: (_) => _toggleTask(task),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: task.isCompleted
                                      ? Colors.grey
                                      : const Color(0xFF29213D),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _removeTask(task),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
