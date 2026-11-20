
class Task {
  String title;
  DateTime date;
  bool isCompleted;

  Task({
    required this.title,
    required this.date,
    this.isCompleted = false,
  });
}

