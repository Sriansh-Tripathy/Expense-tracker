import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/rendering.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDay,
        lastDate: now,
        barrierColor: Colors.lightBlueAccent); //.then((value) => null);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      //show Error;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'please ensure that a valid title ,amount and date has been selected'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Done'))
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    //always dispose any controller made because even though the widget is not been used it will occupy some of the memory which may lead to crashing of the app;

    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
      final width = constraints.maxWidth;
      if (width >= 600) {
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 40, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 50,
                          autocorrect: true,
                          controller: _titleController,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      //if()
                      SizedBox(
                        width: 310,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_selectedDate == null
                                ? 'select a Date'
                                : formFormatter.format(
                                    _selectedDate!)), //we can force dart by using ! to say it will not be null
                            IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month_sharp))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 310,
                        child: Expanded(
                          child: TextField(
                            maxLength: 50,
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 200),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: DropdownButton(
                                value: _selectedCategory,
                                items: Category.values
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Center(
                                          child: Text(
                                            category.name.toUpperCase(),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); //forward the context tot it;
                        },
                        child: Text('cancel',
                            style: TextStyle(
                                color: kColorScheme.onInverseSurface)),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitData();
                        },
                        child: Text('save Expense',
                            style: TextStyle(
                                color: kColorScheme.onInverseSurface)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      } else {
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 40, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 50,
                          autocorrect: true,
                          controller: _titleController,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      //if()
                      //const SizedBox(width: 310),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: 50,
                          keyboardType: TextInputType.number,
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_selectedDate == null
                                ? 'select a Date'
                                : formFormatter.format(
                                    _selectedDate!)), //we can force dart by using ! to say it will not be null
                            IconButton(
                                onPressed: _presentDatePicker,
                                icon: Icon(Icons.calendar_month_sharp))
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                            ;
                          }),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); //forward the context tot it;
                        },
                        child: Text('cancel',
                            style: TextStyle(
                                color: kColorScheme.onInverseSurface)),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitData();
                        },
                        child: Text('save Expense',
                            style: TextStyle(
                                color: kColorScheme.onInverseSurface)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
