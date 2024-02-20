import 'package:flutter/material.dart';

class RubberCollectionMugWidget extends StatefulWidget {
  final String title;
  final double percentage;

  const RubberCollectionMugWidget({
    Key? key,
    required this.title,
    required this.percentage,
  }) : super(key: key);

  @override
  _RubberCollectionMugWidgetState createState() =>
      _RubberCollectionMugWidgetState();
}

class _RubberCollectionMugWidgetState extends State<RubberCollectionMugWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: widget.percentage)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            painter: _RubberMugPainter(percentageCollected: _animation.value),
            child: Container(
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(height: 8),
          Text(widget.title, style: Theme.of(context).textTheme.headline6),
          Text('${_animation.value.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}

class _RubberMugPainter extends CustomPainter {
  final double percentageCollected;

  _RubberMugPainter({required this.percentageCollected});

  @override
  void paint(Canvas canvas, Size size) {
    // Desenha a caneca
    Paint mugPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Path mugPath = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..arcToPoint(
        Offset(size.width * 0.8, size.height),
        radius: Radius.circular(size.width * 0.3),
        clockwise: false,
      )
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..arcToPoint(
        Offset(size.width * 0.2, size.height * 0.2),
        radius: Radius.circular(size.width * 0.3),
        clockwise: false,
      )
      ..close();

    canvas.drawPath(mugPath, mugPaint);

    // Desenha o preenchimento
    Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double fillHeight = size.height * 0.8 * (percentageCollected / 100);
    Path fillPath = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..arcToPoint(
        Offset(size.width * 0.8, size.height),
        radius: Radius.circular(size.width * 0.3),
        clockwise: false,
      )
      ..lineTo(size.width * 0.8, size.height - fillHeight)
      ..arcToPoint(
        Offset(size.width * 0.2, size.height - fillHeight),
        radius: Radius.circular(fillHeight / 2),
        clockwise: true,
      )
      ..close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
