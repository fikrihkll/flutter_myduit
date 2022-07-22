import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myduit/features/data/models/expense_model.dart';
import 'package:myduit/features/data/repositories/expense_repository.dart';
import 'package:myduit/features/presentation/widgets/datePicker_widget.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  // String date = "${datePick}/${_selectedDate.value.year}";
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late ExpenseRepository expenseRepository;

  @override
  void initState() {
    super.initState();

    expenseRepository = ExpenseRepository(firestore: FirebaseFirestore.instance);
  }

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
    return Container(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DatePicker(restorationId: 'home'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category"),
                  SizedBox(height: 12,),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
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
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
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
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
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
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
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
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24,),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // _insertExpense(
                        //   "",
                        //   "Meal",
                        //   _nominalController.text,
                        //   _descController.text,
                        //   ,
                        //   monthCode,
                        //   dailyCode,
                        //   uid,
                        //   timestamp,
                        //   updated_at,
                        //   context),
                      },
                      child: Text(
                          "Save"
                      ),
                      style: ButtonStyle(
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogList(){
    return Container(
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
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white12),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                padding: EdgeInsets.all(12),
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
                        Text("21 Jul 2022, 15.40 PM"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              _buildLogList(),
              SizedBox(height: 12,),
              _buildInsertExpense(),
              SizedBox(height: 12,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDatePicker() async {
    // var result = await showDatePicker(
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(DateTime.now().year-1),
    //     lastDate: DateTime(DateTime.now().year+1));
  }

  Future<void> _insertExpense(String id, String category, String nominal, String desc, String date, String monthCode, String dailyCode, String uid, String timestamp, String updated_at, BuildContext context) async {
    if (category != null && nominal != null && desc != null) {
      await expenseRepository.storeInsertExpense(
        ExpenseModel(
          id: id,
          category: category,
          nominal: nominal,
          description: desc,
          date: date,
          monthlyDateCode: monthCode,
          dailyDateCode: dailyCode,
          userId: uid,
          timestamp: "",
          updated_at: "")
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insert successful")));
    } else if (category == null && nominal == null && desc == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill the inputs")));
    }
  }
}