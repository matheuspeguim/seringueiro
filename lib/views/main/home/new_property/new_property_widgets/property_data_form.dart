import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/common/services/via_cep_service.dart';
import 'package:flutter_seringueiro/common/widgets/custom_text_field.dart';
import 'package:flutter_seringueiro/common/validators/validators.dart';
import 'package:flutter_seringueiro/common/widgets/explanation_card.dart';

class PropertyDataForm extends StatefulWidget {
  final TextEditingController nomeDaPropriedadeController;
  final MaskedTextController cepDaPropriedadeController;
  final TextEditingController cidadeDaPropriedadeController;
  final TextEditingController estadoDaPropriedadeController;
  final TextEditingController areaEmHectaresController;
  final TextEditingController quantidadeDeArvoresController;
  final TextEditingController clonePredominanteController;
  final FocusNode nomeDaPropriedadeFocus;
  final FocusNode cepDaPropriedadeFocus;
  final FocusNode cidadeDaPropriedadeFocus;
  final FocusNode estadoDaPropriedadeFocus;
  final FocusNode areaEmHectaresFocus;
  final FocusNode quantidadeDeArvoresFocus;
  final FocusNode clonePredominanteFocus;

  PropertyDataForm({
    Key? key,
    required this.nomeDaPropriedadeController,
    required this.cepDaPropriedadeController,
    required this.cidadeDaPropriedadeController,
    required this.estadoDaPropriedadeController,
    required this.areaEmHectaresController,
    required this.quantidadeDeArvoresController,
    required this.clonePredominanteController,
    required this.nomeDaPropriedadeFocus,
    required this.cepDaPropriedadeFocus,
    required this.cidadeDaPropriedadeFocus,
    required this.estadoDaPropriedadeFocus,
    required this.areaEmHectaresFocus,
    required this.quantidadeDeArvoresFocus,
    required this.clonePredominanteFocus,
  }) : super(key: key);

  @override
  _PropertyDataFormState createState() => _PropertyDataFormState();
}

class _PropertyDataFormState extends State<PropertyDataForm> {
  final viaCepService = ViaCepService();
  String? _cloneSelecionado;
  final List<String> clones = [
    'RRIM 600',
    'GT 1',
    'PR 255',
    'PB 235',
    'IRRDB 198',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    widget.cepDaPropriedadeController.addListener(_buscarCep);
    _cloneSelecionado = clones.first;
  }

  @override
  void dispose() {
    widget.cepDaPropriedadeController.removeListener(_buscarCep);
    super.dispose();
  }

  void _buscarCep() {
    final cep = widget.cepDaPropriedadeController.text;
    // Remove caracteres não numéricos para verificar se temos 8 dígitos
    final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');

    if (cepLimpo.length == 8) {
      // Chama o serviço de busca por CEP e atualiza os campos de endereço
      viaCepService.fetchEnderecoByCep(cepLimpo).then((endereco) {
        setState(() {
          widget.cidadeDaPropriedadeController.text =
              endereco['localidade'] ?? '';
          widget.estadoDaPropriedadeController.text = endereco['uf'] ?? '';
          // Atualize outros campos conforme necessário
        });
      }).catchError((error) {
        // Trate erros aqui, como mostrar um diálogo de erro
        print('Erro ao buscar o CEP: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CustomTextField(
        controller: widget.nomeDaPropriedadeController,
        label: 'Nome da propriedade',
        validator: Validators.validarNomeDaPropriedade,
        focusNode: widget.nomeDaPropriedadeFocus,
        nextFocusNode: widget.cepDaPropriedadeFocus,
        keyboardType: TextInputType.text,
      ),
      SizedBox(height: 32.0),
      CustomTextField(
        controller: widget.cepDaPropriedadeController,
        label: 'Cep da propriedade',
        validator: Validators.validarCEP,
        focusNode: widget.cepDaPropriedadeFocus,
        nextFocusNode: widget.cidadeDaPropriedadeFocus,
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 32.0),
      CustomTextField(
        controller: widget.cidadeDaPropriedadeController,
        label: 'Cidade da propriedade',
        validator: Validators.validarCidade,
        focusNode: widget.cidadeDaPropriedadeFocus,
        nextFocusNode: widget.estadoDaPropriedadeFocus,
        keyboardType: TextInputType.name,
      ),
      SizedBox(height: 32.0),
      CustomTextField(
        controller: widget.estadoDaPropriedadeController,
        label: 'Estado da propriedade',
        validator: Validators.validarEstado,
        focusNode: widget.estadoDaPropriedadeFocus,
        nextFocusNode: widget.areaEmHectaresFocus,
        keyboardType: TextInputType.name,
      ),
      SizedBox(height: 32.0),
      CustomTextField(
        controller: widget.areaEmHectaresController,
        label: 'Área do seringal (ha)',
        validator: Validators.validarAreasEmHectares,
        focusNode: widget.areaEmHectaresFocus,
        nextFocusNode: widget.quantidadeDeArvoresFocus,
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 32.0),
      CustomTextField(
        controller: widget.quantidadeDeArvoresController,
        label: 'Quantidade de árvores ativas',
        validator: Validators.validarQuantidadeDeArvores,
        focusNode: widget.quantidadeDeArvoresFocus,
        nextFocusNode: widget.clonePredominanteFocus,
        keyboardType: TextInputType.number,
      ),
      SizedBox(
        height: 12,
      ),
      ExplanationCard(
          titulo: 'Clone predominante',
          explicacao:
              'Selecione o clone do seringal ou, se não estiver na lista, especifique um.',
          tipo: MessageType.explicativo),
      DropdownButtonFormField<String>(
        value: _cloneSelecionado,
        decoration: InputDecoration(
          labelText: 'Clone Predominante',
          // Configurações adicionais
        ),
        items: clones.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (newValue == 'Outro') {
              // Se 'Outro' for selecionado, limpa o texto para o usuário inserir um novo valor
              widget.clonePredominanteController.text = '';
            } else {
              // Caso contrário, atualiza com o valor selecionado
              widget.clonePredominanteController.text = newValue!;
            }
            _cloneSelecionado = newValue;
          });
        },
        validator: (value) => value == null ? 'Selecione um clone' : null,
      ),
      if (_cloneSelecionado == 'Outro')
        CustomTextField(
          controller: widget
              .clonePredominanteController, // Controlador separado para 'Outro'
          label: 'Digite o nome do clone',
          validator: Validators.validarNome,
          focusNode: widget.clonePredominanteFocus,
          keyboardType: TextInputType.text,
        ),
    ]);
  }
}
