import 'package:flutter/material.dart';
import 'package:task_app/state/task_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/task.dart';

class AddTaskScreen extends StatefulWidget{

  final Task? task;

  const AddTaskScreen({
    super.key,
    this.task
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.task != null){
      textController.text = widget.task!.title;
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  Future<void> onSavePressed() async {
    await context.read<TaskProvider>().addTask(textController.text);
  }
  void onEdit(Task task, String newTitle){
    context.read<TaskProvider>().editTask(task, newTitle);
  }

  @override
  Widget build(BuildContext context) {

    final status = context.watch<TaskProvider>();
    final isEdit = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text( isEdit ? "Edit Task" : "Add Task" ),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: "Enter your task here",
              ),
              enabled: !status.savingStatus,
            ),

            if(status.errorInput!=null)
              Text(status.errorInput!,style: TextStyle(color: Colors.red),),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed:status.savingStatus? null: () async {
                  if(isEdit){
                    onEdit(widget.task!, textController.text);
                  }
                  else{
                    await onSavePressed();
                  }
                  if(context.read<TaskProvider>().savingStatus==false && context.read<TaskProvider>().errorInput==null) {
                    Navigator.pop(context);
                  }
                },
                child: status.savingStatus? const CircularProgressIndicator():Text(isEdit? "Update" : "Save"))
          ],
      ),
      ),
    );
  }
}