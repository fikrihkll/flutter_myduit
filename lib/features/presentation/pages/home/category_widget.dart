import 'package:flutter/material.dart';
import 'package:myduit/core/icon_util.dart';
import 'package:myduit/features/data/models/expense_model.dart';

class CategoryWidget extends StatelessWidget {
  final Function(int position) onAreaClicked;
  final int itemPosition;
  final ExpenseCategory category;
  final bool isSelected;

  const CategoryWidget({Key? key, required this.itemPosition, required this.category, required this.onAreaClicked, required this.isSelected}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onAreaClicked(itemPosition);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected ?
            Border.all(
              color: Colors.lightBlue,
              width: 1,
            )
                : Border.all(
              color: Colors.white12,
              width: 1,
            )
        ),
        child: Row(
          children: <Widget>[
            Icon(
              IconUtil.getIconFromString(category.name),
              size: 24,
            ),
            SizedBox(width: 4,),
            Text(category.name),
          ],
        ),
      ),
    );
  }
}
