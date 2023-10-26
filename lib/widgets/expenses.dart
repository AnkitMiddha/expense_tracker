import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({
    super.key,
  });
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpenses = [
    Expense(
      title: 'Burger',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Movie',
      amount: 14.96,
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
       useSafeArea: true,
       isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerdExpenses.add(expense);
    });
  }
 
  void _removeExpense(Expense expense) {
    final expenseIndex = _registerdExpenses.indexOf(expense);
    setState(() {
      _registerdExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
    content: const Text("Expense Deleted "),
   duration:const  Duration(seconds: 30),
   action: SnackBarAction(label:'Undo', onPressed: ()
   {
    setState(() {
      _registerdExpenses.insert(expenseIndex, expense);
    });
   })
  
   )
  );
  }
  
  @override
  Widget build(BuildContext context) {
   final width = MediaQuery.of(context).size.width;
   //final Height= MediaQuery.of(context).size.height;
    Widget mainContent = const Center(
      child: Text('No expense found ,  Please add some expenses'),
    );
    if(_registerdExpenses.isNotEmpty)
    {
      mainContent = ExpenseList(
            expenses: _registerdExpenses,
            onRemoveExpense : _removeExpense,
          );
    }
   
    return Scaffold(
      appBar: AppBar(actions: [
        const Text('  Expense Tracker'),
        const Spacer(),
        IconButton(
            onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
            IconButton(onPressed: () {
              
            }, icon: const Icon(Icons.dark_mode_rounded))
      ]),
      
      body: width < 600 ?Column(
        children: [
       Chart(expenses: _registerdExpenses),
          Expanded(
              child: mainContent),
        ],
        
      )
      :Row(
        children: [
          Expanded( child: Chart(expenses: _registerdExpenses)),
          Expanded(
              child: mainContent),
        ],
      )
    );
  }
}
