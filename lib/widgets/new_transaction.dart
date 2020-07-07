import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneNoController = TextEditingController();

  DateTime _selectedDate;

  @override
  void initState() {
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose()');
    super.dispose();
  }

  

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    final enteredDesignation = _designationController.text;
    final enteredPhoneNo = num.parse(_phoneNoController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null || enteredDesignation.isEmpty || enteredPhoneNo < 1000000000) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
      enteredDesignation,
      enteredPhoneNo,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Company/Site Representative:', style: TextStyle(
                fontSize: 20,
              ),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                  // onChanged: (val) {
                  //   titleInput = val;
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  
                  decoration: InputDecoration(labelText: 'Amount', 
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                  // onChanged: (val) => amountInput = val,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Designation'),
                  controller: _designationController,
                  onSubmitted: (_) => _submitData(),
                  // onChanged: (val) {
                  //   titleInput = val;
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  controller: _phoneNoController,
                  onSubmitted: (_) => _submitData(),
                  // onChanged: (val) {
                  //   titleInput = val;
                  // },
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker)
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Inspection'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
