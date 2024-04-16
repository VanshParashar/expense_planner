
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
   NewTransaction({Key? key, required this.addtx}) : super(key: key);
   final Function addtx;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

   final titlecontroller = TextEditingController();
   final amountController = TextEditingController();
    DateTime ? _selectedDate;

   void submitData(){
     if(amountController.text.isEmpty){
       return;
     }
     final enteredtitle = titlecontroller.text;
     final enteredamount =double.parse(amountController.text);
     if(enteredtitle.isEmpty || enteredamount <= 0 || _selectedDate == null){
       return;
     }
     widget.addtx(
       enteredtitle,
       enteredamount,
       _selectedDate,
     );

     Navigator.of(context).pop();
   }

   void presentDatePicker(){
     showDatePicker(
       context: context,
       initialDate: DateTime.now(),
       firstDate: DateTime(2023),
         lastDate: DateTime.now(),
     ).then((pickedDate) {
       if(pickedDate == null){
         return;
       }
       setState(() {
         _selectedDate = pickedDate;
       });
     });
   }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget> [
            TextField(
                decoration: const InputDecoration(
                    labelText: 'Title'
                ),
                controller: titlecontroller,
            ),
            SizedBox(height: 10,),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Amount'
              ),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted:(_) => submitData,
            ),
            Container(height: 80,
              child:  Row(
                children: <Widget>[
                  Expanded(
                      child: Text(_selectedDate == null ? 'No Date Chosen!' :
                      'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}'
                      )
                  ),
                  Text('choose Date',style: TextStyle(fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                  ),
                  ),
                  IconButton(
                    onPressed: presentDatePicker,
                      icon: Icon(Icons.calendar_month,color: Theme.of(context).primaryColor ,),
                  )
                ],
              ),
            ),
            ElevatedButton(onPressed: (){
            submitData();
            },
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
                child: Text('Add Transaction',)

            )
          ],
        ),
      ),
    );
  }
}
