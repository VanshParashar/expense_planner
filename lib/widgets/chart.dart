import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  final List <Transaction> recentTransactions;


  List<Map<String,dynamic>> get groupedTransactionValues{
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for(var i=0 ; i < recentTransactions.length ; i++ ){
        if(recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
        recentTransactions[i].date.year == weekDay.year){

          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0,1),
        'amount':totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data){
            return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(label : data['day'], spendingAmount:  data['amount'], spendingPercOfTotal: totalSpending == 0 ? 0 : (data["amount"] as double) / totalSpending));
          }).toList(),
        ),
      ) ,
    );
  }
}
