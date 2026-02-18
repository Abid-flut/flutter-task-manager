
class Task{

  final int id;
  final String title;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.isCompleted
  });

  factory Task.fromJson(Map<String,dynamic> json){

    return Task(
        id: json['id'] ?? 0,
        title: json['todo'] ?? '',
        isCompleted: json['completed'] ?? false
    );

  }


}