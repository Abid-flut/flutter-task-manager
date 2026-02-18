import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiService{

  final String _baseUrl = 'https://dummyjson.com/todos';

  Future<List<Task>>  fetchTasks() async{
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);
    List<dynamic> data = [];
    
    if(response.statusCode >=200 && response.statusCode <=299){
      final result = jsonDecode(response.body);
      print(response.body);
      data = result['todos'];
      List<Task> tasks=[];
      for(var item in data){
        final map = item as Map<String,dynamic>;
        tasks.add(Task.fromJson(map));
      }
      return tasks;

    }
    else{
      throw Exception("Failed to fetch data");
    }
    
  }

  Future<void> addTask(String title) async{
    final url = Uri.parse('https://dummyjson.com/todos/add');

    final response = await http.post(url,
      headers: {
        'Content-Type' : 'application/json',
      },
      body: jsonEncode({
        'todo':title,
        'completed': false,
        'userId': 1
      })
    );
    print(response.body);
    if(response.statusCode >=200 && response.statusCode <=299){
          return;
    }
    else {
      throw Exception("Failed to add task");

    }

  }
}