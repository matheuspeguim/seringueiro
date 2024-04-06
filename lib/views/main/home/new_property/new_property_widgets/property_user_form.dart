import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/widgets/explanation_card.dart';

class PropertyUserForm extends StatefulWidget {
  final bool initialIsSeringueiro;
  final bool initialIsAgronomo;
  final bool initialIsProprietario;
  final Function(bool) onSeringueiroChanged;
  final Function(bool) onAgronomoChanged;
  final Function(bool) onProprietarioChanged;

  const PropertyUserForm({
    Key? key,
    required this.initialIsSeringueiro,
    required this.initialIsAgronomo,
    required this.initialIsProprietario,
    required this.onSeringueiroChanged,
    required this.onAgronomoChanged,
    required this.onProprietarioChanged,
  }) : super(key: key);

  @override
  _PropertyUserFormState createState() => _PropertyUserFormState();
}

class _PropertyUserFormState extends State<PropertyUserForm> {
  late bool isSeringueiro;
  late bool isAgronomo;
  late bool isProprietario;
  bool _explanation = false;

  @override
  void initState() {
    super.initState();
    isSeringueiro = widget.initialIsSeringueiro;
    isAgronomo = widget.initialIsAgronomo;
    isProprietario = widget.initialIsProprietario;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          title: const Text('Seringueiro'),
          value: isSeringueiro,
          onChanged: (bool value) {
            setState(() {
              isSeringueiro = value;
              widget.onSeringueiroChanged(value);
            });
          },
        ),
        SwitchListTile(
          title: const Text('Agrônomo'),
          value: isAgronomo,
          onChanged: (bool value) {
            setState(() {
              isAgronomo = value;
              widget.onAgronomoChanged(value);
            });
          },
        ),
        SwitchListTile(
          title: const Text('Proprietário'),
          value: isProprietario,
          onChanged: (bool value) {
            setState(() {
              isProprietario = value;
              widget.onProprietarioChanged(value);
            });
          },
        ),
        SwitchListTile(
          title: const Text('Administrador'),
          value: true, // Admin sempre verdadeiro e inativo
          onChanged: null, // Desabilita a interação
          secondary: IconButton(
              icon: Icon(
                Icons.help,
                color: Colors.yellow.shade700,
              ),
              onPressed: () {
                setState(() {
                  _explanation = true; // Mostrar a explicação
                });
              }),
        ),
        if (_explanation == true)
          ExplanationCard(
              titulo: 'Administrador inicial',
              explicacao:
                  'Por regra, o criador de uma propriedade sempre iniciará como administrador, podendo mudar o status após delegar a função de Administrador para outros membros da propriedade.',
              tipo: MessageType.atencao)
      ],
    );
  }
}
