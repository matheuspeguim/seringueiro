import 'package:flutter/material.dart';

class CupFill extends StatefulWidget {
  final String titulo;
  final double valor;

  const CupFill({Key? key, required this.titulo, required this.valor})
      : super(key: key);

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
    if (value < 30) return Colors.blue.shade100;
    if (value < 60) return Colors.blue.shade500;
    return Colors.blue.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 300,
          padding: const EdgeInsets.all(8.0), // Adiciona uma margem interna
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
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
                    height: 3.0 *
                        _animation.value, // Altura baseada no valor animado
                    decoration: BoxDecoration(
                      color: _getColorForValue(_animation.value),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${_animation.value.toInt()}%',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          widget.titulo.toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
