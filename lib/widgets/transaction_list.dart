import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
   TransactionList({Key? key, required this.transaction, required this.deletetx}) : super(key: key);

   final List<Transaction> transaction ;
   final Function deletetx;

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 600 ,
        child: transaction.isEmpty ? Column( children: <Widget>[
          Text('No Transaction added yet !',style: Theme.of(context).textTheme.titleLarge,
          ),
        SizedBox( height: 50,),
        Container(
            height: 200,
            child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
        ],)
            : ListView.builder(
          itemBuilder: (context,index){
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  radius : 30 ,
                  child: Padding(padding: EdgeInsets.all(6),
                  child: FittedBox(child: Text('\$${transaction[index].amount}'))),
                ),
                title: Text(
                  transaction[index].title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                    DateFormat.yMMMd().format(transaction[index].date)
                ),
                trailing: IconButton(icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                  onPressed: (){
                  deletetx(transaction[index].id);
                  },
                ),
              ),
            );
          },
            itemCount : transaction.length,
        ),
      );

  }
}
