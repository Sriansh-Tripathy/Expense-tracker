import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Category { food, travel, leisure, work }

const uuid = Uuid();

final formFormatter = DateFormat.yMd();

const CategoryIcons = {
  Category.food: Icons.dining_outlined,
  Category.travel: Icons.flight_takeoff_sharp,
  Category.leisure: Icons.library_music_outlined,
  Category.work: Icons.work_outline_sharp,
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formFormatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});
  final Category category;
  final List<Expense> expenses;

  double get totalExpense {
    double sum = 0;
     
     for(final expense in expenses)
     {
      sum+=expense.amount;  
     }
    return sum;
  }
}
