import 'package:flutter/material.dart';

class CupFill extends StatefulWidget {
  final String titulo;
  final double valor;
  final double escala;
  final Color corPreenchimento;
  final String unidade;

  const CupFill({
    Key? key,
    required this.titulo,
    required this.valor,
    this.escala = 1,
    this.corPreenchimento = Colors.blue,
    this.unidade = "mm",
  }) : super(key: key);

  @override
  _CupFillState createState() => _CupFillState();
}

class _CupFillState extends State<CupFill> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.valor).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColorForValue(double value) {
    return widget.corPreenchimento;
  }

  @override
  Widget build(BuildContext context) {
    // Dimensões proporcionais baseadas no fator de escala
    double width = 100 * widget.escala;
    double height = 200 * widget.escala;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(4.0), // Adiciona uma margem interna
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(
                12.0 * widget.escala), // Arredondamento proporcional
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5 * widget.escala, // Sombra proporcional
                blurRadius: 7 * widget.escala,
                offset: Offset(
                    0, 3 * widget.escala), // Posição da sombra proporcional
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (_, child) {
                  return Container(
                    height: 2 *
                        widget.escala *
                        _animation
                            .value, // Altura baseada no valor animado e escala
                    decoration: BoxDecoration(
                      color: _getColorForValue(_animation.value),
                      borderRadius: BorderRadius.circular(8.0 * widget.escala),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${_animation.value.toInt()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25 * widget.escala,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(0.0,
                                    -4.0), // Ajusta a posição do 'mm' em relação ao número
                                child: Text(
                                  widget.unidade,
                                  // Texto menor e com menos destaque que o número
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14 * widget.escala,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10 * widget.escala),
        Text(
          widget.titulo,
          style: TextStyle(
            fontSize: 24 * widget.escala,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
