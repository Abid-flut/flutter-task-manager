
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskListBox extends StatelessWidget{

  final int id;
  final String title;
  final VoidCallback toggle;
  final bool isCompleted;
  final VoidCallback onEdit;

  TaskListBox({
    required this.id,
    required this.title,
    required this.toggle,
    required this.isCompleted,
    required this.onEdit
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: onEdit,
          child:
          Container(
              width: 300,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("[ $id ]"),
                    SizedBox(width: 10,),
                    Flexible(child: Text("$title",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          decoration: isCompleted? TextDecoration.lineThrough : null
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    )
                  ],
                ),
              )
          ),
        ),
        OutlinedButton(
          onPressed: toggle,
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(100, 32),
            side: BorderSide(
              color: isCompleted ? Colors.green : Colors.red,
            ),
          ),
          child: Text(
            isCompleted ? 'Completed' : 'Incomplete',
            style: TextStyle(
              color: isCompleted ? Colors.green : Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

      ],
    );
  }

}