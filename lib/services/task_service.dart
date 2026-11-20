
import '../models/task.dart';

class TaskService {
  
  final List<Task> _tasks = [];

  
  List<Task> get tasks {
    final sortedTasks = List<Task>.from(_tasks);

    sortedTasks.sort((a, b) {
      
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

     
      return a.title.toLowerCase().compareTo(
            b.title.toLowerCase(),
          );
    });

    return sortedTasks;
  }

  
  void addTask(String title, DateTime date) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) return;

    _tasks.add(
      Task(
        title: trimmedTitle,
        date: date,
      ),
    );
  }


  void removeTask(Task task) {
    _tasks.remove(task);
  }

 
  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
  }

  
  List<Task> getTasksForDate(DateTime date) {
    return tasks.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();
  }
}
