import 'package:flutter/material.dart';
import 'package:myduit/features/data/models/expense_model.dart';
import 'package:intl/intl.dart';
import 'package:myduit/features/presentation/pages/update/update_page.dart';

class LogWidget extends StatelessWidget {

  final ExpenseModel expense;

  const LogWidget({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (builder) => UpdateLog(expenseModel: expense));
      },
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
                  expense.category,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Rp. ${expense.nominal}",
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
                Flexible(child: Text(expense.description)),
                Text(DateFormat("E, d MMMM yyyy").format(DateFormat("d-M-yyyy").parse(expense.dailyDateCode))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
