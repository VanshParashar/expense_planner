import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Transaction>('transactions');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
       // errorColor: Colors.red,
        primarySwatch: Colors.lightGreen,
          fontFamily: 'OpenSans' ,
        appBarTheme : AppBarTheme(
            toolbarTextStyle: ThemeData.dark().textTheme.copyWith(
                titleLarge: TextStyle(
                    fontFamily: 'Quicksand', fontSize: 25)).bodyLarge,
            titleTextStyle: ThemeData.light().textTheme.copyWith(
                titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 25
                ),
              ).headline6)
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getTransaction();
    // TODO: implement initState
    super.initState();
  }

  final List<Transaction> _userTransaction =[

    Transaction(id: 't1', title: 'New Shoes', amount: 10000, date: DateTime.now()),
    Transaction(id: 't2', title: 'New Car', amount: 1000000, date: DateTime.now()),

  ];

  List<Transaction> get _recentTransaction{
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7)
          ));
    }).toList();
  }
  Future<void> _addNewTransaction(String txtitle, double txamount , DateTime chosenDate) async {
    final transactionBox = await Hive.openBox<Transaction>('transactions');
    final newtx = Transaction(
        title: txtitle,
        amount: txamount,
        date: chosenDate,
      id:DateTime.now().toString()
    );

    setState(() {
      _userTransaction .add(newtx);
      transactionBox.add(newtx);
    });
  }

  Future<List<Transaction>> getTransaction () async{
    final transactionBox = await Hive.openBox<Transaction>('transactions');
    print(transactionBox.values.toList());
    return transactionBox.values.toList();
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (bctx){
      return NewTransaction(addtx: _addNewTransaction);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransaction.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  // HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget> [
          IconButton(
              onPressed: (){
                _startAddNewTransaction(context);
              },
              icon: Icon(Icons.add))
        ],
        title: const  Text('Personal Expensis'),
      ),
      body:  SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Chart(recentTransactions: _recentTransaction),
              TransactionList(
                    transaction: _userTransaction,
                    deletetx: _deleteTransaction,
                  ),
            ],
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          _startAddNewTransaction(context);

        },
      ),
    );
  }
}
