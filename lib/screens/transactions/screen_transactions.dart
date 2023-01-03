import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_flutter/db/category/category_db.dart';
import 'package:money_manager_flutter/db/transactions/transaction_db.dart';
import 'package:money_manager_flutter/models/category/category_model.dart';
import 'package:money_manager_flutter/models/transactions/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB().transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (ctx, index) {
                final _value = newList[index];
                return Slidable(
                  key: Key(_value.id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          TransactionDB.instance.deleteTransaction(_value.id);
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: _value.type == CategoryType.income
                              ? const Color.fromARGB(255, 11, 129, 17)
                              : const Color.fromARGB(255, 190, 40, 40),
                          radius: 50,
                          child: Text(
                            parseDate(_value.date),
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          )),
                      title: Text(
                        'RS ${_value.amount}',
                      ),
                      subtitle: Text(
                        _value.purpose,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newList.length);
        });
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');

    return '${_splitDate[0]}\n${_splitDate[1]}';
  }
}
