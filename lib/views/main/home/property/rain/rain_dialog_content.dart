import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RainDialogContent extends StatefulWidget {
  @override
  _RainDialogContentState createState() => _RainDialogContentState();
}

class _RainDialogContentState extends State<RainDialogContent> {
  DateTime selectedDate = DateTime.now();
  int selectedRainAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () => _selectDate(context),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      DateFormat('dd/MM/yyyy').format(selectedDate),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 96,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedRainAmount = index;
                    });
                  },
                  children: List<Widget>.generate(100, (int index) {
                    return Center(
                        child: Text('$index mm',
                            style: TextStyle(color: Colors.white)));
                  }),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
