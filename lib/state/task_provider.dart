import 'package:flutter/material.dart';
import 'package:task_app/data/models/task.dart';
import 'package:task_app/data/services/task_api_service.dart';

import 'package:shared_preferences/shared_preferences.dart';


class TaskProvider extends ChangeNotifier{

  List<Task> _tasks=[];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorOutput;
  String? _errorInput;
  bool _showCompletedTasks = false;
  final TaskApiService taskApiService = TaskApiService();
  static const _filterKey = 'filter_completed';



  TaskProvider(){
    _init();
  }


  List<Task> get taskList => _tasks;
  bool get  loadingStatus => _isLoading;
  bool get savingStatus => _isSaving;
  String? get errorOutput => _errorOutput;
  String? get errorInput => _errorInput;
  bool get showCompletedTask => _showCompletedTasks;

  Future<void> _init() async{

    await _loadFilterPreference();

  }

  void toggleTask(int id){
    int index = _tasks.indexWhere((item) => item.id==id);
    if(index==-1){
      _errorOutput = " Task Not Found";
    }
    else{
      Task temporaryTask = Task(
          id: _tasks[index].id,
          title: _tasks[index].title,
          isCompleted: !_tasks[index].isCompleted
      );
      _tasks[index] = temporaryTask;
    }
    notifyListeners();
  }

  Future<void> _loadFilterPreference() async{
    final filterPref = await SharedPreferences.getInstance();
    _showCompletedTasks = filterPref.getBool(_filterKey) ?? false;
    notifyListeners();
  }

  List<Task> get visibleTasks{
    if(_showCompletedTasks == true){
      return _tasks.where((t)=>t.isCompleted).toList();
    }
    return _tasks;
  }

  void toggleCompletedFilter() async{
    final writeFilter = await SharedPreferences.getInstance();
    _showCompletedTasks = !_showCompletedTasks;
    await writeFilter.setBool(_filterKey, _showCompletedTasks);
    notifyListeners();
  }

  Future<void> loadTask() async{
    _isLoading = true;
    _errorOutput = null;
    notifyListeners();

    try{
      _tasks = await taskApiService.fetchTasks() ;
    }
    catch(e){
      _errorOutput = " Failed to fetch Tasks";
      print(e);
    }
    finally{
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> addTask(String title) async{
    _errorInput = null;

    if(title.trim().isNotEmpty){
      _isSaving = true;
      notifyListeners();

      try{
        await taskApiService.addTask(title);
        await loadTask();
      }
      catch(e){
        _errorInput = "Failed to add task";
        print(e);
      }
      finally{
        _isSaving = false;
      }
    }
    else{
      _errorInput = "Task cannot be empty";
    }
    notifyListeners();

  }

  Future<void> deleteTask(int id) async{
    int index = _tasks.indexWhere((item)=> item.id==id);

    if(index==-1){
      return;
    }
    else{
      _tasks.removeAt(index);
    }
    notifyListeners();

  }
  
  Future<void> editTask(Task task , String newTitle) async {
    int index = _tasks.indexWhere((item) => item.id == task.id);

    if (index == -1) {
      _errorOutput = " Task Not Found";
    }
    else {
      Task tempTask = Task(
          id: _tasks[index].id,
          title: newTitle,
          isCompleted: _tasks[index].isCompleted
      );
      _tasks[index] = tempTask;
    }
    notifyListeners();
  }

  void restoreTask(Task task, int index) {
    _tasks.insert(index, task);
    notifyListeners();

  }

}