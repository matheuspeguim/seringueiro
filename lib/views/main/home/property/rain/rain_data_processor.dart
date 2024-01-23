import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_state.dart';

class RainDataProcessor {
  List<FlSpot> transformRainData(List<RainChartData> chartData) {
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
}
