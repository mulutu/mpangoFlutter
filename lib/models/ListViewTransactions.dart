import 'package:flutter/material.dart';
import 'Transaction.dart';
import '../DetailsPage.dart';
import 'package:intl/intl.dart';

class ListViewTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  ListViewTransactions({Key key, this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, position) {
            String formatted = formatter.format(transactions[position].transactionDate);
            var trxType = transactions[position].transactionTypeId;
            return GestureDetector(
                onTap: () => _onTapItem(context, transactions[position]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(height: 1.0),
                    Container(
                      padding: const EdgeInsets.only(bottom:2, left:5, top:5),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(child: new Text('${transactions[position].amount}', textAlign:TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0,  color:  (trxType==1) ? Colors.red: Colors.green, )), ),
                          new Expanded(child:new Text('${formatted}', textAlign:TextAlign.right, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13.0, color: Colors.grey), ), ),
                        ]
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 1),
                              child: Text( '${transactions[position].description}', style: TextStyle( fontWeight: FontWeight.bold, ), ),
                            ),
                            Text('${transactions[position].projectName}', style: TextStyle( color: Colors.grey[500], ), ),
                          ]
                        )
                    ),
                  ],
                )
            );

          }),
    );
  }

  void _onTapItem(BuildContext context, Transaction transaction) {
    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(transaction.amount.toString() + ' - ' + transaction.amount.toString())));
    Navigator.push( context, new MaterialPageRoute( builder: (context) => DetailsPage(newTrxObject:transaction))
    );
  }


}