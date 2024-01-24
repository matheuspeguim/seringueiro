import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_state.dart';

class RainDialogContent extends StatefulWidget {
  final User user;
  final Property property;

  RainDialogContent({Key? key, required this.user, required this.property})
      : super(key: key);

  @override
  _RainDialogContentState createState() => _RainDialogContentState();
}

class _RainDialogContentState extends State<RainDialogContent> {
  DateTime selectedDate = DateTime.now();
  int selectedRainAmount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RainBloc, RainState>(
      listener: (context, state) {
        if (state is RainRecordSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registro de chuva salvo com sucesso!')));
          Navigator.of(context).pop();
        } else if (state is RainRecordSaveError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Erro ao salvar registro de chuva: ${state.message}')));
        }
      },
      child: Container(
        color: Colors.blue.shade800,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Registrar Chuva",
                style: TextStyle(color: Colors.white, fontSize: 24)),
            SizedBox(height: 16.0),
            Text("Selecione a data e a quantidade de chuva",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 16.0),
            buildDatePicker(),
            SizedBox(height: 16.0),
            buildRainAmountPicker(),
            SizedBox(height: 16.0),
            buildActionButtons(context)
          ],
        ),
      ),
    );
  }

  InkWell buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.calendar_today, color: Colors.white),
          SizedBox(width: 8.0),
          Text(
            DateFormat('dd/MM/yyyy').format(selectedDate),
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildRainAmountPicker() {
    return Container(
      height: 96,
      child: CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (int index) async {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 30);
          }
          setState(() {
            selectedRainAmount = index;
          });
        },
        children: List<Widget>.generate(100, (int index) {
          return Center(
              child: Text('$index mm', style: TextStyle(color: Colors.white)));
        }),
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            saveRainData();
          },
          child: Text(
            "Salvar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime oneYearBefore = DateTime(now.year - 1, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: oneYearBefore,
      lastDate: now,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void saveRainData() {
    BlocProvider.of<RainBloc>(context).add(SaveRainRecord(
      user: widget.user,
      property: widget.property,
      date: selectedDate,
      rainAmount: selectedRainAmount,
    ));
  }
}
