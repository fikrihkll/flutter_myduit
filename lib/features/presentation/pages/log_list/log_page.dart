import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myduit/features/data/models/expense_model.dart';
import 'package:myduit/features/data/repositories/expense_repository.dart';
import 'package:myduit/features/presentation/pages/home/log_widget.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {

  late ExpenseRepository expenseRepository;
  List<ExpenseModel> listExpense = [];
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  Widget _buildLogList(){
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: expenseRepository.isLoadMoreAvailable ? listExpense.length+1 : listExpense.length,
        itemBuilder: (context, position) {
          if (listExpense.isEmpty) {
            return const Center(child: CupertinoActivityIndicator());
          } else {
            if (position < listExpense.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LogWidget(expense: listExpense[position]),
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          }
        }
    );
  }

  Future<void> fetchData() async {
    var res = await expenseRepository.getListExpense(currentPage);
    listExpense.addAll(res);
    isLoading = false;
    setState(() {
    });
  }

  void onScroll(){
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if(currentScroll == maxScroll && expenseRepository.isLoadMoreAvailable){
      if(!isLoading){
        currentPage ++;
        fetchData();
        isLoading = true;
      }
    }

  }


  @override
  void initState() {
    super.initState();

    expenseRepository = ExpenseRepository(firestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      onScroll();
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Log List"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          currentPage = 1;
          listExpense.clear();
          await fetchData();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLogList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
