import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myduit/features/data/models/expense_model.dart';
import 'package:myduit/features/data/models/summary_expense_model.dart';
import 'package:myduit/features/data/repositories/expense_repository.dart';
import 'package:myduit/features/presentation/pages/home/category_widget.dart';
import 'package:myduit/features/presentation/pages/home/log_widget.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String dateText = "Select date";
  late String monthlyDateCode;
  late String dailyDateCode;
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late ExpenseRepository expenseRepository;
  int selectedCategoryPosition = -1;

  List<ExpenseModel> listExpense = [];
  SummaryExpenseModel dailyExpense = SummaryExpenseModel(id: "", nominal: 0, updatedAt: "", userId: "");
  SummaryExpenseModel monthlyExpense = SummaryExpenseModel(id: "", nominal: 0, updatedAt: "", userId: "");

  @override
  void initState() {
    super.initState();

    expenseRepository = ExpenseRepository(
        firestore: FirebaseFirestore.instance,
        firebaseAuth: FirebaseAuth.instance
    );
    name = FirebaseAuth.instance.currentUser!.displayName;
    fetchLogData();
    fetchDailyExpenseData();
    fetchMonthlyExpenseData();
  }

  Widget _helloUser(){
    return SafeArea(
      top: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  Navigator.pushNamedAndRemoveUntil(context, route.loginPage, (route)=> false);
                },
                child: Text(
                  "Hello, $name glad to see you back!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        decoration: const BoxDecoration(
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
                children: const [
                  Text(
                    "Today's expense",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32,),
              Column(
                children: [
                  Text("Rp ${dailyExpense.nominal}"),
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
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        decoration: const BoxDecoration(
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
                children: const [
                  Text(
                    "This month's expense",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24,),
              Row(
                children: [
                  Text(
                    "Rp ${monthlyExpense.nominal}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, route.logPage);
                      },
                      child: const Text(
                          "Check Logs"
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsertExpense(){
    return Container(
      decoration: const BoxDecoration(
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
                    child: OutlinedButton(
                      onPressed: () {
                        showDate();
                      },
                      child: Text(dateText),
                    ),
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
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    final ExpenseCategory categoryList = categoryNameList[index];
                    return Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: CategoryWidget(
                        itemPosition: index,
                        isSelected: selectedCategoryPosition == index,
                        category: categoryList,
                        onAreaClicked: (itemPosition){
                          selectedCategoryPosition = itemPosition;
                          setState(() {});
                        },
                      ),
                    );
                  }),
                  itemCount: categoryNameList.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
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
                        _insertExpense(
                          "",
                          categoryNameList[selectedCategoryPosition].name,
                          _nominalController.text,
                          _descController.text,
                          dateText,
                          monthlyDateCode,
                          dailyDateCode,
                          FirebaseUtil.getUID(),
                          "",
                          "",
                          context);
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
      decoration: const BoxDecoration(
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
              children: const [
                Text(
                  "Recent expense",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: listExpense.length,
                itemBuilder: (context, position) {
                  if (listExpense.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: LogWidget(expense: listExpense[position]),
                    );
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchDailyExpenseData() async {
    var res = await expenseRepository.getDailyExpense();
    if (res != null) {
      dailyExpense = res;
    }
    setState(() {
    });
  }

  Future<void> fetchMonthlyExpenseData() async {
    var res = await expenseRepository.getMonthlyExpense();
    if (res != null) {
      monthlyExpense = res;
    }
    setState(() {
    });
  }

  Future<void> fetchLogData() async {
    listExpense = await expenseRepository.getCurrentExpense(3);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          fetchLogData();
          fetchDailyExpenseData();
          await fetchMonthlyExpenseData();
      },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                _buildInsertExpense(),
                SizedBox(height: 12,),
                _buildLogList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDate() async {
    var result = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(DateTime.now().year+1));
    if (result != null) {
      dateText = "${result.year}-${result.month}-${result.day}";
      dailyDateCode = "${result.day}-${result.month}-${result.year}";
      monthlyDateCode = "${result.month}-${result.year}";
      setState(() {});
    }
  }

  Future<void> _insertExpense(String id, String category, String nominal, String desc, String date, String monthCode, String dailyCode, String uid, String timestamp, String updated_at, BuildContext context) async {
    if (category != null && nominal != null && desc != null) {
      var res = await expenseRepository.storeInsertExpense(
        ExpenseModel(
          id: id,
          category: category,
          nominal: int.parse(nominal),
          description: desc,
          date: date,
          monthlyDateCode: monthCode,
          dailyDateCode: dailyCode,
          userId: uid,
          timestamp: "",
          updated_at: "")
      );
      if (res) {
        fetchLogData();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insert successful")));
        // _descController.clear();
        // _nominalController.clear();
        // dateText = "Select date";
      }
    } else if (category == null && nominal == null && desc == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill the inputs")));
    }
  }
}