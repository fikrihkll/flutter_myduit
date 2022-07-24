import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myduit/features/data/models/expense_model.dart';
import 'package:myduit/features/data/repositories/expense_repository.dart';
import 'package:myduit/features/presentation/pages/home/category_widget.dart';
import 'package:intl/intl.dart';

class UpdateLog extends StatefulWidget {

  final ExpenseModel expenseModel;

  const UpdateLog({Key? key, required this.expenseModel}) : super(key: key);

  @override
  State<UpdateLog> createState() => _UpdateLogState();
}

class _UpdateLogState extends State<UpdateLog> {

  String date = "Select date";
  int selectedCategoryPosition = -1;
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late String monthlyDateCode;
  late String dailyDateCode;
  late ExpenseRepository expenseRepository;
  bool _isLoadingUpdate = false;

  Future<void> showDate() async {
    var result = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(DateTime.now().year+1));
    if (result != null) {
      date = "${result.year}-${result.month}-${result.day}";
      dailyDateCode = "${result.day}-${result.month}-${result.year}";
      monthlyDateCode = "${result.month}-${result.year}";
      setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();

    _nominalController.text = widget.expenseModel.nominal.toString();
    _descController.text = widget.expenseModel.description;
    selectedCategoryPosition = findCategoryIndex(widget.expenseModel.category);

    var dateTime = DateFormat("d-M-yyyy").parse(widget.expenseModel.dailyDateCode);
    date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    dailyDateCode = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    monthlyDateCode = "${dateTime.month}-${dateTime.year}";

    expenseRepository = ExpenseRepository(firestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance);
  }

  int findCategoryIndex(String categoryName) {
    for (int i=0; i<categoryNameList.length; i++) {
      if (categoryName == categoryNameList[i].name) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.all(Radius.circular(12))
            ),
            child: Column(
              children: [
                _buildInsertExpense()
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _updateData() async {
    _isLoadingUpdate = true;
    setState(() {

    });
    var success = await expenseRepository.updateExpense(
        ExpenseModel(
            id: widget.expenseModel.id,
            category: categoryNameList[selectedCategoryPosition].name,
            nominal: int.parse(_nominalController.text),
            description: _descController.text,
            date: date,
            monthlyDateCode: monthlyDateCode,
            dailyDateCode: dailyDateCode,
            userId: FirebaseAuth.instance.currentUser!.uid,
            timestamp: "",
            updated_at: ""
        )
    );
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upss.. There is something wrong!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update success")));
    }
    _isLoadingUpdate = false;
    setState(() {

    });
    Navigator.pop(context);
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
              children:const [
                Text(
                  "Insert your expense",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nominalController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Amount",
                  labelText: "Amount",
                ),
              ),
            ),
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: "Description",
                  labelText: "Description",
                ),
              ),
            ),
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDate();
                      },
                      child: Text(date),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Category"),
                  const SizedBox(height: 12,),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemBuilder: ((context, index) {
                        final ExpenseCategory categoryList = categoryNameList[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
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
            const SizedBox(height: 24,),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: !_isLoadingUpdate,
                      replacement: const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _updateData();
                        },
                        style: const ButtonStyle(

                        ),
                        child: const Text(
                            "Update"
                        ),
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
}
