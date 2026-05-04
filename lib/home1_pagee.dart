import 'package:flutter/material.dart';
import 'package:smart_habit_tracker/add_habit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
//phone storage (memory)
// data save hota hai permanently
import 'dart:convert';   //data convert karne ke liye
// List → String
//String → List

class Home1Pagee extends StatefulWidget{// matlab dynamic data
  @override
  State<Home1Pagee> createState() => _Home1PageeState();
}

//is page ka sara logic state class kay ander start hota hai
class _Home1PageeState extends State<Home1Pagee> {

  //list that store user all habits
  //map ka matlab aik item ki sari details
  //multiple habits jinke andar details (title aur done) hoti hain
  List<Map<String, dynamic>> habits = [];
  List<String> messages=[
    "Great job 💪",
    "Keep going 🔥",
    "You are doing amazing ✨",
    "Stay consistent 🚀",
    "Small steps, big results 🧠"
  ];

 Color selectedColor = Colors.orange;  //app ka current theme color


//yeh flutter ka method hai init state
  //is mai load data call ho raha app jaise start ho gi
  //init state run ho ga aur loaddata method call ho ga
  @override
  void initState() { // jab screen (State) first time banti hai
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  selectedColor,
        title: Text("Smart Habit Builder", style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //icon button mai method hai onPressed
              //yahan yeh ho ga kay jab bhi button press ho ga onPressed run ho ga
              //setState() call hota hai aur is  method  kay ander jo kuch hai wo run ho ga
              //UI refresh hoti hai
              //AppBar ka color change
              IconButton(
                //icon button ka look
                icon: Icon(Icons.circle, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    selectedColor = Colors.blue;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.circle, color: Colors.green),
                onPressed: () {
                  setState(() {
                    selectedColor = Colors.green;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.circle, color: Colors.purple),
                onPressed: () {

                  setState(() {
                    selectedColor = Colors.purple;
                  });
                },
              ),
            ],
          ),

          // Progress Bar + Text
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                LinearProgressIndicator(
                  //yeh aik condition hai kay ager habit empy hai to 0 warna calculation karo bharte jao
            value: habits.isEmpty
                      ? 0
                      : habits.where((h) => h["done"] == true).length /
                      habits.length,
                  backgroundColor: Colors.grey,
                  color: selectedColor,
                  minHeight: 10,
                ),

                SizedBox(height: 10),

                Text(
                  "${habits.where((h) => h["done"] == true).length} / ${habits.length} Completed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 📋 LIST
          Expanded(
            child: habits.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //list ka icon use kiya hai center mai
                  Icon(Icons.list_alt, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No Habits Yet",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),

                  Text(
                    "Tap + to add your first habit",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              //kitni items show karni hain
              itemCount: habits.length,
              // item builder: ek ek habit ko screen pe banana
              itemBuilder: (context, index) {


                return Dismissible(
                  key: ValueKey(habits[index]["title"]),

                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete Habit"),
                          content: Text("Do you want to delete this habit?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  onDismissed: (direction) {
                    setState(() {
                      habits.removeAt(index);
                    });

                    saveData();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Deleted successfully ✅")),
                    );
                  },

                  child: ListTile(
                    title: Text(habits[index]["title"].toString()),

                    trailing: Checkbox(
                      value: habits[index]["done"] ?? false,
                      onChanged: (value) {
                        setState(() {
                          habits[index]["done"] = value!;

                          if (value == true) {
                            final msg = (messages..shuffle()).first;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          }
                        });

                        saveData();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      //button ana hai Add ka
      //yeh aik + sign ka button hota hai jo screen kay
      //bottom right corner par hota
      //user is se new habit add kar sakta hai

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await //matalb wait karo
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddHabitPage(),
          ),
          );

          if (result != null ){ //yani user ne kuch input kiya hai
            setState(() {
              //new habit ko list ke start (top) pe add karo
              //Map wala matlab: result ko proper format mein convert karo
              habits.insert(0, Map<String, dynamic>.from(result));
            });
            saveData();
          }
        },
        child: Icon(Icons.add),

      ),

    );
  }

  //yeh function data ko phone ki memory mai save karta ha
  void saveData() async {
    //prefs is object
      // Get access to device local storage (SharedPreferences instance)
    final prefs = await SharedPreferences.getInstance();
    // Convert habits list (Map/List) into JSON string format
    // because SharedPreferences can only store simple data like String
    prefs.setString("habits", jsonEncode(habits));
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("habits");

    if (data == null) return;

    try {
      //JSON string -> list mein convert
      final decoded = jsonDecode(data);

      setState(() {
        //decoded data ko proper List<Map> format mein convert karo
        habits = List<Map<String, dynamic>>.from(
            decoded.map((e) => Map<String, dynamic>.from(e))
        );
      });
    } catch (e) {
      // agar koi error aye to yeh run karo
      setState(() {
        //data kharab yani corrupt to reset kar do
        habits = [];
      });
      prefs.remove("habits");
    }
  }
}