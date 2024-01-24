import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RainChart {
  Widget buildChart(List<FlSpot> rainData, seringueiraMonths) {
    // Encontrar o maior valor de Y
    final maxYValue = rainData.fold<double>(
        0.0,
        (previousValue, spot) =>
            spot.y > previousValue ? spot.y : previousValue);

    // Determinar o intervalo e o maxY baseado no maior valor
    int interval;
    if (maxYValue <= 2) {
      interval = 1; // Para valores baixos, usar um intervalo pequeno
    } else if (maxYValue <= 10) {
      interval = 2;
    } else {
      interval =
          (maxYValue / 5).ceil(); // Para valores maiores, aumentar o intervalo
    }
    final dynamicMaxY = (maxYValue / interval).ceil() * interval;

    List<BarChartGroupData> barGroups = [];
    for (var spot in rainData) {
      final barGroup = BarChartGroupData(
        x: spot.x.toInt(),
        barRods: [
          BarChartRodData(
              toY: spot.y,
              color: Colors.blue.shade900,
              width: 10, // Largura da barra
              borderRadius: BorderRadius.horizontal()),
        ],
        showingTooltipIndicators: [
          0
        ], // Sempre mostrar o tooltip para cada barra
      );
      barGroups.add(barGroup);
    }

    return Container(
        margin: EdgeInsets.only(top: 64),
        child: BarChart(
          swapAnimationDuration:
              Duration(milliseconds: 500), // Duração da animação
          swapAnimationCurve: Curves.easeOut, // Curva de animação
          BarChartData(
            maxY: dynamicMaxY.toDouble(),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    // Verifica se o índice está dentro da faixa do array para evitar erros
                    if (value.toInt() < seringueiraMonths.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          seringueiraMonths[value.toInt()],
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return Container();
                  },
                  reservedSize: 32,
                ),
              ),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.blue.shade400,
                tooltipPadding: const EdgeInsets.all(4),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.round()} mm', // Exibe o valor da barra
                    const TextStyle(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            gridData: FlGridData(
                show: true, drawHorizontalLine: true, drawVerticalLine: false),
            borderData: FlBorderData(show: false),
            barGroups: barGroups,
          ),
        ));
  }
}
