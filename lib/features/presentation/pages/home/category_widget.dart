import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final int selectedItemPosition;
  final int itemPosition;

  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}
