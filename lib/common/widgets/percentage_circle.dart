import 'package:flutter/material.dart';
import 'dart:math' as math;

class PercentageCircle extends StatefulWidget {
  final String titulo;
  final double valor;
  final Color? themeColor;

  const PercentageCircle(
      {Key? key,
      required this.titulo,
      required this.valor,
      this.themeColor = Colors.white})
      : super(key: key);

  @override
  _PercentageCircleState createState() => _PercentageCircleState();
}

class _PercentageCircleState extends State<PercentageCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duração da animação
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

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size.width * 0.18; // 60% da largura da tela

    return Container(
        padding: EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(size, size),
                  painter: _CirclePainter(_animation.value,
                      widget.themeColor! // Usando o valor animado
                      ),
                ),
                Text(
                  '${_animation.value.toInt()}%',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                    color: widget.themeColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              widget.titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
          ],
        ));
  }
}

class _CirclePainter extends CustomPainter {
  final double valor;
  final Color themeColor;

  _CirclePainter(this.valor, this.themeColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint basePaint = Paint()
      ..color = themeColor.withOpacity(0.2)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    // Ajuste do gradiente de cores baseado no valor da porcentagem
    List<Color> colors;
    if (valor < 30) {
      colors = [Colors.redAccent, Colors.red];
    } else if (valor < 60) {
      colors = [Colors.orange, Colors.yellow];
    } else {
      colors = [Colors.greenAccent, Colors.green];
    }
    Paint progressPaint = Paint()
      ..strokeWidth = 15
      ..shader = LinearGradient(
        colors: colors,
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(size.center(Offset.zero),
        size.width / 2 - basePaint.strokeWidth / 2, basePaint);

    double angle = 2 * math.pi * (valor / 100);
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2 - progressPaint.strokeWidth / 2),
      math.pi * 1.5,
      angle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
