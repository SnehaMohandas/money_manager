import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/db/transactions/transaction_db.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';
import 'package:money_manager_flutter/models/transactions/transaction_model.dart';

class ScreenAddTransactions extends StatefulWidget {
  static const routeName = 'add-transation';
  const ScreenAddTransactions({super.key});

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionsState();
}

class _ScreenAddTransactionsState extends State<ScreenAddTransactions> {
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _purposeController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Purpose'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now());
                if (_selectedDateTemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : _selectedDate.toString(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newType) {
                          setState(() {
                            _selectedCategoryType = CategoryType.income;
                            _categoryID = null;
                          });
                        }),
                    const Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategoryType,
                      onChanged: (newType) {
                        setState(() {
                          _selectedCategoryType = CategoryType.expense;
                          _categoryID = null;
                        });
                      },
                    ),
                    const Text('Expense'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButton(
              value: _categoryID,
              hint: const Text('Select Category'),
              items: (_selectedCategoryType == CategoryType.income
                      ? CategoryDB().incomecategoryListNotifier
                      : CategoryDB().expenseCategoryListNotifier)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                  onTap: () {
                    _selectedCategoryModel = e;
                  },
                );
              }).toList(),
              onChanged: (selectedValue) {
                setState(() {
                  _categoryID = selectedValue;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addTransaction();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeController.text;
    final _amountText = _amountController.text;

    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_categoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
