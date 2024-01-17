import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_state.dart';

class RainChartWidget extends StatefulWidget {
  final String propertyId;

  RainChartWidget({Key? key, required this.propertyId}) : super(key: key);

  @override
  _RainChartWidgetState createState() => _RainChartWidgetState();
}

class _RainChartWidgetState extends State<RainChartWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<RainBloc>(context)
          .add(LoadRainData(propertyId: widget.propertyId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RainBloc, RainState>(
      builder: (context, state) {
        if (state is RainChartDataLoaded) {
          var rainData = _transformRainData(state.chartData);
          return rainData.isNotEmpty
              ? _buildChart(rainData.cast<FlSpot>())
              : Container();
        } else if (state is RainLoading) {
          return CircularProgressIndicator();
        } else {
          return Text('Não foi possível carregar os dados do gráfico');
        }
      },
    );
  }

  List<FlSpot> _transformRainData(List<RainChartData> chartData) {
    DateTime startOfLastSeason;
    DateTime endOfLastSeason;
    DateTime now = DateTime.now();

// Definindo a safra atual
    if (now.month >= 9) {
      // Se estivermos entre setembro e dezembro, a safra começa neste ano
      startOfLastSeason = DateTime(now.year, 9);
      endOfLastSeason = DateTime(now.year + 1, 7);
    } else {
      // Se estivermos entre janeiro e agosto, a safra começou no ano anterior
      startOfLastSeason = DateTime(now.year - 1, 9);
      endOfLastSeason = DateTime(now.year, 7);
    }

    Map<int, double> monthlyRainSum = {};
    for (var data in chartData) {
      if (data.date.isAfter(startOfLastSeason) &&
          data.date.isBefore(endOfLastSeason)) {
        int monthIndex = data.date.month - 9; // Setembro como mês 0
        monthIndex = (monthIndex < 0)
            ? monthIndex + 12
            : monthIndex; // Ajuste para meses do ano seguinte
        monthlyRainSum.update(
            monthIndex, (currentSum) => currentSum + data.rainAmount.toDouble(),
            ifAbsent: () => data.rainAmount.toDouble());
      }
    }

    return monthlyRainSum.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }

  Widget _buildChart(List<FlSpot> rainData) {
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

    final List<String> seringueiraMonths = [
      'Set',
      'Out',
      'Nov',
      'Dez',
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago'
    ];

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
