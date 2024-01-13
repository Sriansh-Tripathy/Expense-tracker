import 'package:expense_tracker/widgets/expenses_lists/expenses_lists.dart';
import "package:expense_tracker/models/expense.dart";
import "package:expense_tracker/widgets/new_expense.dart";
import "package:flutter/material.dart";

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Courese',
        amount: 17.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'movie',
        amount: 15,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('no expense found . try adding some'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent =
          ExpensesList(expenses: _registeredExpenses, onDelete: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: Icon(Icons.add_circle_outline_sharp),
          )
        ],
      ),
      body: Column(
        children: [
          Text('the chart'),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
