import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? name;


  Widget _helloUser(){
    return SafeArea(
      top: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                "Hello, $name glad to see you back!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTodayExpense(){
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children:[
                  Text(
                    "Today's expense",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32,),
              Column(
                children: [
                  Text("Rp 12.000"),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildThisMonthExpense(){
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children:[
                  Text(
                    "This month's expense",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Row(
                children: [
                  Text(
                    "Rp 12.000",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {  },
                      child: Text(
                          "Check Logs"
                      ),
                      style: ButtonStyle(
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildInsertExpense(){
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children:[
                  Text(
                    "Insert your expense",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nominalController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Amount",
                    labelText: "Amount",
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "Description",
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category"),
                  SizedBox(height: 12,),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white12,
                              width: 1,
                            )
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.fastfood_rounded,
                                size: 24,
                              ),
                              SizedBox(width: 4,),
                              Text("Meal"),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white12,
                              width: 1,
                            )
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.fastfood_rounded,
                                size: 24,
                              ),
                              SizedBox(width: 4,),
                              Text("Meal"),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white12,
                              width: 1,
                            )
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.fastfood_rounded,
                                size: 24,
                              ),
                              SizedBox(width: 4,),
                              Text("Meal"),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white12,
                              width: 1,
                            )
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.fastfood_rounded,
                                size: 24,
                              ),
                              SizedBox(width: 4,),
                              Text("Meal"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 24,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {  },
                      child: Text(
                          "Save"
                      ),
                      style: ButtonStyle(
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildLogLists(){
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "Recent expense",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Meal",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rp 30.000",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ayam geprek 2"),
                        Text("Ayam geprek 2"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _helloUser(),
              SizedBox(height: 32,),
              _buildTodayExpense(),
              SizedBox(height: 12,),
              _buildThisMonthExpense(),
              SizedBox(height: 12,),
              _buildLogLists(),
              SizedBox(height: 12,),
              _buildInsertExpense(),
              SizedBox(height: 12,),

            ],
          ),
        ),
      ),
    );
  }
}