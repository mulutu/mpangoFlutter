import 'package:flutter/material.dart';
import 'models/Transaction.dart';
import 'models/Project.dart';
import 'models/Account.dart';
import 'HomePage.dart';
import 'models/ChartOfAccounts.dart';
import 'models/TransactionService.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'models/ProjectService.dart';
import 'models/ChartOfAccountsService.dart';
import 'ui/SelectProject.dart';
import 'ui/SelectDate.dart';
import 'ui/SelectAccount.dart';

class CreateTransactionPage extends StatefulWidget {
  var newTrxObject;
  CreateTransactionPage({ this.newTrxObject  });

  @override
  _CreateTransactionState createState() => new _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransactionPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Transaction newTransaction =  new Transaction();

  final TextEditingController _controllerProjects = new TextEditingController();
  final TextEditingController _controllerAccounts = new TextEditingController();
  final TextEditingController _controllerDate = new TextEditingController();

  String pageTitle = "";

  Project projectObj;
  List<Project> projectsList = <Project>[];
  //String _projectName = '';

  List<Account> accountsList = <Account>[];
  //String _accountName = '';
  Account accountObj;

  _getProjectsRecords() async {
    List<Project> projects_ = await ProjectService().fetchProjects();
    setState(() {
      for (Project record in projects_) {
        this.projectsList.add(record);
      }
    });
  }

  _getAccountsRecords() async {
    List<ChartOfAccounts> accounts_ = await ChartOfAccountsService().fetchChartOfAccounts();
    setState(() {
      for (ChartOfAccounts record in accounts_) {
        List<Account> list = record.listOfAccounts.records;
        if(list.length > 0 ) {
          this.accountsList.addAll(list);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    newTransaction = widget.newTrxObject;
    newTransaction.userId = 1;
    _getProjectsRecords();
    _getAccountsRecords();

    if(newTransaction.transactionTypeId==0){
      pageTitle = "New Income";
    }else{
      pageTitle = "New Expense";
    }
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(pageTitle),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[

              new TextFormField(
                decoration: const InputDecoration( icon: const Icon(Icons.person), hintText: 'Enter transaction amount', labelText: 'Amount', ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //inputFormatters: [ WhitelistingTextInputFormatter.digitsOnly,  ],
                validator: (val) => val.isEmpty ? 'Amount is required' : null,
                onSaved: (val) => newTransaction.amount = double.parse(val), // as double,
                textInputAction: TextInputAction.next,
              ),
              InkWell(
                onTap: () {
                  _awaitReturnValueFromSelectProjectScreen(context);
                  /*Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new SelectProject(newTrxObj:newTransaction)),
                  );*/
                },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Select Project',
                      labelText: 'Select Project',
                    ),
                    keyboardType: TextInputType.text,
                    controller: _controllerProjects,
                    textInputAction: TextInputAction.next,
                    //onChanged: (v)=>setState((){_text=v;}),
                    //validator: (val) => isValidDob(val) ? null : 'Not a valid name',
                    //onSaved: (val) => newTransaction.transactionDate = new DateFormat("yyyy-MM-dd").parse(val), // as double,
                    //onSaved: (val) => newTransaction.transactionDate = new DateFormat.yMd().parse(val),
                  ),
                )
              ),
              InkWell(
                  onTap: () {
                    _awaitReturnValueFromSelectAccountScreen(context);
                  },
                  child: IgnorePointer(
                    child: new TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'Select Account',
                        labelText: 'Select Account',
                      ),
                      keyboardType: TextInputType.text,
                      controller: _controllerAccounts,
                      textInputAction: TextInputAction.next,
                      //onChanged: (v)=>setState((){_text=v;}),
                      //validator: (val) => isValidDob(val) ? null : 'Not a valid name',
                      //onSaved: (val) => newTransaction.transactionDate = new DateFormat("yyyy-MM-dd").parse(val), // as double,
                      //onSaved: (val) => newTransaction.transactionDate = new DateFormat.yMd().parse(val),
                    ),
                  )
              ),
              InkWell(
                  onTap: () {
                    //_chooseDate(context, _controller.text);
                    _awaitReturnValueFromSelectDateScreen(context);
                  },
                child: IgnorePointer(
                    child: new TextFormField(
                        decoration: const InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'Enter date of transaction',
                        labelText: 'Date',
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: _controllerDate,
                      validator: (val) => isValidDob(val) ? null : 'Not a valid date',
                      //onSaved: (val) => newTransaction.transactionDate = new DateFormat("yyyy-MM-dd").parse(val), // as double,
                      onSaved: (val) => newTransaction.transactionDate = new DateFormat.yMd().parse(val),
                  ),
                )
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'Enter the description',
                  labelText: 'Description',
                ),
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                validator: (val) => val.isEmpty ? 'Description is required' : null,
                onSaved: (val) => newTransaction.description = val, // as double,
              ),
              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  //onPressed: null,
                  onPressed: _submitForm,
                )
              ),

            ],
          )
        )
      )
    );
  }


  void _awaitReturnValueFromSelectAccountScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectAccount(newTrxObj:newTransaction),
        ));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      newTransaction = result;
      _controllerAccounts.text = newTransaction.accountId.toString();
    });

    print("CREATETRX TRX checked projects IDS: ${newTransaction.transactionDate.toString()}");

  }

  void _awaitReturnValueFromSelectDateScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectDate(newTrxObj:newTransaction),
        ));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      newTransaction = result;
      _controllerDate.text = newTransaction.transactionDate.toString();
    });

    print("CREATETRX TRX checked projects IDS: ${newTransaction.transactionDate.toString()}");

  }

  void _awaitReturnValueFromSelectProjectScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectProject(newTrxObj:newTransaction),
        ));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      newTransaction = result;
      _controllerProjects.text = newTransaction.selectedProjects.toString();
    });

    print("CREATETRX TRX checked projects IDS: ${newTransaction.selectedProjects.toString()}");

  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Amount: ${newTransaction.amount}');
      print('Description: ${newTransaction.description}');
      print('Date: ${newTransaction.transactionDate}');
      print('ProjectId: ${newTransaction.projectId}');
      print('AccountId: ${newTransaction.accountId}');
      print('UserId: ${newTransaction.userId}');
      print('TransactionTypeId: ${newTransaction.transactionTypeId}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      var transactionService = new TransactionService();
      transactionService.createTransaction(newTransaction)
          .then((value) => showMessage('New transaction created for ${value.message}!', Colors.blue)
      );


    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
    Navigator.push(
        context,
        new MaterialPageRoute( builder: (context) => HomePage())
    );
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}