import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddHabitPage extends StatefulWidget{
  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}
//StatefulWidget class mein controller nahi hota
// controller State class ke andar hota ha, widget class mein nahi
class _AddHabitPageState extends State<AddHabitPage> {
  //yeh user ka input capture karega
  TextEditingController habitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Text("Add Habit", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 24),),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:  habitController,
              //input box ko style dena
              decoration:  InputDecoration(
                labelText: "Enter your habit",
                //input box ke around border
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            ElevatedButton(
                onPressed: (){
                  if(habitController.text.isNotEmpty){
                    Navigator.pop(context,
                        {
                          "title":habitController.text,
                        "done":false
                        });
                  }
            },

                child: Text("Add Habit",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose()  //lifecycle method
  // jab screen close hoti hai to automatically call hota hai jo use hota hai screen ko clear karne kay liye take memory na use ho
  {
    habitController.dispose();
    super.dispose();
  }
}