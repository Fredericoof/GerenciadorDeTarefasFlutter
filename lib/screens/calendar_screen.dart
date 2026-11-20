
import 'package:material_ui/material_ui.dart';

import '../services/task_service.dart';
import 'tasks_screen.dart';

class CalendarScreen extends StatefulWidget {
  final TaskService taskService;

  const CalendarScreen({
    super.key,
    required this.taskService,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _visibleMonth;

  final List<String> _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  final List<String> _weekDays = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    _selectedDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    _visibleMonth = DateTime(
      today.year,
      today.month,
    );
  }

  void _changeMonth(int amount) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + amount,
      );

      _selectedDate = DateTime(
        _visibleMonth.year,
        _visibleMonth.month,
        1,
      );
    });
  }

  bool _isSelected(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();

    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  void _openTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasksScreen(
          selectedDate: _selectedDate,
          taskService: widget.taskService,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;

    
    final firstWeekday = firstDay.weekday;

    final totalCells = ((firstWeekday - 1 + daysInMonth + 6) ~/ 7) * 7;

    final selectedTasks = widget.taskService.getTasksForDate(
      _selectedDate,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text(
          'Meu calendário',
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
              const Text(
                'Planeje sua rotina',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF29213D),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Selecione um dia para organizar suas tarefas.',
                style: TextStyle(
                  color: Color(0xFF756B89),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _changeMonth(-1),
                    icon: const Icon(Icons.chevron_left),
                    color: const Color(0xFF6C4AB6),
                  ),

                  Text(
                    '${_months[_visibleMonth.month - 1]} '
                    '${_visibleMonth.year}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29213D),
                    ),
                  ),

                  IconButton(
                    onPressed: () => _changeMonth(1),
                    icon: const Icon(Icons.chevron_right),
                    color: const Color(0xFF6C4AB6),
                  ),
                ],
              ),

              const SizedBox(height: 12),

             
              Row(
                children: _weekDays.map((day) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF756B89),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalCells,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final dayNumber = index - firstWeekday + 2;

                    if (dayNumber < 1 || dayNumber > daysInMonth) {
                      return const SizedBox.shrink();
                    }

                    final date = DateTime(
                      _visibleMonth.year,
                      _visibleMonth.month,
                      dayNumber,
                    );

                    final selected = _isSelected(date);
                    final today = _isToday(date);

                    final hasTasks = widget.taskService
                        .getTasksForDate(date)
                        .isNotEmpty;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF6C4AB6)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: today && !selected
                              ? Border.all(
                                  color: const Color(0xFF6C4AB6),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$dayNumber',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF29213D),
                              ),
                            ),
                            const SizedBox(height: 3),
                            if (hasTasks)
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF6C4AB6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/'
                      '${_selectedDate.month.toString().padLeft(2, '0')}/'
                      '${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF29213D),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      selectedTasks.isEmpty
                          ? 'Nenhuma tarefa cadastrada neste dia.'
                          : '${selectedTasks.length} tarefa(s) cadastrada(s).',
                      style: const TextStyle(
                        color: Color(0xFF756B89),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _openTasks,
                  icon: const Icon(Icons.task_alt),
                  label: const Text(
                    'Ver tarefas do dia',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4AB6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
